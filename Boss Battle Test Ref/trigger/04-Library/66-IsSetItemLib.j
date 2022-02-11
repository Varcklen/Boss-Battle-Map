library IsSetItemLib

    function IsSetItem takes integer it, integer settag returns boolean
        local integer cyclA = 1
        local integer cyclAEnd = udg_DB_SetItems_Num[settag]
        local boolean is = false
        
        loop 
            exitwhen cyclA > cyclAEnd
            if it == DB_SetItems[settag][cyclA] then
                set is = true
                set cyclA = cyclAEnd
            endif
            set cyclA = cyclA + 1
        endloop
        
        return is
    endfunction
endlibrary