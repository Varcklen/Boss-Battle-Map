function Trig_Mystery_box_Conditions takes nothing returns boolean
    return GetItemTypeId(GetManipulatedItem()) == 'I0FC'
endfunction

function Trig_Mystery_box_Actions takes nothing returns nothing
    local unit u = GetManipulatingUnit()
    local integer index = LoadInteger( udg_hash, GetHandleId(GetManipulatedItem()), StringHash( "modbad25" ) )
    
    call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\Human\\Polymorph\\PolyMorphDoneGround.mdl", GetUnitX( u ), GetUnitY( u ) ) )
    call RemoveSavedInteger(udg_hash, GetHandleId( GetManipulatedItem() ), StringHash( "modbad25" ) )
    call RemoveItem( GetManipulatedItem() )
    call UnitAddItem(u, CreateItem(index, GetUnitX(u), GetUnitY(u)))
    
    set u = null
endfunction

//===========================================================================
function InitTrig_Mystery_box takes nothing returns nothing
    set gg_trg_Mystery_box = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Mystery_box, EVENT_PLAYER_UNIT_USE_ITEM )
    call TriggerAddCondition( gg_trg_Mystery_box, Condition( function Trig_Mystery_box_Conditions ) )
    call TriggerAddAction( gg_trg_Mystery_box, function Trig_Mystery_box_Actions )
endfunction

