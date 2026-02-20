#Requires AutoHotkey v2.0
#UseHook true
A_MaxHotkeysPerInterval := 200

IME_SET(SetSts) {
    try {
        hwnd := WinGetID("A")
        if (!hwnd)
            return
        DetectHiddenWindows true
        pHwnd := DllCall("imm32\ImmGetDefaultIMEWnd", "Ptr", hwnd, "Ptr")
        if (pHwnd)
            SendMessage(0x0283, 0x006, SetSts, , "ahk_id " pHwnd)
    }
}

IME_GET() {
    try {
        hwnd := WinGetID("A")
        if (!hwnd)
            return 0
        DetectHiddenWindows true
        pHwnd := DllCall("imm32\ImmGetDefaultIMEWnd", "Ptr", hwnd, "Ptr")
        if (pHwnd)
            return SendMessage(0x0283, 0x005, 0, , "ahk_id " pHwnd)
    }
    return 0
}

; ==========================================
; IME制御
; ==========================================

; 無変換キー → IMEオフ
vk1D:: {
    Critical
    ime1 := IME_GET()
    Sleep 10
    ime2 := IME_GET()
    if (ime1 && ime2)
        Send "{F10}"
    Sleep 50
    IME_SET(0)
    return
}

; かなキー → IMEオン
vk1C:: {
    Critical
    IME_SET(1)
    return
}

; ==========================================
; ウィンドウ切り替え（左下Ctrl+Tab）
; ==========================================

; Ctrl+Tab → ウィンドウ切り替え（Alt+Tab）
^Tab:: {
    Send "{Alt down}{Tab}"
    KeyWait "Ctrl"
    Send "{Alt up}"
    return
}

; Ctrl+Shift+Tab → ウィンドウ逆切り替え（Alt+Shift+Tab）
^+Tab:: {
    Send "{Alt down}{Shift down}{Tab}{Shift up}"
    KeyWait "Ctrl"
    Send "{Alt up}"
    return
}

; ==========================================
; タブ切り替え（Tab下のキー = 右Alt + Tab）
; ==========================================

; 右Alt+Tab → タブ次へ / 右Alt+Shift+Tab → タブ前へ
~RAlt & Tab:: {
    if GetKeyState("Shift", "P")
        Send "^+{Tab}"
    else
        Send "^{Tab}"
    return
}

; ==========================================
; その他
; ==========================================

; 左Alt単押し → Escを送ってフォーカスを戻す
~LAlt Up:: {
    if (A_PriorKey = "LAlt")
        Send "{Esc}"
    return
}

; Ctrl+Space → Win+H（音声入力）
^Space:: {
    Send "#{h}"
    return
}
