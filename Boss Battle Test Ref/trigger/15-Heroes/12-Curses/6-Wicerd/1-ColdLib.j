library ColdLib requires BuffsLibLib

    function FreezeCast takes nothing returns nothing
        local integer id = GetHandleId( GetExpiredTimer() )
        local unit u = LoadUnitHandle( udg_hash, id, StringHash( "frzi" ) )

        call UnitRemoveAbility( u, 'A17G' )
        call UnitRemoveAbility( u, 'B07J' )
        call FlushChildHashtable( udg_hash, id )

        set u = null
    endfunction

    function FreezeFireCast takes nothing returns nothing
        local integer id = GetHandleId( GetExpiredTimer( ) )
        local integer counter = LoadInteger( udg_hash, id, StringHash( "frzf" ) )
        local real dmg = LoadReal( udg_hash, id, StringHash( "frzf" ) )
        local unit target = LoadUnitHandle( udg_hash, id, StringHash( "frzf" ) )
        local unit dummy = LoadUnitHandle( udg_hash, id, StringHash( "frzfd" ) )
        
        if GetUnitState( target, UNIT_STATE_LIFE) > 0.405 then
            call UnitDamageTarget( dummy, target, dmg, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS )
        endif
        
        if counter > 0 and GetUnitState( target, UNIT_STATE_LIFE) > 0.405 and GetUnitAbilityLevel( target, 'A17I') > 0 then
            call SaveInteger( udg_hash, id, StringHash( "frzf" ), counter - 1 )
        else
            call UnitRemoveAbility( target, 'A17I' )
            call UnitRemoveAbility( target, 'B07K' )
            call RemoveUnit( dummy )
            call FlushChildHashtable( udg_hash, id )
            call DestroyTimer( GetExpiredTimer() )
        endif
        
        set target = null
        set dummy = null
    endfunction

    function freezest takes unit caster, unit target, real t, integer lvl returns nothing
        local integer id = GetHandleId( target )
        local real dmg

        if GetUnitAbilityLevel( caster, 'B07L' ) == 0 then
            call UnitAddAbility( target, 'A17G' )
            
            if LoadTimerHandle( udg_hash, id, StringHash( "frzi" ) ) == null then
                call SaveTimerHandle( udg_hash, id, StringHash( "frzi" ), CreateTimer() )
            endif
            set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "frzi" ) ) ) 
            call SaveUnitHandle( udg_hash, id, StringHash( "frzi" ), target )
            call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( target ), StringHash( "frzi" ) ), t, false, function FreezeCast )
            if BuffLogic() then
                call debuffst( caster, target, null, lvl, t )
            endif
        else
            set dmg = (16 + (4*GetUnitAbilityLevel( caster, 'A17L' ))) * GetUnitSpellPower(caster)
            call UnitAddAbility( target, 'A17I' )
            call dummyspawn( caster, 0, 'A0N5', 0, 0 )
            
            if LoadTimerHandle( udg_hash, id, StringHash( "frzf" ) ) == null then
                call SaveTimerHandle( udg_hash, id, StringHash( "frzf" ), CreateTimer() )
            endif
            set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "frzf" ) ) ) 
            call SaveUnitHandle( udg_hash, id, StringHash( "frzf" ), target )
            call SaveUnitHandle( udg_hash, id, StringHash( "frzfd" ), bj_lastCreatedUnit )
            call SaveReal( udg_hash, id, StringHash( "frzf" ), dmg )
            call SaveInteger( udg_hash, id, StringHash( "frzf" ), R2I(t) )
            call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( target ), StringHash( "frzf" ) ), 1, true, function FreezeFireCast )
            if BuffLogic() then
                call debuffst( caster, target, null, lvl, t )
            endif
        endif

        set caster = null
        set target = null
    endfunction

endlibrary