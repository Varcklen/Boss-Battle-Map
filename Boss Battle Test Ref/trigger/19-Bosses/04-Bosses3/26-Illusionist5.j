//TESH.scrollpos=0
//TESH.alwaysfold=0
function Trig_gg_trg_Illusionist5_Conditions takes nothing returns boolean
    return GetUnitTypeId(udg_DamageEventTarget) == 'h020'  and GetUnitLifePercent(udg_DamageEventTarget) <= 80
endfunction

function Trig_gg_trg_Illusionist5_Actions takes nothing returns nothing
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
function InitTrig_Illusionist5 takes nothing returns nothing
    set gg_trg_Illusionist5 = CreateTrigger()
    call DisableTrigger( gg_trg_Illusionist5 )
    call TriggerRegisterVariableEvent( gg_trg_Illusionist5, "udg_AfterDamageEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_Illusionist5, Condition( function Trig_gg_trg_Illusionist5_Conditions ) )
    call TriggerAddAction( gg_trg_Illusionist5, function Trig_gg_trg_Illusionist5_Actions )
endfunction

