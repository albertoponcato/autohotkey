; AutoHotkey v2 script to transform selected text
; Ctrl+Alt+L = lowercase
; Ctrl+Alt+U = UPPERCASE
; Ctrl+Alt+T = Title Case

#Requires AutoHotkey v2.0

; Lowercase - Ctrl+Alt+L
^!l:: {
    TransformSelectedText("lower")
}

; UPPERCASE - Ctrl+Alt+U
^!u:: {
    TransformSelectedText("upper")
}

; Title Case - Ctrl+Alt+T
^!t:: {
    TransformSelectedText("title")
}

; Main function to transform text
TransformSelectedText(type) {
    ; Save current clipboard content
    clipboardBackup := ClipboardAll()
    A_Clipboard := ""
    
    ; Copy selected text
    Send("^c")
    
    ; Wait for text to be copied
    if !ClipWait(0.5) {
        A_Clipboard := clipboardBackup
        return
    }
    
    originalText := A_Clipboard
    
    ; Transform text based on type
    switch type {
        case "lower":
            transformedText := StrLower(originalText)
        case "upper":
            transformedText := StrUpper(originalText)
        case "title":
            transformedText := StrTitle(originalText)
    }
    
    ; Put transformed text in clipboard
    A_Clipboard := transformedText
    
    ; Paste transformed text
    Send("^v")
    
    ; Wait before restoring clipboard
    Sleep(100)
    
    ; Restore original clipboard content
    A_Clipboard := clipboardBackup
}

; Startup message
TrayTip("Text Transform Script Active", 
    "Ctrl+Alt+L = lowercase`n" .
    "Ctrl+Alt+U = UPPERCASE`n" .
    "Ctrl+Alt+T = Title Case", 
    "Iconi")
Sleep(3000)
HideTrayTip()

HideTrayTip() {
    TrayTip()  ; Hide the tooltip
}