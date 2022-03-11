function Trig_gg_trg_MageTruch2_Conditions takes nothing returns boolean
    return GetUnitTypeId(udg_DamageEventTarget) == 'n03L' and GetUnitLifePercent(udg_DamageEventTarget) <= 75
endfunction

function MageTruch2Cast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local unit boss = LoadUnitHandle( udg_hash, id, StringHash( "bsmtr2" ) )
    local unit target
    local real x1
    local real y1
    local real x2
    local real y2
    
    if GetUnitState( boss, UNIT_STATE_LIFE) <= 0.405 or not( udg_fightmod[0] ) then
        call DestroyTimer( GetExpiredTimer() )
        call FlushChildHashtable( udg_hash, id )
    else
        set target = randomtarget( boss, 600, "enemy", "hero", "", "", "" )
        if target != null then
            set x1 = GetUnitX( boss )
            set y1 = GetUnitY( boss )
            set x2 = GetUnitX( target )
            set y2 = GetUnitY( target )
            call SetUnitPosition( boss, x2, y2 )
            call SetUnitPosition( target, x1, y1 )
            call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\Human\\MassTeleport\\MassTeleportCaster.mdl", x1, y1 ) )
            call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\Human\\MassTeleport\\MassTeleportCaster.mdl", x2, y2 ) )
            call PanCameraToTimedForPlayer( GetOwningPlayer( target ), x1, y1, 0 )
        endif
    endif
    
    set boss = null
 endfunction  

function Trig_gg_trg_MageTruch2_Actions takes nothing returns nothing
    local integer id = GetHandleId( udg_DamageEventTarget )

    call DisableTrigger( GetTriggeringTrigger() )
    
    if LoadTimerHandle( udg_hash, id, StringHash( "bsmtr" ) ) == null then 
        call SaveTimerHandle( udg_hash, id, StringHash( "bsmtr" ), CreateTimer() )
    endif
	set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "bsmtr" ) ) ) 
    call SaveUnitHandle( udg_hash, id, StringHash( "bsmtr" ), udg_DamageEventTarget )
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( udg_DamageEventTarget ), StringHash( "bsmtr" ) ), bosscast(7), true, function MageTruch1Cast )
    
    set id = GetHandleId( udg_DamageEventTarget )
    if LoadTimerHandle( udg_hash, id, StringHash( "bsmtr2" ) ) == null  then
        call SaveTimerHandle( udg_hash, id, StringHash( "bsmtr2" ), CreateTimer() )
    endif
	set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "bsmtr2" ) ) ) 
    call SaveUnitHandle( udg_hash, id, StringHash( "bsmtr2" ), udg_DamageEventTarget )
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( udg_DamageEventTarget ), StringHash( "bsmtr2" ) ), bosscast(12), true, function MageTruch2Cast )
endfunction

//===========================================================================
function InitTrig_MageTruch2 takes nothing returns nothing
    set gg_trg_MageTruch2 = CreateTrigger()
    call DisableTrigger( gg_trg_MageTruch2 )
    call TriggerRegisterVariableEvent( gg_trg_MageTruch2, "udg_AfterDamageEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_MageTruch2, Condition( function Trig_gg_trg_MageTruch2_Conditions ) )
    call TriggerAddAction( gg_trg_MageTruch2, function Trig_gg_trg_MageTruch2_Actions )
endfunction

