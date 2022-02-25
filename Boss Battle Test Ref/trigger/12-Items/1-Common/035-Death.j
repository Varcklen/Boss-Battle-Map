function Trig_Death_Conditions takes nothing returns boolean
    return GetItemTypeId(GetManipulatedItem()) == 'I0DD' and udg_fightmod[1] and Battle_Ended == false
endfunction

function Trig_Death_Actions takes nothing returns nothing
    local integer cyclA = 1

    call stazisst( GetManipulatingUnit(), GetManipulatedItem() )
    call DisplayTextToForce( bj_FORCE_ALL_PLAYERS, "Used |cffffcc00Tarot Card: Death|r." )
    set udg_Heroes_Chanse = udg_Heroes_Chanse + 1
    call MultiSetValue( udg_multi, 2, 1, I2S( udg_Heroes_Chanse ) )
    loop
        exitwhen cyclA > 4
        if GetUnitState( udg_hero[cyclA], UNIT_STATE_LIFE) > 0.405 then
            call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\Undead\\AnimateDead\\AnimateDeadTarget.mdl", GetUnitX(udg_hero[cyclA]), GetUnitY(udg_hero[cyclA]) ) )
            call KillUnit( udg_hero[cyclA] )
        endif
        set cyclA = cyclA + 1
    endloop
endfunction

//===========================================================================
function InitTrig_Death takes nothing returns nothing
    set gg_trg_Death = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Death, EVENT_PLAYER_UNIT_USE_ITEM )
    call TriggerAddCondition( gg_trg_Death, Condition( function Trig_Death_Conditions ) )
    call TriggerAddAction( gg_trg_Death, function Trig_Death_Actions )
endfunction

