library CombatLib requires TextLib

    function combat takes unit u, boolean b, integer sp returns boolean
        local boolean l = true
        if not( udg_combatlogic[GetPlayerId( GetOwningPlayer( u ) ) + 1] ) then
            if b and IsUnitInGroup( u, udg_heroinfo ) and GetSpellAbilityId() == sp then
                call textst( "|c00909090 Doesn't work out of combat", u, 64, 90, 10, 1 )
            endif
            set l = false
        endif
        set u = null
        return l
    endfunction

endlibrary