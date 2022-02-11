library AnyHasLvLLib

    function AnyHasLvL takes integer i returns boolean
        local integer cyclA = 1
        local boolean l = false
        
        loop
            exitwhen cyclA > 4
            if udg_LvL[cyclA] >= i then
                set l = true
                set cyclA = 4
            endif
            set cyclA = cyclA + 1
        endloop
        return l
    endfunction

endlibrary