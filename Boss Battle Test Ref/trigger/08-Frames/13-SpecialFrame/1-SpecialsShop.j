scope SpecialsShop initializer init

    globals
        private constant integer ID_SHOP = 'h027'
        
        private constant integer BUTTONS = 6
        private constant integer BUTTONS_IN_A_ROW = 3
        private constant integer BUTTONS_ARRAYS = BUTTONS + 1
        private constant integer COST = 100
        private constant real SPECIALS_ICON_SIZE = 0.035
        private constant integer KEY_SPECIAL = StringHash( "spec" )
        private constant integer KEY_SPECIAL_POSITION = StringHash( "specp" )
        private constant string SPECIAL_GETTING_ANIMATION = "Abilities\\Spells\\Items\\TomeOfRetraining\\TomeOfRetrainingCaster.mdl"
        
        private framehandle background = null
        private integer array special[BUTTONS_ARRAYS]
        private framehandle array glueButton[BUTTONS_ARRAYS]
        private framehandle array icon[BUTTONS_ARRAYS]
        private string array name[BUTTONS_ARRAYS]
        private string array description[BUTTONS_ARRAYS]
        
        private integer array GettedSpecialCell[PLAYERS_LIMIT_ARRAYS]
    endglobals
    
    /*struct SpecialButton
        readonly framehandle icon
        readonly framehandle glueButton
        readonly integer special = 0
        
        static method create takes framehandle icon, framehandle glueButton returns SpecialButton
            local SpecialButton this = SpecialButton.allocate() 
            .icon = icon
            .glueButton = glueButton
            
            set icon = null
            set glueButton = null
            return this
        endmethod
    endstruct*/
    
    private function isNotExceptionByIndex takes integer index returns boolean
        if udg_DB_Ability_Special[index] != 'A0EG' then
            return true
        endif
        return false
    endfunction
    
    private function isNotException takes integer special returns boolean
        if special != 'A0EG' then
            return true
        endif
        return false
    endfunction
    
    private function isSpecialNotUsed takes integer index returns boolean
        local integer i = 1
        loop
            exitwhen i > PLAYERS_LIMIT
            if udg_Ability_Spec[i] == udg_DB_Ability_Special[index] and isNotExceptionByIndex(index) then
                return false
            endif
            set i = i + 1
        endloop
        return true
    endfunction
    
    public function Refresh takes nothing returns nothing
        local integer i 
        local ListInt list = ListInt.create()
        local integer special
        
        set i = 1
        loop
            exitwhen i > udg_Database_NumberItems[37]
            if isSpecialNotUsed(i) then
                call list.Add(udg_DB_Ability_Special[i])
            endif
            set i = i + 1
        endloop
        
        set i = 1
        loop
            exitwhen i > BUTTONS
            call BlzFrameSetVisible( icon[i], true)
            if list.IsEmpty() then
                set i = BUTTONS
                call BJDebugMsg("Warning! Not enough specials in the rotation to refresh the shop.")
            else
                set special = list.GetRandomCellAndRemove()
                call SaveInteger(udg_hash, GetHandleId(glueButton[i]), KEY_SPECIAL, special )
                call BlzFrameSetTexture( icon[i], BlzGetAbilityIcon( special ), 0, true )
                set name[i] = BlzGetAbilityTooltip( special, 0)
                set description[i] = BlzGetAbilityExtendedTooltip( special, 0 )
            endif
            set i = i + 1
        endloop
        
        call list.destroy()
    endfunction
    
    private function IsCanBuy takes player owner, unit hero returns boolean
        local boolean isCan = true
        
        if GetPlayerState(owner, PLAYER_STATE_RESOURCE_GOLD) < COST then
            call DisplayTimedTextToPlayer( owner, 0, 0, 5, "Not enough gold." )
            set isCan = false
        elseif hero == null then
            call DisplayTimedTextToPlayer( owner, 0, 0, 5, "You don't have a hero." )
            set isCan = false
        endif
    
        set owner = null
        set hero = null
        return isCan
    endfunction

    private function Buy takes nothing returns nothing
        local player owner = GetTriggerPlayer()
        local integer frameId = GetHandleId(BlzGetTriggerFrame())
        local integer special = LoadInteger(udg_hash, frameId, KEY_SPECIAL )
        local integer position = LoadInteger(udg_hash, frameId, KEY_SPECIAL_POSITION )
        local integer heroIndex = GetPlayerId( owner ) + 1
        local unit hero = udg_hero[heroIndex]
        
        if GetLocalPlayer() == GetTriggerPlayer() then
            call BlzFrameSetVisible( BlzGetTriggerFrame(),false)
            call BlzFrameSetVisible( BlzGetTriggerFrame(),true)
        endif
        
        if IsCanBuy(owner, hero) then
            call NewSpecial( hero, special )
            call PlaySpecialEffect( SPECIAL_GETTING_ANIMATION, hero)
            call SetPlayerState( owner, PLAYER_STATE_RESOURCE_GOLD, IMaxBJ( 0, GetPlayerState(owner, PLAYER_STATE_RESOURCE_GOLD) - COST ) )
            if GetLocalPlayer() == GetTriggerPlayer() then
                call BlzFrameSetVisible( background, false)
            endif
            if GettedSpecialCell[heroIndex] != 0 then
                call BlzFrameSetVisible( icon[GettedSpecialCell[heroIndex]], true)
            endif
            set GettedSpecialCell[heroIndex] = position
            if isNotException(special) then
                call BlzFrameSetVisible( icon[position], false)
            endif
        elseif GetLocalPlayer() == owner then
            call StartSound(gg_snd_Error)
        endif
        
        set owner = null
        set hero = null
    endfunction
    
    private function EnableTooltip takes nothing returns nothing
        local integer index = LoadInteger(udg_hash, GetHandleId(BlzGetTriggerFrame()), StringHash("index") )
 
        call Tooltip_SetLocalTooltipText(GetTriggerPlayer(), name[index], description[index])
    endfunction
    
    private function CreateSpecialButton takes integer index, integer rowPos, integer columnPos returns nothing
        set icon[index] = BlzCreateFrameByType("BACKDROP", "", background, "StandartFrameTemplate", 0)
        call BlzFrameSetSize(icon[index], SPECIALS_ICON_SIZE, SPECIALS_ICON_SIZE)
        call BlzFrameSetPoint( icon[index], FRAMEPOINT_CENTER, background, FRAMEPOINT_TOPLEFT, rowPos*SPECIALS_ICON_SIZE, -SPECIALS_ICON_SIZE*columnPos )
        
        set glueButton[index] = BlzCreateFrameByType("GLUEBUTTON", "", icon[index], "ScoreScreenTabButtonTemplate", 0)
        call BlzFrameSetSize( glueButton[index], SPECIALS_ICON_SIZE, SPECIALS_ICON_SIZE )
        call BlzFrameSetPoint( glueButton[index], FRAMEPOINT_CENTER, icon[index], FRAMEPOINT_CENTER, 0, 0 )
        call Tooltip_AddMouseEvent( glueButton[index], function EnableTooltip, function Buy, index )
        call SaveInteger(udg_hash, GetHandleId(glueButton[index]), KEY_SPECIAL_POSITION, index )
        
        set name[index] = ""
        set description[index] = ""
    endfunction

    private function Trig_SpecialsShop_Actions takes nothing returns nothing
        local framehandle frame
        local integer i
        local integer rowPos
        local integer columnPos
        local real backGroundSizeX
        local real backGroundSizeY
        
        set background = BlzCreateFrame("QuestButtonBaseTemplate", BlzGetOriginFrame(ORIGIN_FRAME_GAME_UI,0), 0, 0)
        call BlzFrameSetAbsPoint(background, FRAMEPOINT_TOPRIGHT, 0.75, 0.53)
        call BlzFrameSetVisible( background, false )
        call BlzFrameSetLevel( background, -1 )
        
        call Frames_AddExitButton(background)
        
        set i = 1
        set rowPos = 0 
        set columnPos = 1
        loop
            exitwhen i > BUTTONS
            set rowPos = rowPos + 1
            if rowPos > BUTTONS_IN_A_ROW then
                set rowPos = 1
                set columnPos = columnPos + 1
            endif
            call CreateSpecialButton(i, rowPos, columnPos)
            set i = i + 1
        endloop
        
        set backGroundSizeX = 0.05+(BUTTONS_IN_A_ROW*SPECIALS_ICON_SIZE)
        set backGroundSizeY = 0.06+(columnPos*SPECIALS_ICON_SIZE)

        call BlzFrameSetSize(background, backGroundSizeX, backGroundSizeY)
        
        set frame = BlzCreateFrameByType("TEXT", "", background, "StandartFrameTemplate", 0)
        call BlzFrameSetSize( frame, backGroundSizeX - 0.02, 0.03 )
        call BlzFrameSetPoint( frame, FRAMEPOINT_BOTTOMLEFT, background, FRAMEPOINT_BOTTOMLEFT, 0.01,0.005) 
        call BlzFrameSetText( frame, "Choose a |cff8080ffspecial|r ability.|n|cffffcc00Cost:|r 100 gold. |cFF959697The ability can be changed at any time.|r" )
        
        call Refresh()
        
        set frame = null
    endfunction
    
    
    //Shoop Choosing
    private function SpecialChoose_Conditions takes nothing returns boolean
        return udg_fightmod[0] == false
    endfunction

    private function SpecialChoose takes nothing returns nothing
        //ПРИВЕРИТЬ НА DESYNC!!!
        if GetLocalPlayer() == GetTriggerPlayer() then
            if GetUnitTypeId(GetTriggerUnit()) == ID_SHOP then
                call BlzFrameSetVisible( background, true )
            else
                call BlzFrameSetVisible( background, false )
            endif
        endif
    endfunction
    
    
    //Fight Start
    private function FightStartGlobal takes nothing returns nothing
        call BlzFrameSetVisible( background, false )
    endfunction
    
    //Hero's Repick
    private function HeroRepick takes nothing returns nothing
        if GetLocalPlayer() == GetOwningPlayer(Event_HeroRepick_Hero) then
            call BlzFrameSetVisible( background, false )
        endif
    endfunction
    
    //Win boss fight
    private function GlobalBossFightWin takes nothing returns nothing
        call Refresh()
    endfunction
    
    //Reset data at the beginning of the battle
    private function FightStartEvent takes nothing returns nothing
        set GettedSpecialCell[Event_FightStart_Index] = 0
    endfunction

    //===========================================================================
    private function init takes nothing returns nothing
        local integer i
        local trigger trig = CreateTrigger()
        
        call TriggerRegisterTimerEvent(trig, 1, false)
        call TriggerAddAction( trig, function Trig_SpecialsShop_Actions )
        
        set i = 0
        set trig = CreateTrigger()
        loop
            exitwhen i > 3
            call TriggerRegisterPlayerSelectionEventBJ( trig, Player(i), true )
            set i = i + 1
        endloop
        call TriggerAddCondition( trig, Condition( function SpecialChoose_Conditions ) )
        call TriggerAddAction( trig, function SpecialChoose )
        
        call CreateEventTrigger( "udg_FightStartGlobal_Real", function FightStartGlobal, null )
        call CreateEventTrigger( "Event_HeroRepick_Real", function HeroRepick, null )
        call CreateEventTrigger( "Event_GlobalBossFightWin_Real", function GlobalBossFightWin, null )
        call CreateEventTrigger( "udg_FightStart_Real", function FightStartEvent, null )
        
        set trig = null
    endfunction

endscope