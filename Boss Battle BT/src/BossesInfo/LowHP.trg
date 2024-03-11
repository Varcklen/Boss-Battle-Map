{
  "Id": 50333402,
  "Comment": "",
  "IsScript": true,
  "RunOnMapInit": false,
  "Script": "scope LowHP initializer init\r\n\r\n    globals\r\n        private constant integer HEALTH_NEEDED = 35\r\n    endglobals\r\n\r\n    private function SetCineFilter takes player owner, boolean isActive returns nothing\r\n        if GetLocalPlayer() == owner then\r\n            call DisplayCineFilter(isActive)\r\n        endif\r\n        call SaveBoolean( udg_hash, GetHandleId(owner), StringHash( \"hpvis\" ), isActive )\r\n    \r\n        set owner = null\r\n    endfunction\r\n\r\n    private function HPVision takes nothing returns nothing\r\n        local integer id = GetHandleId( GetExpiredTimer( ) )\r\n        local unit hero = LoadUnitHandle( udg_hash, id, StringHash( \"hpvis\" ) )\r\n        local player owner = GetOwningPlayer(hero) \r\n        local real healthPercent = GetHealthPercent(hero)\r\n        local integer i = GetUnitUserData(hero)\r\n        local boolean isActive = LoadBoolean( udg_hash, GetHandleId(owner), StringHash( \"hpvis\" ) )\r\n        \r\n        if udg_combatlogic[GetUnitUserData(hero)] == false then\r\n            call SetCineFilter(owner, false)\r\n            call FlushChildHashtable( udg_hash, id )\r\n            call DestroyTimer( GetExpiredTimer() ) \r\n        elseif healthPercent <= HEALTH_NEEDED and IsUnitAlive(hero) and not(isActive) then\r\n            call SetCineFilter(owner, true)\r\n        elseif (healthPercent > HEALTH_NEEDED or IsUnitDead(hero)) and isActive then\r\n            call SetCineFilter(owner, false)\r\n        endif\r\n        \r\n        set hero = null\r\n        set owner = null\r\n    endfunction\r\n    \r\n    private function FightStart_Conditions takes nothing returns boolean\r\n        return udg_FightStart_Unit != null and udg_combatlogic[GetUnitUserData(udg_FightStart_Unit)]\r\n    endfunction\r\n\r\n    private function FightStart takes nothing returns nothing\r\n        call InvokeTimerWithUnit(udg_FightStart_Unit, \"hpvis\", 1, true, function HPVision )\r\n    endfunction\r\n\r\n    private function init takes nothing returns nothing\r\n        call CreateEventTrigger( \"udg_FightStart_Real\", function FightStart, function FightStart_Conditions )\r\n    endfunction\r\nendscope",
  "Events": [],
  "LocalVariables": [],
  "Conditions": [],
  "Actions": []
}