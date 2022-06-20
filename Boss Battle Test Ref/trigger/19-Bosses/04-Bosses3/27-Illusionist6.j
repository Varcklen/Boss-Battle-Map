function Trig_Illusionist6_Conditions takes nothing returns boolean
    return GetUnitTypeId(udg_DamageEventTarget) == 'h020' and GetUnitLifePercent(udg_DamageEventTarget) <= 40
endfunction

function Trig_Illusionist6_Actions takes nothing returns nothing
    local integer cyclA = 1
    local real hp
    local real mp
    
    call DisableTrigger( GetTriggeringTrigger() )
    loop
        exitwhen cyclA > 4
	if GetUnitState( udg_hero[cyclA], UNIT_STATE_LIFE) > 0.405 then
		set hp = GetUnitState(udg_hero[cyclA], UNIT_STATE_LIFE)/GetUnitState(udg_hero[cyclA], UNIT_STATE_MAX_LIFE)
		set mp = GetUnitState(udg_hero[cyclA], UNIT_STATE_MANA)/GetUnitState(udg_hero[cyclA], UNIT_STATE_MAX_MANA)
    		call SetUnitState( udg_hero[cyclA], UNIT_STATE_LIFE, GetUnitState( udg_hero[cyclA], UNIT_STATE_MAX_LIFE) * mp )
    		call SetUnitState( udg_hero[cyclA], UNIT_STATE_MANA, GetUnitState( udg_hero[cyclA], UNIT_STATE_MAX_MANA) * hp )
                call DestroyEffect( AddSpecialEffectTarget("Abilities\\Spells\\Undead\\ReplenishMana\\ReplenishManaCasterOverhead.mdl", udg_hero[cyclA], "origin") )
	endif
        set cyclA = cyclA + 1
    endloop
endfunction

//===========================================================================
function InitTrig_Illusionist6 takes nothing returns nothing
    set gg_trg_Illusionist6 = CreateTrigger(  )
    call DisableTrigger( gg_trg_Illusionist6 )
    call TriggerRegisterVariableEvent( gg_trg_Illusionist6, "udg_AfterDamageEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_Illusionist6, Condition( function Trig_Illusionist6_Conditions ) )
    call TriggerAddAction( gg_trg_Illusionist6, function Trig_Illusionist6_Actions )
endfunction

