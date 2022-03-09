function Trig_MountGiant5_Conditions takes nothing returns boolean
    return GetUnitTypeId( udg_DamageEventTarget ) == 'e000' and GetUnitLifePercent(udg_DamageEventTarget) <= 30
endfunction

function Trig_MountGiant5_Actions takes nothing returns nothing
    local integer cyclA = 1

    call DisableTrigger( GetTriggeringTrigger() )
    
	loop
		exitwhen cyclA > 4
		if GetUnitState( udg_hero[cyclA], UNIT_STATE_LIFE) > 0.405 then
        		call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\Human\\ThunderClap\\ThunderClapCaster.mdl", GetUnitX(udg_hero[cyclA]), GetUnitY(udg_hero[cyclA]) ) ) 
    			call SetUnitState( udg_hero[cyclA], UNIT_STATE_MANA, RMaxBJ(0,GetUnitState( udg_hero[cyclA], UNIT_STATE_MANA) - (0.2*GetUnitState( udg_hero[cyclA], UNIT_STATE_MAX_MANA)) ))
    			call SetUnitState( udg_hero[cyclA], UNIT_STATE_LIFE, RMaxBJ(0,GetUnitState( udg_hero[cyclA], UNIT_STATE_LIFE) - (0.2*GetUnitState( udg_hero[cyclA], UNIT_STATE_MAX_LIFE)) ))
		endif
		set cyclA = cyclA + 1
	endloop
endfunction

//===========================================================================
function InitTrig_MountGiant5 takes nothing returns nothing
    set gg_trg_MountGiant5 = CreateTrigger(  )
    call DisableTrigger( gg_trg_MountGiant5 )
    call TriggerRegisterVariableEvent( gg_trg_MountGiant5, "udg_AfterDamageEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_MountGiant5, Condition( function Trig_MountGiant5_Conditions ) )
    call TriggerAddAction( gg_trg_MountGiant5, function Trig_MountGiant5_Actions )
endfunction

