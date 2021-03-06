function Trig_Chief5_Conditions takes nothing returns boolean
    return GetUnitTypeId( udg_DamageEventTarget ) == 'h01X' and GetUnitLifePercent(udg_DamageEventTarget) <= 80
endfunction

function Trig_Chief5_Actions takes nothing returns nothing
    local integer cyclA = 1

    call DisableTrigger( GetTriggeringTrigger() )
 
        call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\Human\\DispelMagic\\DispelMagicTarget.mdl", GetUnitX(udg_DamageEventTarget), GetUnitY(udg_DamageEventTarget) ) ) 
	call DelBuff( udg_DamageEventTarget, false )   
	loop
		exitwhen cyclA > 4
		if GetUnitState( udg_hero[cyclA], UNIT_STATE_LIFE) > 0.405 then
        		call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\Human\\DispelMagic\\DispelMagicTarget.mdl", GetUnitX(udg_hero[cyclA]), GetUnitY(udg_hero[cyclA]) ) ) 
			call DelBuff( udg_hero[cyclA], false )
		endif
		set cyclA = cyclA + 1
	endloop
endfunction

//===========================================================================
function InitTrig_Chief5 takes nothing returns nothing
    set gg_trg_Chief5 = CreateTrigger(  )
    call DisableTrigger( gg_trg_Chief5 )
    call TriggerRegisterVariableEvent( gg_trg_Chief5, "udg_AfterDamageEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_Chief5, Condition( function Trig_Chief5_Conditions ) )
    call TriggerAddAction( gg_trg_Chief5, function Trig_Chief5_Actions )
endfunction

