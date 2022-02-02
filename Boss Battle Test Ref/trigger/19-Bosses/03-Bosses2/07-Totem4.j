function Trig_Totem4_Conditions takes nothing returns boolean
    return ( GetUnitTypeId(udg_DamageEventTarget) == 'o007' ) and ( GetUnitLifePercent( udg_DamageEventTarget ) <= 25 )
endfunction

function Trig_Totem4_Actions takes nothing returns nothing
    local integer id
    local integer cyclA = 1
    local real x
    local real y

    call DisableTrigger( GetTriggeringTrigger() )
    loop
        exitwhen cyclA > 4
        if GetUnitState( udg_hero[cyclA], UNIT_STATE_LIFE) > 0.405 then
            set x = GetUnitX(udg_DamageEventTarget) + 1200 * Cos((45 + ( 90 * cyclA )) * bj_DEGTORAD)
            set y = GetUnitY(udg_DamageEventTarget) + 1200 * Sin((45 + ( 90 * cyclA )) * bj_DEGTORAD)
            set bj_lastCreatedUnit = CreateUnit( GetOwningPlayer( udg_DamageEventTarget ), 'n035', x, y, 270)
            set id = GetHandleId( bj_lastCreatedUnit )
            call PingMinimapLocForForceEx( bj_FORCE_ALL_PLAYERS, GetUnitLoc(bj_lastCreatedUnit), 5, bj_MINIMAPPINGSTYLE_ATTACK, 100, 50, 50 )
            call IssuePointOrder( bj_lastCreatedUnit, "move", GetUnitX( udg_DamageEventTarget ), GetUnitY( udg_DamageEventTarget ) )

            if LoadTimerHandle( udg_hash, id, StringHash( "bstm3" ) ) == null  then
                call SaveTimerHandle( udg_hash, id, StringHash( "bstm3" ), CreateTimer() )
            endif
            set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "bstm3" ) ) ) 
            call SaveUnitHandle( udg_hash, id, StringHash( "bstm3" ), bj_lastCreatedUnit )
            call SaveUnitHandle( udg_hash, id, StringHash( "bstm3t" ), udg_DamageEventTarget )
            call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( bj_lastCreatedUnit ), StringHash( "bstm3" ) ), bosscast(1), true, function Totem2Cast )
        endif
        set cyclA = cyclA + 1
    endloop
endfunction

//===========================================================================
function InitTrig_Totem4 takes nothing returns nothing
    set gg_trg_Totem4 = CreateTrigger(  )
    call DisableTrigger( gg_trg_Totem4 )
    call TriggerRegisterVariableEvent( gg_trg_Totem4, "udg_DamageEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_Totem4, Condition( function Trig_Totem4_Conditions ) )
    call TriggerAddAction( gg_trg_Totem4, function Trig_Totem4_Actions )
endfunction

