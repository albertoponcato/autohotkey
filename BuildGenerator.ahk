^+d::
{
    ; Data di partenza (1 gennaio 2000)
    start := "20000101000000"

    ; Data attuale (A_Now)
    now := A_Now

    ; Differenza in giorni
    diffDays := DateDiff(now, start, "Days")

    ; Copia negli appunti
    A_Clipboard := diffDays

    ; Incolla
    Send "^v"
}