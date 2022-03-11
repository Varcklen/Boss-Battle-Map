function Trig_Kobzar_Conditions takes nothing returns boolean
    return GetItemTypeId(GetManipulatedItem()) == 'I08X'
endfunction

function Trig_Kobzar_Actions takes nothing returns nothing
    call DestroyEffect( AddSpecialEffectTarget( "Abilities\\Spells\\Items\\AIem\\AIemTarget.mdl", GetManipulatingUnit(), "origin") )
    if GetHeroInt( GetManipulatingUnit(), false) < 10000 then
        call statst( GetManipulatingUnit(), 0, 0, GetHeroInt( GetManipulatingUnit(), false), 0, true )
    endif
    call stazisst( GetManipulatingUnit(), GetManipulatedItem() )
endfunction

//===========================================================================
function InitTrig_Kobzar takes nothing returns nothing
    set gg_trg_Kobzar = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Kobzar, EVENT_PLAYER_UNIT_USE_ITEM )
    call TriggerAddCondition( gg_trg_Kobzar, Condition( function Trig_Kobzar_Conditions ) )
    call TriggerAddAction( gg_trg_Kobzar, function Trig_Kobzar_Actions )
endfunction