{
  "Id": 50332081,
  "Comment": "",
  "IsScript": true,
  "RunOnMapInit": false,
  "Script": "library BuffDeleteLib requires SpellPower, ShamanBallLib, MajyteLib, Luck, Multiboard, UniquesLib, StatLib, PauseLib, JesterLib\r\n\r\n    globals\r\n        real Event_DeleteBuff_Real\r\n        unit Event_DeleteBuff_Unit\r\n    endglobals\r\n\r\n    //Obsolete. Do not use\r\n    function CreateTrigger_DeleteBuff takes code func returns nothing\r\n        local trigger trig = CreateTrigger(  )\r\n\r\n        call TriggerRegisterVariableEvent( trig, \"Event_DeleteBuff_Real\", EQUAL, 1.00 )\r\n        call TriggerAddAction( trig, func )\r\n        \r\n        set trig = null\r\n    endfunction\r\n\r\n    function DelBuff takes unit u, boolean l returns nothing\r\n        local real hp\r\n        local real mp\r\n        local integer array k\r\n        local integer g\r\n        local integer i = GetPlayerId(GetOwningPlayer(u))\r\n\r\n        if l then\r\n            call UnitRemoveAbility( u, 'A0EX' )\r\n            if GetUnitAbilityLevel(u, 'A16J') > 0 then\r\n                call UnitRemoveAbility( u, 'A16J' )\r\n                call SaveUnitHandle( udg_hash, GetHandleId( u ), StringHash( \"mdnqtt\" ), u )\r\n            endif\r\n            if GetUnitAbilityLevel(u, 'A17U') > 0 then\r\n                call UnitRemoveAbility( u, 'A17U' )\r\n            endif\r\n            if GetUnitAbilityLevel(u, 'A04U') > 0 then\r\n                call BallEnergy( u, -3 )\r\n            endif\r\n        endif\r\n        call IssueImmediateOrderBJ( u, \"unimmolation\" )\r\n        \r\n        set Event_DeleteBuff_Unit = u\r\n        \r\n        set Event_DeleteBuff_Real = 0\r\n        set Event_DeleteBuff_Real = 1\r\n        set Event_DeleteBuff_Real = 0\r\n        \r\n        if GetUnitAbilityLevel( u, 'B060') > 0 then\r\n            call UnitRemoveAbility( u, 'B060')\r\n        endif\r\n        if GetUnitAbilityLevel(u, 'B02L') > 0 then\r\n            call UnitRemoveAbility( u, 'A147' )\r\n            call UnitRemoveAbility( u, 'B02L' )\r\n        endif\r\n        if GetUnitAbilityLevel(u, 'B09J') > 0 then\r\n            call UnitRemoveAbility( u, 'A05W' )\r\n            call UnitRemoveAbility( u, 'B09J' )\r\n        endif\r\n        if GetUnitAbilityLevel(u, 'B01T') > 0 then\r\n            call UnitRemoveAbility( u, 'A0LB' )\r\n            call UnitRemoveAbility( u, 'B01T' )\r\n        endif\r\n        if GetUnitAbilityLevel(u, 'B04O') > 0 then\r\n            call UnitRemoveAbility( u, 'A067' )\r\n            call UnitRemoveAbility( u, 'B04O' )\r\n        endif\r\n        if GetUnitAbilityLevel(u, 'B00Z') > 0 then\r\n            call UnitRemoveAbility( u, 'A038' )\r\n            call UnitRemoveAbility( u, 'B00Z' )\r\n        endif\r\n        if GetUnitAbilityLevel(u, 'B05Y') > 0 then\r\n            call UnitRemoveAbility( u, 'A10I' )\r\n            call UnitRemoveAbility( u, 'B05Y' )\r\n        endif\r\n        if GetUnitAbilityLevel(u, 'B012') > 0 then\r\n            call UnitRemoveAbility( u, 'A04P' )\r\n            call UnitRemoveAbility( u, 'B012' )\r\n        endif\r\n        if GetUnitAbilityLevel(u, 'B010') > 0 then\r\n            call UnitRemoveAbility( u, 'A04I' )\r\n            call UnitRemoveAbility( u, 'B010' )\r\n        endif\r\n        \r\n        if GetUnitAbilityLevel(u, 'B02B') > 0 then\r\n            call UnitRemoveAbility( u, 'A196' )\r\n            call UnitRemoveAbility( u, 'A197' )\r\n            call UnitRemoveAbility( u, 'B02B' )\r\n        endif\r\n        if GetUnitAbilityLevel(u, 'B09I') > 0 then\r\n            call UnitRemoveAbility( u, 'A18L' )\r\n            call UnitRemoveAbility( u, 'A18M' )\r\n            call UnitRemoveAbility( u, 'A17P' )\r\n            call UnitRemoveAbility( u, 'A17N' )\r\n            call UnitRemoveAbility( u, 'B09I' )\r\n        endif\r\n        if GetUnitAbilityLevel(u, 'B09E') > 0 then\r\n            call UnitRemoveAbility( u, 'A12C' )\r\n            call UnitRemoveAbility( u, 'B09E' )\r\n        endif\r\n        if GetUnitAbilityLevel(u, 'B099') > 0 then\r\n            call UnitRemoveAbility( u, 'A0ZC' )\r\n            call UnitRemoveAbility( u, 'B099' )\r\n        endif\r\n        if GetUnitAbilityLevel( u, 'B08R' ) > 0 then\r\n            call pausest( u, -1 )\r\n            call UnitRemoveAbility( u, 'A02F' )\r\n            call UnitRemoveAbility( u, 'A02G' )\r\n            call UnitRemoveAbility( u, 'B08R' )\r\n        endif\r\n        if GetUnitAbilityLevel( u, 'A0JB' ) > 0 then\r\n            call UnitRemoveAbility( u, 'A0JB' )\r\n        endif\r\n        if GetUnitAbilityLevel( u, 'B094' ) > 0 then\r\n            call jesterst(u, -100, 1 )\r\n        endif\r\n        if GetUnitAbilityLevel(u, 'B08O') > 0 then\r\n            call UnitRemoveAbility( u, 'A17Q' )\r\n            call UnitRemoveAbility( u, 'B08O' )\r\n            call UnitRemoveAbility( u, 'A181' )\r\n            call UnitRemoveAbility( u, 'A180' )\r\n        endif\r\n        if GetUnitAbilityLevel(u, 'B08M') > 0 then\r\n            call UnitRemoveAbility( u, 'A148' )\r\n            call UnitRemoveAbility( u, 'B08M' )\r\n        endif\r\n        if GetUnitAbilityLevel(u, 'B08Q') > 0 then\r\n            call UnitRemoveAbility( u, 'A18K' )\r\n            call UnitRemoveAbility( u, 'B08Q' )\r\n        endif\r\n        if GetUnitAbilityLevel(u, 'B08K') > 0 then\r\n            call UnitRemoveAbility( u, 'A146' )\r\n            call UnitRemoveAbility( u, 'B08K' )\r\n        endif\r\n        if GetUnitAbilityLevel(u, 'B08J') > 0 then\r\n            call UnitRemoveAbility( u, 'A145' )\r\n            call UnitRemoveAbility( u, 'B08J' )\r\n        endif\r\n        if GetUnitAbilityLevel(u, 'B08D') > 0 then\r\n            call UnitRemoveAbility( u, 'A08T' )\r\n            call UnitRemoveAbility( u, 'B08D' )\r\n        endif\r\n        if GetUnitAbilityLevel(u, 'B08C') > 0 then\r\n            call UnitRemoveAbility( u, 'A12Z' )\r\n            call UnitRemoveAbility( u, 'A0FZ' )\r\n            call UnitRemoveAbility( u, 'A0PB' )\r\n            call UnitRemoveAbility( u, 'B08C' )\r\n        endif\r\n        if GetUnitAbilityLevel( u, 'B05T') > 0 then\r\n            call UnitRemoveAbility( u, 'A12N' )\r\n            call UnitRemoveAbility( u, 'B05T' )\r\n        endif\r\n        if GetUnitAbilityLevel( u, 'B05W') > 0 then\r\n            call UnitRemoveAbility( u, 'A12V' )\r\n            call UnitRemoveAbility( u, 'B05W' )\r\n        endif\r\n        if GetUnitAbilityLevel( u, 'B089') > 0 then\r\n            call UnitRemoveAbility( u, 'A0ZR' )\r\n            call UnitRemoveAbility( u, 'B089' )\r\n        endif\r\n        if GetUnitAbilityLevel( u, 'B08B') > 0 then\r\n            call UnitRemoveAbility( u, 'A12X' )\r\n            call UnitRemoveAbility( u, 'B08B' )\r\n        endif\r\n        if GetUnitAbilityLevel( u, 'B088') > 0 then\r\n            call UnitRemoveAbility( u, 'A0YE' )\r\n            call UnitRemoveAbility( u, 'B088' )\r\n        endif\r\n        if GetUnitAbilityLevel( u, 'B05W') > 0 then\r\n            call PauseUnit( u, false )\r\n            call UnitRemoveAbility( u, 'A0TT' )\r\n            call UnitRemoveAbility( u, 'B016' )\r\n        endif\r\n        if GetUnitAbilityLevel( u, 'B05U') > 0 then\r\n            call UnitRemoveAbility( u, 'A12P' )\r\n            call UnitRemoveAbility( u, 'B05U' )\r\n        endif\r\n        if GetUnitAbilityLevel( u, 'B05V') > 0 then\r\n            call UnitRemoveAbility( u, 'A12R' )\r\n            call UnitRemoveAbility( u, 'B05V' )\r\n        endif   \r\n        if GetUnitAbilityLevel( u, 'B05R') > 0 then\r\n            call UnitRemoveAbility( u, 'A128' )\r\n            call UnitRemoveAbility( u, 'B05R' )\r\n        endif\r\n        if GetUnitAbilityLevel( u, 'B04E') > 0 then\r\n            call UnitRemoveAbility( u, 'A0RL' )\r\n            call UnitRemoveAbility( u, 'B04E' )\r\n            call SaveUnitHandle( udg_hash, GetHandleId( u ), StringHash( \"twhhtt\" ), u )\r\n        endif\r\n        if GetUnitAbilityLevel( u, 'B01Z') > 0 then\r\n            call UnitRemoveAbility( u, 'A0BO' )\r\n            call UnitRemoveAbility( u, 'A0VE' )\r\n            call UnitRemoveAbility( u, 'B01Z' )\r\n        endif\r\n        if GetUnitAbilityLevel( u, 'A10C') > 0 then\r\n            call UnitRemoveAbility( u, 'A10C' )\r\n        endif\r\n        if GetUnitAbilityLevel( u, 'B01V') > 0 then\r\n            call UnitRemoveAbility( u, 'A0Y2' )\r\n            call UnitRemoveAbility( u, 'B01V' )\r\n        endif\r\n        if GetUnitAbilityLevel( u, 'B05M') > 0 then\r\n            call UnitRemoveAbility( u, 'A0ZU' )\r\n            call UnitRemoveAbility( u, 'B05M' )\r\n        endif\r\n        if GetUnitAbilityLevel(u, 'B06P') > 0 then\r\n            call UnitRemoveAbility( u, 'A0U8' )\r\n            call UnitRemoveAbility( u, 'B06P' )\r\n        endif\r\n        if GetUnitAbilityLevel(u, 'B023') > 0 then\r\n            call UnitRemoveAbility( u, 'A0D5' )\r\n            call UnitRemoveAbility( u, 'B023' ) \r\n        endif\r\n        if GetUnitAbilityLevel(u, 'B06N') > 0 then\r\n            call UnitRemoveAbility( u, 'A0S2' )\r\n            call UnitRemoveAbility( u, 'B06N' ) \r\n        endif\r\n        if GetUnitAbilityLevel(u, 'B030') > 0 or GetUnitAbilityLevel(u, 'B02Z') > 0 then\r\n            call UnitRemoveAbility( u, 'B02Z' )\r\n            call UnitRemoveAbility( u, 'A0L4' ) \r\n            call UnitRemoveAbility( u, 'A0L8' )\r\n            call UnitRemoveAbility( u, 'B030' )     \r\n        endif\r\n        if GetUnitAbilityLevel(u, 'B01J') > 0 then\r\n            call UnitRemoveAbility( u, 'A0O7' )\r\n            call UnitRemoveAbility( u, 'A0O6' )\r\n            call UnitRemoveAbility( u, 'A08H' )\r\n            call UnitRemoveAbility( u, 'A04S' )\r\n            call UnitRemoveAbility( u, 'B01J' )\r\n            call UnitRemoveAbility( u, 'B037' )  \r\n        endif\r\n        if GetUnitAbilityLevel(u, 'B004') > 0 then\r\n            call UnitRemoveAbility( u, 'A0M2' )\r\n            call UnitRemoveAbility( u, 'A0N2' )\r\n            call UnitRemoveAbility( u, 'B004' )\r\n        endif\r\n        if GetUnitAbilityLevel(u, 'B01Q') > 0 then\r\n            call UnitRemoveAbility( u, 'A0A0' )\r\n            call UnitRemoveAbility( u, 'A09X' ) \r\n            call UnitRemoveAbility( u, 'A0RX' ) \r\n            call UnitRemoveAbility( u, 'B01Q' )\r\n            call SaveInteger( udg_hash, GetHandleId( u ), StringHash( \"hrnrs\" ), 0 )\r\n        endif\r\n        if GetUnitAbilityLevel(u, 'B02S') > 0 then\r\n            call UnitRemoveAbility( u, 'A07C' )\r\n            call UnitRemoveAbility( u, 'B02S' ) \r\n        endif\r\n        if GetUnitAbilityLevel(u, 'B03C') > 0 then\r\n            call UnitRemoveAbility( u, 'A0QP' )\r\n            call UnitRemoveAbility( u, 'B03C' )\r\n        endif\r\n        if GetUnitAbilityLevel(u, 'B03H') > 0 then\r\n            call UnitRemoveAbility( u, 'A0QU' )\r\n            call UnitRemoveAbility( u, 'B03H' )       \r\n        endif\r\n        if GetUnitAbilityLevel(u, 'BOhx') > 0 then\r\n            call UnitRemoveAbility( u, 'BOhx' ) \r\n        endif\r\n        if GetUnitAbilityLevel(u, 'B00S') > 0 then\r\n            call UnitRemoveAbility( u, 'A0ML' )\r\n            call UnitRemoveAbility( u, 'A0MI' ) \r\n            call UnitRemoveAbility( u, 'A06R' )\r\n            call UnitRemoveAbility( u, 'B00S' )  \r\n        endif\r\n        if GetUnitAbilityLevel(u, 'B01F') > 0 then\r\n            call UnitRemoveAbility( u, 'A0JS' ) \r\n            call UnitRemoveAbility( u, 'B01F' )     \r\n        endif\r\n        if GetUnitAbilityLevel(u, 'B024') > 0 then\r\n            call UnitRemoveAbility( u, 'A0TD' )\r\n            call UnitRemoveAbility( u, 'B024' )\r\n        endif\r\n        if GetUnitAbilityLevel(u, 'B06D') > 0 then\r\n            call UnitRemoveAbility( u, 'A0H0' )\r\n            call UnitRemoveAbility( u, 'B06D' )\r\n        endif\r\n        if GetUnitAbilityLevel(u, 'B03L') > 0 then\r\n            call UnitRemoveAbility( u, 'A0U2' )\r\n            call UnitRemoveAbility( u, 'A0A6' )\r\n            call UnitRemoveAbility( u, 'B03L' )\r\n        endif\r\n        if GetUnitAbilityLevel(u, 'B03T') > 0 then\r\n            call UnitRemoveAbility( u, 'A0XU' )\r\n            call UnitRemoveAbility( u, 'B03T' )\r\n        endif\r\n        if GetUnitAbilityLevel(u, 'B06E') > 0 then\r\n            call UnitRemoveAbility( u, 'A0GZ' )\r\n            call UnitRemoveAbility( u, 'B06E' )\r\n        endif\r\n        if GetUnitAbilityLevel(u, 'B03U') > 0 then\r\n            call UnitRemoveAbility( u, 'A0Y0' )\r\n            call UnitRemoveAbility( u, 'B03U' )\r\n        endif\r\n        if GetUnitAbilityLevel(u, 'B03K') > 0 then\r\n            call UnitRemoveAbility( u, 'A05G' )\r\n            call UnitRemoveAbility( u, 'B03K' )\r\n        endif\r\n        if GetUnitAbilityLevel(u, 'B03Z') > 0 then\r\n            call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( u ), StringHash( \"majt\" ) ), 0, false, function MajyteCast ) \r\n        endif\r\n        if GetUnitAbilityLevel(u, 'B02C') > 0 then\r\n            call UnitRemoveAbility( u, 'A0SF' )\r\n            call UnitRemoveAbility( u, 'B02C' )\r\n        endif\r\n        if GetUnitAbilityLevel(u, 'B07H') > 0 then\r\n            call UnitRemoveAbility( u, 'A179' )\r\n            call UnitRemoveAbility( u, 'B07H' )\r\n        endif\r\n        if GetUnitAbilityLevel(u, 'B01D') > 0 then\r\n            call UnitRemoveAbility( u, 'A09Q' )\r\n            call UnitRemoveAbility( u, 'B006' ) \r\n        endif\r\n        if GetUnitAbilityLevel(u, 'B01O') > 0 then\r\n            call UnitRemoveAbility( u, 'A0KE' )\r\n            call UnitRemoveAbility( u, 'B01O' )\r\n        endif\r\n        if GetUnitAbilityLevel(u, 'B036') > 0 then\r\n            call UnitRemoveAbility( u, 'A0HZ' )\r\n            call UnitRemoveAbility( u, 'B036' )    \r\n        endif\r\n        if GetUnitAbilityLevel(u, 'B05B') > 0 then\r\n            call UnitRemoveAbility( u, 'A092' )\r\n            call UnitRemoveAbility( u, 'B05B' )    \r\n        endif\r\n        if GetUnitAbilityLevel(u, 'B04H') > 0 then\r\n            call UnitRemoveAbility( u, 'A06V' )\r\n            call UnitRemoveAbility( u, 'B04H' )    \r\n        endif\r\n        if GetUnitAbilityLevel(u, 'B07G') > 0 then\r\n            call UnitRemoveAbility( u, 'A172' )\r\n            call UnitRemoveAbility( u, 'B07G' )    \r\n        endif\r\n        if GetUnitAbilityLevel(u, 'B048') > 0 or GetUnitAbilityLevel(u, 'B049') > 0 then\r\n            call UnitRemoveAbility( u, 'A0ZZ' )\r\n            call UnitRemoveAbility( u, 'A0ZY' )  \r\n            call UnitRemoveAbility( u, 'A09O' )\r\n            call UnitRemoveAbility( u, 'B048' )  \r\n            call UnitRemoveAbility( u, 'B049' )\r\n        endif\r\n        if GetUnitAbilityLevel(u, 'B00P') > 0 then\r\n            call UnitRemoveAbility( u, 'A0LJ' )\r\n            call UnitRemoveAbility( u, 'A0BE' )  \r\n            call UnitRemoveAbility( u, 'B00P' )      \r\n        endif\r\n        if GetUnitAbilityLevel(u, 'B02Y') > 0 then\r\n            call UnitRemoveAbility( u, 'A090' )\r\n            call UnitRemoveAbility( u, 'B02Y' ) \r\n        endif\r\n        if GetUnitAbilityLevel(u, 'B003') > 0 then\r\n            call UnitRemoveAbility( u, 'A0EE' )\r\n            call UnitRemoveAbility( u, 'B003' ) \r\n        endif\r\n        if GetUnitAbilityLevel(u, 'B02P') > 0 then\r\n            call UnitRemoveAbility( u, 'A0PX' )\r\n            call UnitRemoveAbility( u, 'B02P' )\r\n            call SaveInteger( udg_hash, GetHandleId( u ), StringHash( \"hrnqs\" ), 0 )\r\n        endif\r\n        if GetUnitAbilityLevel(u, 'B01S') > 0 then\r\n            call UnitRemoveAbility( u, 'A0T4' )\r\n            call UnitRemoveAbility( u, 'B01S' )     \r\n        endif\r\n        if GetUnitAbilityLevel(u, 'B04K' ) > 0 then\r\n            call UnitRemoveAbility( u, 'A08T' )\r\n            call UnitRemoveAbility( u, 'B04K' )  \r\n        endif\r\n        if GetUnitAbilityLevel(u, 'B04T' ) > 0 then\r\n            call UnitRemoveAbility( u, 'B04T' )  \r\n        endif\r\n        if GetUnitAbilityLevel(u, 'B011' ) > 0 then\r\n            call UnitRemoveAbility( u, 'A06V' )\r\n            call UnitRemoveAbility( u, 'B011' )  \r\n        endif\r\n        if GetUnitAbilityLevel(u, 'B06R' ) > 0 then\r\n            call UnitRemoveAbility( u, 'A11H' )\r\n            call UnitRemoveAbility( u, 'B06R' )  \r\n        endif\r\n        if GetUnitAbilityLevel(u, 'B06X' ) > 0 then\r\n            call UnitRemoveAbility( u, 'A152' )\r\n            call UnitRemoveAbility( u, 'B06X' )  \r\n        endif\r\n        if GetUnitAbilityLevel(u, 'B04L') > 0 then\r\n            call UnitRemoveAbility( u, 'A0C3' )\r\n            call UnitRemoveAbility( u, 'A0B1' )\r\n            call UnitRemoveAbility( u, 'B04L' )     \r\n        endif\r\n        if GetUnitAbilityLevel(u, 'B022') > 0 then\r\n            call UnitRemoveAbility( u, 'A0RK' )\r\n            call UnitRemoveAbility( u, 'B022' )\r\n        endif\r\n        if GetUnitAbilityLevel(u, 'B07B') > 0 then\r\n            call UnitRemoveAbility( u, 'A16M' )\r\n            call UnitRemoveAbility( u, 'B07B' )\r\n        endif\r\n        if GetUnitAbilityLevel(u, 'B072') > 0 then\r\n            call UnitRemoveAbility( u, 'A15P' )\r\n            call UnitRemoveAbility( u, 'B072' )\r\n        endif\r\n        if GetUnitAbilityLevel(u, 'B06Q') > 0 then\r\n        call UnitRemoveAbility( u, 'A103' )\r\n        call UnitRemoveAbility( u, 'B06Q' )\r\n        endif\r\n        if GetUnitAbilityLevel(u, 'B06W') > 0 then\r\n        call UnitRemoveAbility( u, 'A14Z' )\r\n        call UnitRemoveAbility( u, 'B06W' )\r\n        endif\r\n        if GetUnitAbilityLevel(u, 'B007') > 0 then\r\n            call UnitRemoveAbility( u, 'A05A' )\r\n            call UnitRemoveAbility( u, 'B007' ) \r\n        endif\r\n        if GetUnitAbilityLevel(u, 'B06O') > 0 then\r\n            call UnitRemoveAbility( u, 'A05C' )\r\n            call UnitRemoveAbility( u, 'B06O' ) \r\n        endif\r\n        if GetUnitAbilityLevel(u, 'B013') > 0 then\r\n            call UnitRemoveAbility( u, 'A0SX' )\r\n            call UnitRemoveAbility( u, 'B013' ) \r\n        endif\r\n        if GetUnitAbilityLevel(u, 'B047') > 0 then\r\n            call UnitRemoveAbility( u, 'A05X' )\r\n            call UnitRemoveAbility( u, 'B047' ) \r\n        endif\r\n        if GetUnitAbilityLevel(u, 'B014') > 0 then\r\n            call UnitRemoveAbility( u, 'A0T3' )\r\n            call UnitRemoveAbility( u, 'B014' ) \r\n        endif\r\n        if GetUnitAbilityLevel(u, 'B06H') > 0 then\r\n            call UnitRemoveAbility( u, 'A0KP' )\r\n            call UnitRemoveAbility( u, 'B06H' ) \r\n        endif\r\n        if GetUnitAbilityLevel(u, 'B00D') > 0 then\r\n            call UnitRemoveAbility( u, 'A02O' )\r\n            call UnitRemoveAbility( u, 'B00D' )  \r\n        endif\r\n        if GetUnitAbilityLevel(u, 'B00X') > 0 then\r\n            call UnitRemoveAbility( u, 'A04B' )\r\n            call UnitRemoveAbility( u, 'B00X' )  \r\n        endif\r\n        if GetUnitAbilityLevel(u, 'B032') > 0 and inv(u, 'I040') == 0  then\r\n            call UnitRemoveAbility( u, 'A054' )\r\n            call UnitRemoveAbility( u, 'B032' )\r\n        endif\r\n        if GetUnitAbilityLevel(u, 'Bply') > 0  then\r\n            call UnitRemoveAbility( u, 'Bply' )\r\n        endif\r\n        if GetUnitAbilityLevel(u, 'B04R') > 0 then\r\n            call UnitRemoveAbility( u, 'A0PJ' )\r\n            call UnitRemoveAbility( u, 'B04R' )        \r\n        endif\r\n        if GetUnitAbilityLevel(u, 'B06Y') > 0 then\r\n            call UnitRemoveAbility( u, 'A15A' )\r\n            call UnitRemoveAbility( u, 'B06Y' )        \r\n        endif\r\n        if GetUnitAbilityLevel(u, 'B07C') > 0 then\r\n            call UnitRemoveAbility( u, 'A16P' )\r\n            call UnitRemoveAbility( u, 'B07C' )        \r\n        endif\r\n        if GetUnitAbilityLevel(u, 'B06M') > 0 then\r\n            call UnitRemoveAbility( u, 'A0PN' )\r\n            call UnitRemoveAbility( u, 'B06M' )        \r\n        endif\r\n        if GetUnitAbilityLevel(u, 'B00W') > 0 then\r\n            call UnitRemoveAbility( u, 'A03G' )\r\n            call UnitRemoveAbility( u, 'B00W' )        \r\n        endif\r\n        if GetUnitAbilityLevel(u, 'B07S') > 0 then\r\n            call UnitRemoveAbility( u, 'A0EA' )\r\n            call UnitRemoveAbility( u, 'B07S' )        \r\n        endif\r\n        if GetUnitAbilityLevel(u, 'A0QQ') > 0 then\r\n            call UnitRemoveAbility( u, 'A0QQ' )\r\n        endif\r\n        if GetUnitAbilityLevel(u, 'B020') > 0 then\r\n            call UnitRemoveAbility( u, 'B020')\r\n        endif\r\n        if GetUnitAbilityLevel(u, 'B054') > 0 then\r\n            call UnitRemoveAbility( u, 'A0UP' )\r\n            call UnitRemoveAbility( u, 'B054' )         \r\n        endif\r\n        if GetUnitAbilityLevel(u, 'B07K') > 0 then\r\n            call UnitRemoveAbility( u, 'A17I' )\r\n            call UnitRemoveAbility( u, 'B07K' )         \r\n        endif\r\n        if GetUnitAbilityLevel(u, 'B07J') > 0 then\r\n            call UnitRemoveAbility( u, 'A17G' )\r\n            call UnitRemoveAbility( u, 'B07J' )         \r\n        endif\r\n        if GetUnitAbilityLevel(u, 'B07V') > 0 then\r\n            call UnitRemoveAbility( u, 'A0O4' )\r\n            call UnitRemoveAbility( u, 'B07V' )         \r\n        endif\r\n            if GetUnitAbilityLevel(u, 'B07V') > 0 then\r\n            call UnitRemoveAbility( u, 'A0P0' )\r\n            call UnitRemoveAbility( u, 'B07W' )         \r\n        endif\r\n        if GetUnitAbilityLevel(u, 'B069') > 0 then\r\n            call UnitRemoveAbility( u, 'A0EO' )\r\n            call UnitRemoveAbility( u, 'B069' )         \r\n        endif\r\n        if GetUnitAbilityLevel(u, 'B07T') > 0 then\r\n            call UnitRemoveAbility( u, 'A0IU' )\r\n            call UnitRemoveAbility( u, 'B07T' )         \r\n        endif\r\n        if GetUnitAbilityLevel(u, 'B034') > 0 then\r\n            call UnitRemoveAbility( u, 'A0NJ' )\r\n            call UnitRemoveAbility( u, 'B034' )         \r\n        endif\r\n        if GetUnitAbilityLevel(u, 'B055') > 0 then\r\n            call UnitRemoveAbility( u, 'A0UU' )\r\n            call UnitRemoveAbility( u, 'B055' ) \r\n        endif\r\n        if GetUnitAbilityLevel(u, 'B057') > 0  then\r\n            call UnitRemoveAbility( u, 'A0V3' )\r\n            call UnitRemoveAbility( u, 'B057' )       \r\n        endif\r\n        if GetUnitAbilityLevel(u, 'B058') > 0 then\r\n            call UnitRemoveAbility( u, 'A0V7' )\r\n            call UnitRemoveAbility( u, 'B058' )      \r\n        endif\r\n        if GetUnitAbilityLevel(u, 'B02E') > 0  then\r\n            call UnitRemoveAbility( u, 'A0QM' )\r\n            call UnitRemoveAbility( u, 'B02E' )      \r\n        endif\r\n        if GetUnitAbilityLevel(u, 'B07X') > 0  then\r\n            call UnitRemoveAbility( u, 'A0S4' )\r\n            call UnitRemoveAbility( u, 'B07X' )      \r\n        endif\r\n        if GetUnitAbilityLevel(u, 'B02F') > 0 then\r\n            call UnitRemoveAbility( u, 'A0VO' )\r\n            call UnitRemoveAbility( u, 'B02F' )      \r\n        endif\r\n        if GetUnitAbilityLevel(u, 'B02G') > 0 then\r\n            call UnitRemoveAbility( u, 'A0VQ' )\r\n            call UnitRemoveAbility( u, 'B02G' )      \r\n        endif\r\n        if GetUnitAbilityLevel(u, 'B067') > 0 then\r\n            call UnitRemoveAbility( u, 'A0DP' )\r\n            call UnitRemoveAbility( u, 'B067' )      \r\n        endif\r\n        if GetUnitAbilityLevel(u, 'B068') > 0 then\r\n            call UnitRemoveAbility( u, 'A01E' )\r\n            call UnitRemoveAbility( u, 'B068' )      \r\n        endif\r\n        if GetUnitAbilityLevel(u, 'B07P') > 0 then\r\n            call UnitRemoveAbility( u, 'A0FU' )\r\n            call UnitRemoveAbility( u, 'B07P' )      \r\n        endif\r\n        if GetUnitAbilityLevel(u, 'B04E') > 0 then\r\n            call UnitRemoveAbility( u, 'A013' )\r\n            call UnitRemoveAbility( u, 'B04E' )      \r\n        endif\r\n        if GetUnitAbilityLevel(u, 'B03F') > 0 then\r\n            call UnitRemoveAbility( u, 'A0I5' )\r\n            call UnitRemoveAbility( u, 'B03F' )      \r\n        endif\r\n        if GetUnitAbilityLevel(u, 'A0QG') > 0 then\r\n            call UnitRemoveAbility( u, 'A0QG' )     \r\n        endif\r\n        if GetUnitAbilityLevel(u, 'A0MA') > 0 then\r\n            call UnitRemoveAbility( u, 'A0MA' )  \r\n            call UnitRemoveAbility( u, 'B01L' )\r\n        endif\r\n        if GetUnitAbilityLevel(u, 'A07M') > 0 then\r\n            call UnitRemoveAbility( u, 'A0DZ' )  \r\n            call UnitRemoveAbility( u, 'B07M' )\r\n        endif\r\n        if GetUnitAbilityLevel(u, 'B07I') > 0 then\r\n            call UnitRemoveAbility( u, 'A17E' )  \r\n            call UnitRemoveAbility( u, 'B07I' )\r\n        endif\r\n        if GetUnitAbilityLevel(u, 'A107') > 0 then \r\n            call UnitRemoveAbility( u, 'A107' )  \r\n            call UnitRemoveAbility( u, 'B04A' )\r\n            call pausest( u, -1 )\r\n        endif\r\n        if GetUnitAbilityLevel(u, 'B01D') > 0 then\r\n            call UnitRemoveAbility( u, 'A0WN' )  \r\n            call UnitRemoveAbility( u, 'B01D' )\r\n        endif\r\n        if GetUnitAbilityLevel(u, 'B01M') > 0 then\r\n            call UnitRemoveAbility( u, 'A0WP' )  \r\n            call UnitRemoveAbility( u, 'B01M' )\r\n        endif\r\n        if GetUnitAbilityLevel(u, 'B05E') > 0 then\r\n            call UnitRemoveAbility( u, 'A0WX' )  \r\n            call UnitRemoveAbility( u, 'B05E' )\r\n        endif\r\n        if GetUnitAbilityLevel(u, 'B05K') > 0 then\r\n            call UnitRemoveAbility( u, 'A0XG' )  \r\n            call UnitRemoveAbility( u, 'B05K' )\r\n        endif\r\n        if GetUnitAbilityLevel(u, 'B06F') > 0 then\r\n            call UnitRemoveAbility( u, 'A0GX' )  \r\n            call UnitRemoveAbility( u, 'B06F' )\r\n        endif\r\n        //zihi adds\r\n        if GetUnitAbilityLevel(u, 'BZ02') > 0 then\r\n            call UnitRemoveAbility( u, 'AZ02' )  \r\n            call UnitRemoveAbility( u, 'BZ02' )\r\n        endif\r\n        //zihi stops\r\n        if GetUnitAbilityLevel(u, 'B038') > 0 then\r\n            call BlzSetUnitBaseDamage( u, BlzGetUnitBaseDamage(u, 0) - LoadInteger( udg_hash, GetHandleId( u ), StringHash( \"rage\" ) ), 0 )\r\n            call UnitRemoveAbility( u, 'A19T' )\r\n            call UnitRemoveAbility( u, 'B038' )\r\n            call RemoveSavedInteger( udg_hash, GetHandleId( u ), StringHash( \"rage\" ) )\r\n        endif \r\n        if GetUnitAbilityLevel(u, 'B00N') > 0 then\r\n            call BlzSetUnitBaseDamage( u, BlzGetUnitBaseDamage(u, 0) - LoadInteger( udg_hash, GetHandleId( u ), StringHash( \"prsw\" ) ), 0 )\r\n            call UnitRemoveAbility( u, 'A03W' )\r\n            call UnitRemoveAbility( u, 'B00N' )\r\n            call RemoveSavedInteger( udg_hash, GetHandleId( u ), StringHash( \"prsw\" ) )\r\n        endif \r\n        if GetUnitAbilityLevel( u, 'B05P') > 0 then\r\n            call SaveInteger( udg_hash, GetHandleId( u ), StringHash( \"shieldnum\" ), 0 )\r\n            call SaveReal( udg_hash, GetHandleId( u ), StringHash( \"shield\" ), 0 )\r\n            call SaveReal( udg_hash, GetHandleId( u ), StringHash( \"shieldMax\" ), 0 )\r\n            call UnitRemoveAbility( u, 'A11F' )\r\n            call UnitRemoveAbility( u, 'B05P' )\r\n        endif\r\n        if GetUnitAbilityLevel(u, 'B09D') > 0 then\r\n            call spdst( u, -LoadReal( udg_hash, GetHandleId( u ), StringHash( \"kepr1\" ) ) )\r\n            call UnitRemoveAbility( u, 'A0PV' )\r\n            call UnitRemoveAbility( u, 'B09D' )\r\n            call RemoveSavedReal( udg_hash, GetHandleId( u ), StringHash( \"kepr1\" ) )\r\n        endif\r\n        if GetUnitAbilityLevel(u, 'B098') > 0 then\r\n            call spdst( u, -LoadReal( udg_hash, GetHandleId( u ), StringHash( \"orbntc1\" ) ) )\r\n            call UnitRemoveAbility( u, 'A0WU' )\r\n            call UnitRemoveAbility( u, 'B098' )\r\n            call RemoveSavedReal( udg_hash, GetHandleId( u ), StringHash( \"orbntc1\" ) )\r\n        endif\r\n        if GetUnitAbilityLevel(u, 'B09K') > 0 then\r\n            call spdst( u, -LoadReal( udg_hash, GetHandleId( u ), StringHash( \"brde\" ) ) )\r\n            call UnitRemoveAbility( u, 'A1AU' )\r\n            call UnitRemoveAbility( u, 'B09K' )\r\n            call RemoveSavedReal( udg_hash, GetHandleId( u ), StringHash( \"brde\" ) )\r\n        endif\r\n        if GetUnitAbilityLevel( u, 'B015') > 0 then\r\n            call spdst( u, -LoadReal( udg_hash, GetHandleId( u ), StringHash( \"mgct\" ) ) )\r\n            call UnitRemoveAbility( u, 'A0TG' )\r\n            call UnitRemoveAbility( u, 'B015' )\r\n            call RemoveSavedReal( udg_hash, GetHandleId( u ), StringHash( \"mgct\" ) )\r\n        endif\r\n        if GetUnitAbilityLevel( u, 'B03Z') > 0 then\r\n            call spdst( u, -LoadReal( udg_hash, GetHandleId( u ), StringHash( \"majt\" ) ) )\r\n            call UnitRemoveAbility( u, 'A0YC' )\r\n            call UnitRemoveAbility( u, 'B03Z' )\r\n            call RemoveSavedReal( udg_hash, GetHandleId( u ), StringHash( \"majt\" ) )\r\n        endif\r\n        if GetUnitAbilityLevel( u, 'B028') > 0 then\r\n            call spdst( u, -LoadReal( udg_hash, GetHandleId( u ), StringHash( \"sopp\" ) ) )\r\n            call UnitRemoveAbility( u, 'A0CJ' )\r\n            call UnitRemoveAbility( u, 'B028' )\r\n            call RemoveSavedReal( udg_hash, GetHandleId( u ), StringHash( \"sopp\" ) )\r\n        endif\r\n        if GetUnitAbilityLevel( u, 'B093') > 0 then\r\n            call spdst( u, -LoadReal( udg_hash, GetHandleId( u ), StringHash( \"orbfp1\" ) ) )\r\n            call UnitRemoveAbility( u, 'A0I7' )\r\n            call UnitRemoveAbility( u, 'B093' )\r\n            call RemoveSavedReal( udg_hash, GetHandleId( u ), StringHash( \"orbfp1\" ) )\r\n        endif\r\n        if GetUnitAbilityLevel(u, 'B07A') > 0 then\r\n            call UnitRemoveAbility( u, 'A16I' )\r\n            call UnitRemoveAbility( u, 'B07A' )\r\n        endif\r\n        if GetUnitAbilityLevel(u, 'B07O') > 0 then\r\n            call UnitRemoveAbility( u, 'A0FP' )\r\n            call UnitRemoveAbility( u, 'B07O' )\r\n        endif\r\n        if GetUnitAbilityLevel( u, 'B00Q') > 0 and GetUnitState( u, UNIT_STATE_LIFE) > 0.405 then\r\n            set hp = GetUnitState( u, UNIT_STATE_LIFE) / GetUnitState( u, UNIT_STATE_MAX_LIFE)\r\n            set mp = GetUnitState( u, UNIT_STATE_LIFE) / GetUnitState( u, UNIT_STATE_MAX_LIFE)\r\n            call statst( u, -LoadInteger( udg_hash, GetHandleId( u ), StringHash( \"vamr\" ) ), -LoadInteger( udg_hash, GetHandleId( u ), StringHash( \"vamr\" ) ), -LoadInteger( udg_hash, GetHandleId( u ), StringHash( \"vamr\" ) ), 0, false )\r\n            call UnitRemoveAbility( u, 'A0K6' )\r\n            call UnitRemoveAbility( u, 'B00Q' )\r\n            call SetUnitState( u, UNIT_STATE_LIFE, hp * GetUnitState( u, UNIT_STATE_MAX_LIFE))\r\n            call SetUnitState( u, UNIT_STATE_MANA, mp * GetUnitState( u, UNIT_STATE_MAX_MANA))\r\n            call RemoveSavedInteger( udg_hash, GetHandleId( u ), StringHash( \"vamr\" ) )\r\n        endif\r\n        if GetUnitAbilityLevel( u, 'B05Q') > 0 and GetUnitState( u, UNIT_STATE_LIFE) > 0.405 then\r\n            set mp = GetUnitState( u, UNIT_STATE_MANA) / GetUnitState( u, UNIT_STATE_MAX_MANA)\r\n            call statst( u, 0, -LoadInteger( udg_hash, GetHandleId( u ), StringHash( \"outra\" ) ), -LoadInteger( udg_hash, GetHandleId( u ), StringHash( \"outri\" ) ), 0, false )\r\n            call UnitRemoveAbility( u, 'A081' )\r\n            call UnitRemoveAbility( u, 'B05Q' )\r\n            call SetUnitState( u, UNIT_STATE_MANA, mp * GetUnitState( u, UNIT_STATE_MAX_MANA))\r\n            call RemoveSavedInteger( udg_hash, GetHandleId( u ), StringHash( \"outra\" ) )\r\n            call RemoveSavedInteger( udg_hash, GetHandleId( u ), StringHash( \"outri\" ) )\r\n        endif\r\n        if GetUnitAbilityLevel( u, 'B051') > 0 then\r\n            call luckyst( u, -LoadInteger( udg_hash, GetHandleId( u ), StringHash( \"gldc\" ) ) )\r\n            call UnitRemoveAbility( u, 'A0TM' )\r\n            call UnitRemoveAbility( u, 'B051' )\r\n            call RemoveSavedInteger( udg_hash, GetHandleId( u ), StringHash( \"gldc\" ) )\r\n        endif\r\n        if GetUnitAbilityLevel( u, 'B03J') > 0 then\r\n            call luckyst( u, -LoadInteger( udg_hash, GetHandleId( u ), StringHash( \"cirr\" ) ) )\r\n            call UnitRemoveAbility( u, 'A0SL' )\r\n            call UnitRemoveAbility( u, 'B03J' )\r\n            call RemoveSavedInteger( udg_hash, GetHandleId( u ), StringHash( \"cirr\" ) )\r\n        endif\r\n        if GetUnitAbilityLevel( u, 'A0UX') > 0 and GetUnitState( u, UNIT_STATE_LIFE) > 0.405 then\r\n            set hp = GetUnitState( u, UNIT_STATE_LIFE) / GetUnitState( u, UNIT_STATE_MAX_LIFE)\r\n            call statst( u, -LoadInteger( udg_hash, GetHandleId( u ), StringHash( \"comrs\" ) ), 0, 0, 0, false )\r\n            call SetUnitState( u, UNIT_STATE_LIFE, hp * GetUnitState( u, UNIT_STATE_MAX_LIFE))\r\n            call UnitRemoveAbility( u, 'A0UX' )\r\n            call UnitRemoveAbility( u, 'B056' )\r\n            call RemoveSavedInteger( udg_hash, GetHandleId( u ), StringHash( \"comrs\" ) )\r\n        endif\r\n        \r\n        set u = null\r\n    endfunction\r\n\r\nendlibrary",
  "Events": [],
  "LocalVariables": [],
  "Conditions": [],
  "Actions": []
}