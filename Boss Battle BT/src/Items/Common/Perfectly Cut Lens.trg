{
  "Id": 50332503,
  "Comment": "",
  "IsScript": true,
  "RunOnMapInit": false,
  "Script": "function Trig_Perfectly_Cut_Lens_Conditions takes nothing returns boolean\r\n    return GetItemTypeId(GetManipulatedItem()) == 'I03R'\r\nendfunction\r\n\r\nfunction Perfectly_Cut_LensCast takes nothing returns nothing\r\n    local integer id = GetHandleId( GetExpiredTimer() )\r\n    local unit caster = LoadUnitHandle( udg_hash, id, StringHash( \"pcln\" ) )\r\n    local integer pl = LoadInteger( udg_hash, id, StringHash( \"pclnpl\" ) )\r\n    local item it = LoadItemHandle( udg_hash, id, StringHash( \"pclni\" ) )\r\n    local integer crystals = (udg_Set_Cristall_Number[pl+1]*100)\r\n    local integer arm = LoadInteger( udg_hash, GetHandleId( caster ), StringHash( \"pcln\" ) )\r\n    \r\n    if not(UnitHasItem(caster, it)) then\r\n        call FlushChildHashtable( udg_hash, id )\r\n        call DestroyTimer( GetExpiredTimer() )\r\n    elseif arm != crystals then\r\n        call BlzSetAbilityRealLevelFieldBJ( BlzGetItemAbility(it, 'A0BL'), ABILITY_RLF_AREA_OF_EFFECT, 0, crystals )\r\n        call BlzSetItemExtendedTooltip( it, words( caster, BlzGetItemExtendedTooltip(it), \"|cffbe81f7\", \"|r\", I2S(crystals) ) )\r\n        call BlzSetItemExtendedTooltip( it, words( caster, BlzGetItemExtendedTooltip(it), \"|cffffffff\", \"|r\", I2S(crystals) ) )\r\n        call SaveInteger( udg_hash, GetHandleId( caster ), StringHash( \"pcln\" ), crystals ) \r\n    endif\r\n\r\n    set caster = null\r\n    set it = null\r\nendfunction\r\n\r\nfunction Trig_Perfectly_Cut_Lens_Actions takes nothing returns nothing\r\n    local integer id = GetHandleId( GetManipulatedItem() )\r\n\r\n    if LoadTimerHandle( udg_hash, id, StringHash( \"pcln\" ) ) == null  then\r\n        call SaveTimerHandle( udg_hash, id, StringHash( \"pcln\" ), CreateTimer() )\r\n    endif\r\n    set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( \"pcln\" ) ) )\r\n    call SaveUnitHandle( udg_hash, id, StringHash( \"pcln\" ), GetManipulatingUnit() ) \r\n    call SaveItemHandle( udg_hash, id, StringHash( \"pclni\" ), GetManipulatedItem() )\r\n    call SaveInteger( udg_hash, id, StringHash( \"pclnpl\" ), CorrectPlayer(GetManipulatingUnit())-1 )\r\n    call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( GetManipulatedItem() ), StringHash( \"pcln\" ) ), 4, true, function Perfectly_Cut_LensCast )\r\nendfunction\r\n\r\n//===========================================================================\r\nfunction InitTrig_Perfectly_Cut_Lens takes nothing returns nothing\r\n    set gg_trg_Perfectly_Cut_Lens = CreateTrigger(  )\r\n    call TriggerRegisterAnyUnitEventBJ( gg_trg_Perfectly_Cut_Lens, EVENT_PLAYER_UNIT_PICKUP_ITEM ) \r\n    call TriggerAddCondition( gg_trg_Perfectly_Cut_Lens, Condition( function Trig_Perfectly_Cut_Lens_Conditions ) )\r\n    call TriggerAddAction( gg_trg_Perfectly_Cut_Lens, function Trig_Perfectly_Cut_Lens_Actions )\r\nendfunction\r\n\r\n",
  "Events": [],
  "LocalVariables": [],
  "Conditions": [],
  "Actions": []
}