function Trig_Berserk3_Conditions takes nothing returns boolean
    return GetUnitTypeId(udg_DamageEventTarget) == 'e00F' and GetUnitLifePercent(udg_DamageEventTarget) <= 30
endfunction

function Trig_Berserk3_Actions takes nothing returns nothing
    call DisableTrigger( GetTriggeringTrigger() )
    call UnitAddAbility( udg_DamageEventTarget, 'S009' )
    call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\NightElf\\BattleRoar\\RoarCaster.mdl", GetUnitX( udg_DamageEventTarget ), GetUnitY( udg_DamageEventTarget ) ) )
endfunction

//===========================================================================
function InitTrig_Berserk3 takes nothing returns nothing
    set gg_trg_Berserk3 = CreateTrigger(  )
    call DisableTrigger( gg_trg_Berserk3 )
    call TriggerRegisterVariableEvent( gg_trg_Berserk3, "udg_AfterDamageEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_Berserk3, Condition( function Trig_Berserk3_Conditions ) )
    call TriggerAddAction( gg_trg_Berserk3, function Trig_Berserk3_Actions )
endfunction

