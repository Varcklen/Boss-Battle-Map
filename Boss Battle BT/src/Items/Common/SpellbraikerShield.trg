{
  "Id": 50332533,
  "Comment": "",
  "IsScript": true,
  "RunOnMapInit": false,
  "Script": "function Trig_SpellbraikerShield_Conditions takes nothing returns boolean \r\n\treturn GetItemTypeId(GetManipulatedItem()) == 'I00X' or ( GetItemTypeId(GetManipulatedItem()) == 'I030' and udg_Set_Weapon_Logic[GetPlayerId(GetOwningPlayer( GetTriggerUnit( ) )) + 1 + 52] ) \r\nendfunction \r\n\r\nfunction WitcherShieldEnd takes nothing returns nothing\r\n    local integer id = GetHandleId( GetExpiredTimer() )\r\n    call UnitRemoveAbility( LoadUnitHandle( udg_hash, id, StringHash( \"wshend\" ) ), 'A07C' ) \r\n    call UnitRemoveAbility( LoadUnitHandle( udg_hash, id, StringHash( \"wshend\" ) ), 'B02S' ) \r\n    call FlushChildHashtable( udg_hash, id )\r\nendfunction\r\n\r\nfunction WitcherShieldCast takes nothing returns nothing \r\n    local integer id = GetHandleId( GetExpiredTimer( ) )\r\n    local unit caster = LoadUnitHandle( udg_hash, id, StringHash( \"wsh\" ) )\r\n    local integer id1\r\n    local real t = timebonus(caster, 3)\r\n    local item it = LoadItemHandle( udg_hash, id, StringHash( \"wsht\" ) )\r\n    \r\n    if not(UnitHasItem(caster,it )) then\r\n        call UnitRemoveAbility( caster, 'A07C' ) \r\n        call UnitRemoveAbility( caster, 'B02S' )\r\n        call FlushChildHashtable( udg_hash, id )\r\n        call DestroyTimer( GetExpiredTimer() )\r\n    elseif GetUnitState( caster, UNIT_STATE_LIFE) > 0.405 then\r\n        set id1 = GetHandleId( caster )\r\n\t\tcall UnitAddAbility( caster, 'A07C' ) \r\n        if LoadTimerHandle( udg_hash, id1, StringHash( \"wshend\" ) ) == null then\r\n            call SaveTimerHandle( udg_hash, id1, StringHash( \"wshend\" ), CreateTimer() )\r\n        endif\r\n        set id1 = GetHandleId( LoadTimerHandle( udg_hash, id1, StringHash( \"wshend\" ) ) ) \r\n        call SaveUnitHandle( udg_hash, id1, StringHash( \"wshend\" ), caster )\r\n        call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( caster ), StringHash( \"wshend\" ) ), t, false, function WitcherShieldEnd )\r\n\tendif\r\n    \r\n    set it = null\r\n    set caster = null\r\nendfunction \r\n\r\nfunction Trig_SpellbraikerShield_Actions takes nothing returns nothing \r\n    local integer id\r\n    local unit caster\r\n    local item it\r\n\r\n    if udg_CastLogic then\r\n        set udg_CastLogic = false\r\n        set caster = udg_Caster\r\n        set it = udg_CastItem\r\n    else    \r\n        set caster = GetManipulatingUnit()\r\n        set it = GetManipulatedItem()\r\n    endif\r\n\r\n    set id = GetHandleId( it )\r\n    if LoadTimerHandle( udg_hash, id, StringHash( \"wsh\" ) ) == null then\r\n        call SaveTimerHandle( udg_hash, id, StringHash( \"wsh\" ), CreateTimer() )\r\n    endif \r\n\tset id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( \"wsh\" ) ) ) \r\n\tcall SaveUnitHandle( udg_hash, id, StringHash( \"wsh\" ), caster ) \r\n    call SaveItemHandle( udg_hash, id, StringHash( \"wsht\" ), it ) \r\n\tcall TimerStart( LoadTimerHandle( udg_hash, GetHandleId( it ), StringHash( \"wsh\" ) ), 12, true, function WitcherShieldCast )\r\n    \r\n    set caster = null\r\n    set it = null\r\nendfunction \r\n\r\n//=========================================================================== \r\nfunction InitTrig_SpellbraikerShield takes nothing returns nothing \r\n\tset gg_trg_SpellbraikerShield = CreateTrigger( ) \r\n\tcall TriggerRegisterAnyUnitEventBJ( gg_trg_SpellbraikerShield, EVENT_PLAYER_UNIT_PICKUP_ITEM ) \r\n\tcall TriggerAddCondition( gg_trg_SpellbraikerShield, Condition( function Trig_SpellbraikerShield_Conditions ) ) \r\n\tcall TriggerAddAction( gg_trg_SpellbraikerShield, function Trig_SpellbraikerShield_Actions ) \r\nendfunction",
  "Events": [],
  "LocalVariables": [],
  "Conditions": [],
  "Actions": []
}