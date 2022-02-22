function Trig_Sheep_Elixir_Conditions takes nothing returns boolean
    return GetItemTypeId(GetManipulatedItem()) == 'I0BO'
endfunction

function Trig_Sheep_Elixir_Actions takes nothing returns nothing
    call NewUniques( GetManipulatingUnit(), 'A0MG' )
    call DestroyEffect( AddSpecialEffect( "Objects\\Spawnmodels\\Demon\\DemonSmallDeathExplode\\DemonSmallDeathExplode.mdl", GetUnitX( GetManipulatingUnit() ), GetUnitY( GetManipulatingUnit() ) ) )
    call stazisst( GetManipulatingUnit(), GetManipulatedItem() )
endfunction

//===========================================================================
function InitTrig_Sheep_Elixir takes nothing returns nothing
    set gg_trg_Sheep_Elixir = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Sheep_Elixir, EVENT_PLAYER_UNIT_USE_ITEM )
    call TriggerAddCondition( gg_trg_Sheep_Elixir, Condition( function Trig_Sheep_Elixir_Conditions ) )
    call TriggerAddAction( gg_trg_Sheep_Elixir, function Trig_Sheep_Elixir_Actions )
endfunction

