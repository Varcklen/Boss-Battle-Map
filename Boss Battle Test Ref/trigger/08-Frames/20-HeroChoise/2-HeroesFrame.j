scope HeroChoose

    globals
        framehandle herobut
        framehandle banbut
        framehandle array herotool
        framehandle array herospell
        framehandle array hero1
        framehandle array hero2
        framehandle array hero3
        framehandle array hero4
        framehandle array hero5
        framehandle array hero6
        framehandle array hero7
        framehandle array hero8
        framehandle array hero9
        framehandle array hero1v
        framehandle array hero2v
        framehandle array hero3v
        framehandle array hero4v
        framehandle array hero5v
        framehandle array hero6v
        framehandle array hero7v
        framehandle array hero8v
        framehandle array hero9v
        framehandle array lvlic
        framehandle array lvltxt
        framehandle herohard
        framehandle heroavtor
        framehandle array herospellname
        framehandle array herospelltool
        framehandle butskin
        framehandle butskinv
        framehandle array butskin1
        framehandle array butskinv1
        framehandle array lockskin1
        framehandle array numskin1
        
        private framehandle AspectsParent = null 
        private framehandle array AspectVision[3]
        private framehandle array AspectButton[3]
        private constant real ASPECTS_SIZE = 0.025
        private constant real ASPECTS_INDENT = 0.005
        
        boolean array IsBanned[HEROES_COUNT_ARRAYS]
    endglobals
    
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
        endif
        
        set localPlayer = null
    endfunction 
    
    function IsFlying takes integer heroId returns boolean
        if heroId == 'N038' then
            return true
        elseif heroId == 'u002' then
            return true
        elseif heroId == 'N04J' then
            return true
        elseif heroId == 'N054' then
            return true
        elseif heroId == 'N05A' then
            return true
        elseif heroId == 'O01Y' then
            return true
        endif
        return false
    endfunction
    
    function HeroChooseButton takes nothing returns nothing
        local integer cyclA = 1
        local integer cyclAEnd
        local integer i = GetPlayerId( GetTriggerPlayer() ) + 1
        local boolean l = false
        local string text
        local integer k = 0
        local integer ab = 0
        local integer c = 0
        local integer uniq = 0
        local string icon = ""

        if GetLocalPlayer() == GetTriggerPlayer() then
            call BlzFrameSetVisible( BlzGetTriggerFrame(),false)
            call BlzFrameSetVisible( BlzGetTriggerFrame(),true)
        endif
        
        if hero1[0] == BlzGetTriggerFrame() then
            set udg_HeroChoose[i] = udg_DB_HeroFrame_Buffer[0]
            set l = true
        endif

        if not(l) then
            set cyclA = 1
            set cyclAEnd = udg_DB_HeroFrame_Number[1]
            loop
                exitwhen cyclA > cyclAEnd
                if BlzGetTriggerFrame() == hero1[cyclA] then
                    set udg_HeroChoose[i] = udg_DB_HeroFrame_Buffer[cyclA]
                    set icon = udg_DB_HeroFrame_Buffer_Icon[cyclA]
                    set l = true
                    set cyclA = cyclAEnd
                    set ab = 1
                endif
                set cyclA = cyclA + 1
            endloop
        endif

        if not(l) then
            set cyclA = 1
            set cyclAEnd = udg_DB_HeroFrame_Number[2]
            loop
                exitwhen cyclA > cyclAEnd
                if BlzGetTriggerFrame() == hero2[cyclA] then
                    set udg_HeroChoose[i] = udg_DB_HeroFrame_Deffender[cyclA]
                    set icon = udg_DB_HeroFrame_Deffender_Icon[cyclA]
                    set l = true
                    set cyclA = cyclAEnd
                    set ab = 2
                endif
                set cyclA = cyclA + 1
            endloop
        endif

        if not(l) then
            set cyclA = 1
            set cyclAEnd = udg_DB_HeroFrame_Number[3]
            loop
                exitwhen cyclA > cyclAEnd
                if BlzGetTriggerFrame() == hero3[cyclA] then
                    set udg_HeroChoose[i] = udg_DB_HeroFrame_Ripper[cyclA]
                    set icon = udg_DB_HeroFrame_Ripper_Icon[cyclA]
                    set l = true
                    set cyclA = cyclAEnd
                    set ab = 3
                endif
                set cyclA = cyclA + 1
            endloop
        endif
        if not(l) then
            set cyclA = 1
            set cyclAEnd = udg_DB_HeroFrame_Number[4]
            loop
                exitwhen cyclA > cyclAEnd
                if BlzGetTriggerFrame() == hero4[cyclA] then
                    set udg_HeroChoose[i] = udg_DB_HeroFrame_Hybrid[cyclA]
                    set icon = udg_DB_HeroFrame_Hybrid_Icon[cyclA]
                    set l = true
                    set uniq = udg_DB_HeroFrame_Uniques[cyclA]
                    set cyclA = cyclAEnd
                    set ab = 4
                endif
                set cyclA = cyclA + 1
            endloop
        endif
        if not(l) then
            set cyclA = 1
            set cyclAEnd = udg_DB_HeroFrame_Number[5]
            loop
                exitwhen cyclA > cyclAEnd
                if BlzGetTriggerFrame() == hero5[cyclA] then
                    set udg_HeroChoose[i] = udg_DB_HeroFrame_Maraduer[cyclA]
                    set icon = udg_DB_HeroFrame_Maraduer_Icon[cyclA]
                    set l = true
                    set cyclA = cyclAEnd
                    set ab = 5
                endif
                set cyclA = cyclA + 1
            endloop
        endif
        if not(l) then
            set cyclA = 1
            set cyclAEnd = udg_DB_HeroFrame_Number[6]
            loop
                exitwhen cyclA > cyclAEnd
                if BlzGetTriggerFrame() == hero6[cyclA] then
                    set udg_HeroChoose[i] = udg_DB_HeroFrame_Killer[cyclA]
                    set icon = udg_DB_HeroFrame_Killer_Icon[cyclA]
                    set l = true
                    set cyclA = cyclAEnd
                    set ab = 6
                endif
                set cyclA = cyclA + 1
            endloop
        endif
        if not(l) then
            set cyclA = 1
            set cyclAEnd = udg_DB_HeroFrame_Number[7]
            loop
                exitwhen cyclA > cyclAEnd
                if BlzGetTriggerFrame() == hero7[cyclA] then
                    set udg_HeroChoose[i] = udg_DB_HeroFrame_Elemental[cyclA]
                    set icon = udg_DB_HeroFrame_Elemental_Icon[cyclA]
                    set l = true
                    set cyclA = cyclAEnd
                    set ab = 7
                endif
                set cyclA = cyclA + 1
            endloop
        endif
        if not(l) then
            set cyclA = 1
            set cyclAEnd = udg_DB_HeroFrame_Number[8]
            loop
                exitwhen cyclA > cyclAEnd
                if BlzGetTriggerFrame() == hero8[cyclA] then
                    set udg_HeroChoose[i] = udg_DB_HeroFrame_Healer[cyclA]
                    set icon = udg_DB_HeroFrame_Healer_Icon[cyclA]
                    set l = true
                    set cyclA = cyclAEnd
                    set ab = 8
                endif
                set cyclA = cyclA + 1
            endloop
        endif
        if not(l) then
            set cyclA = 1
            set cyclAEnd = udg_DB_HeroFrame_Number[9]
            loop
                exitwhen cyclA > cyclAEnd
                if BlzGetTriggerFrame() == hero9[cyclA] then
                    set udg_HeroChoose[i] = udg_DB_HeroFrame_Debuffer[cyclA]
                    set icon = udg_DB_HeroFrame_Debuffer_Icon[cyclA]
                    set cyclA = cyclAEnd
                    set ab = 9
                endif
                set cyclA = cyclA + 1
            endloop
        endif

        set cyclA = 1
        set cyclAEnd = udg_Database_InfoNumberHeroes
        loop
            exitwhen cyclA > cyclAEnd
            if udg_Database_Hero[cyclA] == udg_HeroChoose[i] then
                set k = cyclA
                set cyclA = cyclAEnd
            endif
            set cyclA = cyclA + 1
        endloop
        
        if BlzGetUnitSkin(udg_HeroSpawn[i]) == udg_HeroChoose[i] then
            return
        endif
        
        call RemoveUnit( udg_HeroSpawn[i] )
        set udg_SkinUsed[i] = 0
        if IsFlying(udg_HeroChoose[i]) then
            set udg_HeroSpawn[i] = CreateUnit( Player(PLAYER_NEUTRAL_PASSIVE), udg_HeroChoose[i], GetLocationX(udg_point[25+i]), GetLocationY(udg_point[25+i]), bj_UNIT_FACING )
        else
            set udg_HeroSpawn[i] = CreateUnit( Player(PLAYER_NEUTRAL_PASSIVE), 'u000', GetLocationX(udg_point[25+i]), GetLocationY(udg_point[25+i]), bj_UNIT_FACING )
            call SetUnitSkin( udg_HeroSpawn[i], udg_HeroChoose[i] )
        endif
        set udg_HeroKey[i] = k
        set udg_HeroKeyPos[i] = ab
        set udg_HeroKeyIcon[i] = icon
        if ab == 1 or ab == 2 or ab == 3 then
            set c = 13
        elseif ab == 4 or ab == 5 or ab == 6 then
            set c = 23
        elseif ab == 7 or ab == 8 or ab == 9 then
            set c = 14
        endif
        call SetUnitColor( udg_HeroSpawn[i], GetPlayerColor(ConvertedPlayer(c) ) )
        call BlzShowUnitTeamGlow( udg_HeroSpawn[i], FALSE ) 
        call QueueUnitAnimationBJ( udg_HeroSpawn[i], "stand" )
        call QueueUnitAnimationBJ( udg_HeroSpawn[i], "attack" )
        call QueueUnitAnimationBJ( udg_HeroSpawn[i], "stand" )
        call SetUnitState( udg_HeroSpawn[i], UNIT_STATE_MANA, GetUnitState( udg_HeroSpawn[i], UNIT_STATE_MAX_MANA) )
        call FogModifierStart( udg_Visible[i] )

        call CameraSetupApplyForPlayer( true, udg_CameraChoose[i], Player(i-1), 0 )
        call SetCameraTargetControllerNoZForPlayer( Player(i-1), udg_HeroSpawn[i], 210.00, -150.00, false )

        if ab == 0 then
            if GetLocalPlayer() == GetTriggerPlayer() then
                call BlzFrameSetVisible( AspectsParent, false )
                call BlzFrameSetVisible( herospell[1], false )
                call BlzFrameSetVisible( herospell[2], false )
                call BlzFrameSetVisible( herospell[3], false )
                call BlzFrameSetVisible( herospell[4], false )
                call BlzFrameSetVisible( herospell[5], false )

                call BlzFrameSetText( heroavtor, "" )
                call BlzFrameSetText( herohard, "" )
            endif
        else
            if ab != 4 then
                set uniq = udg_DB_HeroFrame_Ability[ab]
            endif
            
            if Aspects_IsHeroIndexCanUseAspects(k) then
                if GetLocalPlayer() == GetTriggerPlayer() then
                    call BlzFrameSetVisible( AspectsParent, true )
                endif
                set cyclA = 1
                loop
                    exitwhen cyclA > ASPECT_LIMIT
                    call SetAspectButtons(GetTriggerPlayer(), cyclA, Aspect[k][cyclA])
                    set cyclA = cyclA + 1
                endloop
                //Set visible
            else
                if GetLocalPlayer() == GetTriggerPlayer() then
                    call BlzFrameSetVisible( AspectsParent, false )
                endif
            endif
            if GetLocalPlayer() == GetTriggerPlayer() then
                call BlzFrameSetTexture( herospell[1], BlzGetAbilityIcon( Database_Hero_Abilities[1][k] ),0, true)
                call BlzFrameSetTexture( herospell[2], BlzGetAbilityIcon( Database_Hero_Abilities[2][k] ),0, true)
                call BlzFrameSetTexture( herospell[3], BlzGetAbilityIcon( Database_Hero_Abilities[3][k]),0, true)
                call BlzFrameSetTexture( herospell[4], BlzGetAbilityIcon( Database_Hero_Abilities[4][k]),0, true)
                call BlzFrameSetTexture( herospell[5], BlzGetAbilityIcon( uniq ),0, true)
            
                call BlzFrameSetText(herospelltool[1], BlzGetAbilityResearchExtendedTooltip(Database_Hero_Abilities[1][k], 0) )
                call BlzFrameSetText(herospellname[1], BlzGetAbilityResearchTooltip(Database_Hero_Abilities[1][k], 0) )
                call BlzFrameSetSize(herotool[1], 0.33, StringSizeSmall(BlzGetAbilityResearchExtendedTooltip(Database_Hero_Abilities[1][k], 0)) )

                call BlzFrameSetText(herospelltool[2], BlzGetAbilityResearchExtendedTooltip(Database_Hero_Abilities[2][k], 0) )
                call BlzFrameSetText(herospellname[2], BlzGetAbilityResearchTooltip(Database_Hero_Abilities[2][k], 0) )
                call BlzFrameSetSize(herotool[2], 0.33, StringSizeSmall(BlzGetAbilityResearchExtendedTooltip(Database_Hero_Abilities[2][k], 0)))

                call BlzFrameSetText(herospelltool[3], BlzGetAbilityResearchExtendedTooltip(Database_Hero_Abilities[3][k], 0) )
                call BlzFrameSetText(herospellname[3], BlzGetAbilityResearchTooltip(Database_Hero_Abilities[3][k], 0) )
                call BlzFrameSetSize(herotool[3], 0.33, StringSizeSmall(BlzGetAbilityResearchExtendedTooltip(Database_Hero_Abilities[3][k], 0)))

                call BlzFrameSetText(herospelltool[4], BlzGetAbilityResearchExtendedTooltip(Database_Hero_Abilities[4][k], 0) )
                call BlzFrameSetText(herospellname[4], BlzGetAbilityResearchTooltip(Database_Hero_Abilities[4][k], 0) )
                call BlzFrameSetSize(herotool[4], 0.33, StringSizeSmall(BlzGetAbilityResearchExtendedTooltip(Database_Hero_Abilities[4][k], 0)))

                call BlzFrameSetText(herospelltool[5], BlzGetAbilityExtendedTooltip(uniq, 0))
                call BlzFrameSetText(herospellname[5], GetAbilityName(uniq) )
                call BlzFrameSetSize(herotool[5], 0.33, StringSizeSmall(BlzGetAbilityExtendedTooltip(uniq, 0)))
                
                call BlzFrameSetVisible( herospell[1], true )
                call BlzFrameSetVisible( herospell[2], true )
                call BlzFrameSetVisible( herospell[3], true )
                call BlzFrameSetVisible( herospell[4], true )
                call BlzFrameSetVisible( herospell[5], true )

                call BlzFrameSetText( heroavtor, udg_DB_Hero_Avtor[k] )
                call BlzFrameSetText( herohard, udg_DB_Hero_Hard[k] )
                
                call BlzFrameSetTexture( butskinv, icon,0, true)
            endif
            
            set cyclA = 1
            loop
                exitwhen cyclA > udg_DB_Skin_Limit
                if GetLocalPlayer() == GetTriggerPlayer() then
                    if skiniconBTN[k][cyclA] != null and StringLength(skiniconBTN[k][cyclA]) > 3 then
                        if BlzFrameIsVisible(butskinv1[1]) then
                            call BlzFrameSetVisible( butskin1[cyclA], true )
                        endif
                        call BlzFrameSetVisible( butskin, true )
                        if udg_LvL[i] < skinlvl[k][cyclA] then
                            call BlzFrameSetText( numskin1[cyclA], I2S(skinlvl[k][cyclA]) )
                            call BlzFrameSetTexture( butskinv1[cyclA], skiniconDIS[k][cyclA],0, true)
                            call BlzFrameSetVisible( lockskin1[cyclA], true )
                            call BlzFrameSetVisible( numskin1[cyclA], true )
                        else
                            call BlzFrameSetTexture( butskinv1[cyclA], skiniconBTN[k][cyclA],0, true)
                            call BlzFrameSetVisible( lockskin1[cyclA], false )
                            call BlzFrameSetVisible( numskin1[cyclA], false )
                        endif
                    else
                        if cyclA == 1 then
                            call BlzFrameSetVisible( butskin, false )
                        endif
                        call BlzFrameSetVisible( butskin1[cyclA], false )
                    endif
                endif
                set cyclA = cyclA + 1
            endloop
        endif
    endfunction
    
    private function IsCanChoosedManyTimes takes integer heroId returns boolean
        if heroId == udg_Database_Hero[31] then
            return true
        elseif heroId == udg_Database_Hero[34] then
            return true
        endif
        return false
    endfunction
    
    private function IsHeroCanBeChosen takes integer heroId, integer index, boolean isThisHeroExist returns boolean
        /*call BJDebugMsg("==================================" )
        call BJDebugMsg("index: " + I2S(index))*/
        if IsBanned[index] then
            //call BJDebugMsg("IsBanned")
            return false
        elseif heroId == 0 then
            return false
        elseif isThisHeroExist then
            return false
        elseif not(udg_UnitHeroLogic[index] == false or IsCanChoosedManyTimes(heroId) ) then
            /*if udg_UnitHeroLogic[index] then
                call BJDebugMsg("true")
            else
                call BJDebugMsg("false")
            endif
            call BJDebugMsg("udg_UnitHeroLogic[index] == false or IsCanChoosedManyTimes(heroId)")*/
            return false
        endif
    
        return true
    endfunction
    
    function HeroesButton takes nothing returns nothing
        local player pl = GetTriggerPlayer()
        local integer i = GetPlayerId( pl ) + 1
        local integer h = GetPlayerId( udg_Host ) + 1
        local integer k = udg_HeroKey[i]
        local integer cyclA = 1
        local boolean l = false

        /*loop
            exitwhen cyclA > 4
            if GetUnitTypeId( udg_hero[cyclA] ) == udg_HeroChoose[i] then
                set l = true
            endif
            set cyclA = cyclA + 1
        endloop*/
        if LoadInteger( udg_hash, i, StringHash( "randpick" ) ) >= 3 and udg_HeroChoose[i] == udg_DB_HeroFrame_Buffer[0] then
            set l = true
        endif
        /*if udg_UnitHeroLogic[k] then
            set l = true
        endif*/

        if IsHeroCanBeChosen( udg_HeroChoose[i], k, l ) then
            call RemoveUnit( udg_HeroSpawn[i] )
            call FogModifierStop( udg_Visible[i] )
            if GetLocalPlayer() == pl then
                call BlzFrameSetVisible( AspectsParent, false )
                call ResetToGameCameraForPlayer( pl, 0 )
                call BlzFrameSetVisible( butskin, false )
                call BlzFrameSetVisible( herobut, false )
                call BlzFrameSetVisible( banbut, false )
                if AnyHasLvL(2) then
                    call BlzFrameSetVisible( modesbut, true )
                    if pl == udg_Host then
                        call BlzFrameSetVisible( modeslight, true )
                    endif
                    if not(AnyHasLvL(10)) then
                        call BlzFrameSetVisible( modebase, false )
                        call BlzFrameSetVisible( rotbase, false )
                    endif
                endif
            endif
            set cyclA = 1
            loop
                exitwhen cyclA > udg_DB_Skin_Limit
                if GetLocalPlayer() == pl then
                    call BlzFrameSetVisible( butskin1[cyclA], false )
                endif
                set cyclA = cyclA + 1
            endloop
            if udg_HeroChoose[i] == udg_DB_HeroFrame_Buffer[0] then
                call RandomHero( pl )
            else
                call CreateUnit( pl, udg_HeroChoose[i], GetLocationX(GetRectCenter(gg_rct_HeroesTp)), GetLocationY(GetRectCenter(gg_rct_HeroesTp)), bj_UNIT_FACING )
            endif
            set udg_HeroChoose[i] = 0
        else
            if udg_HeroChoose[i] == udg_DB_HeroFrame_Buffer[0] then
                call DisplayTimedTextToPlayer( pl, 0, 0, 10, "Attempts exhausted." )
            else
                call DisplayTimedTextToPlayer( pl, 0, 0, 5, "This hero is not available. Please choose an another hero.")
            endif
        endif

        set pl = null
    endfunction

    function HeroFrameBonus takes nothing returns nothing
        local integer cyclA
        local integer rand

        set cyclA = 1
        loop
            exitwhen cyclA > 4
            set rand = GetRandomInt( 1, 9 )
            set udg_HeroBonusPotion[cyclA] = GetRandomInt( 1, udg_DB_HeroFrame_Number[rand] )
            set udg_HeroBonusPotionClass[cyclA] = rand
            set cyclA = cyclA + 1
        endloop
    endfunction

    function SkinButton takes nothing returns nothing
        local player p = GetTriggerPlayer()
        local integer i = GetPlayerId( p ) + 1
        local integer cyclA = 1
        local integer cyclAEnd
        local boolean l = false
        local integer k
        local integer cyclB

        set cyclA = 1
        set cyclAEnd = udg_Database_InfoNumberHeroes
        loop
            exitwhen cyclA > cyclAEnd or l
            if udg_HeroChoose[i] == udg_Database_Hero[cyclA] then
                set k = cyclA
                set l = true
            endif
            set cyclA = cyclA + 1
        endloop

        if butskin == BlzGetTriggerFrame() then
            set udg_SkinUsed[i] = 0
            set cyclA = 1
            loop
                exitwhen cyclA > udg_DB_Skin_Limit
                if BlzFrameIsVisible(butskinv1[cyclA]) then
                    call BlzSetUnitSkin( udg_HeroSpawn[i], udg_HeroChoose[i] )
                    if GetLocalPlayer() == p then
                        call BlzFrameSetVisible( butskin1[cyclA], false )
                    endif
                else
                    if GetLocalPlayer() == p then
                        if skiniconBTN[k][cyclA] != null then
                            call BlzFrameSetVisible( butskin1[cyclA], true )
                        endif
                    endif
                endif
                set cyclA = cyclA + 1
            endloop
        else
            set cyclB = 1
            loop
                exitwhen cyclB > udg_DB_Skin_Limit
                if butskin1[cyclB] == BlzGetTriggerFrame() then//[1]
                    if l and udg_LvL[i] >= skinlvl[k][cyclB] then//[1]
                        set udg_SkinUsed[i] = skinmodel[k][cyclB]//[1]
                        call BlzFrameSetTexture( faceframe[i], skiniconBTN[k][cyclB], 0, false)
                        call SetUnitSkin( udg_HeroSpawn[i], udg_SkinUsed[i] )
                        call BlzShowUnitTeamGlow( udg_HeroSpawn[i], FALSE ) 
                    else
                        set udg_SkinUsed[i] = 0
                    endif
                endif
                set cyclB = cyclB + 1
            endloop
        endif
        
        set p = null
    endfunction

    function HeroBan takes nothing returns nothing
        local player p = GetTriggerPlayer()
        local integer i = GetPlayerId( p ) + 1
        local integer k = udg_HeroKey[i]
        local integer ab = udg_HeroKeyPos[i]
        local integer cyclA
        local integer cyclAEnd
        local string str = ""

        if GetLocalPlayer() == p then
            call BlzFrameSetVisible( BlzGetTriggerFrame(),false)
            call BlzFrameSetVisible( BlzGetTriggerFrame(),true)
        endif
        
        if udg_HeroChoose[i] != 0 and udg_HeroChoose[i] != udg_DB_HeroFrame_Buffer[0] then
            set cyclA = 1
            loop
                exitwhen cyclA > 4
                if GetUnitTypeId(udg_hero[cyclA]) == udg_HeroChoose[i] then
                    call Repick( Player(cyclA-1) )
                    call DisplayTimedTextToPlayer(Player(cyclA-1), 0, 0, 10, "The host has banned this hero.")
                endif
                set cyclA = cyclA + 1
            endloop
            if IsBanned[k] then
                set IsBanned[k] = false
                set str = udg_HeroKeyIcon[i]
                set udg_BanLimit = udg_BanLimit + 1
            elseif udg_BanLimit > 0 then
                set IsBanned[k] = true
                set str = "war3mapImported\\BTNban.blp"
                set udg_BanLimit = udg_BanLimit - 1
            else
                call DisplayTimedTextToPlayer( p, 0, 0, 10, "The limit of banned heroes has been exceeded. Unban the hero to continue." )
            endif
            
            if str != "" then
                if ab == 1 then
                    set cyclA = 1
                    set cyclAEnd = udg_DB_HeroFrame_Number[1]
                    loop
                        exitwhen cyclA > cyclAEnd
                        if udg_DB_HeroFrame_Buffer[cyclA] == udg_HeroChoose[i] then
                            call BlzFrameSetTexture( hero1v[cyclA], str,0, true)
                            set cyclA = cyclAEnd
                        endif
                        set cyclA = cyclA + 1
                    endloop
                endif

                if ab == 2 then
                    set cyclA = 1
                    set cyclAEnd = udg_DB_HeroFrame_Number[2]
                    loop
                        exitwhen cyclA > cyclAEnd
                        if udg_DB_HeroFrame_Deffender[cyclA] == udg_HeroChoose[i] then
                            call BlzFrameSetTexture( hero2v[cyclA], str,0, true)
                            set cyclA = cyclAEnd
                        endif
                        set cyclA = cyclA + 1
                    endloop
                endif
                
                if ab == 3 then
                    set cyclA = 1
                    set cyclAEnd = udg_DB_HeroFrame_Number[3]
                    loop
                        exitwhen cyclA > cyclAEnd
                        if udg_DB_HeroFrame_Ripper[cyclA] == udg_HeroChoose[i] then
                            call BlzFrameSetTexture( hero3v[cyclA], str,0, true)
                            set cyclA = cyclAEnd
                        endif
                        set cyclA = cyclA + 1
                    endloop
                endif
                
                if ab == 4 then
                    set cyclA = 1
                    set cyclAEnd = udg_DB_HeroFrame_Number[4]
                    loop
                        exitwhen cyclA > cyclAEnd
                        if udg_DB_HeroFrame_Hybrid[cyclA] == udg_HeroChoose[i] then
                            call BlzFrameSetTexture( hero4v[cyclA], str,0, true)
                            set cyclA = cyclAEnd
                        endif
                        set cyclA = cyclA + 1
                    endloop
                endif
                
                if ab == 5 then
                    set cyclA = 1
                    set cyclAEnd = udg_DB_HeroFrame_Number[5]
                    loop
                        exitwhen cyclA > cyclAEnd
                        if udg_DB_HeroFrame_Maraduer[cyclA] == udg_HeroChoose[i] then
                            call BlzFrameSetTexture( hero5v[cyclA], str,0, true)
                            set cyclA = cyclAEnd
                        endif
                        set cyclA = cyclA + 1
                    endloop
                endif
                
                if ab == 6 then
                    set cyclA = 1
                    set cyclAEnd = udg_DB_HeroFrame_Number[6]
                    loop
                        exitwhen cyclA > cyclAEnd
                        if udg_DB_HeroFrame_Killer[cyclA] == udg_HeroChoose[i] then
                            call BlzFrameSetTexture( hero6v[cyclA], str,0, true)
                            set cyclA = cyclAEnd
                        endif
                        set cyclA = cyclA + 1
                    endloop
                endif
                
                if ab == 7 then
                    set cyclA = 1
                    set cyclAEnd = udg_DB_HeroFrame_Number[7]
                    loop
                        exitwhen cyclA > cyclAEnd
                        if udg_DB_HeroFrame_Elemental[cyclA] == udg_HeroChoose[i] then
                            call BlzFrameSetTexture( hero7v[cyclA], str,0, true)
                            set cyclA = cyclAEnd
                        endif
                        set cyclA = cyclA + 1
                    endloop
                endif
                
                if ab == 8 then
                    set cyclA = 1
                    set cyclAEnd = udg_DB_HeroFrame_Number[8]
                    loop
                        exitwhen cyclA > cyclAEnd
                        if udg_DB_HeroFrame_Healer[cyclA] == udg_HeroChoose[i] then
                            call BlzFrameSetTexture( hero8v[cyclA], str,0, true)
                            set cyclA = cyclAEnd
                        endif
                        set cyclA = cyclA + 1
                    endloop
                endif
                
                if ab == 9 then
                    set cyclA = 1
                    set cyclAEnd = udg_DB_HeroFrame_Number[9]
                    loop
                        exitwhen cyclA > cyclAEnd
                        if udg_DB_HeroFrame_Debuffer[cyclA] == udg_HeroChoose[i] then
                            call BlzFrameSetTexture( hero9v[cyclA], str,0, true)
                            set cyclA = cyclAEnd
                        endif
                        set cyclA = cyclA + 1
                    endloop
                endif
            endif
        endif
        
        set p = null
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

    function Trig_HeroesFrame_Actions takes nothing returns nothing
        local trigger trig
        local trigger trigclass = CreateTrigger()
        local trigger trigskin = CreateTrigger()
        local framehandle herofon
        local framehandle buttool
        local framehandle class
        local framehandle namefon
        local framehandle newframe
        local framehandle array newfrtrg
        local framehandle array potion
        local integer cyclA = 1
        local integer cyclAEnd
        local integer cyclB
        local real size = 0.032
        local real xpos = 0.66
        
        set newfrtrg[1] = null
        set newfrtrg[2] = null
        
        call HeroFrameBonus()

        set herobut = BlzCreateFrame("ScriptDialogButton", BlzGetOriginFrame(ORIGIN_FRAME_GAME_UI, 0), 0,0) 
        call BlzFrameSetSize(herobut, 0.07,0.04)
        call BlzFrameSetAbsPoint(herobut, FRAMEPOINT_CENTER, 0.18,0.185)
        call BlzFrameSetText(herobut, "Choose")
        call BlzFrameSetLevel( herobut, -1 )
        call BlzFrameSetVisible( herobut, false )
        
        set trig = CreateTrigger()
        call BlzTriggerRegisterFrameEvent(trig, herobut, FRAMEEVENT_CONTROL_CLICK)
        call TriggerAddAction(trig, function HeroesButton)
        
        set banbut = BlzCreateFrame("ScriptDialogButton", herobut, 0,0) 
        call BlzFrameSetSize(banbut, 0.04,0.04)
        call BlzFrameSetAbsPoint(banbut, FRAMEPOINT_CENTER, 0.06,0.185)
        call BlzFrameSetText(banbut, "Ban")
        call BlzFrameSetVisible( banbut, false )
        
        set trig = CreateTrigger()
        call BlzTriggerRegisterFrameEvent(trig, banbut, FRAMEEVENT_CONTROL_CLICK)
        call TriggerAddAction(trig, function HeroBan)

        set herofon = BlzCreateFrame("EscMenuBackdrop", herobut, 0, 0)
        call BlzFrameSetAbsPoint(herofon, FRAMEPOINT_CENTER, 0.398, 0.16)
        call BlzFrameSetSize(herofon, 0.3, 0.075)

        set namefon = BlzCreateFrame("QuestButtonBaseTemplate", herobut, 0, 0)
        call BlzFrameSetAbsPoint(namefon, FRAMEPOINT_CENTER, 0.458, 0.205)
        call BlzFrameSetSize(namefon, 0.15, 0.05)
        call BlzFrameSetLevel( namefon, -2 )

        set herohard = BlzCreateFrameByType("TEXT", "", namefon, "StandartFrameTemplate", 0)
        call BlzFrameSetSize( herohard, 0.2, 0.04 )
        call BlzFrameSetPoint( herohard, FRAMEPOINT_TOPLEFT, namefon, FRAMEPOINT_TOPLEFT, 0.01,-0.01) 
        call BlzFrameSetText( herohard, "" )

        set heroavtor = BlzCreateFrameByType("TEXT", "", namefon, "StandartFrameTemplate", 0)
        call BlzFrameSetSize( heroavtor, 0.2, 0.04 )
        call BlzFrameSetPoint( heroavtor, FRAMEPOINT_TOPLEFT, namefon, FRAMEPOINT_TOPLEFT, 0.01,-0.02) 
        call BlzFrameSetText( heroavtor, "" )
        
        //skins
        set butskin = BlzCreateFrameByType("GLUEBUTTON", "", herobut, "ScoreScreenTabButtonTemplate", 0)
        call BlzFrameSetAbsPoint(butskin, FRAMEPOINT_CENTER, 0.02,0.2)	
        call BlzFrameSetSize(butskin, 0.035, 0.035)
        call BlzFrameSetVisible( butskin, false )
        
        call TriggerAddAction(trigskin, function SkinButton)
        call BlzTriggerRegisterFrameEvent(trigskin, butskin, FRAMEEVENT_CONTROL_CLICK)

        set butskinv = BlzCreateFrameByType("BACKDROP", "", butskin, "StandartFrameTemplate", 0)
        call BlzFrameSetAllPoints(butskinv,butskin )
        call BlzFrameSetTexture( butskinv, "",0, true)
        
        set namefon = BlzCreateFrame( "QuestButtonBaseTemplate", butskin, 0, 0 )
        call BlzFrameSetAbsPoint(namefon, FRAMEPOINT_CENTER, 0.02, 0.17)
        call BlzFrameSetSize( namefon, 0.04, 0.03 )

        set newframe = BlzCreateFrameByType("TEXT", "",  namefon, "StandartFrameTemplate", 0)
        call BlzFrameSetPoint( newframe, FRAMEPOINT_CENTER, namefon, FRAMEPOINT_CENTER, 0.007, -0.005) 
        call BlzFrameSetSize(newframe, 0.04, 0.02)
        call BlzFrameSetText( newframe, "skins" )
        
        set cyclA = 1
        loop
            exitwhen cyclA > udg_DB_Skin_Limit
            set butskin1[cyclA] = BlzCreateFrameByType("GLUEBUTTON", "", butskin, "ScoreScreenTabButtonTemplate", 0)
            call BlzFrameSetAbsPoint(butskin1[cyclA], FRAMEPOINT_CENTER, 0.02,0.2+(0.03*cyclA))	
            call BlzFrameSetSize(butskin1[cyclA], 0.03, 0.03)
            call BlzFrameSetVisible( butskin1[cyclA], false )
            call BlzTriggerRegisterFrameEvent(trigskin, butskin1[cyclA], FRAMEEVENT_CONTROL_CLICK)
            call BlzFrameSetLevel( butskin1[cyclA], -1 )

            set butskinv1[cyclA] = BlzCreateFrameByType("BACKDROP", "", butskin1[cyclA], "StandartFrameTemplate", 0)
            call BlzFrameSetAllPoints(butskinv1[cyclA],butskin1[cyclA] )
            call BlzFrameSetTexture( butskinv1[cyclA], "",0, true)
            
            set lockskin1[cyclA] = BlzCreateFrameByType("BACKDROP", "", butskin1[cyclA], "StandartFrameTemplate", 0)
            call BlzFrameSetSize( lockskin1[cyclA], 0.015, 0.015 )
            call BlzFrameSetPoint( lockskin1[cyclA], FRAMEPOINT_CENTER, butskin1[cyclA], FRAMEPOINT_CENTER, 0,0) 
            call BlzFrameSetTexture( lockskin1[cyclA], "framelock.blp",0, true)
            
            set numskin1[cyclA] = BlzCreateFrameByType("TEXT", "", butskin1[cyclA], "StandartFrameTemplate", 0)
            call BlzFrameSetSize( numskin1[cyclA], 0.01, 0.01 )
            call BlzFrameSetPoint( numskin1[cyclA], FRAMEPOINT_CENTER, butskin1[cyclA], FRAMEPOINT_CENTER, 0.002,-0.005) 
            set cyclA = cyclA + 1
        endloop
        
        
        set cyclA = 1
        loop
            exitwhen cyclA > 5
            set herospell[cyclA] = BlzCreateFrameByType("BACKDROP", "", herobut, "", 0)
            set buttool = BlzCreateFrameByType("FRAME", "", herospell[cyclA],"", 0)
            set herotool[cyclA] = BlzCreateFrame( "QuestButtonBaseTemplate", herospell[cyclA], 0, 0 )//BlzCreateFrameByType("QuestButtonBaseTemplate", "", herospell[cyclA], "StandartFrameTemplate", 0)
            set herospellname[cyclA] = BlzCreateFrameByType("TEXT", "", herotool[cyclA], "StandartFrameTemplate", 0)
            set herospelltool[cyclA] = BlzCreateFrameByType("TEXT", "", herotool[cyclA], "StandartFrameTemplate", 0)
             
            call BlzFrameSetPoint( herospellname[cyclA], FRAMEPOINT_TOPLEFT, herotool[cyclA], FRAMEPOINT_TOPLEFT, 0.005,-0.01) 
            call BlzFrameSetLevel( herospellname[cyclA], 1 )
            call BlzFrameSetSize(herospellname[cyclA], 0.3, 0.6)

            call BlzFrameSetPoint( herospelltool[cyclA], FRAMEPOINT_TOPLEFT, herotool[cyclA], FRAMEPOINT_TOPLEFT, 0.005,-0.025) 
            call BlzFrameSetLevel( herospelltool[cyclA], 1 )
            call BlzFrameSetSize(herospelltool[cyclA], 0.3, 0.6)

            call BlzFrameSetAllPoints(buttool, herospell[cyclA])
            call BlzFrameSetTooltip(buttool, herotool[cyclA])
        
            call BlzFrameSetSize(herospell[cyclA], 0.04, 0.04)
            if cyclA == 5 then
                call BlzFrameSetPoint( herospell[cyclA], FRAMEPOINT_CENTER, herofon, FRAMEPOINT_CENTER, 0.04*(cyclA-3)+0.02, 0 )
            else
                call BlzFrameSetPoint( herospell[cyclA], FRAMEPOINT_CENTER, herofon, FRAMEPOINT_CENTER, 0.04*(cyclA-3), 0 )
            endif
            call BlzFrameSetSize(herotool[cyclA], 0.33, 0.06)
            call BlzFrameSetAbsPoint(herotool[cyclA], FRAMEPOINT_BOTTOM, 0.7, 0.16)

            call BlzFrameSetTexture( herospell[cyclA], "war3mapImported\\PASfeed-icon-red-1_result.blp",0, true)
            call BlzFrameSetVisible( herospell[cyclA], false )
            set cyclA = cyclA + 1
        endloop

        set cyclA = 1
        loop
            exitwhen cyclA > 9
            set class = BlzCreateFrameByType("BACKDROP", "", herobut, "", 0)
            set buttool = BlzCreateFrameByType("FRAME", "", herobut,"", 0)
            
            call BlzFrameSetAllPoints(buttool, class)
        
            call BlzFrameSetSize(class, size, size)
            call BlzFrameSetAbsPoint(class, FRAMEPOINT_CENTER, (xpos+size)-(size*cyclA),0.5+size)

            call SetStableTool( buttool, udg_DB_HeroesFrame_Name[cyclA], udg_DB_HeroesFrame_Tooltip[cyclA] )

            call BlzFrameSetTexture( class, udg_DB_HeroesFrame_Icon[cyclA],0, true)
            set cyclA = cyclA + 1
        endloop

        call TriggerAddAction(trigclass, function HeroChooseButton)

        set hero1[0] = BlzCreateFrameByType("GLUEBUTTON", "", herobut, "ScoreScreenTabButtonTemplate", 0)
        call BlzFrameSetAbsPoint(hero1[0], FRAMEPOINT_CENTER, (xpos+size)-(size*10),0.5+size)	
        call BlzFrameSetSize(hero1[0], size, size)

        set buttool = BlzCreateFrameByType("BACKDROP", "", hero1[0], "StandartFrameTemplate", 0)
        call BlzFrameSetAllPoints(buttool,hero1[0] )
        
        call BlzTriggerRegisterFrameEvent(trigclass, hero1[0], FRAMEEVENT_CONTROL_CLICK)
        call BlzFrameSetTexture( buttool, "war3mapImported\\PASBTNSelectHeroOn.blp",0, true)

        set cyclA = 1
        loop
            exitwhen cyclA > 4
            set lvlic[cyclA] = BlzCreateFrameByType("BACKDROP", "", herobut, "", 0)
            call BlzFrameSetAbsPoint(lvlic[cyclA], FRAMEPOINT_CENTER, 0.57+(cyclA*0.03), 0.2)	
            call BlzFrameSetSize(lvlic[cyclA], 0.03, 0.03)
            
            if GetPlayerSlotState( Player( cyclA - 1 ) ) == PLAYER_SLOT_STATE_PLAYING then
                call BlzFrameSetTexture(lvlic[cyclA], "ReplaceableTextures\\CommandButtons\\BTNSelectHeroOn.blp", 0, true)
            else
                call BlzFrameSetTexture(lvlic[cyclA], "war3mapImported\\BTNDivineShieldOff-Reforged.blp", 0, true)
                call BlzFrameSetVisible( lvltxt[cyclA], false )
            endif
            
            set newframe = BlzCreateFrameByType("BACKDROP", "", herobut, "", 0)
            call BlzFrameSetPoint( newframe, FRAMEPOINT_CENTER, lvlic[cyclA], FRAMEPOINT_CENTER, 0,-0.025) 	
            call BlzFrameSetSize(newframe, 0.02, 0.02)
            call BlzFrameSetTexture( newframe, "war3mapImported\\BTNfeed-icon-red-1_result.blp",0, true)
            
            set lvltxt[cyclA] = BlzCreateFrameByType("TEXT", "", herobut, "StandartFrameTemplate", 0)
            call BlzFrameSetSize( lvltxt[cyclA], 0.01, 0.01 )
            //call BlzFrameSetAbsPoint(lvltxt[cyclA], FRAMEPOINT_RIGHT, 0.587+(cyclA*0.03), 0.2) 
            call BlzFrameSetPoint( lvltxt[cyclA], FRAMEPOINT_CENTER, newframe, FRAMEPOINT_CENTER, 0, 0) 
            set cyclA = cyclA + 1
        endloop

        set cyclA = 1
        set cyclAEnd = udg_DB_HeroFrame_Number[1]
        loop
            exitwhen cyclA > cyclAEnd
            set hero1[cyclA] = BlzCreateFrameByType("GLUEBUTTON", "", herobut, "ScoreScreenTabButtonTemplate", 0)
            call BlzFrameSetAbsPoint(hero1[cyclA], FRAMEPOINT_CENTER, (xpos+size)-(size*1),(0.5+size)-(size*cyclA))	
            call BlzFrameSetSize(hero1[cyclA], size, size)

            set hero1v[cyclA] = BlzCreateFrameByType("BACKDROP", "", hero1[cyclA], "StandartFrameTemplate", 0)
            call BlzFrameSetAllPoints(hero1v[cyclA],hero1[cyclA] )
        
            call BlzTriggerRegisterFrameEvent(trigclass, hero1[cyclA], FRAMEEVENT_CONTROL_CLICK)
            call BlzFrameSetTexture( hero1v[cyclA], udg_DB_HeroFrame_Buffer_Icon[cyclA],0, true)

            if udg_DB_HeroFrame_Buffer[cyclA] == udg_Database_Hero[udg_Database_InfoNumberHeroes] then
                set newfrtrg[1] = hero1[cyclA]
            elseif udg_DB_HeroFrame_Buffer[cyclA] == udg_Database_Hero[udg_Database_InfoNumberHeroes-1] then
                set newfrtrg[2] = hero1[cyclA]
            endif
            
            set cyclB = 1
            loop
                exitwhen cyclB > 4
                if udg_HeroBonusPotion[cyclB] == cyclA and udg_HeroBonusPotionClass[cyclB] == 1 then
                    set potion[cyclB] = hero1[cyclA]
                    set udg_HeroBonusPotionHero[cyclB] = udg_DB_HeroFrame_Buffer[cyclA]
                endif
                set cyclB = cyclB + 1
            endloop
            set cyclA = cyclA + 1
        endloop

        set cyclA = 1
        set cyclAEnd = udg_DB_HeroFrame_Number[2]
        loop
            exitwhen cyclA > cyclAEnd
            set hero2[cyclA] = BlzCreateFrameByType("GLUEBUTTON", "", herobut, "ScoreScreenTabButtonTemplate", 0)
            call BlzFrameSetAbsPoint(hero2[cyclA], FRAMEPOINT_CENTER, (xpos+size)-(size*2),(0.5+size)-(size*cyclA))	
            call BlzFrameSetSize(hero2[cyclA], size, size)

            set hero2v[cyclA] = BlzCreateFrameByType("BACKDROP", "", hero2[cyclA], "StandartFrameTemplate", 0)
            call BlzFrameSetAllPoints(hero2v[cyclA],hero2[cyclA] )
        
            call BlzTriggerRegisterFrameEvent(trigclass, hero2[cyclA], FRAMEEVENT_CONTROL_CLICK)
            call BlzFrameSetTexture( hero2v[cyclA], udg_DB_HeroFrame_Deffender_Icon[cyclA],0, true)

            if udg_DB_HeroFrame_Deffender[cyclA] == udg_Database_Hero[udg_Database_InfoNumberHeroes] then
                set newfrtrg[1] = hero2[cyclA]
            elseif udg_DB_HeroFrame_Deffender[cyclA] == udg_Database_Hero[udg_Database_InfoNumberHeroes-1] then
                set newfrtrg[2] = hero2[cyclA]
            endif
            
            set cyclB = 1
            loop
                exitwhen cyclB > 4
                if udg_HeroBonusPotion[cyclB] == cyclA and udg_HeroBonusPotionClass[cyclB] == 2 then
                    set potion[cyclB] = hero2[cyclA]
                    set udg_HeroBonusPotionHero[cyclB] = udg_DB_HeroFrame_Deffender[cyclA]
                endif
                set cyclB = cyclB + 1
            endloop
            set cyclA = cyclA + 1
        endloop

        set cyclA = 1
        set cyclAEnd = udg_DB_HeroFrame_Number[3]
        loop
            exitwhen cyclA > cyclAEnd
            set hero3[cyclA] = BlzCreateFrameByType("GLUEBUTTON", "", herobut, "ScoreScreenTabButtonTemplate", 0)
            call BlzFrameSetAbsPoint(hero3[cyclA], FRAMEPOINT_CENTER, (xpos+size)-(size*3),(0.5+size)-(size*cyclA))	
            call BlzFrameSetSize(hero3[cyclA], size, size)

            set hero3v[cyclA] = BlzCreateFrameByType("BACKDROP", "", hero3[cyclA], "StandartFrameTemplate", 0)
            call BlzFrameSetAllPoints(hero3v[cyclA],hero3[cyclA] )
        
            call BlzTriggerRegisterFrameEvent(trigclass, hero3[cyclA], FRAMEEVENT_CONTROL_CLICK)
            call BlzFrameSetTexture( hero3v[cyclA], udg_DB_HeroFrame_Ripper_Icon[cyclA],0, true)

            if udg_DB_HeroFrame_Ripper[cyclA] == udg_Database_Hero[udg_Database_InfoNumberHeroes] then
                set newfrtrg[1] = hero3[cyclA]
            elseif udg_DB_HeroFrame_Ripper[cyclA] == udg_Database_Hero[udg_Database_InfoNumberHeroes-1] then
                set newfrtrg[2] = hero3[cyclA]
            endif
            
            set cyclB = 1
            loop
                exitwhen cyclB > 4
                if udg_HeroBonusPotion[cyclB] == cyclA and udg_HeroBonusPotionClass[cyclB] == 3 then
                    set potion[cyclB] = hero3[cyclA]
                    set udg_HeroBonusPotionHero[cyclB] = udg_DB_HeroFrame_Ripper[cyclA]
                endif
                set cyclB = cyclB + 1
            endloop
            set cyclA = cyclA + 1
        endloop

        set cyclA = 1
        set cyclAEnd = udg_DB_HeroFrame_Number[4]
        loop
            exitwhen cyclA > cyclAEnd
            set hero4[cyclA] = BlzCreateFrameByType("GLUEBUTTON", "", herobut, "ScoreScreenTabButtonTemplate", 0)
            call BlzFrameSetAbsPoint(hero4[cyclA], FRAMEPOINT_CENTER, (xpos+size)-(size*4),(0.5+size)-(size*cyclA))	
            call BlzFrameSetSize(hero4[cyclA], size, size)

            set hero4v[cyclA] = BlzCreateFrameByType("BACKDROP", "", hero4[cyclA], "StandartFrameTemplate", 0)
            call BlzFrameSetAllPoints(hero4v[cyclA],hero4[cyclA] )
        
            call BlzTriggerRegisterFrameEvent(trigclass, hero4[cyclA], FRAMEEVENT_CONTROL_CLICK)
            call BlzFrameSetTexture( hero4v[cyclA], udg_DB_HeroFrame_Hybrid_Icon[cyclA],0, true)

            if udg_DB_HeroFrame_Hybrid[cyclA] == udg_Database_Hero[udg_Database_InfoNumberHeroes] then
                set newfrtrg[1] = hero4[cyclA]
            elseif udg_DB_HeroFrame_Hybrid[cyclA] == udg_Database_Hero[udg_Database_InfoNumberHeroes-1] then
                set newfrtrg[2] = hero4[cyclA]
            endif
            
            set cyclB = 1
            loop
                exitwhen cyclB > 4
                if udg_HeroBonusPotion[cyclB] == cyclA and udg_HeroBonusPotionClass[cyclB] == 4 then
                    set potion[cyclB] = hero4[cyclA]
                    set udg_HeroBonusPotionHero[cyclB] = udg_DB_HeroFrame_Hybrid[cyclA]
                endif
                set cyclB = cyclB + 1
            endloop
            set cyclA = cyclA + 1
        endloop

        set cyclA = 1
        set cyclAEnd = udg_DB_HeroFrame_Number[5]
        loop
            exitwhen cyclA > cyclAEnd
            set hero5[cyclA] = BlzCreateFrameByType("GLUEBUTTON", "", herobut, "ScoreScreenTabButtonTemplate", 0)
            call BlzFrameSetAbsPoint(hero5[cyclA], FRAMEPOINT_CENTER, (xpos+size)-(size*5),(0.5+size)-(size*cyclA))	
            call BlzFrameSetSize(hero5[cyclA], size, size)

            set hero5v[cyclA] = BlzCreateFrameByType("BACKDROP", "", hero5[cyclA], "StandartFrameTemplate", 0)
            call BlzFrameSetAllPoints(hero5v[cyclA],hero5[cyclA] )
        
            call BlzTriggerRegisterFrameEvent(trigclass, hero5[cyclA], FRAMEEVENT_CONTROL_CLICK)
            call BlzFrameSetTexture( hero5v[cyclA], udg_DB_HeroFrame_Maraduer_Icon[cyclA],0, true)

            if udg_DB_HeroFrame_Maraduer[cyclA] == udg_Database_Hero[udg_Database_InfoNumberHeroes] then
                set newfrtrg[1] = hero5[cyclA]
            elseif udg_DB_HeroFrame_Maraduer[cyclA] == udg_Database_Hero[udg_Database_InfoNumberHeroes-1] then
                set newfrtrg[2] = hero5[cyclA]
            endif
            
            set cyclB = 1
            loop
                exitwhen cyclB > 4
                if udg_HeroBonusPotion[cyclB] == cyclA and udg_HeroBonusPotionClass[cyclB] == 5 then
                    set potion[cyclB] = hero5[cyclA]
                    set udg_HeroBonusPotionHero[cyclB] = udg_DB_HeroFrame_Maraduer[cyclA]
                endif
                set cyclB = cyclB + 1
            endloop
            set cyclA = cyclA + 1
        endloop
        
        set cyclA = 1
        set cyclAEnd = udg_DB_HeroFrame_Number[6]
        loop
            exitwhen cyclA > cyclAEnd
            set hero6[cyclA] = BlzCreateFrameByType("GLUEBUTTON", "", herobut, "ScoreScreenTabButtonTemplate", 0)
            call BlzFrameSetAbsPoint(hero6[cyclA], FRAMEPOINT_CENTER, (xpos+size)-(size*6),(0.5+size)-(size*cyclA))	
            call BlzFrameSetSize(hero6[cyclA], size, size)

            set hero6v[cyclA] = BlzCreateFrameByType("BACKDROP", "", hero6[cyclA], "StandartFrameTemplate", 0)
            call BlzFrameSetAllPoints(hero6v[cyclA],hero6[cyclA] )
        
            call BlzTriggerRegisterFrameEvent(trigclass, hero6[cyclA], FRAMEEVENT_CONTROL_CLICK)
            call BlzFrameSetTexture( hero6v[cyclA], udg_DB_HeroFrame_Killer_Icon[cyclA],0, true)

            if udg_DB_HeroFrame_Killer[cyclA] == udg_Database_Hero[udg_Database_InfoNumberHeroes] then
                set newfrtrg[1] = hero6[cyclA]
            elseif udg_DB_HeroFrame_Killer[cyclA] == udg_Database_Hero[udg_Database_InfoNumberHeroes-1] then
                set newfrtrg[2] = hero6[cyclA]
            endif
            
            set cyclB = 1
            loop
                exitwhen cyclB > 4
                if udg_HeroBonusPotion[cyclB] == cyclA and udg_HeroBonusPotionClass[cyclB] == 6 then
                    set potion[cyclB] = hero6[cyclA]
                    set udg_HeroBonusPotionHero[cyclB] = udg_DB_HeroFrame_Killer[cyclA]
                endif
                set cyclB = cyclB + 1
            endloop
            set cyclA = cyclA + 1
        endloop
        
        set cyclA = 1
        set cyclAEnd = udg_DB_HeroFrame_Number[7]
        loop
            exitwhen cyclA > cyclAEnd
            set hero7[cyclA] = BlzCreateFrameByType("GLUEBUTTON", "", herobut, "ScoreScreenTabButtonTemplate", 0)
            call BlzFrameSetAbsPoint(hero7[cyclA], FRAMEPOINT_CENTER, (xpos+size)-(size*7),(0.5+size)-(size*cyclA))	
            call BlzFrameSetSize(hero7[cyclA], size, size)

            set hero7v[cyclA] = BlzCreateFrameByType("BACKDROP", "", hero7[cyclA], "StandartFrameTemplate", 0)
            call BlzFrameSetAllPoints(hero7v[cyclA],hero7[cyclA] )
        
            call BlzTriggerRegisterFrameEvent(trigclass, hero7[cyclA], FRAMEEVENT_CONTROL_CLICK)
            call BlzFrameSetTexture( hero7v[cyclA], udg_DB_HeroFrame_Elemental_Icon[cyclA],0, true)

            if udg_DB_HeroFrame_Elemental[cyclA] == udg_Database_Hero[udg_Database_InfoNumberHeroes] then
                set newfrtrg[1] = hero7[cyclA]
            elseif udg_DB_HeroFrame_Elemental[cyclA] == udg_Database_Hero[udg_Database_InfoNumberHeroes-1] then
                set newfrtrg[2] = hero7[cyclA]
            endif
            
            set cyclB = 1
            loop
                exitwhen cyclB > 4
                if udg_HeroBonusPotion[cyclB] == cyclA and udg_HeroBonusPotionClass[cyclB] == 7 then
                    set potion[cyclB] = hero7[cyclA]
                    set udg_HeroBonusPotionHero[cyclB] = udg_DB_HeroFrame_Elemental[cyclA]
                endif
                set cyclB = cyclB + 1
            endloop
            set cyclA = cyclA + 1
        endloop
        
        set cyclA = 1
        set cyclAEnd = udg_DB_HeroFrame_Number[8]
        loop
            exitwhen cyclA > cyclAEnd
            set hero8[cyclA] = BlzCreateFrameByType("GLUEBUTTON", "", herobut, "ScoreScreenTabButtonTemplate", 0)
            call BlzFrameSetAbsPoint(hero8[cyclA], FRAMEPOINT_CENTER, (xpos+size)-(size*8),(0.5+size)-(size*cyclA))	
            call BlzFrameSetSize(hero8[cyclA], size, size)

            set hero8v[cyclA] = BlzCreateFrameByType("BACKDROP", "", hero8[cyclA], "StandartFrameTemplate", 0)
            call BlzFrameSetAllPoints(hero8v[cyclA],hero8[cyclA] )
        
            call BlzTriggerRegisterFrameEvent(trigclass, hero8[cyclA], FRAMEEVENT_CONTROL_CLICK)
            call BlzFrameSetTexture( hero8v[cyclA], udg_DB_HeroFrame_Healer_Icon[cyclA],0, true)

            if udg_DB_HeroFrame_Healer[cyclA] == udg_Database_Hero[udg_Database_InfoNumberHeroes] then
                set newfrtrg[1] = hero8[cyclA]
            elseif udg_DB_HeroFrame_Healer[cyclA] == udg_Database_Hero[udg_Database_InfoNumberHeroes-1] then
                set newfrtrg[2] = hero8[cyclA]
            endif
            
            set cyclB = 1
            loop
                exitwhen cyclB > 4
                if udg_HeroBonusPotion[cyclB] == cyclA and udg_HeroBonusPotionClass[cyclB] == 8 then
                    set potion[cyclB] = hero8[cyclA]
                    set udg_HeroBonusPotionHero[cyclB] = udg_DB_HeroFrame_Healer[cyclA]
                endif
                set cyclB = cyclB + 1
            endloop
            set cyclA = cyclA + 1
        endloop

        set cyclA = 1
        set cyclAEnd = udg_DB_HeroFrame_Number[9]
        loop
            exitwhen cyclA > cyclAEnd
            set hero9[cyclA] = BlzCreateFrameByType("GLUEBUTTON", "", herobut, "ScoreScreenTabButtonTemplate", 0)
            call BlzFrameSetAbsPoint(hero9[cyclA], FRAMEPOINT_CENTER, (xpos+size)-(size*9),(0.5+size)-(size*cyclA))	
            call BlzFrameSetSize(hero9[cyclA], size, size)

            set hero9v[cyclA] = BlzCreateFrameByType("BACKDROP", "", hero9[cyclA], "StandartFrameTemplate", 0)
            call BlzFrameSetAllPoints(hero9v[cyclA],hero9[cyclA] )
        
            call BlzTriggerRegisterFrameEvent(trigclass, hero9[cyclA], FRAMEEVENT_CONTROL_CLICK)
            call BlzFrameSetTexture( hero9v[cyclA], udg_DB_HeroFrame_Debuffer_Icon[cyclA],0, true)

            if udg_DB_HeroFrame_Debuffer[cyclA] == udg_Database_Hero[udg_Database_InfoNumberHeroes] then
                set newfrtrg[1] = hero9[cyclA]
            elseif udg_DB_HeroFrame_Debuffer[cyclA] == udg_Database_Hero[udg_Database_InfoNumberHeroes-1] then
                set newfrtrg[2] = hero9[cyclA]
            endif	
            
            set cyclB = 1
            loop
                exitwhen cyclB > 4
                if udg_HeroBonusPotion[cyclB] == cyclA and udg_HeroBonusPotionClass[cyclB] == 9 then
                    set potion[cyclB] = hero9[cyclA]
                    set udg_HeroBonusPotionHero[cyclB] = udg_DB_HeroFrame_Debuffer[cyclA]
                endif
                set cyclB = cyclB + 1
            endloop
            set cyclA = cyclA + 1
        endloop

        set cyclA = 1
        loop
            exitwhen cyclA > 1
            set newframe = BlzCreateFrameByType("BACKDROP", "", herobut, "", 0)
            call BlzFrameSetPoint( newframe, FRAMEPOINT_CENTER, newfrtrg[cyclA], FRAMEPOINT_BOTTOMRIGHT, -0.006,0.006) 	
            call BlzFrameSetSize(newframe, 0.02, 0.02)
            call BlzFrameSetTexture( newframe, "framenew.blp",0, true)
            set cyclA = cyclA + 1
        endloop
        
        set cyclA = 1
        loop
            exitwhen cyclA > 4
            set newframe = BlzCreateFrameByType("BACKDROP", "", herobut, "", 0)
            call BlzFrameSetPoint( newframe, FRAMEPOINT_CENTER, potion[cyclA], FRAMEPOINT_BOTTOMLEFT, 0.007,0.007) 
            call BlzFrameSetSize(newframe, 0.01, 0.01)
            call BlzFrameSetTexture( newframe, "potionframe.blp",0, true)
            set cyclA = cyclA + 1
        endloop
        
        set AspectsParent = BlzCreateFrame("QuestButtonBaseTemplate", herobut, 0, 0)
        call BlzFrameSetAbsPoint(AspectsParent, FRAMEPOINT_CENTER, 0.32, 0.205)
        call BlzFrameSetSize(AspectsParent, 0.11, 0.05)
        call BlzFrameSetLevel( AspectsParent, -2 )
        call BlzFrameSetVisible( AspectsParent, false )
        
        set cyclA = 0
        loop
            exitwhen cyclA > 2
            set AspectVision[cyclA] = BlzCreateFrameByType("BACKDROP", "AspectVision0" + I2S(cyclA), AspectsParent, "", 1) 
            call BlzFrameSetPoint(AspectVision[cyclA], FRAMEPOINT_BOTTOMLEFT, AspectsParent, FRAMEPOINT_BOTTOMLEFT, 0.01 + (cyclA*(ASPECTS_SIZE+ASPECTS_INDENT)),0.015)
            call BlzFrameSetSize(AspectVision[cyclA], ASPECTS_SIZE, ASPECTS_SIZE)
            call BlzFrameSetTexture(AspectVision[cyclA], "", 0, true) 
            
            set AspectButton[cyclA] = BlzCreateFrameByType("BUTTON", "", AspectVision[cyclA], "", 1) 
            call BlzFrameSetAllPoints(AspectButton[cyclA],AspectVision[cyclA] )
            
            set newframe = BlzCreateFrameByType("BACKDROP", "", AspectVision[cyclA], "StandartFrameTemplate", 0)
            call BlzFrameSetTexture(newframe, "war3mapImported\\PAS_Effect.blp", 0, true)
            call BlzFrameSetAllPoints(newframe, AspectVision[cyclA])
            set cyclA = cyclA + 1
        endloop
        
        call Tooltip_AddEvent(AspectButton[0], function TooltipEnable0 )
        call Tooltip_AddEvent(AspectButton[1], function TooltipEnable1 )
        call Tooltip_AddEvent(AspectButton[2], function TooltipEnable2 )

        set trig = null
        set trigclass = null
        set herofon = null
        set buttool = null
        set class = null
        set namefon = null
        set newframe = null
    endfunction

    //===========================================================================
    function InitTrig_HeroesFrame takes nothing returns nothing
        set gg_trg_HeroesFrame = CreateTrigger(  )
        call TriggerRegisterTimerExpireEvent( gg_trg_HeroesFrame, udg_StartTimer )
        call TriggerAddAction( gg_trg_HeroesFrame, function Trig_HeroesFrame_Actions )
    endfunction

endscope