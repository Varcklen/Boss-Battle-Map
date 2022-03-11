library MajyteLib requires SpellPower

    function MajyteCast takes nothing returns nothing
        local integer id = GetHandleId( GetExpiredTimer( ) )
        local unit u = LoadUnitHandle( udg_hash, id, StringHash( "majt" ) )
        local boolean l = LoadBoolean( udg_hash, GetHandleId( u ), StringHash( "majt" ) )

        if GetUnitAbilityLevel( u, 'A0YC') > 0 and l then
            call spdst( u, -1 * LoadReal( udg_hash, GetHandleId( u ), StringHash( "majt" ) ) )
            call UnitRemoveAbility( u, 'A0YC' )
            call UnitRemoveAbility( u, 'B03Z' )
        call SaveBoolean( udg_hash, GetHandleId(u), StringHash( "majt" ), false )
            call RemoveSavedReal( udg_hash, GetHandleId( u ), StringHash( "majt" ) )
            call FlushChildHashtable( udg_hash, id )
        endif
        
        set u = null
    endfunction

endlibrary