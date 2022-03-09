function Trig_Bandit3_Conditions takes nothing returns boolean
    return GetUnitTypeId(udg_DamageEventTarget) == 'h014' and GetUnitLifePercent(udg_DamageEventTarget) <= 50.
endfunction

function Trig_Bandit3_Actions takes nothing returns nothing
	local integer cyclA = 1
	local real x
	local real y

    call DisableTrigger( GetTriggeringTrigger() )
    call UnitAddAbility( udg_DamageEventTarget, 'A0XS' )
    call DestroyEffect( AddSpecialEffectTarget("Abilities\\Spells\\NightElf\\Taunt\\TauntCaster.mdl", udg_DamageEventTarget, "origin") )

	loop
		exitwhen cyclA > 4
    		set x = GetRectCenterX( udg_Boss_Rect ) + 2000 * Cos( ( 45 + ( 90 * cyclA ) ) * bj_DEGTORAD )
    		set y = GetRectCenterY( udg_Boss_Rect ) + 2000 * Sin( ( 45 + ( 90 * cyclA ) ) * bj_DEGTORAD )
    		call CreateUnit( GetOwningPlayer( udg_DamageEventTarget ), 'n02V', x, y, 270 )
		set cyclA = cyclA + 1
	endloop
endfunction

//===========================================================================
function InitTrig_Bandit3 takes nothing returns nothing
    set gg_trg_Bandit3 = CreateTrigger(  )
    call DisableTrigger( gg_trg_Bandit3 )
    call TriggerRegisterVariableEvent( gg_trg_Bandit3, "udg_AfterDamageEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_Bandit3, Condition( function Trig_Bandit3_Conditions ) )
    call TriggerAddAction( gg_trg_Bandit3, function Trig_Bandit3_Actions )
endfunction

