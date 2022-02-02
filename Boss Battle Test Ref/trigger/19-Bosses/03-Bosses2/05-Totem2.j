function Trig_Totem2_Conditions takes nothing returns boolean
    return GetUnitTypeId(udg_DamageEventTarget) == 'o007' and GetUnitLifePercent( udg_DamageEventTarget ) <= 75
endfunction

function Totem2Cast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local integer id1
    local integer cyclA = 1
    local unit boss = LoadUnitHandle( udg_hash, id, StringHash( "bstm3t" ) )
    local unit shadow = LoadUnitHandle( udg_hash, id, StringHash( "bstm3" ) )
    local real NewX = GetUnitX(shadow) - GetUnitX(boss)
    local real NexY = GetUnitY(shadow) - GetUnitY(boss)
    
    if GetUnitState( boss, UNIT_STATE_LIFE) <= 0.405 or GetUnitState( shadow, UNIT_STATE_LIFE) <= 0.405 or not( udg_fightmod[0] ) then
        call DestroyTimer( GetExpiredTimer() )
        call FlushChildHashtable( udg_hash, id )
    elseif SquareRoot(NewX * NewX + NexY * NexY) <= 300 then
        call KillUnit( shadow )
        loop
            exitwhen cyclA > 4
            if GetUnitState( udg_hero[cyclA], UNIT_STATE_LIFE) > 0.405 then
                set bj_lastCreatedUnit = CreateUnit( GetOwningPlayer( boss ), 'u000', GetUnitX( udg_hero[cyclA] ), GetUnitY( udg_hero[cyclA] ), 270 )
                call spectime("Abilities\\Spells\\Human\\FlameStrike\\FlameStrike1.mdl", GetUnitX( bj_lastCreatedUnit ), GetUnitY( bj_lastCreatedUnit ), 8 )
            
                set id1 = GetHandleId( bj_lastCreatedUnit )
                if LoadTimerHandle( udg_hash, id1, StringHash( "bstm2" ) ) == null  then
                    call SaveTimerHandle( udg_hash, id1, StringHash( "bstm2" ), CreateTimer() )
                endif
                set id1 = GetHandleId( LoadTimerHandle( udg_hash, id1, StringHash( "bstm2" ) ) ) 
                call SaveUnitHandle( udg_hash, id1, StringHash( "bstm2" ), boss )
                call SaveUnitHandle( udg_hash, id1, StringHash( "bstm2d" ), bj_lastCreatedUnit )
                call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( bj_lastCreatedUnit ), StringHash( "bstm2" ) ), 0.5, true, function TotemCast1 )
            endif
            set cyclA = cyclA + 1
        endloop
        call DestroyTimer( GetExpiredTimer() )
        call FlushChildHashtable( udg_hash, id )
    //else
        //call IssuePointOrder( shadow, "move", GetUnitX( boss ), GetUnitY( boss ) )
    endif
    
    set boss = null
    set shadow = null
endfunction

function Trig_Totem2_Actions takes nothing returns nothing
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
            call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( bj_lastCreatedUnit ), StringHash( "bstm3" ) ), 0.5, true, function Totem2Cast )
        endif
        set cyclA = cyclA + 1
    endloop
endfunction

//===========================================================================
function InitTrig_Totem2 takes nothing returns nothing
    set gg_trg_Totem2 = CreateTrigger()
    call DisableTrigger( gg_trg_Totem2 )
    call TriggerRegisterVariableEvent( gg_trg_Totem2, "udg_DamageEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_Totem2, Condition( function Trig_Totem2_Conditions ) )
    call TriggerAddAction( gg_trg_Totem2, function Trig_Totem2_Actions )
endfunction

