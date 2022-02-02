function Trig_Voidlord2_Conditions takes nothing returns boolean
    return GetUnitTypeId(GetDyingUnit()) == 'h008'
endfunction

function Trig_Voidlord2_Actions takes nothing returns nothing
	local unit u = LoadUnitHandle( udg_hash, GetHandleId( GetDyingUnit() ), StringHash( "egg" ) )

	call SetUnitPosition( u, GetUnitX(GetDyingUnit()), GetUnitY(GetDyingUnit()) )
    call PauseUnit( u, false )
	call ShowUnitShow( u )
	call DestroyEffect( AddSpecialEffectTarget("Abilities\\Spells\\NightElf\\BattleRoar\\RoarCaster.mdl", u, "origin" ) )

	set u = null
endfunction

//===========================================================================
function InitTrig_Voidlord2 takes nothing returns nothing
    set gg_trg_Voidlord2 = CreateTrigger(  )
    call DisableTrigger( gg_trg_Voidlord2 )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Voidlord2, EVENT_PLAYER_UNIT_DEATH )
    call TriggerAddCondition( gg_trg_Voidlord2, Condition( function Trig_Voidlord2_Conditions ) )
    call TriggerAddAction( gg_trg_Voidlord2, function Trig_Voidlord2_Actions )
endfunction

