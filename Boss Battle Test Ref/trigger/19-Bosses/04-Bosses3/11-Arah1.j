function Trig_Arah1_Conditions takes nothing returns boolean
    return GetUnitTypeId(udg_DamageEventTarget) == 'h00K' and GetUnitLifePercent(udg_DamageEventTarget) <= 60
endfunction

function ArahEnd takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local unit boss = LoadUnitHandle( udg_hash, id, StringHash( "bsar1" ) )

    if GetUnitState( boss, UNIT_STATE_LIFE) > 0.405 and ( udg_fightmod[0] ) then
        call SetUnitPosition( boss, GetRectCenterX(udg_Boss_Rect), GetRectCenterY(udg_Boss_Rect) )
        call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\Orc\\MirrorImage\\MirrorImageDeathCaster.mdl", GetUnitX( boss ), GetUnitY( boss ) ) )
        call ShowUnit( boss, true )
        call PauseUnit( boss, false )
        call IssueImmediateOrder( boss, "stop" )
        call aggro( boss )
    endif
    call DestroyTimer( LoadTimerHandle( udg_hash, GetHandleId( boss ), StringHash( "bsar" ) ) )
    call DestroyTimer( GetExpiredTimer() )
    call FlushChildHashtable( udg_hash, GetHandleId( boss ) )
    call FlushChildHashtable( udg_hash, id )
    
    set boss = null
endfunction

function ArahCast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local unit boss = LoadUnitHandle( udg_hash, id, StringHash( "bsar" ) )
    local unit target = GroupPickRandomUnit(udg_otryad)
    
    if GetUnitState( boss, UNIT_STATE_LIFE) <= 0.405 or not( udg_fightmod[0] ) then
        call RemoveUnit(boss)
        call DestroyTimer( LoadTimerHandle( udg_hash, GetHandleId( boss ), StringHash( "bsar1" ) ) )
        call DestroyTimer( GetExpiredTimer() )
        call FlushChildHashtable( udg_hash, id )
    else
        call CreateUnit( GetOwningPlayer( boss ), 'h00L', GetUnitX( target ) + GetRandomReal(-300, 300), GetUnitY( target ) + GetRandomReal(-300, 300), GetRandomReal(0, 360) )
    endif
    
    set boss = null
    set target = null
endfunction

function Trig_Arah1_Actions takes nothing returns nothing
    local integer id = GetHandleId( udg_DamageEventTarget )

    call DisableTrigger( GetTriggeringTrigger() )
    call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\Orc\\MirrorImage\\MirrorImageDeathCaster.mdl", GetUnitX( udg_DamageEventTarget ), GetUnitY( udg_DamageEventTarget ) ) )
    call IssueImmediateOrder( udg_DamageEventTarget, "stop" )
    call ShowUnit( udg_DamageEventTarget, false )
    call PauseUnit( udg_DamageEventTarget, true )
    call SetUnitPosition( udg_DamageEventTarget, GetRectCenterX( gg_rct_HeroesTp ), GetRectCenterY( gg_rct_HeroesTp ) )
    
    if LoadTimerHandle( udg_hash, id, StringHash( "bsar" ) ) == null  then
        call SaveTimerHandle( udg_hash, id, StringHash( "bsar" ), CreateTimer() )
    endif
	set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "bsar" ) ) ) 
    call SaveUnitHandle( udg_hash, id, StringHash( "bsar" ), udg_DamageEventTarget )
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( udg_DamageEventTarget ), StringHash( "bsar" ) ), bosscast(1.5), true, function ArahCast )
    
    set id = GetHandleId( udg_DamageEventTarget )
    if LoadTimerHandle( udg_hash, id, StringHash( "bsar1" ) ) == null  then
        call SaveTimerHandle( udg_hash, id, StringHash( "bsar1" ), CreateTimer() )
    endif
	set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "bsar1" ) ) ) 
    call SaveUnitHandle( udg_hash, id, StringHash( "bsar1" ), udg_DamageEventTarget )
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( udg_DamageEventTarget ), StringHash( "bsar1" ) ), bosscast(30), false, function ArahEnd )
endfunction

//===========================================================================
function InitTrig_Arah1 takes nothing returns nothing
    set gg_trg_Arah1 = CreateTrigger()
    call DisableTrigger( gg_trg_Arah1 )
    call TriggerRegisterVariableEvent( gg_trg_Arah1, "udg_AfterDamageEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_Arah1, Condition( function Trig_Arah1_Conditions ) )
    call TriggerAddAction( gg_trg_Arah1, function Trig_Arah1_Actions )
endfunction

