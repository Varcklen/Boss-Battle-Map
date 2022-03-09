function Trig_SeaGiant4_Conditions takes nothing returns boolean
    return GetUnitTypeId( udg_DamageEventTarget ) == 'n00W' and GetUnitLifePercent(udg_DamageEventTarget) <= 30
endfunction

function Trig_SeaGiant4_Actions takes nothing returns nothing
    local integer cyclA = 1
    
    call DisableTrigger( GetTriggeringTrigger() )
    call UnitAddAbility( udg_DamageEventTarget, 'A0DH')
    call TransmissionFromUnitWithNameBJ( bj_FORCE_ALL_PLAYERS, udg_DamageEventTarget, GetUnitName(udg_DamageEventTarget), null, "I won’t give up so easily!", bj_TIMETYPE_SET, 3, false )
    call DestroyEffect( AddSpecialEffectTarget( "Abilities\\Spells\\NightElf\\BattleRoar\\RoarCaster.mdl", udg_DamageEventTarget, "origin") )
endfunction

//===========================================================================
function InitTrig_SeaGiant4 takes nothing returns nothing
    set gg_trg_SeaGiant4 = CreateTrigger(  )
    call DisableTrigger( gg_trg_SeaGiant4 )
    call TriggerRegisterVariableEvent( gg_trg_SeaGiant4, "udg_AfterDamageEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_SeaGiant4, Condition( function Trig_SeaGiant4_Conditions ) )
    call TriggerAddAction( gg_trg_SeaGiant4, function Trig_SeaGiant4_Actions )
endfunction

