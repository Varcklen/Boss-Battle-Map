library Repick requires SpellPower, NullingAbility

    globals
        real Event_HeroRepick_Real = 0
        unit Event_HeroRepick_Hero = null
    endglobals
    
    private function DeleteItems takes unit hero returns nothing
        local integer i = 0
        local item it
        
        loop
            exitwhen i > 5
            set it = UnitItemInSlot(hero, i)
            if UnitHasItem( hero, it ) then
                call UnitRemoveItem(hero, it)//leave from inventory
                call RemoveItem( it )//delete them
            endif
            set i = i + 1
        endloop
    
        set hero = null
        set it = null
    endfunction

    function Repick takes player owner returns nothing
        local integer index = GetPlayerId(owner) + 1
        local integer heroKey = udg_HeroNum[index]
        local unit hero = udg_hero[index]
        local unit temp
        
        if hero == null then
            set temp = null
            set owner = null
            return
        endif

        set udg_UnitHeroLogic[heroKey] = false
        set udg_SkinUsed[index] = 0
        if udg_logic[54] == false then
            call PauseTimer( udg_timer[1] )
            call PauseTimer( udg_timer[2] )
            call PauseTimer( udg_timer[3] )
        endif
        call UnitAddItem( hero, CreateItem( 'I03S', GetUnitX(hero), GetUnitY(hero) ) )//Remove all abilities form hero
        if udg_fightlogic[index] then
            set udg_fightlogic[index] = false
            set udg_Player_Readiness = udg_Player_Readiness - 1
        endif
        call MMD_UpdateValueString("hero", owner, "none")
        call GroupRemoveUnit(udg_otryad, hero)
        call GroupRemoveUnit(udg_heroinfo, hero)
        
        if udg_number[index + 100] == 7 then
            call spdst( hero, -10 )
        endif
        
        call DeleteItems(hero)
        call MultiSetIcon( udg_multi, ( udg_Multiboard_Position[index] * 3 ) - 1, 3, "ReplaceableTextures\\CommandButtons\\BTNSelectHeroOn.blp" )

        set Event_HeroRepick_Hero = hero
        set Event_HeroRepick_Real = 0.00
        set Event_HeroRepick_Real = 1.00
        set Event_HeroRepick_Real = 0.00

        //Delete shield numbers
        call DestroyTextTag( LoadTextTagHandle( udg_hash, GetHandleId(hero), StringHash( "shldtx" ) ) )

        if udg_UntilFirstFight then
            set temp = CreateUnit( Player(PLAYER_NEUTRAL_PASSIVE), 'u000', GetLocationX(udg_point[25+index]), GetLocationY(udg_point[25+index]), bj_UNIT_FACING )
            call CameraSetupApplyForPlayer( true, udg_CameraChoose[index], Player(index-1), 0 )
            call SetCameraTargetControllerNoZForPlayer( Player(index-1), temp, 200.00, -150.00, false )
        
            call BlzFrameSetTexture( iconframe[index], "ReplaceableTextures\\CommandButtons\\BTNDivineShieldOff.blp", 0, true )
            call BlzFrameSetTexture( faceframe[index], "ReplaceableTextures\\CommandButtons\\BTNSelectHeroOn.blp", 0, false)
            call BlzFrameSetVisible( uniqframe[index], false)
            call BlzFrameSetVisible( specframe[index], false)
            call BlzFrameSetTexture( HeroesTable_ChoosedHeroButton[index], HeroesTable_ChoosedHeroIcon[index], 0, true )

            if GetLocalPlayer() == owner then
                //call BlzFrameSetVisible( AspectVision, false )
                call BlzFrameSetVisible( juleback, false )
                call BlzFrameSetVisible( quartback, false )
                call BlzFrameSetVisible( modesback, false )
                call BlzFrameSetVisible( modesbut, false )
                call BlzFrameSetVisible( modeslight, false )
                call BlzFrameSetVisible( fon,false)
                call BlzFrameSetVisible( butbk,false)
                call BlzFrameSetVisible( iconframe[1],false)
                call BlzFrameSetVisible( iconframe[2],false)
                call BlzFrameSetVisible( iconframe[3],false)
                call BlzFrameSetVisible( iconframe[4],false)
                call BlzFrameSetVisible( faceframe[1],false)
                call BlzFrameSetVisible( faceframe[2],false)
                call BlzFrameSetVisible( faceframe[3],false)
                call BlzFrameSetVisible( faceframe[4],false)
                call BlzFrameSetVisible( rpkmod,false)
                call BlzFrameSetVisible( arrowframe, false )
            endif
        endif
        
        call SetUnitOwner( hero, Player(PLAYER_NEUTRAL_PASSIVE), true )
        call FlushChildHashtable( udg_hash, GetHandleId(hero) )
        call SetUnitPosition(hero, GetLocationX(udg_point[25+index]), GetLocationY(udg_point[25+index]))
        call SetUnitFacing(hero, 270)
        call ShowUnit(hero, false )
        set udg_hero[index] = null
        set ChoosedHero[index] = null
        
        set hero = null
        set temp = null
        set owner = null
    endfunction

endlibrary