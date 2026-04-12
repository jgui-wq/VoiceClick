#Requires AutoHotkey v2.0
#SingleInstance Force

; ================================================================
; VoiceClick — Windows Voice Typing on left click
; Press F1 to toggle, then click any text field to dictate
; Only activates in text inputs and terminals
; ================================================================

; Auto-elevate to admin (avoids conflicts with elevated terminals / PowerShell)
if !A_IsAdmin {
    try Run('*RunAs "' A_ScriptFullPath '"')
    ExitApp
}

global DictationMode := false
A_IconTip := "VoiceClick — inactive"

F1:: {
    global DictationMode
    DictationMode := !DictationMode
    if DictationMode {
        A_IconTip := "VoiceClick — ACTIVE"
        ToolTip("VoiceClick ON")
        SetTimer(() => ToolTip(), -1500)
        TriggerDictation()
    } else {
        A_IconTip := "VoiceClick — inactive"
        ToolTip("VoiceClick OFF")
        SetTimer(() => ToolTip(), -1500)
    }
}

~LButton:: {
    global DictationMode
    if DictationMode {
        KeyWait("LButton")
        SetTimer(TryDictation, -200)
    }
}

TryDictation() {
    ; Retry up to 5× (100ms apart) to let the caret appear (Chromium/Explorer lag)
    Loop 5 {
        if IsTextTarget() {
            TriggerDictation()
            return
        }
        Sleep(100)
    }
}

F2:: {
    path := A_ScriptDir . "\dictbar_debug.txt"
    out := "=== " . A_Now . " ===`n"
    for hwnd in WinGetList() {
        try {
            style := WinGetStyle(hwnd)
            if !(style & 0x10000000)
                continue
            WinGetPos(&x, &y, &w, &h, hwnd)
            if (w < 50 || h < 20)
                continue
            exe := WinGetProcessName(hwnd)
            cls := WinGetClass(hwnd)
            ttl := WinGetTitle(hwnd)
            out .= Format("exe={1}  class={2}  size={3}x{4}  title={5}`n", exe, cls, w, h, ttl)
        }
    }
    FileAppend(out . "`n", path)
    ToolTip("Dumped to " . path)
    SetTimer(() => ToolTip(), -2000)
}

TriggerDictation() {
    SendInput("{LWin down}h{LWin up}")
    SetTimer(MoveDictationBar, -350)
}

MoveDictationBar() {
    Loop 8 {
        for hwnd in WinGetList("ahk_exe TextInputHost.exe") {
            try {
                style := WinGetStyle(hwnd)
                if !(style & 0x10000000)  ; WS_VISIBLE
                    continue
                WinGetPos(&x, &y, &w, &h, hwnd)
                if (w < 120 || h < 40)  ; skip tiny IME popups
                    continue
                MonitorGetWorkArea(MonitorGetPrimary(), &mL, &mT, &mR, &mB)
                WinMove(mR - w - 20, mB - h - 20, , , hwnd)
                return
            }
        }
        Sleep(150)
    }
}

IsTextTarget() {
    try {
        winClass := WinGetClass("A")

        ; --- Terminals: always allow ---
        if winClass ~= "i)CASCADIA_HOSTING|ConsoleWindowClass|mintty|VirtualConsole|PuTTY"
            return true

        ; --- Win32 text controls (Edit, RichEdit, Scintilla…) ---
        try {
            focused := ControlGetFocus("A")
            if focused {
                cls := ControlGetClassNN(focused, "A")
                if cls ~= "i)^Edit|RichEdit|RICHEDIT|Scintilla|TextBox|AutoSuggest"
                    return true
            }
        }

        ; --- UIA: focused element control type (Chromium/Explorer) ---
        if UIAIsFocusedEditable()
            return true

        ; --- MSAA fallback: element under cursor ---
        if AccIsEditable()
            return true

        ; --- Visible text caret = active text field ---
        try {
            x := 0, y := 0
            if CaretGetPos(&x, &y)
                return true
        }

        return false
    } catch
        return false
}

UIAIsFocusedEditable() {
    static uia := 0
    if !uia {
        try uia := ComObject("{ff48dba4-60ef-4201-aa87-54103eef594e}", "{30cbe57d-d9d0-452a-ab13-7ac5ac4825ee}")
        catch
            return false
    }
    element := 0
    try {
        if ComCall(8, uia, "ptr*", &element) != 0 || !element
            return false

        varBuf := Buffer(24, 0)
        ctrl := 0
        if ComCall(10, element, "int", 30003, "ptr", varBuf) = 0 {
            vt := NumGet(varBuf, 0, "ushort")
            if (vt = 3)
                ctrl := NumGet(varBuf, 8, "int")
            DllCall("oleaut32\VariantClear", "ptr", varBuf)
        }

        if !(ctrl = 50004 || ctrl = 50030 || ctrl = 50003) {
            ObjRelease(element)
            return false
        }

        ; Verify mouse click actually lands inside focused element's bounding rect
        MouseGetPos(&mx, &my)
        rectBuf := Buffer(24, 0)
        inside := false
        if ComCall(10, element, "int", 30001, "ptr", rectBuf) = 0 {  ; BoundingRect
            vt := NumGet(rectBuf, 0, "ushort")
            if (vt = (0x2000 | 5)) {  ; VT_ARRAY|VT_R8
                psa := NumGet(rectBuf, 8, "ptr")
                if psa {
                    pData := 0
                    if DllCall("oleaut32\SafeArrayAccessData", "ptr", psa, "ptr*", &pData) = 0 {
                        L := NumGet(pData, 0, "double")
                        T := NumGet(pData, 8, "double")
                        W := NumGet(pData, 16, "double")
                        H := NumGet(pData, 24, "double")
                        DllCall("oleaut32\SafeArrayUnaccessData", "ptr", psa)
                        if (W > 0 && H > 0 && mx >= L && mx < L + W && my >= T && my < T + H)
                            inside := true
                    }
                }
            }
            DllCall("oleaut32\VariantClear", "ptr", rectBuf)
        }
        ObjRelease(element)
        return inside
    } catch {
        if element
            try ObjRelease(element)
        return false
    }
}

AccIsEditable() {
    try {
        MouseGetPos(&mx, &my)
        pt64 := ((my & 0xFFFFFFFF) << 32) | (mx & 0xFFFFFFFF)
        pvar := Buffer(24, 0)
        pacc := 0
        hr := DllCall("oleacc\AccessibleObjectFromPoint"
            , "int64", pt64
            , "ptr*", &pacc
            , "ptr", pvar)
        if (hr != 0 || !pacc)
            return false

        acc := ComValue(9, pacc, 1)  ; VT_DISPATCH, take ownership

        role := 0
        try role := acc.accRole(0)

        state := 0
        try state := acc.accState(0)

        ; STATE_SYSTEM_UNAVAILABLE=0x1, STATE_SYSTEM_READONLY=0x40
        if (state & 0x41)
            return false

        ; ROLE_SYSTEM_TEXT=42, ROLE_SYSTEM_DOCUMENT=15, ROLE_SYSTEM_COMBOBOX=46
        return (role = 42 || role = 15 || role = 46)
    } catch
        return false
}
