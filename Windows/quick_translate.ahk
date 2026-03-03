; =============================================================================
; Quick Translate - AutoHotkey v2 Integration
; =============================================================================
; Ctrl+Shift+Y → 選択テキストを翻訳ポップアップに送る
;
; ※ Ctrl+Shift+T（ポップアップ起動）はPython側のシステムトレイが処理するので
;   このスクリプトではCtrl+Shift+Yのみ担当
; =============================================================================

#Requires AutoHotkey v2.0
#SingleInstance Force

; --- Configuration ---
SCRIPT_DIR := A_ScriptDir
PYTHON_EXE := "python"
TRANSLATE_SCRIPT := SCRIPT_DIR "\quick_translate.py"
TEMP_FILE := A_Temp "\qt_selected.txt"

; --- Ctrl+Shift+Y: Translate selected text ---
^+y:: {
    ; クリップボードを保存
    ClipSaved := ClipboardAll()
    A_Clipboard := ""

    ; 選択テキストをコピー
    Send("^c")
    if !ClipWait(1) {
        ; 選択テキストがない場合は普通にポップアップを開く
        Run(PYTHON_EXE ' "' TRANSLATE_SCRIPT '" --popup', , "Hide")
        A_Clipboard := ClipSaved
        return
    }

    SelectedText := A_Clipboard

    ; クリップボードを復元
    A_Clipboard := ClipSaved

    ; テンプファイルに書き出し
    try {
        FileDelete(TEMP_FILE)
    }
    FileObj := FileOpen(TEMP_FILE, "w", "UTF-8")
    FileObj.Write(SelectedText)
    FileObj.Close()

    ; Python ポップアップをテンプファイル指定で起動
    Run(PYTHON_EXE ' "' TRANSLATE_SCRIPT '" --popup-file "' TEMP_FILE '"', , "Hide")
}
