
function Trig_Volatile_Water_Conditions takes nothing returns boolean
    return GetItemTypeId(Event_ItemExchange_Item) == 'I0GD'
endfunction

function Trig_Volatile_Water_Actions takes nothing returns nothing
    local unit hero = Event_ItemExchange_Hero

    set Event_ItemExchange_Item = Inventory_ReplaceItemByNew(hero, Event_ItemExchange_Item, GetItemTypeId(Event_ItemExchange_OldItem))
    call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\Human\\Polymorph\\PolyMorphDoneGround.mdl", GetUnitX( hero ), GetUnitY( hero ) ) )
    
    set hero = null
endfunction

//===========================================================================
function InitTrig_Volatile_Water takes nothing returns nothing
    call CreateEventTrigger( "Event_ItemExchange_Real", function Trig_Volatile_Water_Actions, function Trig_Volatile_Water_Conditions )
endfunction

