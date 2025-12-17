; AutoHotkey v2 script for multiple find & replace on selected text
; Ctrl+Alt+R = Replace HTML tags with styled versions

#Requires AutoHotkey v2.0

; Multiple find & replace - Ctrl+Alt+R
^!r:: {
    MultipleReplace()
}

; Main function to perform multiple replacements
MultipleReplace() {
    ; Save current clipboard content
    clipboardBackup := ClipboardAll()
    A_Clipboard := ""
    
    ; Copy selected text
    Send("^c")
    
    ; Wait for text to be copied
    if !ClipWait(0.5) {
        A_Clipboard := clipboardBackup
        MsgBox("No text selected or copy failed!", "Error", "Icon!")
        return
    }
    
    originalText := A_Clipboard
    modifiedText := originalText
    
    ; Define replacements (find => replace)
    replacements := Map(
        "<h2>", '<h2 class="h4 fw-semibold">',
        "<h3>", '<h3 class="h5 fw-semibold">',
        "<p>", '<p class="fs-sm">'
    )
    
    ; Perform all replacements
    replacementCount := 0
    for findStr, replaceStr in replacements {
        ; Count occurrences before replacement
        beforeCount := CountOccurrences(modifiedText, findStr)
        
        ; Perform replacement
        modifiedText := StrReplace(modifiedText, findStr, replaceStr, false, &count)
        
        replacementCount += count
    }
    
    ; Put modified text in clipboard
    A_Clipboard := modifiedText
    
    ; Paste modified text
    Send("^v")
    
    ; Wait before restoring clipboard
    Sleep(100)
    
    ; Restore original clipboard content
    A_Clipboard := clipboardBackup
    
    ; Show result message
    if replacementCount > 0 {
        TrayTip("Replacements Done", 
            replacementCount . " replacement(s) made", 
            "Iconi")
        Sleep(2000)
        HideTrayTip()
    } else {
        TrayTip("No Replacements", 
            "No matching patterns found", 
            "Icon!")
        Sleep(2000)
        HideTrayTip()
    }
}

; Helper function to count occurrences of a string
CountOccurrences(haystack, needle) {
    count := 0
    pos := 1
    while (pos := InStr(haystack, needle, false, pos)) {
        count++
        pos += StrLen(needle)
    }
    return count
}

; Startup message
TrayTip("Multiple Replace Script Active", 
    "Ctrl+Alt+R = Replace HTML tags`n" .
    "<h2> -> <h2 class='h4 fw-semibold'>`n" .
    "<h3> -> <h3 class='h5 fw-semibold'>`n" .
    "<p> -> <p class='fs-sm'>", 
    "Iconi")
Sleep(4000)
HideTrayTip()

HideTrayTip() {
    TrayTip()  ; Hide the tooltip
}