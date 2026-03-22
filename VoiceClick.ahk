#Requires AutoHotkey v2.0
#SingleInstance Force

; ================================================================
; VoiceClick — Windows Voice Typing on left click
; Press F1 to toggle, then click any text field to dictate
; Only activates in text inputs and terminals
; ================================================================

global DictationMode := false
A_IconTip := "VoiceClick — inactive"

F1:: {
    global DictationMode
    DictationMode := !DictationMode
    if DictationMode {
        A_IconTip := "VoiceClick — ACTIVE"
        ToolTip("VoiceClick ON")
        SetTimer(() => ToolTip(), -1500)
        SendInput("{LWin down}h{LWin up}")
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
        SetTimer(TryDictation, -150)
    }
}

TryDictation() {
    if IsTextTarget()
        SendInput("{LWin down}h{LWin up}")
}

IsTextTarget() {
    try {
        winClass := WinGetClass("A")

        ; --- Terminals: always allow ---
        if winClass ~= "i)CASCADIA_HOSTING|ConsoleWindowClass|mintty|VirtualConsole|PuTTY"
            return true

        ; --- Chromium/Electron (Edge, Chrome, Perplexity, VS Code…) ---
        if winClass ~= "i)Chrome_WidgetWin"
            return true

        ; --- Windows Explorer (address bar, search bar, rename) ---
        if winClass ~= "i)CabinetWClass|ExploreWClass"
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
