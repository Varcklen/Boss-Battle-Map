function Trig_Aku4_Conditions takes nothing returns boolean
    return GetUnitTypeId(udg_DamageEventTarget) == 'n04O'  and GetUnitLifePercent(udg_DamageEventTarget) <= 80
endfunction

function Aku4Cast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local unit boss = LoadUnitHandle( udg_hash, id, StringHash( "bsdl4" ) )

    if GetUnitState( boss, UNIT_STATE_LIFE) <= 0.405 or not( udg_fightmod[0] ) then
        call DestroyTimer( GetExpiredTimer() )
        call FlushChildHashtable( udg_hash, id )
    else
        call DestroyEffect( AddSpecialEffectTarget("Abilities\\Spells\\NightElf\\BattleRoar\\RoarCaster.mdl", boss, "origin" ) )
        call UnitAddAbility( boss, 'A02Z' )
    endif
    
    set boss = null
endfunction

function Trig_Aku4_Actions takes nothing returns nothing
    local integer id = GetHandleId( udg_DamageEventTarget )
    
    call DisableTrigger( GetTriggeringTrigger() )
    
    if LoadTimerHandle( udg_hash, id, StringHash( "bsdl4" ) ) == null  then
        call SaveTimerHandle( udg_hash, id, StringHash( "bsdl4" ), CreateTimer() )
    endif
	set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "bsdl4" ) ) ) 
    call SaveUnitHandle( udg_hash, id, StringHash( "bsdl4" ), udg_DamageEventTarget )
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( udg_DamageEventTarget ), StringHash( "bsdl4" ) ), bosscast(20), true, function Aku4Cast )
endfunction

//===========================================================================
function InitTrig_Aku4 takes nothing returns nothing
    set gg_trg_Aku4 = CreateTrigger()
    call DisableTrigger( gg_trg_Aku4 )
    call TriggerRegisterVariableEvent( gg_trg_Aku4, "udg_AfterDamageEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_Aku4, Condition( function Trig_Aku4_Conditions ) )
    call TriggerAddAction( gg_trg_Aku4, function Trig_Aku4_Actions )
endfunction

