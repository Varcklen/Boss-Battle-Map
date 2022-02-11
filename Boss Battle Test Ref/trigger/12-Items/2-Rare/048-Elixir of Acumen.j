function Trig_Elixir_of_Acumen_Conditions takes nothing returns boolean
    return GetItemTypeId(GetManipulatedItem()) == 'I0BA'
endfunction

function Trig_Elixir_of_Acumen_Actions takes nothing returns nothing
    call DestroyEffect( AddSpecialEffectTarget("Abilities\\Spells\\Human\\Polymorph\\PolyMorphDoneGround.mdl", GetManipulatingUnit(), "origin" ) )
    if udg_PotionsUsed[GetPlayerId( GetOwningPlayer( GetManipulatingUnit() ) ) + 1] >= 5 then
        call NewUniques( GetManipulatingUnit(), 'A13I' )
    endif
    call statst( GetManipulatingUnit(), 1, 1, 1, 0, true )
    
    call stazisst( GetManipulatingUnit(), GetManipulatedItem() )
endfunction

//===========================================================================
function InitTrig_Elixir_of_Acumen takes nothing returns nothing
    set gg_trg_Elixir_of_Acumen = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Elixir_of_Acumen, EVENT_PLAYER_UNIT_USE_ITEM )
    call TriggerAddCondition( gg_trg_Elixir_of_Acumen, Condition( function Trig_Elixir_of_Acumen_Conditions ) )
    call TriggerAddAction( gg_trg_Elixir_of_Acumen, function Trig_Elixir_of_Acumen_Actions )
endfunction

