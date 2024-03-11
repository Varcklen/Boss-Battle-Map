{
  "Id": 50332317,
  "Comment": "",
  "IsScript": true,
  "RunOnMapInit": false,
  "Script": "scope SpecialsShop initializer init\r\n\r\n    globals\r\n        private constant integer ID_SHOP = 'h027'\r\n        \r\n        private constant integer BUTTONS = 6\r\n        private constant integer BUTTONS_IN_A_ROW = 3\r\n        private constant integer BUTTONS_ARRAYS = BUTTONS + 1\r\n        private constant integer COST = 100\r\n        private constant real SPECIALS_ICON_SIZE = 0.035\r\n        private constant integer KEY_SPECIAL = StringHash( \"spec\" )\r\n        private constant integer KEY_SPECIAL_POSITION = StringHash( \"specp\" )\r\n        private constant string SPECIAL_GETTING_ANIMATION = \"Abilities\\\\Spells\\\\Items\\\\TomeOfRetraining\\\\TomeOfRetrainingCaster.mdl\"\r\n        \r\n        private framehandle background = null\r\n        private integer array special[BUTTONS_ARRAYS]\r\n        private framehandle array glueButton[BUTTONS_ARRAYS]\r\n        private framehandle array icon[BUTTONS_ARRAYS]\r\n        private string array name[BUTTONS_ARRAYS]\r\n        private string array description[BUTTONS_ARRAYS]\r\n        \r\n        private integer array GettedSpecialCell[PLAYERS_LIMIT_ARRAYS]\r\n    endglobals\r\n    \r\n    /*struct SpecialButton\r\n        readonly framehandle icon\r\n        readonly framehandle glueButton\r\n        readonly integer special = 0\r\n        \r\n        static method create takes framehandle icon, framehandle glueButton returns SpecialButton\r\n            local SpecialButton this = SpecialButton.allocate() \r\n            .icon = icon\r\n            .glueButton = glueButton\r\n            \r\n            set icon = null\r\n            set glueButton = null\r\n            return this\r\n        endmethod\r\n    endstruct*/\r\n    \r\n    private function isNotExceptionByIndex takes integer index returns boolean\r\n        if udg_DB_Ability_Special[index] != 'A0EG' then\r\n            return true\r\n        endif\r\n        return false\r\n    endfunction\r\n    \r\n    private function isNotException takes integer special returns boolean\r\n        if special != 'A0EG' then\r\n            return true\r\n        endif\r\n        return false\r\n    endfunction\r\n    \r\n    private function isSpecialNotUsed takes integer index returns boolean\r\n        local integer i = 1\r\n        loop\r\n            exitwhen i > PLAYERS_LIMIT\r\n            if udg_Ability_Spec[i] == udg_DB_Ability_Special[index] and isNotExceptionByIndex(index) then\r\n                return false\r\n            endif\r\n            set i = i + 1\r\n        endloop\r\n        return true\r\n    endfunction\r\n    \r\n    public function Refresh takes nothing returns nothing\r\n        local integer i \r\n        local ListInt list = ListInt.create()\r\n        local integer special\r\n        \r\n        set i = 1\r\n        loop\r\n            exitwhen i > udg_Database_NumberItems[37]\r\n            if isSpecialNotUsed(i) then\r\n                call list.Add(udg_DB_Ability_Special[i])\r\n            endif\r\n            set i = i + 1\r\n        endloop\r\n        \r\n        set i = 1\r\n        loop\r\n            exitwhen i > BUTTONS\r\n            call BlzFrameSetVisible( icon[i], true)\r\n            if list.IsEmpty() then\r\n                set i = BUTTONS\r\n                call BJDebugMsg(\"Warning! Not enough specials in the rotation to refresh the shop.\")\r\n            else\r\n                set special = list.GetRandomCellAndRemove()\r\n                call SaveInteger(udg_hash, GetHandleId(glueButton[i]), KEY_SPECIAL, special )\r\n                call BlzFrameSetTexture( icon[i], BlzGetAbilityIcon( special ), 0, true )\r\n                set name[i] = BlzGetAbilityTooltip( special, 0)\r\n                set description[i] = BlzGetAbilityExtendedTooltip( special, 0 )\r\n            endif\r\n            set i = i + 1\r\n        endloop\r\n        \r\n        call list.destroy()\r\n    endfunction\r\n    \r\n    private function IsCanBuy takes player owner, unit hero returns boolean\r\n        local boolean isCan = true\r\n        \r\n        if GetPlayerState(owner, PLAYER_STATE_RESOURCE_GOLD) < COST then\r\n            call DisplayTimedTextToPlayer( owner, 0, 0, 5, \"Not enough gold.\" )\r\n            set isCan = false\r\n        elseif hero == null then\r\n            call DisplayTimedTextToPlayer( owner, 0, 0, 5, \"You don't have a hero.\" )\r\n            set isCan = false\r\n        endif\r\n    \r\n        set owner = null\r\n        set hero = null\r\n        return isCan\r\n    endfunction\r\n\r\n    private function Buy takes nothing returns nothing\r\n        local player owner = GetTriggerPlayer()\r\n        local integer frameId = GetHandleId(BlzGetTriggerFrame())\r\n        local integer special = LoadInteger(udg_hash, frameId, KEY_SPECIAL )\r\n        local integer position = LoadInteger(udg_hash, frameId, KEY_SPECIAL_POSITION )\r\n        local integer heroIndex = GetPlayerId( owner ) + 1\r\n        local unit hero = udg_hero[heroIndex]\r\n        \r\n        if GetLocalPlayer() == GetTriggerPlayer() then\r\n            call BlzFrameSetVisible( BlzGetTriggerFrame(),false)\r\n            call BlzFrameSetVisible( BlzGetTriggerFrame(),true)\r\n        endif\r\n        \r\n        if IsCanBuy(owner, hero) then\r\n            call NewSpecial( hero, special )\r\n            call PlaySpecialEffect( SPECIAL_GETTING_ANIMATION, hero)\r\n            call SetPlayerState( owner, PLAYER_STATE_RESOURCE_GOLD, IMaxBJ( 0, GetPlayerState(owner, PLAYER_STATE_RESOURCE_GOLD) - COST ) )\r\n            if GetLocalPlayer() == GetTriggerPlayer() then\r\n                call BlzFrameSetVisible( background, false)\r\n            endif\r\n            if GettedSpecialCell[heroIndex] != 0 then\r\n                call BlzFrameSetVisible( icon[GettedSpecialCell[heroIndex]], true)\r\n            endif\r\n            set GettedSpecialCell[heroIndex] = position\r\n            if isNotException(special) then\r\n                call BlzFrameSetVisible( icon[position], false)\r\n            endif\r\n        elseif GetLocalPlayer() == owner then\r\n            call StartSound(gg_snd_Error)\r\n        endif\r\n        \r\n        set owner = null\r\n        set hero = null\r\n    endfunction\r\n    \r\n    private function EnableTooltip takes nothing returns nothing\r\n        local integer index = LoadInteger(udg_hash, GetHandleId(BlzGetTriggerFrame()), StringHash(\"index\") )\r\n \r\n        call Tooltip_SetLocalTooltipText(GetTriggerPlayer(), name[index], description[index])\r\n    endfunction\r\n    \r\n    private function CreateSpecialButton takes integer index, integer rowPos, integer columnPos returns nothing\r\n        set icon[index] = BlzCreateFrameByType(\"BACKDROP\", \"\", background, \"StandartFrameTemplate\", 0)\r\n        call BlzFrameSetSize(icon[index], SPECIALS_ICON_SIZE, SPECIALS_ICON_SIZE)\r\n        call BlzFrameSetPoint( icon[index], FRAMEPOINT_CENTER, background, FRAMEPOINT_TOPLEFT, rowPos*SPECIALS_ICON_SIZE, -SPECIALS_ICON_SIZE*columnPos )\r\n        \r\n        set glueButton[index] = BlzCreateFrameByType(\"GLUEBUTTON\", \"\", icon[index], \"ScoreScreenTabButtonTemplate\", 0)\r\n        call BlzFrameSetSize( glueButton[index], SPECIALS_ICON_SIZE, SPECIALS_ICON_SIZE )\r\n        call BlzFrameSetPoint( glueButton[index], FRAMEPOINT_CENTER, icon[index], FRAMEPOINT_CENTER, 0, 0 )\r\n        call Tooltip_AddMouseEvent( glueButton[index], function EnableTooltip, function Buy, index )\r\n        call SaveInteger(udg_hash, GetHandleId(glueButton[index]), KEY_SPECIAL_POSITION, index )\r\n        \r\n        set name[index] = \"\"\r\n        set description[index] = \"\"\r\n    endfunction\r\n\r\n    private function Trig_SpecialsShop_Actions takes nothing returns nothing\r\n        local framehandle frame\r\n        local integer i\r\n        local integer rowPos\r\n        local integer columnPos\r\n        local real backGroundSizeX\r\n        local real backGroundSizeY\r\n        \r\n        set background = BlzCreateFrame(\"QuestButtonBaseTemplate\", BlzGetOriginFrame(ORIGIN_FRAME_GAME_UI,0), 0, 0)\r\n        call BlzFrameSetAbsPoint(background, FRAMEPOINT_TOPRIGHT, 0.75, 0.53)\r\n        call BlzFrameSetVisible( background, false )\r\n        call BlzFrameSetLevel( background, -1 )\r\n        \r\n        call Frames_AddExitButton(background)\r\n        \r\n        set i = 1\r\n        set rowPos = 0 \r\n        set columnPos = 1\r\n        loop\r\n            exitwhen i > BUTTONS\r\n            set rowPos = rowPos + 1\r\n            if rowPos > BUTTONS_IN_A_ROW then\r\n                set rowPos = 1\r\n                set columnPos = columnPos + 1\r\n            endif\r\n            call CreateSpecialButton(i, rowPos, columnPos)\r\n            set i = i + 1\r\n        endloop\r\n        \r\n        set backGroundSizeX = 0.05+(BUTTONS_IN_A_ROW*SPECIALS_ICON_SIZE)\r\n        set backGroundSizeY = 0.06+(columnPos*SPECIALS_ICON_SIZE)\r\n\r\n        call BlzFrameSetSize(background, backGroundSizeX, backGroundSizeY)\r\n        \r\n        set frame = BlzCreateFrameByType(\"TEXT\", \"\", background, \"StandartFrameTemplate\", 0)\r\n        call BlzFrameSetSize( frame, backGroundSizeX - 0.02, 0.03 )\r\n        call BlzFrameSetPoint( frame, FRAMEPOINT_BOTTOMLEFT, background, FRAMEPOINT_BOTTOMLEFT, 0.01,0.005) \r\n        call BlzFrameSetText( frame, \"Choose a |cff8080ffspecial|r ability.|n|cffffcc00Cost:|r 100 gold. |cFF959697The ability can be changed at any time.|r\" )\r\n        \r\n        call Refresh()\r\n        \r\n        set frame = null\r\n    endfunction\r\n    \r\n    \r\n    //Shoop Choosing\r\n    private function SpecialChoose_Conditions takes nothing returns boolean\r\n        return udg_fightmod[0] == false\r\n    endfunction\r\n\r\n    private function SpecialChoose takes nothing returns nothing\r\n        //ПРИВЕРИТЬ НА DESYNC!!!\r\n        if GetLocalPlayer() == GetTriggerPlayer() then\r\n            if GetUnitTypeId(GetTriggerUnit()) == ID_SHOP then\r\n                call BlzFrameSetVisible( background, true )\r\n            else\r\n                call BlzFrameSetVisible( background, false )\r\n            endif\r\n        endif\r\n    endfunction\r\n    \r\n    \r\n    //Fight Start\r\n    private function FightStartGlobal takes nothing returns nothing\r\n        call BlzFrameSetVisible( background, false )\r\n    endfunction\r\n    \r\n    //Hero's Repick\r\n    private function HeroRepick takes nothing returns nothing\r\n        if GetLocalPlayer() == GetOwningPlayer(Event_HeroRepick_Hero) then\r\n            call BlzFrameSetVisible( background, false )\r\n        endif\r\n    endfunction\r\n    \r\n    //Win boss fight\r\n    private function OnMainBattleWin takes nothing returns nothing\r\n        call Refresh()\r\n    endfunction\r\n    \r\n    //Reset data at the beginning of the battle\r\n    private function FightStartEvent takes nothing returns nothing\r\n        set GettedSpecialCell[Event_FightStart_Index] = 0\r\n    endfunction\r\n\r\n    //===========================================================================\r\n    private function init takes nothing returns nothing\r\n        local integer i\r\n        local trigger trig = CreateTrigger()\r\n        \r\n        call TriggerRegisterTimerEvent(trig, 1, false)\r\n        call TriggerAddAction( trig, function Trig_SpecialsShop_Actions )\r\n        \r\n        set i = 0\r\n        set trig = CreateTrigger()\r\n        loop\r\n            exitwhen i > 3\r\n            call TriggerRegisterPlayerSelectionEventBJ( trig, Player(i), true )\r\n            set i = i + 1\r\n        endloop\r\n        call TriggerAddCondition( trig, Condition( function SpecialChoose_Conditions ) )\r\n        call TriggerAddAction( trig, function SpecialChoose )\r\n        \r\n        call CreateEventTrigger( \"udg_FightStartGlobal_Real\", function FightStartGlobal, null )\r\n        call CreateEventTrigger( \"Event_HeroRepick_Real\", function HeroRepick, null )\r\n        call CreateEventTrigger( \"Event_MainBattleWin\", function OnMainBattleWin, null )\r\n        call CreateEventTrigger( \"udg_FightStart_Real\", function FightStartEvent, null )\r\n        \r\n        set trig = null\r\n    endfunction\r\n\r\nendscope",
  "Events": [],
  "LocalVariables": [],
  "Conditions": [],
  "Actions": []
}