globals
    constant integer FAKE_COIN_GOLD = 300
endglobals

function Trig_Fake_Coin_Conditions takes nothing returns boolean
    return GetItemTypeId(Event_ItemExchange_Item) == 'I0AZ'
endfunction

function Trig_Fake_Coin_Actions takes nothing returns nothing
    local unit hero = Event_ItemExchange_Hero

    call DisplayTimedTextToPlayer(GetOwningPlayer(Event_ItemExchange_Hero), 0, 0, 5., "You were given |cffffcc00\"" + GetItemName(Event_ItemExchange_Item) + "\"|r." )
    call RemoveItem( Event_ItemExchange_Item )
    call moneyst( Event_ItemExchange_Hero, FAKE_COIN_GOLD )
    call moneyst( Event_ItemExchange_Friend, FAKE_COIN_GOLD )
    
    set hero = null
endfunction

//===========================================================================
function InitTrig_Fake_Coin takes nothing returns nothing
    call CreateEventTrigger( "Event_ItemExchange_Real", function Trig_Fake_Coin_Actions, function Trig_Fake_Coin_Conditions )
endfunction

