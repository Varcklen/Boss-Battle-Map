library StunLib requires TimebonusLib, UnitstLib, BuffsLibLib

    function StunCast takes nothing returns nothing
        local integer id = GetHandleId( GetExpiredTimer() )
        local unit u = LoadUnitHandle( udg_hash, id, StringHash( "stun" ) )
        local integer h = LoadInteger( udg_hash, GetHandleId( u ), StringHash( "stun" ) ) - 1

        call SaveInteger( udg_hash, GetHandleId( u ), StringHash( "stun" ), h )
        //обязательно должен срабатывать
        call BlzPauseUnitEx(u, false)
        if h <= 0 then
            call UnitRemoveAbility( u, 'A05J' )
            call UnitRemoveAbility( u, 'BPSE' )
        endif
        call FlushChildHashtable( udg_hash, id )

        set u = null
    endfunction

    function UnitStun takes unit caster, unit target, real r returns nothing
        local integer k = GetPlayerId(GetOwningPlayer( caster )) + 1
        local integer h = LoadInteger( udg_hash, GetHandleId( target ), StringHash( "stun" ) )
        local real t = timebonus(caster, r)
        local integer id
        local group g = CreateGroup()
        local unit n

        if GetUnitTypeId( target ) != 'h01K' and GetUnitState( target, UNIT_STATE_LIFE) > 0.405 then
            call SaveInteger( udg_hash, GetHandleId( target ), StringHash( "stun" ), h + 1 )
            call BlzPauseUnitEx(target, true)
            call UnitAddAbility( target, 'A05J' )
            set id = GetHandleId( target )
            
            //намеренно без условия
            call SaveTimerHandle( udg_hash, id, StringHash( "stun" ), CreateTimer() )
            set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "stun" ) ) ) 
            call SaveUnitHandle( udg_hash, id, StringHash( "stun" ), target )
            call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( target ), StringHash( "stun" ) ), t, false, function StunCast )
            
            if inv( caster, 'I075' ) > 0 then
                call GroupEnumUnitsInRange( g, GetUnitX( target ), GetUnitY( target ), 400, null )
                loop
                    set n = FirstOfGroup(g)
                    exitwhen n == null
                    if unitst( n, caster, "enemy" ) and n != target then
                        set h = LoadInteger( udg_hash, GetHandleId( n ), StringHash( "stun" ) )
                        call SaveInteger( udg_hash, GetHandleId( n ), StringHash( "stun" ), h + 1 )
                        call BlzPauseUnitEx(n, true)
                        call UnitAddAbility( n, 'A05J' )
                        set id = GetHandleId( n )
                        
                        //намеренно без условия
                        call SaveTimerHandle( udg_hash, id, StringHash( "stun" ), CreateTimer() )
                        set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "stun" ) ) ) 
                        call SaveUnitHandle( udg_hash, id, StringHash( "stun" ), n )
                        call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( n ), StringHash( "stun" ) ), t, false, function StunCast )
                    endif
                    call GroupRemoveUnit(g,n)
                endloop
            endif
        endif
        call debuffst( caster, target, null, 1, t )
        
        call GroupClear( g )
        call DestroyGroup( g )
        set g = null
        set n = null
        set caster = null
        set target = null
    endfunction

endlibrary