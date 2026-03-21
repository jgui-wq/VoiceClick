# VoiceClick

Dictate anywhere with a click. VoiceClick turns Windows built-in Voice Typing (Win+H) into a click-to-dictate tool — press F1 to arm it, then click any text field to start dictating.

![Windows 10/11](https://img.shields.io/badge/Windows-10%20%7C%2011-blue) ![AutoHotkey v2](https://img.shields.io/badge/AutoHotkey-v2.0-green) ![License MIT](https://img.shields.io/badge/License-MIT-yellow)

## How it works

1. **F1** toggles dictation mode on/off
2. **Click** any text field — Voice Typing starts automatically
3. Speak — your words appear as text
4. **Click** another field — dictation follows your cursor

VoiceClick only activates in text inputs (edit fields, terminals, search bars), not on buttons, menus, or the taskbar.

## Supported targets

| Target | Detection |
|--------|-----------|
| Terminals (Windows Terminal, cmd, PowerShell, Git Bash, PuTTY) | Window class |
| Standard text fields (Notepad, dialogs, search bars) | Control class (Edit, RichEdit, Scintilla) |
| Other apps with text cursor | Caret position |

## Install

1. Install [AutoHotkey v2](https://www.autohotkey.com/) (free)
2. Download `VoiceClick.ahk`
3. Double-click to run

Optional: place a shortcut in your Startup folder (`Win+R` → `shell:startup`) to launch it automatically.

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
