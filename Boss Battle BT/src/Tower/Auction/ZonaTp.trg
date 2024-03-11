{
  "Id": 50332258,
  "Comment": "",
  "IsScript": true,
  "RunOnMapInit": false,
  "Script": "function Trig_ZonaTp_Conditions takes nothing returns boolean\r\n    return IsUnitType(GetEnteringUnit(), UNIT_TYPE_HERO) or IsUnitType( GetEnteringUnit(), UNIT_TYPE_ANCIENT)\r\nendfunction\r\n\r\nfunction Trig_ZonaTp_Actions takes nothing returns nothing\r\n\tlocal unit unitUsed = GetEnteringUnit()\r\n    local rect array r\r\n    local integer i = 0\r\n    local integer index = GetPlayerId(GetOwningPlayer(unitUsed))\r\n    local real x\r\n    local real y\r\n\r\n    set r[0] = gg_rct_Zona1\r\n    set r[1] = gg_rct_Zona2\r\n    set r[2] = gg_rct_Zona3\r\n    set r[3] = gg_rct_Zona4\r\n\r\n    set x = GetLocationX(GetRectCenter(r[index]))\r\n    set y = GetLocationY(GetRectCenter(r[index]))\r\n    \r\n    loop\r\n        exitwhen i > 3\r\n        if RectContainsCoords( r[i], GetUnitX(unitUsed), GetUnitY(unitUsed) ) and GetOwningPlayer(unitUsed) != Player( i ) then\r\n            if IsUnitType( unitUsed, UNIT_TYPE_ANCIENT) then\r\n                call KillUnit( unitUsed )\r\n            else\r\n                call SetUnitPosition( unitUsed, x, y )\r\n\t\t\t\tcall PanCameraToTimedForPlayer( GetOwningPlayer(unitUsed), x, y, 0 )\r\n                call DestroyEffect( AddSpecialEffect(\"Void Teleport Caster.mdx\", x, y ) )\r\n            endif\r\n            set i = 3\r\n        endif\r\n        set r[i] = null\r\n        set i = i + 1\r\n    endloop\r\n    call SelectUnitForPlayerSingle( ExchangerUnit[index], Player(index) )\r\n    \r\n    set unitUsed = null\r\nendfunction\r\n\r\n//===========================================================================\r\nfunction InitTrig_ZonaTp takes nothing returns nothing\r\n    set gg_trg_ZonaTp = CreateTrigger(  )\r\n    call TriggerRegisterEnterRectSimple( gg_trg_ZonaTp, gg_rct_Zona1 )\r\n    call TriggerRegisterEnterRectSimple( gg_trg_ZonaTp, gg_rct_Zona2 )\r\n    call TriggerRegisterEnterRectSimple( gg_trg_ZonaTp, gg_rct_Zona3 )\r\n    call TriggerRegisterEnterRectSimple( gg_trg_ZonaTp, gg_rct_Zona4 )\r\n    call TriggerAddCondition( gg_trg_ZonaTp, Condition( function Trig_ZonaTp_Conditions ) )\r\n    call TriggerAddAction( gg_trg_ZonaTp, function Trig_ZonaTp_Actions )\r\nendfunction",
  "Events": [],
  "LocalVariables": [],
  "Conditions": [],
  "Actions": []
}