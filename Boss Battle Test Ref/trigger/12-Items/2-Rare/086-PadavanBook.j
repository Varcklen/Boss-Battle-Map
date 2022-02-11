function Trig_PadavanBook_Conditions takes nothing returns boolean
    return GetItemTypeId(GetManipulatedItem()) == 'I04C'
endfunction

function Trig_PadavanBook_Actions takes nothing returns nothing
    call statst( GetManipulatingUnit(), 2, 2, 2, 0, true )
    if GetHeroLevel(GetManipulatingUnit()) <= 5 then
        call SetHeroLevel(GetManipulatingUnit(), GetHeroLevel(GetManipulatingUnit()) + 1, false)
        call DestroyEffect( AddSpecialEffectTarget("Abilities\\Spells\\Other\\Levelup\\LevelupCaster.mdl", GetManipulatingUnit(), "origin" ) )
    else
        call DestroyEffect( AddSpecialEffectTarget("Abilities\\Spells\\Human\\HolyBolt\\HolyBoltSpecialArt.mdl", GetManipulatingUnit(), "origin" ) )
    endif
    call stazisst( GetManipulatingUnit(), GetManipulatedItem() )
endfunction

//===========================================================================
function InitTrig_PadavanBook takes nothing returns nothing
    set gg_trg_PadavanBook = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_PadavanBook, EVENT_PLAYER_UNIT_USE_ITEM )
    call TriggerAddCondition( gg_trg_PadavanBook, Condition( function Trig_PadavanBook_Conditions ) )
    call TriggerAddAction( gg_trg_PadavanBook, function Trig_PadavanBook_Actions )
endfunction

