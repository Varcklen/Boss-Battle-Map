library HeroesTable initializer init requires HeroesTableDatabase, Repick

    globals
        private constant integer CLASSES = HeroesTableDatabase_CLASSES
        private constant integer HEROES_IN_COLUMN_MAX = HeroesTableDatabase_HEROES_IN_COLUMN_MAX
        private framehandle array heroButton[CLASSES][HEROES_IN_COLUMN_MAX]//Class/Position in Column
        private framehandle array heroIcon[CLASSES][HEROES_IN_COLUMN_MAX]//Class/Position in Column
    
        private framehandle HeroTable
        private framehandle ChooseButton
        private framehandle BanButton
        private framehandle array LevelTextFrame
        private framehandle array LevelHeroIcon
        private framehandle MainSkinButton
        private framehandle MainSkinIcon
        private framehandle AbilityBackground
        
        private framehandle array Skins_Button
        private framehandle array Skins_Icon
        private framehandle array Skins_LockFrame
        private framehandle array Skins_Text
        
        real Event_HeroPicked_Real
        unit Event_HeroPicked_Hero
        player Event_HeroPicked_Player
        integer Event_HeroPicked_HeroKey
        integer Event_HeroPicked_Class
        
        private constant real BUTTON_SIZE = 0.032
        private constant real START_POSITION_X = 0.66
        private constant real START_POSITION_Y = 0.5
        private constant integer POTION_BONUSES_ADDED_TO_HEROES = 4
        
        private framehandle array AspectVision[3]
        private framehandle array AspectButton[3]
        private constant real ASPECTS_SIZE = 0.03
        private constant real ASPECTS_INDENT = 0.035
        
        private constant integer KEY_CLASS = StringHash("kclss")
        private constant integer KEY_POSITION = StringHash("kpstn")
        
        private ChoosedHeroTemplate array ChoosedHero[PLAYERS_LIMIT_ARRAYS]
        public framehandle array ChoosedHeroButton[PLAYERS_LIMIT_ARRAYS]
        public string array ChoosedHeroIcon[PLAYERS_LIMIT_ARRAYS]
        
        //private unit array PotancialHero[PLAYERS_LIMIT_ARRAYS][HEROES_COUNT_ARRAYS]
        
        boolean array IsBanned[HEROES_COUNT_ARRAYS]
        
        private framehandle InfoBackground = null 
        private framehandle InfoButton = null 
        private framehandle InfoPanel_Icon = null
        private framehandle StoryTextArea = null
        
        private constant integer TEXT_NUMBERS = 8
        private framehandle array InfoPanelText[TEXT_NUMBERS]
    endglobals
    
    struct ChoosedHeroTemplate
        unit hero = null
        integer class
        integer position
        integer heroKey
    endstruct
    
    private function GetDifficulty takes integer index returns string
        if index == 2 then
            return "|cffff3300Hard|r"
        elseif index == 1 then
            return "|cffffcc00Medium|r"
        elseif index == 0 then
            return "|cff00cc00Easy|r"
        endif
        return "|cffff00ffUNKNOWN!|r"
    endfunction
    
    private function IsCanChoosedManyTimes takes integer heroId returns boolean
        if heroId == udg_Database_Hero[31] then
            return true
        elseif heroId == udg_Database_Hero[34] then
            return true
        endif
        return false
    endfunction
    
    private function StringSizeSmall takes string s returns real
        return (0.0002*StringLength(s))+0.05
    endfunction
    
    public function SetLevelNumberFrame takes player owner, integer level returns nothing
        local integer index = GetPlayerId( owner ) + 1
        call BlzFrameSetText( LevelTextFrame[index], I2S(level) )
        set owner = null
    endfunction
    
    private function ReturnActiveIcon takes unit hero returns nothing
        local integer index = GetUnitUserData(hero)
        local integer heroPosition = udg_HeroNum[index]
        local integer unitType = GetUnitTypeId( hero )
        local integer i
        local integer k
        local integer kEnd
        local boolean end = false

        set udg_UnitHeroLogic[heroPosition] = false
        
        set i = 0
        loop
            exitwhen i > CLASSES or end
            set k = 0
            set kEnd = HeroesTableDatabase_HEROES_IN_CLASS[HEROES_IN_COLUMN_MAX]
            loop
                exitwhen k > CLASSES or end
                if unitType == HeroFrame[i][k] then //NEED ADD!
                    call BlzFrameSetTexture( heroIcon[i][k], BlzGetAbilityIcon(GetUnitTypeId(hero)),0, true) //heroIcon[CLASSES][HEROES_IN_COLUMN_MAX] NEED ADD!
                    set end = true
                endif
                set k = k + 1
            endloop
            set i = i + 1
        endloop

        set hero = null
    endfunction
    
    private function HeroRepick takes nothing returns nothing
        local unit hero = Event_HeroRepick_Hero
        local player owner = GetOwningPlayer(hero)
        local integer index = GetPlayerId( owner ) + 1
    
        call ReturnActiveIcon(hero)
        
        call BlzFrameSetTexture(LevelHeroIcon[index], "ReplaceableTextures\\CommandButtons\\BTNSelectHeroOn.blp", 0, true)
        
        //Десинк?
        if GetLocalPlayer() == owner and udg_UntilFirstFight then
            call BlzFrameSetVisible( AbilityBackground, false )
            call BlzFrameSetVisible( MainSkinButton, false )
            call BlzFrameSetVisible( ChooseButton, false )
            call BlzFrameSetVisible( BanButton, false )
            call BlzFrameSetVisible(InfoBackground, false) 
            call BlzFrameSetVisible(InfoButton, false)
            call BlzFrameSetVisible( HeroTable, true )
            
            if udg_Host == owner then
                call BlzFrameSetVisible( BanButton, true )
            endif
        endif
        
        set owner = null
        set hero = null
    endfunction
    
    private function HeroLeave takes nothing returns nothing
        local unit hero = Event_HeroRepick_Hero
        local player owner = GetOwningPlayer(hero)
        local integer index = GetPlayerId( owner ) + 1
    
        if udg_UntilFirstFight then
            call ReturnActiveIcon(hero)
        endif
        
        call BlzFrameSetVisible( LevelTextFrame[index], false )
        call BlzFrameSetTexture(LevelHeroIcon[index], "war3mapImported\\BTNDivineShieldOff-Reforged.blp", 0, true)
        
        set owner = null
        set hero = null
    endfunction
    
    private function SetHeroColor takes unit hero returns nothing
        if BlzGetUnitIntegerField( hero,UNIT_IF_PRIMARY_ATTRIBUTE) == 1 then
            call SetUnitColor( hero, GetPlayerColor(Player(12)) )
        elseif BlzGetUnitIntegerField( hero,UNIT_IF_PRIMARY_ATTRIBUTE) == 2 then
            call SetUnitColor( hero, GetPlayerColor(Player(13)) )
        elseif BlzGetUnitIntegerField( hero,UNIT_IF_PRIMARY_ATTRIBUTE) == 3 then
            call SetUnitColor( hero, GetPlayerColor(Player(22)) )
        endif
        set hero = null
    endfunction
    
    private function SetAbilitiesInfo takes player owner, unit hero, integer heroIndex, integer alternativeUnique, integer class returns nothing
        local integer unique
        local integer i
     

        if alternativeUnique == 0 then
            set unique = HeroesTableDatabase_Uniques[class]
        else
            set unique = alternativeUnique
        endif

        if GetLocalPlayer() == owner then
            call BlzFrameSetVisible( AbilityBackground, true )
            //МОЖЕТ ВЫЗВАТЬ ДЕСИНК?
            set i = 1
            loop
                exitwhen i > 4
                call BlzFrameSetTexture( abilityFrame[i].icon, BlzGetAbilityIcon( Database_Hero_Abilities[i][heroIndex] ),0, true)
                call abilityFrame[i].SetNameAndDescription(BlzGetAbilityResearchTooltip(Database_Hero_Abilities[i][heroIndex], 0), BlzGetAbilityResearchExtendedTooltip(Database_Hero_Abilities[i][heroIndex], 0) )
                set i = i + 1
            endloop
                
            call BlzFrameSetTexture( abilityFrame[5].icon, BlzGetAbilityIcon( unique ),0, true)
            call abilityFrame[5].SetNameAndDescription( GetAbilityName(unique), BlzGetAbilityExtendedTooltip(unique, 0) )
            call BlzFrameSetTexture( MainSkinIcon, BlzGetAbilityIcon(GetUnitTypeId(hero)),0, true)
        endif
        set owner = null
        set hero = null
    endfunction
    
    private function SetAspectButtons takes player localPlayer, integer whichButton, integer aspectAbility returns nothing 
        local integer playerIndex = GetPlayerId(localPlayer)
    
        if whichButton < 1 or whichButton > 3 then
            call BJDebugMsg("Error! You are trying to access an AspectButton button in Heroes Choose that does not exist. You cannot change its description. Please contact the developer. Current: " + I2S(whichButton))
            return
        endif

        set AspectName[playerIndex][whichButton] = BlzGetAbilityTooltip(aspectAbility, 0)
        set AspectDescription[playerIndex][whichButton] = BlzGetAbilityExtendedTooltip(aspectAbility, 0)

        if GetLocalPlayer() == localPlayer then
            call BlzFrameSetTexture(AspectVision[whichButton-1], BlzGetAbilityIcon(aspectAbility), 0, true)
            call BlzFrameSetVisible( AspectVision[whichButton-1], true )
        endif
        
        set localPlayer = null
    endfunction 
    
    private function SetAspectsInfo takes player owner, integer heroIndex returns nothing
        local integer i
    
        if Aspects_IsHeroIndexCanUseAspects(heroIndex) then
            set i = 1
            loop
                exitwhen i > ASPECT_LIMIT
                call SetAspectButtons(owner, i, Aspect[heroIndex][i])
                set i = i + 1
            endloop
            if GetLocalPlayer() == owner then
                call BlzFrameSetVisible( InfoPanelText[TEXT_NUMBERS - 2], false )
            endif
        else
            if GetLocalPlayer() == owner then
                call BlzFrameSetVisible( AspectVision[0], false )
                call BlzFrameSetVisible( AspectVision[1], false )
                call BlzFrameSetVisible( AspectVision[2], false )
                call BlzFrameSetVisible( InfoPanelText[TEXT_NUMBERS - 2], true )
            endif
        endif
        set owner = null
    endfunction
    
    private function SetSkinInfo takes player owner, integer heroIndex, integer index, string mainIconPath returns nothing
        local integer i = 1

        loop
            exitwhen i > udg_DB_Skin_Limit
            if GetLocalPlayer() == owner then
                if skiniconBTN[heroIndex][i] != null and StringLength(skiniconBTN[heroIndex][i]) > 3 then
                    if BlzFrameIsVisible(Skins_Icon[1]) then
                        call BlzFrameSetVisible( Skins_Button[i], true )
                    endif
                    call BlzFrameSetVisible( MainSkinButton, true )
                    call BlzFrameSetTexture( MainSkinIcon, mainIconPath ,0, true)
                    if udg_LvL[index] < skinlvl[heroIndex][i] then
                        call BlzFrameSetText( Skins_Text[i], I2S(skinlvl[heroIndex][i]) )
                        call BlzFrameSetTexture( Skins_Icon[i], skiniconDIS[heroIndex][i],0, true)
                        call BlzFrameSetVisible( Skins_LockFrame[i], true )
                        call BlzFrameSetVisible( Skins_Text[i], true )
                    else
                        call BlzFrameSetTexture( Skins_Icon[i], skiniconBTN[heroIndex][i],0, true)
                        call BlzFrameSetVisible( Skins_LockFrame[i], false )
                        call BlzFrameSetVisible( Skins_Text[i], false )
                    endif
                else
                    if i == 1 then
                        call BlzFrameSetVisible( MainSkinButton, false )
                    endif
                    call BlzFrameSetVisible( Skins_Button[i], false )
                endif
            endif
            set i = i + 1
        endloop
        
        set owner = null
    endfunction
    
    private function DisableInfoFrames takes player owner returns nothing
        if GetLocalPlayer() == owner then
            call BlzFrameSetVisible( AbilityBackground, false )
            call BlzFrameSetVisible( BanButton, false )
            call BlzFrameSetVisible( InfoButton, false) 
            call BlzFrameSetVisible( InfoBackground, false) 
        endif
    
        set owner = null
    endfunction
    
    globals
        private string TempRole
        private integer TempRoleNumber
    endglobals
    
    private function AddRole takes string role returns nothing
        if TempRoleNumber > 0 then
            set TempRole = TempRole + ", "
        endif
        set TempRoleNumber = TempRoleNumber + 1
        set TempRole = TempRole + role
    endfunction
    
    private function GetUnitRoles takes HeroFramehandle heroFrame returns string
        set TempRole = ""
        set TempRoleNumber = 0
    
        if heroFrame.role[ROLE_DEFEND] then
            call AddRole("|cFFD74D0EDefender|r")
        endif
        if heroFrame.role[ROLE_SUPPORT] then
            call AddRole("|cFF4D94B5Support|r")
        endif
        if heroFrame.role[ROLE_HEAL] then
            call AddRole("|cFF399014Healer|r")
        endif
        if heroFrame.role[ROLE_MAGIC_DAMAGE] then
            call AddRole("|cFF0A5EC6Mage|r")
        endif
        if heroFrame.role[ROLE_PHYSICAL_DAMAGE] then
            call AddRole("|cFFC60303Warrior|r")
        endif
        if heroFrame.role[ROLE_SUMMONER] then
            call AddRole("|cFFC0D001Summoner|r")
        endif
        if heroFrame.role[ROLE_CONTROL] then
            call AddRole("|cFFB95BB0Disabler|r")
        endif
    
        call heroFrame.destroy()
        return TempRole
    endfunction
    
    private function GetHeroMainStat takes unit hero returns string
        local string stat = ""
        if BlzGetUnitIntegerField( hero,UNIT_IF_PRIMARY_ATTRIBUTE) == 1 then
            set stat = "|cFFC82323Strength|r"
        elseif BlzGetUnitIntegerField( hero,UNIT_IF_PRIMARY_ATTRIBUTE) == 2 then
            set stat = "|cFF2323C8Intellect|r"
        elseif BlzGetUnitIntegerField( hero,UNIT_IF_PRIMARY_ATTRIBUTE) == 3 then
            set stat = "|cFF23C823Agility|r"
        endif
        set hero = null
        return stat
    endfunction
    
    private function GetUnitType takes unit hero returns string
        local string unitType = ""
        if IsUnitType( hero, UNIT_TYPE_UNDEAD) then
            set unitType = "|cffff1493Undead|r"
        else
            set unitType = "Normal"
        endif
        
        if IsCanChoosedManyTimes(GetUnitTypeId(hero)) then
            set unitType = unitType + " |cFFF2AF8DCloneable|r"
        endif
        set hero = null
        return unitType
    endfunction
    
    private function SetInfoPanel takes player owner, unit hero, HeroFramehandle heroFrame returns nothing
        local string roles = GetUnitRoles(heroFrame)
        local string stat = GetHeroMainStat(hero)
        local string unitType = GetUnitType(hero)
        
        if GetLocalPlayer() == owner then
            call BlzFrameSetText( InfoPanelText[0], GetUnitName(hero) )
            call BlzFrameSetText( InfoPanelText[1], GetDifficulty( heroFrame.difficulty ) )
            call BlzFrameSetText( InfoPanelText[2], heroFrame.author )
            call BlzFrameSetText( InfoPanelText[3], stat )
            call BlzFrameSetText( InfoPanelText[4], unitType )
            call BlzFrameSetText( InfoPanelText[5], roles )
            
            call BlzFrameSetTexture(InfoPanel_Icon, BlzGetAbilityIcon(GetUnitTypeId(hero)), 0, true) 
            if heroFrame.story == null then
                call BlzFrameSetText( StoryTextArea, "None" ) 
            else
                call BlzFrameSetText( StoryTextArea, heroFrame.story ) 
            endif
        endif
        
        call heroFrame.destroy()
        set hero = null
        set owner = null
    endfunction
    
    //Hero choosing
    private function HeroChooseButton takes nothing returns nothing
        local integer heroId = 0
        local integer frameId = GetHandleId(BlzGetTriggerFrame())
        local integer class = LoadInteger(udg_hash, frameId, KEY_CLASS )
        local integer position = LoadInteger(udg_hash, frameId, KEY_POSITION )
        local player owner = GetTriggerPlayer()
        local integer index = GetPlayerId( owner ) + 1
        local HeroFramehandle heroFrame = HeroFrame[class][position]
        local integer unitType
        local unit hero
        
        if GetLocalPlayer() == owner then
            call BlzFrameSetVisible( BlzGetTriggerFrame(), false)
            call BlzFrameSetVisible( BlzGetTriggerFrame(), true)
        endif

        call ShowUnit(ChoosedHero[index].hero, false)
        if heroFrame.hero[index-1] == null then
            set heroFrame.hero[index-1] = CreateUnit( Player(PLAYER_NEUTRAL_PASSIVE), heroFrame.heroId, GetLocationX(udg_point[25+index]), GetLocationY(udg_point[25+index]), bj_UNIT_FACING )
            set ChoosedHero[index].hero = heroFrame.hero[index-1]
            //call BlzShowUnitTeamGlow( ChoosedHero[index].hero, false ) 
        else
            set ChoosedHero[index].hero = heroFrame.hero[index-1]
            call ShowUnit(ChoosedHero[index].hero, true)
        endif
        
        set hero = ChoosedHero[index].hero
        set unitType = GetUnitTypeId(hero)
        set heroId = GetHeroNumber( unitType )
        set ChoosedHero[index].position = position
        set ChoosedHero[index].class = class
        set ChoosedHero[index].heroKey = heroId
        set udg_SkinUsed[index] = 0
        
        call SetUnitSkin( hero, heroFrame.heroId )
        call SetHeroColor(hero)
        call QueueUnitAnimationBJ( hero, "stand" )
        call QueueUnitAnimationBJ( hero, "attack" )
        call QueueUnitAnimationBJ( hero, "stand" )
        call SetUnitState( hero, UNIT_STATE_MANA, GetUnitState( hero, UNIT_STATE_MAX_MANA) )
        call FogModifierStart( udg_Visible[index] )

        call CameraSetupApplyForPlayer( true, udg_CameraChoose[index], Player(index-1), 0 )
        call SetCameraTargetControllerNoZForPlayer( Player(index-1), hero, 210.00, -150.00, false )

        if class == CLASSES then
            call DisableInfoFrames(owner)
        else
            call SetAspectsInfo(owner, heroId)
            call SetSkinInfo(owner, heroId, index, BlzGetAbilityIcon(unitType))
            call SetAbilitiesInfo(owner, hero, heroId, heroFrame.alternativeUnique, class)
            call SetInfoPanel(owner, hero, heroFrame)

            if GetLocalPlayer() == owner then
                if udg_Host == owner then
                    call BlzFrameSetVisible( BanButton, true )
                endif
                call BlzFrameSetVisible( InfoButton, true) 
            endif
        endif

        if GetLocalPlayer() == owner then
            call BlzFrameSetVisible( ChooseButton, true )
        endif

        call heroFrame.destroy()
        set hero = null
        set owner = null
    endfunction
    
    private function IsHeroCanBeChosen takes integer heroId, integer heroIndex, integer playerIndex, boolean isRandomPick returns boolean
        /*call BJDebugMsg("==================================" )
        call BJDebugMsg("heroIndex: " + I2S(heroIndex))*/
        if IsBanned[heroIndex] then
            //call BJDebugMsg("IsBanned")
            return false
        elseif RandomHero_IsCanPickByIndex(playerIndex) == false and isRandomPick then//Attempts_Used[playerIndex] < ATTEMPTS_TO_PICK_RANDOM_HERO
            //call BJDebugMsg("no attemps")
            return false
        elseif heroId == 0 then
            //call BJDebugMsg("no hero")
            return false
        elseif not(udg_UnitHeroLogic[heroIndex] == false or IsCanChoosedManyTimes(heroId) ) then
            /*if udg_UnitHeroLogic[heroIndex] then
                call BJDebugMsg("true")
            else
                call BJDebugMsg("false")
            endif
            call BJDebugMsg("udg_UnitHeroLogic[index] == false or IsCanChoosedManyTimes(heroId)")*/
            return false
        endif
    
        return true
    endfunction
    
    private function GetChoosedHero takes nothing returns nothing
        local player owner = GetTriggerPlayer()
        local integer index = GetPlayerId( owner ) + 1
        local unit hero = ChoosedHero[index].hero
        local integer class = ChoosedHero[index].class
        local integer position = ChoosedHero[index].position 
        local integer heroKey = ChoosedHero[index].heroKey
        local integer heroRawcode = GetUnitTypeId( hero )
        local boolean isRandomPick = heroRawcode == HeroFrame[9][0].heroId

        if IsHeroCanBeChosen( heroRawcode, ChoosedHero[index].heroKey, index, isRandomPick ) then
            if isRandomPick then
                set hero = RandomHero_GetRandomHero( owner )
                set heroKey = GetHeroNumber( GetUnitTypeId(hero) )
            endif
            set Event_HeroPicked_Hero = hero
            set Event_HeroPicked_HeroKey = heroKey
            set Event_HeroPicked_Player = owner
            set Event_HeroPicked_Class = class
            set Event_HeroPicked_Real = 0.00
            set Event_HeroPicked_Real = 1.00
            set Event_HeroPicked_Real = 0.00
            
            set ChoosedHeroButton[index] = heroIcon[class][position]
            set ChoosedHeroIcon[index] = BlzGetAbilityIcon(GetUnitTypeId(hero))
            
            call BlzFrameSetTexture( ChoosedHeroButton[index], "ReplaceableTextures\\CommandButtons\\BTNCancel.blp",0, true) 
            call BlzFrameSetTexture(LevelHeroIcon[index], ChoosedHeroIcon[index], 0, true)
            
            if GetLocalPlayer() == owner then
                call BlzFrameSetVisible( HeroTable, false )
            endif
        elseif isRandomPick then
            call DisplayTimedTextToPlayer( owner, 0, 0, 5, "Attempts exhausted." )
        else
            call DisplayTimedTextToPlayer( owner, 0, 0, 5, "This hero is not available. Please choose an another hero.")
        endif

        set hero = null
        set owner = null
    endfunction

    private function SkinButton takes nothing returns nothing
        local player owner = GetTriggerPlayer()
        local integer index = GetPlayerId( owner ) + 1
        local unit hero = ChoosedHero[index].hero
        local integer heroRawcode = GetUnitTypeId( hero )
        local integer heroKey = ChoosedHero[index].heroKey
        local integer i

        if MainSkinButton == BlzGetTriggerFrame() then
            set udg_SkinUsed[index] = 0
            set i = 1
            loop
                exitwhen i > udg_DB_Skin_Limit
                if BlzFrameIsVisible(Skins_Icon[i]) then
                    call BlzSetUnitSkin( hero, heroRawcode )
                    if GetLocalPlayer() == owner then
                        call BlzFrameSetVisible( Skins_Button[i], false )
                    endif
                else
                    if GetLocalPlayer() == owner then
                        if skiniconBTN[heroKey][i] != null then
                            call BlzFrameSetVisible( Skins_Button[i], true )
                        endif
                    endif
                endif
                set i = i + 1
            endloop
        else
            set i = 1
            loop
                exitwhen i > udg_DB_Skin_Limit
                if Skins_Button[i] == BlzGetTriggerFrame() then
                    if udg_LvL[index] >= skinlvl[heroKey][i] then
                        set udg_SkinUsed[index] = skinmodel[heroKey][i]
                        call BlzFrameSetTexture( faceframe[index], skiniconBTN[heroKey][i], 0, false)
                        call SetUnitSkin( hero, udg_SkinUsed[index] )
                        //call BlzShowUnitTeamGlow( hero, FALSE ) 
                    else
                        set udg_SkinUsed[index] = 0
                    endif
                endif
                set i = i + 1
            endloop
        endif
        
        set hero = null
        set owner = null
    endfunction

    private function HeroBan takes nothing returns nothing
        local player owner = GetTriggerPlayer()
        local integer index = GetPlayerId( owner ) + 1
        local integer heroKey = ChoosedHero[index].heroKey
        //local integer frameId = GetHandleId(BlzGetTriggerFrame())
        local integer class = ChoosedHero[index].class//LoadInteger(udg_hash, frameId, KEY_CLASS )
        local integer position = ChoosedHero[index].position//LoadInteger(udg_hash, frameId, KEY_POSITION )
        local integer heroRawcode = GetUnitTypeId( ChoosedHero[index].hero )
        local integer i

        if GetLocalPlayer() == owner then
            call BlzFrameSetVisible( BlzGetTriggerFrame(),false)
            call BlzFrameSetVisible( BlzGetTriggerFrame(),true)
        endif
        
        /*call BJDebugMsg("class: " + I2S(class))
        call BJDebugMsg("position: " + I2S(position))
        call BJDebugMsg("heroKey: " + I2S(heroKey))*/
        //call BJDebugMsg("heroRawcode: " + I2S(heroRawcode))
        
        if heroRawcode != 0 and heroRawcode != HeroFrame[9][0] then
            if IsBanned[heroKey] then
                //call BJDebugMsg("isBanned: false")
                set IsBanned[heroKey] = false
                call BlzFrameSetTexture( heroIcon[class][position], BlzGetAbilityIcon(GetUnitTypeId(ChoosedHero[index].hero)), 0, true)
                set udg_BanLimit = udg_BanLimit + 1
            elseif udg_BanLimit > 0 then
                //call BJDebugMsg("isBanned: true")
                set IsBanned[heroKey] = true
                call BlzFrameSetTexture( heroIcon[class][position], "war3mapImported\\BTNban.blp", 0, true)
                set udg_BanLimit = udg_BanLimit - 1
                set i = 0
                loop
                    exitwhen i > 3
                    if GetUnitTypeId(udg_hero[i+1]) == heroRawcode then
                        call Repick( Player(i) )
                        call DisplayTimedTextToPlayer(Player(i), 0, 0, 5, "The host has banned this hero.")
                    endif
                    set i = i + 1
                endloop
            else
                call DisplayTimedTextToPlayer( owner, 0, 0, 5, "The limit of banned heroes has been exceeded. Unban the hero to continue." )
            endif
        endif
        
        set owner = null
    endfunction
    
    //Tooltip
    private function TooltipEnable takes integer index returns nothing 
        local player owner = GetTriggerPlayer()
        local integer playerIndex = GetPlayerId(owner)
    
        if GetLocalPlayer() == owner then
            call BlzFrameSetVisible( TooltipBackdrop, true )
        endif
        call Tooltip_SetLocalTooltipText(owner, AspectName[playerIndex][index], AspectDescription[playerIndex][index])
        
        set owner = null
    endfunction 
    
    private function TooltipEnable0 takes nothing returns nothing 
        call TooltipEnable(1)
    endfunction
    
    private function TooltipEnable1 takes nothing returns nothing 
        call TooltipEnable(2)
    endfunction
    
    private function TooltipEnable2 takes nothing returns nothing 
        call TooltipEnable(3)
    endfunction
    
    private function CreatePotionIcon takes framehandle parent returns nothing
        local framehandle newframe
        
        set newframe = BlzCreateFrameByType("BACKDROP", "", parent, "", 0)
        call BlzFrameSetPoint( newframe, FRAMEPOINT_CENTER, parent, FRAMEPOINT_BOTTOMLEFT, 0.007,0.007) 
        call BlzFrameSetSize(newframe, 0.01, 0.01)
        call BlzFrameSetTexture( newframe, "potionframe.blp",0, true)
        
        set newframe = null
    endfunction
    
    private function CreateIconNew takes framehandle parent returns nothing
        local framehandle newframe
        
        set newframe = BlzCreateFrameByType("BACKDROP", "", parent, "", 0)
        call BlzFrameSetPoint( newframe, FRAMEPOINT_CENTER, parent, FRAMEPOINT_BOTTOMRIGHT, -0.006,0.006) 	
        call BlzFrameSetSize(newframe, 0.02, 0.02)
        call BlzFrameSetTexture( newframe, "framenew.blp",0, true)
        
        set newframe = null
    endfunction
    
    private function CreateHeroButton takes trigger trigclass, integer class, integer position returns nothing
        local HeroFramehandle heroFrame = HeroFrame[class][position]
        local integer i
        local framehandle buttonFrame
        local framehandle icon
    
        if heroFrame.heroId == 0 then 
            //call BJDebugMsg("return")
            call heroFrame.destroy()
            set trigclass = null
            set buttonFrame = null
            set icon = null
            return
        endif
        
        set buttonFrame = BlzCreateFrameByType("GLUEBUTTON", "", HeroTable, "ScoreScreenTabButtonTemplate", 0)
        call BlzFrameSetAbsPoint(buttonFrame, FRAMEPOINT_CENTER, START_POSITION_X-(BUTTON_SIZE*class),START_POSITION_Y-(BUTTON_SIZE*position))	
        call BlzFrameSetSize(buttonFrame, BUTTON_SIZE, BUTTON_SIZE)
        call SaveInteger(udg_hash, GetHandleId(buttonFrame), KEY_CLASS, class )
        call SaveInteger(udg_hash, GetHandleId(buttonFrame), KEY_POSITION, position )

        set icon = BlzCreateFrameByType("BACKDROP", "", buttonFrame, "StandartFrameTemplate", 0)
        call BlzFrameSetAllPoints(icon, buttonFrame )
    
        call BlzTriggerRegisterFrameEvent(trigclass, buttonFrame, FRAMEEVENT_CONTROL_CLICK)
        call BlzFrameSetTexture( icon, heroFrame.icon, 0, true)

        set heroIcon[class][position] = icon
        set heroButton[class][position] = buttonFrame

        if heroFrame.heroId == udg_Database_Hero[udg_Database_InfoNumberHeroes] then
            call CreateIconNew(buttonFrame)
            call BlzFrameSetLevel( buttonFrame, 2 )
        endif
        
        set i = 1
        loop
            exitwhen i > POTION_BONUSES_ADDED_TO_HEROES
            if udg_HeroBonusPotion[i] == position and udg_HeroBonusPotionClass[i] == class then
                call CreatePotionIcon(buttonFrame)
                set udg_HeroBonusPotionHero[i] = heroFrame.heroId
                set i = POTION_BONUSES_ADDED_TO_HEROES
            endif
            set i = i + 1
        endloop
        
        call heroFrame.destroy()
        set trigclass = null
        set buttonFrame = null
        set icon = null
    endfunction
    
    private function CreateHeroButtons takes nothing returns nothing
        local trigger trigclass = CreateTrigger()
        local framehandle buttonFrame
        local framehandle icon
        local integer i = 0
        local integer iEnd = CLASSES - 1
        local integer k
        local integer kEnd
        
        loop
            exitwhen i > iEnd
            set k = 0
            set kEnd = HeroesTableDatabase_HEROES_IN_CLASS[i] - 1
            loop
                exitwhen k > kEnd
                call CreateHeroButton(trigclass, i, k)
                set k = k + 1
            endloop
            set i = i + 1
        endloop
    
        //Random Hero
        set buttonFrame = BlzCreateFrameByType("GLUEBUTTON", "", HeroTable, "ScoreScreenTabButtonTemplate", 0)
        call BlzFrameSetAbsPoint(buttonFrame, FRAMEPOINT_CENTER, (START_POSITION_X+BUTTON_SIZE)-(BUTTON_SIZE*10),START_POSITION_Y+BUTTON_SIZE)	
        call BlzFrameSetSize(buttonFrame, BUTTON_SIZE, BUTTON_SIZE)
        call BlzTriggerRegisterFrameEvent(trigclass, buttonFrame, FRAMEEVENT_CONTROL_CLICK)
        call SaveInteger(udg_hash, GetHandleId(buttonFrame), KEY_CLASS, 9 )
        call SaveInteger(udg_hash, GetHandleId(buttonFrame), KEY_POSITION, 0 )

        set icon = BlzCreateFrameByType("BACKDROP", "", buttonFrame, "StandartFrameTemplate", 0)
        call BlzFrameSetAllPoints(icon, buttonFrame )
        call BlzFrameSetTexture( icon, "war3mapImported\\PASBTNSelectHeroOn.blp",0, true)
        
        call TriggerAddAction(trigclass, function HeroChooseButton)
        
        set trigclass = null
        set buttonFrame = null
        set icon = null
    endfunction
    
    private function CreateClassFrames takes nothing returns nothing
        local framehandle class 
        local framehandle buttool 
        local integer index = 0
        
        loop
            exitwhen index > CLASSES - 1
            set class = BlzCreateFrameByType("BACKDROP", "", HeroTable, "", 0)
            call BlzFrameSetSize(class, BUTTON_SIZE, BUTTON_SIZE)
            call BlzFrameSetAbsPoint(class, FRAMEPOINT_CENTER, START_POSITION_X-(BUTTON_SIZE*index),START_POSITION_Y+BUTTON_SIZE)//+BUTTON_SIZE
            call BlzFrameSetTexture( class, ClassFrame[index].icon,0, true)

            set buttool = BlzCreateFrameByType("FRAME", "", HeroTable,"", 0)
            call BlzFrameSetAllPoints(buttool, class)
            call SetStableTool( buttool, ClassFrame[index].className, ClassFrame[index].description )
            set index = index + 1
        endloop
        
        set class = null
        set buttool = null
    endfunction
    
    private function MainStartFrames takes nothing returns nothing
        local integer i
        local integer rand
        local trigger chooseButtonTrigger

        set i = 1
        loop
            exitwhen i > POTION_BONUSES_ADDED_TO_HEROES
            set rand = GetRandomInt( 0, CLASSES - 1 )
            set udg_HeroBonusPotion[i] = GetRandomInt( 0, HeroesTableDatabase_HEROES_IN_CLASS[rand] - 1 )
            set udg_HeroBonusPotionClass[i] = rand
            set i = i + 1
        endloop
        
        set HeroTable = BlzCreateFrameByType("FRAME", "HeroTable", BlzGetOriginFrame(ORIGIN_FRAME_GAME_UI, 0), "StandartFrameTemplate", 0)
        call BlzFrameSetLevel( HeroTable, -1 )
        call BlzFrameSetVisible( HeroTable, false )

        set ChooseButton = BlzCreateFrame("ScriptDialogButton", HeroTable, 0,0) 
        call BlzFrameSetSize( ChooseButton, 0.07,0.04)
        call BlzFrameSetAbsPoint( ChooseButton, FRAMEPOINT_CENTER, 0.18,0.185)
        call BlzFrameSetText( ChooseButton, "Choose")
        call BlzFrameSetLevel( ChooseButton, -1 )
        call BlzFrameSetVisible( ChooseButton, false )
        
        set chooseButtonTrigger = CreateTrigger()
        call BlzTriggerRegisterFrameEvent(chooseButtonTrigger, ChooseButton, FRAMEEVENT_CONTROL_CLICK)
        call TriggerAddAction(chooseButtonTrigger, function GetChoosedHero)
        
        set chooseButtonTrigger = null
    endfunction
    
    private function CreateSkinButtons takes nothing returns nothing
        local trigger skinButtonTrigger = CreateTrigger()
        local framehandle background
        local framehandle skinName
        local integer i
        
        set MainSkinButton = BlzCreateFrameByType("GLUEBUTTON", "", HeroTable, "ScoreScreenTabButtonTemplate", 0)
        call BlzFrameSetAbsPoint(MainSkinButton, FRAMEPOINT_CENTER, 0.02,0.2)	
        call BlzFrameSetSize(MainSkinButton, 0.035, 0.035)
        call BlzFrameSetVisible( MainSkinButton, false )
        
        call TriggerAddAction(skinButtonTrigger, function SkinButton)
        call BlzTriggerRegisterFrameEvent(skinButtonTrigger, MainSkinButton, FRAMEEVENT_CONTROL_CLICK)

        set MainSkinIcon = BlzCreateFrameByType("BACKDROP", "", MainSkinButton, "StandartFrameTemplate", 0)
        call BlzFrameSetAllPoints( MainSkinIcon, MainSkinButton )
        call BlzFrameSetTexture( MainSkinIcon, "",0, true)
        
        set background = BlzCreateFrame( "QuestButtonBaseTemplate", MainSkinButton, 0, 0 )
        call BlzFrameSetAbsPoint(background, FRAMEPOINT_CENTER, 0.02, 0.17)
        call BlzFrameSetSize( background, 0.04, 0.03 )

        set skinName = BlzCreateFrameByType("TEXT", "", background, "StandartFrameTemplate", 0)
        call BlzFrameSetPoint( skinName, FRAMEPOINT_CENTER, background, FRAMEPOINT_CENTER, 0.007, -0.005) 
        call BlzFrameSetSize(skinName, 0.04, 0.02)
        call BlzFrameSetText( skinName, "skins" )
        
        set i = 1
        loop
            exitwhen i > udg_DB_Skin_Limit
            set Skins_Button[i] = BlzCreateFrameByType("GLUEBUTTON", "", MainSkinButton, "ScoreScreenTabButtonTemplate", 0)
            call BlzFrameSetAbsPoint(Skins_Button[i], FRAMEPOINT_CENTER, 0.02,0.2+(0.03*i))	
            call BlzFrameSetSize(Skins_Button[i], 0.03, 0.03)
            call BlzFrameSetVisible( Skins_Button[i], false )
            call BlzTriggerRegisterFrameEvent(skinButtonTrigger, Skins_Button[i], FRAMEEVENT_CONTROL_CLICK)
            call BlzFrameSetLevel( Skins_Button[i], -1 )

            set Skins_Icon[i] = BlzCreateFrameByType("BACKDROP", "", Skins_Button[i], "StandartFrameTemplate", 0)
            call BlzFrameSetAllPoints(Skins_Icon[i],Skins_Button[i] )
            call BlzFrameSetTexture( Skins_Icon[i], "", 0, true)
            
            set Skins_LockFrame[i] = BlzCreateFrameByType("BACKDROP", "", Skins_Button[i], "StandartFrameTemplate", 0)
            call BlzFrameSetSize( Skins_LockFrame[i], 0.015, 0.015 )
            call BlzFrameSetPoint( Skins_LockFrame[i], FRAMEPOINT_CENTER, Skins_Button[i], FRAMEPOINT_CENTER, 0,0) 
            call BlzFrameSetTexture( Skins_LockFrame[i], "framelock.blp",0, true)
            
            set Skins_Text[i] = BlzCreateFrameByType("TEXT", "", Skins_Button[i], "StandartFrameTemplate", 0)
            call BlzFrameSetSize( Skins_Text[i], 0.01, 0.01 )
            call BlzFrameSetPoint( Skins_Text[i], FRAMEPOINT_CENTER, Skins_Button[i], FRAMEPOINT_CENTER, 0.002,-0.005) 
            set i = i + 1
        endloop
        
        set skinButtonTrigger = null
        set background = null
        set skinName = null
    endfunction
    
    struct AbilityFrame
        readonly framehandle icon
        readonly framehandle name
        readonly framehandle description
        private framehandle tooltip
        private static real tooltipSizeY = 0.33
            
        static method create takes framehandle parent returns AbilityFrame
            local AbilityFrame this = AbilityFrame.allocate()
            local framehandle tooltipActivator
            
            set .icon = BlzCreateFrameByType("BACKDROP", "", parent, "", 0)
            
            set .tooltip = BlzCreateFrame( "QuestButtonBaseTemplate", .icon, 0, 0 )
            call BlzFrameSetSize(.tooltip, tooltipSizeY, 0.06)
            call BlzFrameSetAbsPoint(.tooltip, FRAMEPOINT_BOTTOM, 0.7, 0.16)
            
            set .name = BlzCreateFrameByType("TEXT", "", .tooltip, "StandartFrameTemplate", 0)
            set .description = BlzCreateFrameByType("TEXT", "", .tooltip, "StandartFrameTemplate", 0)
            call BlzFrameSetPoint( .name, FRAMEPOINT_TOPLEFT, .tooltip, FRAMEPOINT_TOPLEFT, 0.005,-0.01) 
            call BlzFrameSetPoint( .description, FRAMEPOINT_TOPLEFT, .tooltip, FRAMEPOINT_TOPLEFT, 0.005,-0.025) 
            
            set tooltipActivator = BlzCreateFrameByType("FRAME", "", .icon,"", 0)
            call BlzFrameSetAllPoints(tooltipActivator, .icon)
            call BlzFrameSetTooltip(tooltipActivator, .tooltip)
            
            set parent = null
            set tooltipActivator = null
            return this
        endmethod
        
        method SetNameAndDescription takes string newName, string newDescription returns nothing
            call BlzFrameSetText( .name, newName )
            call BlzFrameSetText( .description, newDescription )
            call BlzFrameSetSize( .tooltip, tooltipSizeY, StringSizeSmall(newDescription) )
        endmethod
    endstruct
    
    globals
        AbilityFrame array abilityFrame[6]
    endglobals
    
    private function CreateAbilityButtons takes nothing returns nothing
        local integer i

        set AbilityBackground = BlzCreateFrame("EscMenuBackdrop", HeroTable, 0, 0)
        call BlzFrameSetAbsPoint(AbilityBackground, FRAMEPOINT_CENTER, 0.398, 0.16)
        call BlzFrameSetSize(AbilityBackground, 0.3, 0.075)
        call BlzFrameSetVisible( AbilityBackground, false )

        set i = 1
        loop
            exitwhen i > 5
            set abilityFrame[i] = AbilityFrame.create(AbilityBackground)
            
            call BlzFrameSetSize(abilityFrame[i].icon, 0.04, 0.04)
            
            if i == 5 then
                call BlzFrameSetPoint( abilityFrame[i].icon, FRAMEPOINT_CENTER, AbilityBackground, FRAMEPOINT_CENTER, 0.04*(i-3)+0.02, 0 )
            else
                call BlzFrameSetPoint( abilityFrame[i].icon, FRAMEPOINT_CENTER, AbilityBackground, FRAMEPOINT_CENTER, 0.04*(i-3), 0 )
            endif

            call BlzFrameSetLevel( abilityFrame[i].name, 1 )
            call BlzFrameSetSize(abilityFrame[i].name, 0.3, 0.6)

            call BlzFrameSetLevel( abilityFrame[i].description, 1 )
            call BlzFrameSetSize(abilityFrame[i].description, 0.3, 0.6)

            call BlzFrameSetTexture( abilityFrame[i].icon, "war3mapImported\\PASfeed-icon-red-1_result.blp",0, true)
            set i = i + 1
        endloop
        
    endfunction
            
    private function CreatePlayerLevelInfoFrames takes nothing returns nothing
        local integer i
        local framehandle textBackground
    
        set i = 1
        loop
            exitwhen i > PLAYERS_LIMIT
            set LevelHeroIcon[i] = BlzCreateFrameByType("BACKDROP", "", HeroTable, "", 0)
            call BlzFrameSetAbsPoint(LevelHeroIcon[i], FRAMEPOINT_CENTER, 0.57+(i*0.03), 0.2)	
            call BlzFrameSetSize(LevelHeroIcon[i], 0.03, 0.03)
            
            if GetPlayerSlotState( Player( i - 1 ) ) == PLAYER_SLOT_STATE_PLAYING then
                call BlzFrameSetTexture(LevelHeroIcon[i], "ReplaceableTextures\\CommandButtons\\BTNSelectHeroOn.blp", 0, true)
            else
                call BlzFrameSetTexture(LevelHeroIcon[i], "war3mapImported\\BTNDivineShieldOff-Reforged.blp", 0, true)
                call BlzFrameSetVisible( LevelTextFrame[i], false )
            endif
            
            set textBackground = BlzCreateFrameByType("BACKDROP", "", HeroTable, "", 0)
            call BlzFrameSetPoint( textBackground, FRAMEPOINT_CENTER, LevelHeroIcon[i], FRAMEPOINT_CENTER, 0,-0.025) 	
            call BlzFrameSetSize( textBackground, 0.02, 0.02)
            call BlzFrameSetTexture( textBackground, "war3mapImported\\BTNfeed-icon-red-1_result.blp",0, true)
            
            set LevelTextFrame[i] = BlzCreateFrameByType("TEXT", "", HeroTable, "StandartFrameTemplate", 0)
            call BlzFrameSetSize( LevelTextFrame[i], 0.01, 0.01 ) 
            call BlzFrameSetPoint( LevelTextFrame[i], FRAMEPOINT_CENTER, textBackground, FRAMEPOINT_CENTER, 0, 0) 
            set i = i + 1
        endloop
        
        set textBackground = null
    endfunction
    
    private function CreateBanButton takes nothing returns nothing
        local trigger trig = CreateTrigger()
    
        set BanButton = BlzCreateFrame("ScriptDialogButton", HeroTable, 0,0) 
        call BlzFrameSetSize(BanButton, 0.04,0.03)
        call BlzFrameSetAbsPoint(BanButton, FRAMEPOINT_BOTTOMLEFT, 0.035,0.195)
        call BlzFrameSetText(BanButton, "Ban")
        call BlzFrameSetVisible( BanButton, false )
         
        call BlzTriggerRegisterFrameEvent(trig, BanButton, FRAMEEVENT_CONTROL_CLICK)
        call TriggerAddAction(trig, function HeroBan)
        
        set trig = null
    endfunction
    
    //Info Panel
    function InfoButtonClick takes nothing returns nothing 
        if GetLocalPlayer() == GetTriggerPlayer() then
            call BlzFrameSetEnable(InfoButton, false) 
            call BlzFrameSetEnable(InfoButton, true)
            if BlzFrameIsVisible(InfoBackground) then
                call BlzFrameSetVisible(InfoBackground, false) 
            else
                call BlzFrameSetVisible(InfoBackground, true) 
            endif
        endif
    endfunction 
    
    private function CreateAspects takes framehandle parent returns nothing
        local framehandle passiveOutline
        local integer i
    
        set i = 0
        loop
            exitwhen i > 2
            set AspectVision[i] = BlzCreateFrameByType("BACKDROP", "AspectVision0" + I2S(i), parent, "", 1) 
            call BlzFrameSetPoint( AspectVision[i], FRAMEPOINT_LEFT, parent, FRAMEPOINT_RIGHT, i*ASPECTS_INDENT, 0)
            call BlzFrameSetSize(AspectVision[i], ASPECTS_SIZE, ASPECTS_SIZE)
            call BlzFrameSetTexture(AspectVision[i], "", 0, true) 
            
            set AspectButton[i] = BlzCreateFrameByType("BUTTON", "", AspectVision[i], "", 1) 
            call BlzFrameSetAllPoints(AspectButton[i], AspectVision[i] )
            
            set passiveOutline = BlzCreateFrameByType("BACKDROP", "", AspectVision[i], "StandartFrameTemplate", 0)
            call BlzFrameSetTexture(passiveOutline, "war3mapImported\\PAS_Effect.blp", 0, true)
            call BlzFrameSetAllPoints(passiveOutline, AspectVision[i])
            set i = i + 1
        endloop
        
        call Tooltip_AddEvent(AspectButton[0], function TooltipEnable0 )
        call Tooltip_AddEvent(AspectButton[1], function TooltipEnable1 )
        call Tooltip_AddEvent(AspectButton[2], function TooltipEnable2 )
        
        set parent = null
        set passiveOutline = null
    endfunction 
    
    private function CreateStory takes framehandle parent returns nothing
        set StoryTextArea = BlzCreateFrame("MyTextArea", parent ,0,0)
        call BlzFrameSetSize( StoryTextArea, 0.32, 0.12)
        call BlzFrameSetPoint( StoryTextArea, FRAMEPOINT_TOPLEFT, parent, FRAMEPOINT_BOTTOMLEFT, 0, -0.005)
        call BlzFrameSetText( StoryTextArea, "None")  
    
        set parent = null
    endfunction 
    
    private function CreateInfoPanel takes nothing returns nothing 
        local framehandle firstFrame
        local framehandle secondFrame
        local trigger trig
        local string array names
        local integer i
        local integer iEnd
    
        set InfoButton = BlzCreateFrame("ScriptDialogButton", HeroTable ,0,0) 
        call BlzFrameSetSize(InfoButton, 0.04,0.03)
        call BlzFrameSetAbsPoint(InfoButton, FRAMEPOINT_BOTTOMLEFT, 0.035,0.165)
        call BlzFrameSetText(InfoButton, "|cffFCD20DInfo|r") 
        call BlzFrameSetVisible(InfoButton, false) 

        set trig = CreateTrigger() 
        call BlzTriggerRegisterFrameEvent( trig, InfoButton, FRAMEEVENT_CONTROL_CLICK) 
        call TriggerAddAction( trig, function InfoButtonClick) 

        set InfoBackground = BlzCreateFrame("QuestButtonBaseTemplate", HeroTable ,0,0) 
        call BlzFrameSetAbsPoint(InfoBackground, FRAMEPOINT_TOPLEFT, 0.015, 0.52) 
        call BlzFrameSetSize( InfoBackground, 0.34, 0.3)
        call BlzFrameSetVisible(InfoBackground, false) 
        call BlzFrameSetLevel( InfoBackground, 2 )

        set names[0] = "|cffe1a019Name:|r"
        set names[1] = "|cffe1a019Difficulty:|r"
        set names[2] = "|cffe1a019Author:|r"
        set names[3] = "|cffe1a019Main Stat:|r"
        set names[4] = "|cffe1a019Type:|r"
        set names[5] = "|cffe1a019Role:|r"
        set names[6] = "|cffe1a019Aspects:|r"
        set names[7] = "|cffe1a019Story:|r"

        set secondFrame = InfoBackground
        set i = 0
        set iEnd = TEXT_NUMBERS - 1
        loop
            exitwhen i > iEnd
            set firstFrame = secondFrame
            set secondFrame = BlzCreateFrameByType("TEXT", "name", InfoBackground, "", 0) 
            
            if i == iEnd then
                call BlzFrameSetPoint( secondFrame, FRAMEPOINT_TOPRIGHT, firstFrame, FRAMEPOINT_BOTTOMRIGHT, 0, -0.01)
                call CreateStory(secondFrame)
                set InfoPanelText[i] = null
            else
                if i == TEXT_NUMBERS - 2 then
                    call BlzFrameSetPoint( secondFrame, FRAMEPOINT_TOPRIGHT, firstFrame, FRAMEPOINT_BOTTOMRIGHT, 0, -0.01)
                    call CreateAspects(secondFrame)
                elseif i == 0 then
                    call BlzFrameSetPoint( secondFrame, FRAMEPOINT_LEFT, firstFrame, FRAMEPOINT_TOPLEFT, 0.01, -0.015) 
                else
                    call BlzFrameSetPoint( secondFrame, FRAMEPOINT_TOPRIGHT, firstFrame, FRAMEPOINT_BOTTOMRIGHT, 0, 0) 
                endif
                set InfoPanelText[i] = BlzCreateFrameByType("TEXT", "name", secondFrame, "", 0)  
                call BlzFrameSetPoint( InfoPanelText[i], FRAMEPOINT_LEFT, secondFrame, FRAMEPOINT_RIGHT, 0.005, 0)
                call BlzFrameSetSize( InfoPanelText[i], 0.18, 0.015)
                call BlzFrameSetText( InfoPanelText[i], "None")
                call BlzFrameSetTextAlignment( InfoPanelText[i], TEXT_JUSTIFY_CENTER, TEXT_JUSTIFY_LEFT) 
            endif
            
            call BlzFrameSetSize( secondFrame, 0.05, 0.015)
            call BlzFrameSetText( secondFrame, names[i] ) 
            call BlzFrameSetTextAlignment( secondFrame, TEXT_JUSTIFY_CENTER, TEXT_JUSTIFY_RIGHT) 
            
            set names[i] = null
            set i = i + 1
        endloop
        
        set InfoPanel_Icon = BlzCreateFrameByType("BACKDROP", "InfoPanelIcon", InfoBackground, "", 1) 
        call BlzFrameSetPoint( InfoPanel_Icon, FRAMEPOINT_TOPRIGHT, InfoBackground, FRAMEPOINT_TOPRIGHT, -0.01, -0.01)
        call BlzFrameSetSize( InfoPanel_Icon, 0.05, 0.05)
        call BlzFrameSetTexture(InfoPanel_Icon, "", 0, true) 
         
        set trig = null
        set firstFrame = null
        set secondFrame = null
    endfunction 
    
    //Init All Peices
    private function InitTable takes nothing returns nothing
        call MainStartFrames()
        call CreateBanButton()
        call CreateSkinButtons()
        call CreateAbilityButtons()
        call CreateClassFrames()
        call CreateHeroButtons()
        call CreatePlayerLevelInfoFrames()
        call CreateInfoPanel()
        
        call BlzFrameSetVisible( HeroTable, true )        
    endfunction
    
    //===========================================================================
    private function StartInit takes nothing returns nothing
        local integer i 
        call CreateEventTrigger( "Event_HeroRepick_Real", function HeroRepick, null )
        call CreateEventTrigger( "Event_PlayerLeave_Real", function HeroLeave, null )
        //call CreateEventTrigger( "Event_HeroChoose_Real", function HeroChoose, null )
        
        call InitTable()
        
        set i = 1
        loop
            exitwhen i > PLAYERS_LIMIT
            set ChoosedHeroButton[i] = null
            set ChoosedHeroIcon[i] = ""
            set ChoosedHero[i] = ChoosedHeroTemplate.create()
            set i = i + 1
        endloop
    endfunction
    
    private function init takes nothing returns nothing
        call BlzLoadTOCFile("war3mapImported\\TextAreaTemplate.toc")
        call CreateEventTrigger( "Event_DatabaseLoaded", function StartInit, null )
    endfunction

endlibrary