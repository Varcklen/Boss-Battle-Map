function Trig_Crab4_Conditions takes nothing returns boolean
    return GetUnitTypeId( udg_DamageEventTarget ) == 'n009' and GetUnitLifePercent(udg_DamageEventTarget) <= 40
endfunction

function Trig_Crab4_Actions takes nothing returns nothing
    local integer id = GetHandleId( udg_DamageEventTarget )
    
    call DisableTrigger( GetTriggeringTrigger() )
    call DestroyEffect( AddSpecialEffectTarget( "Abilities\\Spells\\Undead\\FrostNova\\FrostNovaTarget.mdl", udg_DamageEventTarget, "origin" ) )
    call SetUnitAbilityLevel(udg_DamageEventTarget, 'A01Y', 3 )
    call SaveInteger( udg_hash, GetHandleId( LoadTimerHandle( udg_hash, GetHandleId( udg_DamageEventTarget ), StringHash( "bscr1" ) ) ) , StringHash( "bscr1" ), 3 )
    call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( udg_DamageEventTarget ), StringHash( "bscr1" ) ), bosscast(6), true, function Crab1Cast )
endfunction

//===========================================================================
function InitTrig_Crab4 takes nothing returns nothing
    set gg_trg_Crab4 = CreateTrigger(  )
    call DisableTrigger( gg_trg_Crab4 )
    call TriggerRegisterVariableEvent( gg_trg_Crab4, "udg_AfterDamageEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_Crab4, Condition( function Trig_Crab4_Conditions ) )
    call TriggerAddAction( gg_trg_Crab4, function Trig_Crab4_Actions )
endfunction

