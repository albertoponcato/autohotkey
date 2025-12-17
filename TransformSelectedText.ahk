; AutoHotkey v2 script to transform selected text
; Ctrl+Alt+L = lowercase
; Ctrl+Alt+U = UPPERCASE
; Ctrl+Alt+T = Title Case
; Ctrl+Alt+P = PascalCase
; Ctrl+Alt+C = camelCase

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

; PascalCase - Ctrl+Alt+P
^!p:: {
    TransformSelectedText("pascal")
}

; camelCase - Ctrl+Alt+C
^!c:: {
    TransformSelectedText("camel")
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
        case "pascal":
            transformedText := ToPascalCase(originalText)
        case "camel":
            transformedText := ToCamelCase(originalText)
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

; Convert text to PascalCase
ToPascalCase(text) {
    ; Remove extra spaces and split by space, underscore, hyphen
    text := Trim(text)
    words := StrSplit(RegExReplace(text, "[_\-\s]+", " "), " ")
    
    result := ""
    for word in words {
        if (StrLen(word) > 0) {
            ; Capitalize first letter, lowercase the rest
            result .= StrUpper(SubStr(word, 1, 1)) . StrLower(SubStr(word, 2))
        }
    }
    
    return result
}

; Convert text to camelCase
ToCamelCase(text) {
    pascalCase := ToPascalCase(text)
    
    ; Make first letter lowercase
    if (StrLen(pascalCase) > 0) {
        return StrLower(SubStr(pascalCase, 1, 1)) . SubStr(pascalCase, 2)
    }
    
    return pascalCase
}

; Startup message
TrayTip("Text Transform Script Active", 
    "Ctrl+Alt+L = lowercase`n" .
    "Ctrl+Alt+U = UPPERCASE`n" .
    "Ctrl+Alt+T = Title Case`n" .
    "Ctrl+Alt+P = PascalCase`n" .
    "Ctrl+Alt+C = camelCase", 
    "Iconi")
Sleep(3000)
HideTrayTip()

HideTrayTip() {
    TrayTip()  ; Hide the tooltip
}