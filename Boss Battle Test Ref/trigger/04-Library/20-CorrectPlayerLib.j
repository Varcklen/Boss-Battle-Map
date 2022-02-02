library CorrectPlayerLib

    //Obsolete. Do not use.
    function CorrectPlayer takes unit u returns integer
        local integer cyclA = 1
        local integer i = 0
        loop
            exitwhen cyclA > 4
            if u == udg_hero[cyclA] then
                set i = cyclA
                set cyclA = 4
            endif
            set cyclA = cyclA + 1
        endloop
        set u = null
        return i
    endfunction

endlibrary