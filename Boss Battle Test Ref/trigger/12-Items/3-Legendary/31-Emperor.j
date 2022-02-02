function Trig_Emperor_Conditions takes nothing returns boolean
    return GetItemTypeId(GetManipulatedItem()) == 'I07Z'
endfunction

function Trig_Emperor_Actions takes nothing returns nothing
    if LoadInteger( udg_hash, GetHandleId( GetManipulatingUnit() ), StringHash( "kill" ) ) >= 50 then
        call SetHeroLevel(GetManipulatingUnit(), GetHeroLevel(GetManipulatingUnit()) + 5, true)
    else
        call statst( GetManipulatingUnit(), 1, 1, 1, 0, true )
        call DestroyEffect( AddSpecialEffectTarget("Abilities\\Spells\\NightElf\\BattleRoar\\RoarCaster.mdl", GetManipulatingUnit(), "origin" ) )
    endif
    call stazisst( GetManipulatingUnit(), GetManipulatedItem() )
endfunction

//===========================================================================
function InitTrig_Emperor takes nothing returns nothing
    set gg_trg_Emperor = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Emperor, EVENT_PLAYER_UNIT_USE_ITEM )
    call TriggerAddCondition( gg_trg_Emperor, Condition( function Trig_Emperor_Conditions ) )
    call TriggerAddAction( gg_trg_Emperor, function Trig_Emperor_Actions )
endfunction

