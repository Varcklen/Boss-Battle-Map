function Trig_Wendigo5_Conditions takes nothing returns boolean
    return GetUnitTypeId(udg_DamageEventTarget) == 'n03I' and GetUnitLifePercent(udg_DamageEventTarget) <= 10
endfunction

function Wend5Cast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local unit boss = LoadUnitHandle( udg_hash, id, StringHash( "bswd5" ) )
    local integer i = LoadInteger( udg_hash, id, StringHash( "bswd5" ) ) + 1
    
    call SetUnitScale( boss, 1.5 + (i * 0.025), 1.5 + (i * 0.025), 1.5 + (i * 0.025) )
    call SetUnitVertexColorBJ( boss, 100, 100 - ( 2 * i ), 100 - ( 2 * i ), 0 )
    
    if GetUnitState( boss, UNIT_STATE_LIFE) <= 0.405 or not( udg_fightmod[0] ) or i > 10 then
        call FlushChildHashtable( udg_hash, id )
        call DestroyTimer( GetExpiredTimer() )
    else
        call SaveInteger( udg_hash, id, StringHash( "bswd5" ), i )
        call SetUnitState( boss, UNIT_STATE_LIFE, GetUnitState( boss, UNIT_STATE_LIFE) + ( GetUnitState( boss, UNIT_STATE_MAX_LIFE) * 0.02 ) )
        call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\Human\\Resurrect\\ResurrectTarget.mdl", GetUnitX( boss ), GetUnitY( boss ) ) )
    endif
    
    set boss = null
endfunction

function Trig_Wendigo5_Actions takes nothing returns nothing
    local integer id = GetHandleId( udg_DamageEventTarget )
    local integer cyclA = 1

    call DisableTrigger( GetTriggeringTrigger() )
    call UnitAddAbility( udg_DamageEventTarget, 'A0VR' )
    call DestroyEffect( AddSpecialEffectTarget( "Abilities\\Spells\\NightElf\\BattleRoar\\RoarCaster.mdl", udg_DamageEventTarget, "origin") )
    call TransmissionFromUnitWithNameBJ( bj_FORCE_ALL_PLAYERS, udg_DamageEventTarget, GetUnitName(udg_DamageEventTarget), null, "ENOUGH!", bj_TIMETYPE_SET, 3, false )
    
    if LoadTimerHandle( udg_hash, id, StringHash( "bswd5" ) ) == null  then
        call SaveTimerHandle( udg_hash, id, StringHash( "bswd5" ), CreateTimer() )
    endif
	set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "bswd5" ) ) )
    call SaveUnitHandle( udg_hash, id, StringHash( "bswd5" ), udg_DamageEventTarget )
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( udg_DamageEventTarget ), StringHash( "bswd5" ) ), bosscast(1), true, function Wend5Cast )
endfunction

//===========================================================================
function InitTrig_Wendigo5 takes nothing returns nothing
    set gg_trg_Wendigo5 = CreateTrigger(  )
    call DisableTrigger( gg_trg_Wendigo5 )
    call TriggerRegisterVariableEvent( gg_trg_Wendigo5, "udg_AfterDamageEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_Wendigo5, Condition( function Trig_Wendigo5_Conditions ) )
    call TriggerAddAction( gg_trg_Wendigo5, function Trig_Wendigo5_Actions )
endfunction

