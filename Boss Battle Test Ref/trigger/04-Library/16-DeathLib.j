library DeathLib requires TextLib

    //Is unit can be target of battle ressurect
    function DeathIf takes unit u returns boolean
        local boolean l = false
        if GetUnitAbilityLevel(u, 'A05X') == 0 and not( IsUnitInGroup(u, udg_Return) ) and udg_Heroes_Ressurect_Battle <= 0 and IsUnitInGroup( u, udg_otryad ) then
            set l = true
        endif
        set u = null
        return l
    endfunction

    function IsUnitAlive takes unit myUnit returns boolean
        local boolean isWork = false
        if GetUnitState( myUnit, UNIT_STATE_LIFE) > 0.405 then
            set isWork = true
        endif
        set myUnit = null
        return isWork
    endfunction

    function IsUnitDead takes unit myUnit returns boolean
        local boolean isWork = false
        if GetUnitState( myUnit, UNIT_STATE_LIFE) <= 0.405 then
            set isWork = true
        endif
        set myUnit = null
        return isWork
    endfunction

endlibrary