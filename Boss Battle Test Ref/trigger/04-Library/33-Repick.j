library Repick requires SpellPower, NullingAbility

    globals
        real Event_HeroRepick_Real = 0
        unit Event_HeroRepick_Hero = null
    endglobals

    function DelChooseIcon takes unit u returns nothing
        local integer cyclA = 1
            local integer cyclAEnd = udg_Database_InfoNumberHeroes
            local boolean l = false 
        
        loop
            exitwhen cyclA > cyclAEnd
            if GetUnitTypeId( u ) == udg_Database_Hero[cyclA] then
                set udg_UnitHeroLogic[cyclA] = false
                set cyclA = cyclAEnd
            endif
            set cyclA = cyclA + 1
        endloop

    if udg_HeroChooseMode == 2 then
        set cyclA = 1
        set cyclAEnd = udg_DB_HeroFrame_Number[1]
        loop
            exitwhen cyclA > cyclAEnd
            if GetUnitTypeId( u ) == udg_DB_HeroFrame_Buffer[cyclA] then
                call BlzFrameSetTexture( hero1v[cyclA], udg_DB_HeroFrame_Buffer_Icon[cyclA],0, true)
                set cyclA = cyclAEnd
                set l = true
            endif
            set cyclA = cyclA + 1
        endloop

        if not(l) then
        set cyclA = 1
        set cyclAEnd = udg_DB_HeroFrame_Number[2]
        loop
            exitwhen cyclA > cyclAEnd
            if GetUnitTypeId( u ) == udg_DB_HeroFrame_Deffender[cyclA] then
                call BlzFrameSetTexture( hero2v[cyclA], udg_DB_HeroFrame_Deffender_Icon[cyclA],0, true)
                set cyclA = cyclAEnd
                set l = true
            endif
            set cyclA = cyclA + 1
        endloop
        endif

        if not(l) then
        set cyclA = 1
        set cyclAEnd = udg_DB_HeroFrame_Number[3]
        loop
            exitwhen cyclA > cyclAEnd
            if GetUnitTypeId( u ) == udg_DB_HeroFrame_Ripper[cyclA] then
                call BlzFrameSetTexture( hero3v[cyclA], udg_DB_HeroFrame_Ripper_Icon[cyclA],0, true)
                set cyclA = cyclAEnd
                set l = true
            endif
            set cyclA = cyclA + 1
        endloop
        endif

        if not(l) then
        set cyclA = 1
        set cyclAEnd = udg_DB_HeroFrame_Number[4]
        loop
            exitwhen cyclA > cyclAEnd
            if GetUnitTypeId( u ) == udg_DB_HeroFrame_Hybrid[cyclA] then
                call BlzFrameSetTexture( hero4v[cyclA], udg_DB_HeroFrame_Hybrid_Icon[cyclA],0, true)
                set cyclA = cyclAEnd
                set l = true
            endif
            set cyclA = cyclA + 1
        endloop
        endif

        if not(l) then
        set cyclA = 1
        set cyclAEnd = udg_DB_HeroFrame_Number[5]
        loop
            exitwhen cyclA > cyclAEnd
            if GetUnitTypeId( u ) == udg_DB_HeroFrame_Maraduer[cyclA] then
                call BlzFrameSetTexture( hero5v[cyclA], udg_DB_HeroFrame_Maraduer_Icon[cyclA],0, true)
                set cyclA = cyclAEnd
                set l = true
            endif
            set cyclA = cyclA + 1
        endloop
        endif
        
        if not(l) then
        set cyclA = 1
        set cyclAEnd = udg_DB_HeroFrame_Number[6]
        loop
            exitwhen cyclA > cyclAEnd
            if GetUnitTypeId( u ) == udg_DB_HeroFrame_Killer[cyclA] then
                call BlzFrameSetTexture( hero6v[cyclA], udg_DB_HeroFrame_Killer_Icon[cyclA],0, true)
                set cyclA = cyclAEnd
                set l = true
            endif
            set cyclA = cyclA + 1
        endloop
        endif
        
        if not(l) then
        set cyclA = 1
        set cyclAEnd = udg_DB_HeroFrame_Number[7]
        loop
            exitwhen cyclA > cyclAEnd
            if GetUnitTypeId( u ) == udg_DB_HeroFrame_Elemental[cyclA] then
                call BlzFrameSetTexture( hero7v[cyclA], udg_DB_HeroFrame_Elemental_Icon[cyclA],0, true)
                set cyclA = cyclAEnd
                set l = true
            endif
            set cyclA = cyclA + 1
        endloop
        endif
        
        if not(l) then
        set cyclA = 1
        set cyclAEnd = udg_DB_HeroFrame_Number[8]
        loop
            exitwhen cyclA > cyclAEnd
            if GetUnitTypeId( u ) == udg_DB_HeroFrame_Healer[cyclA] then
                call BlzFrameSetTexture( hero8v[cyclA], udg_DB_HeroFrame_Healer_Icon[cyclA],0, true)
                set cyclA = cyclAEnd
                set l = true
            endif
            set cyclA = cyclA + 1
        endloop
        endif

        if not(l) then
        set cyclA = 1
        set cyclAEnd = udg_DB_HeroFrame_Number[9]
        loop
            exitwhen cyclA > cyclAEnd
            if GetUnitTypeId( u ) == udg_DB_HeroFrame_Debuffer[cyclA] then
                call BlzFrameSetTexture( hero9v[cyclA], udg_DB_HeroFrame_Debuffer_Icon[cyclA],0, true)
                set cyclA = cyclAEnd
                set l = true
            endif
            set cyclA = cyclA + 1
        endloop
        endif
    endif

        set u = null
    endfunction

    function Repick takes player p returns nothing
        local integer cyclA = 1
        local integer cyclAEnd = udg_Database_InfoNumberHeroes
        local integer i = GetPlayerId(p) + 1
        local boolean l = false

        loop
            exitwhen cyclA > cyclAEnd
            if GetUnitTypeId( udg_hero[i] ) == udg_Database_Hero[cyclA] then
                set udg_UnitHeroLogic[cyclA] = false
                set cyclA = cyclAEnd
            endif
            set cyclA = cyclA + 1
        endloop
        set udg_SkinUsed[i] = 0
        if not(udg_logic[54]) then
            call PauseTimer( udg_timer[1] )
            call PauseTimer( udg_timer[2] )
            call PauseTimer( udg_timer[3] )
        endif
        call delspellpas( udg_hero[i] )
        if udg_fightlogic[i] then
            set udg_fightlogic[i] = false
            set udg_Player_Readiness = udg_Player_Readiness - 1
        endif
        call MMD_UpdateValueString("hero",p,"none")
        call GroupRemoveUnit(udg_otryad, udg_hero[i])
        call GroupRemoveUnit(udg_heroinfo, udg_hero[i])
        call UnitRemoveAbility(udg_unit[i + 31], 'A0J8')
        call UnitRemoveAbility(udg_unit[i + 31], 'A06V')
        if udg_number[i + 100] == 7 then
            call spdst( udg_hero[i], -10 )
        elseif GetUnitTypeId(udg_hero[i]) == udg_Database_Hero[1] then
            call DestroyLeaderboard( udg_panel[1] )
        elseif GetUnitTypeId(udg_hero[i]) == 'O016' then
            call DestroyLeaderboard( udg_panel[3] )
        endif
        call MultiSetIcon( udg_multi, ( udg_Multiboard_Position[i] * 3 ) - 1, 3, "ReplaceableTextures\\CommandButtons\\BTNSelectHeroOn.blp" )

        set udg_HeroSpawn[i] = CreateUnit( Player(PLAYER_NEUTRAL_PASSIVE), 'u000', GetLocationX(udg_point[25+i]), GetLocationY(udg_point[25+i]), bj_UNIT_FACING )
        call CameraSetupApplyForPlayer( true, udg_CameraChoose[i], Player(i-1), 0 )
        call SetCameraTargetControllerNoZForPlayer( Player(i-1), udg_HeroSpawn[i], 200.00, -150.00, false )

        set Event_HeroRepick_Hero = udg_hero[i]
        set Event_HeroRepick_Real = 0.00
        set Event_HeroRepick_Real = 1.00
        set Event_HeroRepick_Real = 0.00

        //Delete shield numbers
        call DestroyTextTag( LoadTextTagHandle( udg_hash, GetHandleId(udg_hero[i]), StringHash( "shldtx" ) ) )

        call BlzFrameSetTexture(lvlic[i], "ReplaceableTextures\\CommandButtons\\BTNSelectHeroOn.blp", 0, true)
        call BlzFrameSetTexture( iconframe[i], "ReplaceableTextures\\CommandButtons\\BTNDivineShieldOff.blp", 0, true )
        call BlzFrameSetTexture( faceframe[i], "ReplaceableTextures\\CommandButtons\\BTNSelectHeroOn.blp", 0, false)
        call BlzFrameSetVisible( uniqframe[i],false)
        call BlzFrameSetVisible( specframe[i],false)
        call DelChooseIcon( udg_hero[i] )
        call FlushChildHashtable( udg_hash, GetHandleId(udg_hero[i]) )
        call RemoveUnit( udg_hero[i] )
        set udg_hero[i] = null
        set ChoosedHero[i] = null

        if GetLocalPlayer() == p then
            call BlzFrameSetVisible( AspectVision, false )
            call BlzFrameSetVisible( specback, false )
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
            call BlzFrameSetTexture( herospell[1], "war3mapImported\\PASfeed-icon-red-1_result.blp",0, true)
            call BlzFrameSetTexture( herospell[2], "war3mapImported\\PASfeed-icon-red-1_result.blp",0, true)
            call BlzFrameSetTexture( herospell[3], "war3mapImported\\PASfeed-icon-red-1_result.blp",0, true)
            call BlzFrameSetTexture( herospell[4], "war3mapImported\\PASfeed-icon-red-1_result.blp",0, true)
            call BlzFrameSetTexture( herospell[5], "war3mapImported\\PASfeed-icon-red-1_result.blp",0, true)
            call BlzFrameSetVisible( herospell[1], false )
            call BlzFrameSetVisible( herospell[2], false )
            call BlzFrameSetVisible( herospell[3], false )
            call BlzFrameSetVisible( herospell[4], false )
            call BlzFrameSetVisible( herospell[5], false )
            call BlzFrameSetVisible( rpkmod,false)
            call BlzFrameSetVisible( arrowframe, false )
            if udg_HeroChooseMode == 2 then
                call BlzFrameSetVisible( herobut, true )
                if udg_Host == p then
                    call BlzFrameSetVisible( banbut, true )
                endif
            endif
        endif
        
        set p = null
    endfunction

endlibrary