{
  "Id": 50332846,
  "Comment": "",
  "IsScript": true,
  "RunOnMapInit": false,
  "Script": "globals\r\n    unit Event_Book_Of_Oblivion_Used_Unit\r\n    real Event_Book_Of_Oblivion_Used_Real\r\nendglobals\r\n\r\nfunction Trig_Book_of_Oblivion_Conditions takes nothing returns boolean\r\n    return GetItemTypeId(GetManipulatedItem()) == 'I03S'\r\nendfunction\r\n\r\n/*function Book_of_OblivionEnd takes nothing returns nothing\r\n    local integer id = GetHandleId( GetExpiredTimer() )\r\n    local item it = LoadItemHandle( udg_hash, id, StringHash( \"bkoo1\" ) )\r\n    \r\n    call RemoveItem( it )\r\n    call FlushChildHashtable( udg_hash, id )\r\n    \r\n    set it = null\r\nendfunction\r\n\r\nfunction Book_of_OblivionCast takes nothing returns nothing\r\n    local integer id = GetHandleId( GetExpiredTimer() )\r\n    local item it = LoadItemHandle( udg_hash, id, StringHash( \"bkoo\" ) )\r\n    local unit u = LoadUnitHandle( udg_hash, id, StringHash( \"bkoou\" ) )\r\n    local integer id1\r\n    \r\n    call UnitAddItem(u, it)\r\n    call FlushChildHashtable( udg_hash, id )\r\n    \r\n    set id1 = GetHandleId( it )\r\n    call SaveTimerHandle( udg_hash, GetHandleId( it ), StringHash( \"bkoo1\" ), CreateTimer() )\r\n\tset id1 = GetHandleId( LoadTimerHandle( udg_hash, GetHandleId( it ), StringHash( \"bkoo1\" ) ) ) \r\n\tcall SaveItemHandle( udg_hash, id1, StringHash( \"bkoo1\" ), it )\r\n\tcall TimerStart( LoadTimerHandle( udg_hash, GetHandleId( it ), StringHash( \"bkoo1\" ) ), 0.1, false, function Book_of_OblivionEnd )\r\n    \r\n    set it = null\r\n    set u = null\r\nendfunction*/\r\n\r\nfunction Trig_Book_of_Oblivion_Actions takes nothing returns nothing\r\n\t/*local unit caster = GetManipulatingUnit()\r\n    local integer i = GetPlayerId(GetOwningPlayer(GetManipulatingUnit())) + 1\r\n    local integer id*/\r\n    \r\n    local unit caster = GetManipulatingUnit()\r\n    local integer playerId = GetPlayerId(GetOwningPlayer(caster)) + 1\r\n    local integer heroTypeId = udg_HeroNum[playerId]\r\n    local integer i\r\n    local integer abilityId\r\n    local integer skillPoints = 0\r\n    local integer abilityLevel\r\n    \r\n    call delspellpas( caster )\r\n    call UnitResetCooldown( caster )\r\n    \r\n    set Event_Book_Of_Oblivion_Used_Unit = caster\r\n    set Event_Book_Of_Oblivion_Used_Real = 0.00\r\n    set Event_Book_Of_Oblivion_Used_Real = 1.00\r\n    set Event_Book_Of_Oblivion_Used_Real = 0.00\r\n    \r\n    set i = 1\r\n    loop\r\n    \texitwhen i > 4\r\n    \tset abilityId = Database_Hero_Abilities[i][heroTypeId]\r\n    \tset abilityLevel = GetUnitAbilityLevel(caster, abilityId)\r\n    \tset skillPoints = skillPoints + abilityLevel\r\n    \tif abilityLevel > 0 then\r\n    \t\t//call BlzSetAbilityIntegerFieldBJ( BlzGetUnitAbility(caster, abilityId), ABILITY_IF_LEVELS, 0 )\r\n    \t\tcall UnitRemoveAbility(caster, abilityId)\r\n    \t\t//call SetUnitAbilityLevel(caster, abilityId, 0)\r\n\t\tendif\r\n    \tset i = i + 1\r\n\tendloop\r\n\tcall ModifyHeroSkillPoints( caster, bj_MODIFYMETHOD_ADD, skillPoints )\r\n\tcall DestroyEffect( AddSpecialEffectTarget(\"Abilities\\\\Spells\\\\Items\\\\TomeOfRetraining\\\\TomeOfRetrainingCaster.mdl\", caster, \"origin\" ) )\r\n\r\n    /*set bj_lastCreatedItem = CreateItem( 'I01M', GetUnitX(GetManipulatingUnit()), GetUnitY(GetManipulatingUnit()))\r\n\r\n    call SaveTimerHandle( udg_hash, GetHandleId( bj_lastCreatedItem ), StringHash( \"bkoo\" ), CreateTimer() )\r\n\tset id = GetHandleId( LoadTimerHandle( udg_hash, GetHandleId( bj_lastCreatedItem ), StringHash( \"bkoo\" ) ) ) \r\n\tcall SaveItemHandle( udg_hash, id, StringHash( \"bkoo\" ), bj_lastCreatedItem )\r\n    call SaveUnitHandle( udg_hash, id, StringHash( \"bkoou\" ), GetManipulatingUnit() )\r\n\tcall TimerStart( LoadTimerHandle( udg_hash, GetHandleId( bj_lastCreatedItem ), StringHash( \"bkoo\" ) ), 0.01, false, function Book_of_OblivionCast )*/\r\n\t\r\n\tset caster = null\r\nendfunction\r\n\r\n//===========================================================================\r\nfunction InitTrig_Book_of_Oblivion takes nothing returns nothing\r\n    set gg_trg_Book_of_Oblivion = CreateTrigger(  )\r\n    call TriggerRegisterAnyUnitEventBJ( gg_trg_Book_of_Oblivion, EVENT_PLAYER_UNIT_PICKUP_ITEM )\r\n    call TriggerAddCondition( gg_trg_Book_of_Oblivion, Condition( function Trig_Book_of_Oblivion_Conditions ) )\r\n    call TriggerAddAction( gg_trg_Book_of_Oblivion, function Trig_Book_of_Oblivion_Actions )\r\nendfunction\r\n\r\n",
  "Events": [],
  "LocalVariables": [],
  "Conditions": [],
  "Actions": []
}