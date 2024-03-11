{
  "Id": 50332656,
  "Comment": "",
  "IsScript": true,
  "RunOnMapInit": false,
  "Script": "function Trig_Plaiful_Spirit_Conditions takes nothing returns boolean\r\n    return GetItemTypeId(GetManipulatedItem()) == 'I07L'\r\nendfunction\r\n\r\nfunction Naughty_SpiritCast takes nothing returns nothing \r\n\tlocal integer id = GetHandleId( GetExpiredTimer( ) )\r\n    local unit u = LoadUnitHandle( udg_hash, id, StringHash( \"nght\" ) )\r\n\tlocal real r = 12 * GetUnitSpellPower(u)\r\n    local item it = LoadItemHandle( udg_hash, id, StringHash( \"nghtt\" ) )\r\n    \r\n    if not(UnitHasItem(u,it )) then\r\n        call FlushChildHashtable( udg_hash, id )\r\n        call DestroyTimer( GetExpiredTimer() )\r\n    elseif GetUnitState( u, UNIT_STATE_MANA) >= r and GetUnitState( u, UNIT_STATE_LIFE) > 0.405 and not( udg_fightmod[3] ) and combat( u, false, 0 ) then\r\n        call DestroyEffect( AddSpecialEffect( \"Abilities\\\\Spells\\\\Human\\\\Invisibility\\\\InvisibilityTarget.mdl\", GetUnitX( u ), GetUnitY( u ) ) )\r\n        call spdst( u, 0.5 )\r\n        call SetUnitState( u, UNIT_STATE_MANA, RMaxBJ(0,GetUnitState( u, UNIT_STATE_MANA) - r ) )\r\n    endif\r\n    \r\n    set it = null\r\n    set u = null\r\nendfunction \r\n\r\nfunction Trig_Plaiful_Spirit_Actions takes nothing returns nothing\r\n    local integer id = GetHandleId( GetManipulatedItem() )\r\n\r\n    if LoadTimerHandle( udg_hash, id, StringHash( \"nght\" ) ) == null  then\r\n        call SaveTimerHandle( udg_hash, id, StringHash( \"nght\" ), CreateTimer() )\r\n    endif \r\n\tset id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( \"nght\" ) ) ) \r\n\tcall SaveUnitHandle( udg_hash, id, StringHash( \"nght\" ), GetManipulatingUnit() ) \r\n    call SaveItemHandle( udg_hash, id, StringHash( \"nghtt\" ), GetManipulatedItem() ) \r\n\tcall TimerStart( LoadTimerHandle( udg_hash, GetHandleId( GetManipulatedItem() ), StringHash( \"nght\" ) ), 10, true, function Naughty_SpiritCast )\r\nendfunction\r\n\r\n//===========================================================================\r\nfunction InitTrig_Plaiful_Spirit takes nothing returns nothing\r\n    set gg_trg_Plaiful_Spirit = CreateTrigger(  )\r\n    call TriggerRegisterAnyUnitEventBJ( gg_trg_Plaiful_Spirit, EVENT_PLAYER_UNIT_PICKUP_ITEM )\r\n    call TriggerAddCondition( gg_trg_Plaiful_Spirit, Condition( function Trig_Plaiful_Spirit_Conditions ) )\r\n    call TriggerAddAction( gg_trg_Plaiful_Spirit, function Trig_Plaiful_Spirit_Actions )\r\nendfunction\r\n\r\n",
  "Events": [],
  "LocalVariables": [],
  "Conditions": [],
  "Actions": []
}