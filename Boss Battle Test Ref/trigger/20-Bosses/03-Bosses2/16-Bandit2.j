function Trig_Bandit2_Conditions takes nothing returns boolean
    return GetUnitTypeId(udg_DamageEventTarget) == 'h014' and GetUnitLifePercent(udg_DamageEventTarget) <= 75.
endfunction

function Trig_Bandit2_Actions takes nothing returns nothing
	local integer cyclA = 1
	local real x
	local real y

    call DisableTrigger( GetTriggeringTrigger() )
    call UnitAddAbility( udg_DamageEventTarget, 'A0XR' )
    call DestroyEffect( AddSpecialEffectTarget("Abilities\\Spells\\Other\\HowlOfTerror\\HowlCaster.mdl", udg_DamageEventTarget, "origin") )

	loop
		exitwhen cyclA > 4
    		set x = GetRectCenterX( udg_Boss_Rect ) + 2000 * Cos( ( 45 + ( 90 * cyclA ) ) * bj_DEGTORAD )
    		set y = GetRectCenterY( udg_Boss_Rect ) + 2000 * Sin( ( 45 + ( 90 * cyclA ) ) * bj_DEGTORAD )
    		call CreateUnit( GetOwningPlayer( udg_DamageEventTarget ), 'n02V', x, y, 270 )
		set cyclA = cyclA + 1
	endloop
endfunction

//===========================================================================
function InitTrig_Bandit2 takes nothing returns nothing
    set gg_trg_Bandit2 = CreateTrigger(  )
    call DisableTrigger( gg_trg_Bandit2 )
    call TriggerRegisterVariableEvent( gg_trg_Bandit2, "udg_AfterDamageEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_Bandit2, Condition( function Trig_Bandit2_Conditions ) )
    call TriggerAddAction( gg_trg_Bandit2, function Trig_Bandit2_Actions )
endfunction

