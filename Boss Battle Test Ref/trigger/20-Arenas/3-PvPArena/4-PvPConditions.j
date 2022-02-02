library PvPConditions
    
    function IsUnitInDuel takes unit myUnit returns boolean
        local boolean inDuel = false
    
        if myUnit == udg_unit[57] then
            set inDuel = true
        elseif myUnit == udg_unit[58] then
            set inDuel = true
        endif
    
        set myUnit = null
        return inDuel
    endfunction
    
endlibrary