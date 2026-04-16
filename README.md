# VoiceClic

Dictate anywhere with a click. VoiceClic turns Windows built-in Voice Typing (Win+H) into a click-to-dictate tool — press F1 to arm it, then click any text field to start dictating.

![Windows 10/11](https://img.shields.io/badge/Windows-10%20%7C%2011-blue) ![AutoHotkey v2](https://img.shields.io/badge/AutoHotkey-v2.0-green) ![License MIT](https://img.shields.io/badge/License-MIT-yellow)

## How it works

1. **F1** toggles dictation mode on/off
2. **Click** any text field — Voice Typing starts automatically
3. Speak — your words appear as text
4. **Click** another field — dictation follows your cursor

VoiceClic only activates in text inputs (edit fields, terminals, search bars), not on buttons, menus, or the taskbar.

## Supported targets

| Target | Detection |
|--------|-----------|
| Terminals (Windows Terminal, cmd, PowerShell, Git Bash, PuTTY) | Window class |
| Standard text fields (Notepad, dialogs, search bars) | Control class (Edit, RichEdit, Scintilla) |
| Chromium browsers (Chrome, Edge, Opera, Brave) and Windows Explorer | UIAutomation (focused element + mouse inside its rect) |
| Other apps with text cursor | Caret position / MSAA |

## Install (recommended)

1. Download **VoiceClic.exe** from the [latest release](../../releases/latest)
2. Double-click — accept the UAC prompt (needed so it can act inside elevated PowerShell/terminals)
3. Press F1 to arm

No AutoHotkey install required: the exe is self-contained.

For auto-start: drop a shortcut in `Win+R` → `shell:startup`.

## Install (from source)

For developers or users who prefer the raw script:

1. Install [AutoHotkey v2](https://www.autohotkey.com/) (free)
2. Download `VoiceClic.ahk`
3. Double-click to run

## Mute the dictation sound

Windows Voice Typing plays a chime when it starts. To silence it:

1. Press **Win+H** to trigger dictation once
2. Right-click the **volume icon** in the taskbar → **Volume Mixer**
3. Mute **"Windows Feature Experience"**

This persists across reboots.

## Requirements

- Windows 10 or 11 with Voice Typing enabled
- [AutoHotkey v2.0+](https://www.autohotkey.com/)

## License

MIT
