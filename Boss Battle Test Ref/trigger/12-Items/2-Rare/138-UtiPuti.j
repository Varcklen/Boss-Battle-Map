function Trig_UtiPuti_Conditions takes nothing returns boolean
    return GetItemTypeId(GetManipulatedItem()) == 'I08J'
endfunction

function Trig_UtiPuti_Actions takes nothing returns nothing
    call NewUniques( GetManipulatingUnit(), 'A00N' )
    call DestroyEffect( AddSpecialEffect( "Objects\\Spawnmodels\\Demon\\DemonSmallDeathExplode\\DemonSmallDeathExplode.mdl", GetUnitX( GetManipulatingUnit() ), GetUnitY( GetManipulatingUnit() ) ) )
    call stazisst( GetManipulatingUnit(), GetManipulatedItem() )
endfunction

//===========================================================================
function InitTrig_UtiPuti takes nothing returns nothing
    set gg_trg_UtiPuti = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_UtiPuti, EVENT_PLAYER_UNIT_USE_ITEM )
    call TriggerAddCondition( gg_trg_UtiPuti, Condition( function Trig_UtiPuti_Conditions ) )
    call TriggerAddAction( gg_trg_UtiPuti, function Trig_UtiPuti_Actions )
endfunction

