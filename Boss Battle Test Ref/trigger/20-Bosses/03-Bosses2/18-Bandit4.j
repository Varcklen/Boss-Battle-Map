function Trig_Bandit4_Conditions takes nothing returns boolean
    return GetUnitTypeId(udg_DamageEventTarget) == 'h014' and GetUnitLifePercent(udg_DamageEventTarget) <= 25
endfunction

function Trig_Bandit4_Actions takes nothing returns nothing
	local integer cyclA = 1
	local real x
	local real y

    call DisableTrigger( GetTriggeringTrigger() )
    call SaveInteger( udg_hash, GetHandleId( udg_DamageEventTarget ), StringHash( "bsrg" ), 2 )
    call DestroyEffect( AddSpecialEffectTarget("Abilities\\Spells\\Other\\Transmute\\PileofGold.mdl", udg_DamageEventTarget, "origin") )

	loop
		exitwhen cyclA > 4
    		set x = GetRectCenterX( udg_Boss_Rect ) + 2000 * Cos( ( 45 + ( 90 * cyclA ) ) * bj_DEGTORAD )
    		set y = GetRectCenterY( udg_Boss_Rect ) + 2000 * Sin( ( 45 + ( 90 * cyclA ) ) * bj_DEGTORAD )
    		call CreateUnit( GetOwningPlayer( udg_DamageEventTarget ), 'n02V', x, y, 270 )
		set cyclA = cyclA + 1
	endloop
endfunction

//===========================================================================
function InitTrig_Bandit4 takes nothing returns nothing
    set gg_trg_Bandit4 = CreateTrigger(  )
    call DisableTrigger( gg_trg_Bandit4 )
    call TriggerRegisterVariableEvent( gg_trg_Bandit4, "udg_AfterDamageEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_Bandit4, Condition( function Trig_Bandit4_Conditions ) )
    call TriggerAddAction( gg_trg_Bandit4, function Trig_Bandit4_Actions )
endfunction

