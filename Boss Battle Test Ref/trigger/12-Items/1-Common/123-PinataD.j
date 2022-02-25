function Trig_PinataD_Conditions takes nothing returns boolean
    return GetUnitTypeId(GetDyingUnit()) == 'h01Z'
endfunction

function Trig_PinataD_Actions takes nothing returns nothing
    local integer cyclA = 1
    loop
	exitwhen cyclA > 4
	if GetPlayerSlotState( Player( cyclA - 1 ) ) == PLAYER_SLOT_STATE_PLAYING then
		call moneyst( udg_hero[cyclA], 100 )
		if GetUnitState( udg_hero[cyclA], UNIT_STATE_LIFE) > 0.405 and UnitInventoryCount(udg_hero[cyclA]) < 6 then
            call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\Orc\\MirrorImage\\MirrorImageDeathCaster.mdl", GetUnitX( udg_hero[cyclA] ), GetUnitY( udg_hero[cyclA] ) ) )
		    call ItemRandomizerAll( udg_hero[cyclA], 0 )
		endif
	endif
        set cyclA = cyclA + 1
    endloop
endfunction

//===========================================================================
function InitTrig_PinataD takes nothing returns nothing
    set gg_trg_PinataD = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_PinataD, EVENT_PLAYER_UNIT_DEATH )
    call TriggerAddCondition( gg_trg_PinataD, Condition( function Trig_PinataD_Conditions ) )
    call TriggerAddAction( gg_trg_PinataD, function Trig_PinataD_Actions )
endfunction

