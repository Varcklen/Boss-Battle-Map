globals
    real Event_HeroChoose_Real = 0
    unit Event_HeroChoose_Hero = null
endglobals

function Trig_HeroesChoise_Conditions takes nothing returns boolean
    return IsUnitType(GetEnteringUnit(), UNIT_TYPE_HERO)
endfunction

function Trig_HeroesChoise_Actions takes nothing returns nothing
    local player pl = GetOwningPlayer(GetEnteringUnit())
    local integer i = GetPlayerId(pl) + 1
    local integer cyclA
    local integer cyclAEnd = udg_Database_InfoNumberHeroes
    local boolean l = false
    local boolean k = false
    local integer id = GetHandleId( GetEnteringUnit() )
    local real x
    local real y
    local real fac
    local boolean g
    
    set cyclA = 1
    loop
        exitwhen cyclA > cyclAEnd
        if ( not( udg_UnitHeroLogic[cyclA] ) or GetUnitTypeId( GetEnteringUnit() ) == udg_Database_Hero[31] or GetUnitTypeId( GetEnteringUnit() ) == udg_Database_Hero[34] ) and GetUnitTypeId( GetEnteringUnit() ) == udg_Database_Hero[cyclA] then
            set udg_HeroNum[i] = cyclA
            set udg_UnitHeroLogic[cyclA] = true
            call MultiSetIcon( udg_multi, ( udg_Multiboard_Position[i] * 3 ) - 1, 3, udg_DB_Hero_Icon[cyclA] )
            set udg_UnitHero[cyclA] = GetEnteringUnit()
            call UnitAddAbility( udg_unit[i + 4], udg_HeroStatus[i] )
            call BlzFrameSetTexture(lvlic[i], udg_DB_Hero_Icon[cyclA], 0, true)
            if udg_SkinUsed[i] == 0 then
                call BlzFrameSetTexture( faceframe[i], udg_DB_Hero_Icon[cyclA], 0, false)
            endif
            set l = true
            set cyclA = cyclAEnd
        endif
        set cyclA = cyclA + 1
    endloop
    if l and udg_hero[i] == null then
        set udg_hero[i] = GetEnteringUnit()
    else
        call RemoveUnit( GetEnteringUnit() )
        call DisplayTimedTextToForce( GetForceOfPlayer(GetOwningPlayer(GetEnteringUnit())), 5., "This hero is unavailable. Choose another hero." )
        return
    endif
    
    call MMD_UpdateValueString("hero",pl,GetUnitName(udg_hero[i]))
    
    call SetUnitUserData(udg_hero[i], i)
    set g = false
    set cyclA = 1
    loop
        exitwhen cyclA > 9
        if GetUnitAbilityLevel( GetEnteringUnit(), udg_DB_Hero_SpecAb[cyclA] ) > 0 then
            set udg_number[i + 100] = cyclA
            set cyclA = 9
            set g = true
        endif
        set cyclA = cyclA + 1
    endloop
    if not(g) then
        set udg_number[i + 100] = 4
    endif

    set cyclA = 1
    set cyclAEnd = udg_Database_NumberItems[13]
    loop
        exitwhen cyclA > cyclAEnd
        if GetUnitAbilityLevel( GetEnteringUnit(), udg_DB_Hero_SpecAb[cyclA] ) > 0 then
            call NewUniques( GetEnteringUnit(), udg_DB_Hero_SpecAb[cyclA] )
        endif
        set cyclA = cyclA + 1
    endloop
    if udg_Boss_LvL > 1 then
        call SetHeroLevel( GetEnteringUnit(), GetHeroLevel(GetEnteringUnit()) + 1, true)
        set x = GetLocationX( udg_point[i + 21] )
        set y = GetLocationY( udg_point[i + 21] )
        set fac = 90
    else
        set x = GetRectCenterX(gg_rct_HeroTp)
        set y = GetRectCenterY(gg_rct_HeroTp)
        set fac = 270
    endif
    set cyclA = 0
    loop
        exitwhen cyclA > 3
        if GetOwningPlayer(GetEnteringUnit()) != Player(cyclA) and GetPlayerSlotState(Player(cyclA)) == PLAYER_SLOT_STATE_PLAYING then
            call DisplayTimedTextToPlayer(Player(cyclA), 0, 0, 10., udg_Player_Color[i] + ( GetPlayerName(GetOwningPlayer(GetEnteringUnit())) + ( "|r choose: |cfffcc00f" + ( GetUnitName( GetEnteringUnit()) ) ) ) )
        endif
        set cyclA = cyclA + 1
    endloop
    
    set Event_HeroChoose_Hero = udg_hero[i]
    set Event_HeroChoose_Real = 0.00
    set Event_HeroChoose_Real = 1.00
    set Event_HeroChoose_Real = 0.00
    
    if GetUnitTypeId(GetEnteringUnit()) == 'O00C' then
        set udg_panel[1] = CreateLeaderboardBJ( GetForceOfPlayer(GetOwningPlayer(GetEnteringUnit())), "" )
        call LeaderboardSetLabelColor(udg_panel[1], 250, 200, 50, 250 )
        call LeaderboardAddItemBJ( Player(4), udg_panel[1], "Rubies: ", udg_cristal )
    endif
    if GetUnitTypeId(GetEnteringUnit()) == 'O016' then
        set udg_panel[3] = CreateLeaderboardBJ( GetForceOfPlayer(GetOwningPlayer(GetEnteringUnit())), "" )
        call LeaderboardSetLabelColor(udg_panel[3], 250, 200, 50, 250 )
        call LeaderboardAddItemBJ( Player(4), udg_panel[3], "Entropies: ", udg_entropy[i] )
        if GetRandomInt(1,10) == 1 then
            call BlzSetHeroProperName( GetEnteringUnit(), "Identity Crisis" )
        endif
    endif
    call GroupAddUnit( udg_otryad, GetEnteringUnit() )
    call GroupAddUnit( udg_heroinfo, GetEnteringUnit() )

    if udg_LvL[i] <= 5 then
        if GetLocalPlayer() == GetOwningPlayer(GetEnteringUnit()) then
            call BlzFrameSetVisible( arrowframe, true )
        endif
    endif
    call UnitAddItem(GetEnteringUnit(), CreateItem('I054', GetUnitX(GetEnteringUnit()), GetUnitY(GetEnteringUnit())))
    if udg_logic[8] then
        call UnitAddItem(GetEnteringUnit(), CreateItem('I056', GetUnitX(GetEnteringUnit()), GetUnitY(GetEnteringUnit())))
        set udg_logic[8] = false
    elseif udg_HeroChooseMode == 2 and (GetUnitTypeId(GetEnteringUnit()) == udg_HeroBonusPotionHero[1] or GetUnitTypeId(GetEnteringUnit()) == udg_HeroBonusPotionHero[2] or  GetUnitTypeId(GetEnteringUnit()) == udg_HeroBonusPotionHero[3] or  GetUnitTypeId(GetEnteringUnit()) == udg_HeroBonusPotionHero[4]) then
        call UnitAddItem(GetEnteringUnit(), CreateItem('I05B', GetUnitX(GetEnteringUnit()), GetUnitY(GetEnteringUnit())))
    endif
    if udg_LvL[i] >= 15 then
        call UnitAddItem(GetEnteringUnit(), CreateItem('I055', GetUnitX(GetEnteringUnit()), GetUnitY(GetEnteringUnit())))
    endif
    if udg_LvL[i] >= 20 then
        call UnitAddItem(GetEnteringUnit(), CreateItem('I0CX', GetUnitX(GetEnteringUnit()), GetUnitY(GetEnteringUnit())))
    endif

    if not( udg_logic[54] ) and udg_Boss_LvL == 1 and (udg_hero[1]!=null or GetPlayerSlotState(Player(0)) != PLAYER_SLOT_STATE_PLAYING) and (udg_hero[2]!=null or GetPlayerSlotState(Player(1)) != PLAYER_SLOT_STATE_PLAYING) and (udg_hero[3]!=null or GetPlayerSlotState(Player(2)) != PLAYER_SLOT_STATE_PLAYING) and (udg_hero[4]!=null or GetPlayerSlotState(Player(3)) != PLAYER_SLOT_STATE_PLAYING) then
        call ResumeTimer(udg_timer[1])
        call ResumeTimer(udg_timer[3])
    endif

    if udg_HeroChooseMode == 2 then
        set cyclA = 1
        set cyclAEnd = udg_DB_HeroFrame_Number[1]
        loop
            exitwhen cyclA > cyclAEnd
            if GetUnitTypeId( udg_hero[i] ) == udg_DB_HeroFrame_Buffer[cyclA] then
                call BlzFrameSetTexture( hero1v[cyclA], "ReplaceableTextures\\CommandButtons\\BTNCancel.blp",0, true)
                set k = true
                set cyclA = cyclAEnd
            endif
            set cyclA = cyclA + 1
        endloop

        if not(k) then
            set cyclA = 1
            set cyclAEnd = udg_DB_HeroFrame_Number[2]
            loop
                exitwhen cyclA > cyclAEnd
                if GetUnitTypeId( udg_hero[i] ) == udg_DB_HeroFrame_Deffender[cyclA] then
                    call BlzFrameSetTexture( hero2v[cyclA], "ReplaceableTextures\\CommandButtons\\BTNCancel.blp",0, true)
                    set k = true
                    set cyclA = cyclAEnd
                endif
                set cyclA = cyclA + 1
            endloop
        endif

        if not(k) then
            set cyclA = 1
            set cyclAEnd = udg_DB_HeroFrame_Number[3]
            loop
                exitwhen cyclA > cyclAEnd
                if GetUnitTypeId( udg_hero[i] ) == udg_DB_HeroFrame_Ripper[cyclA] then
                    call BlzFrameSetTexture( hero3v[cyclA], "ReplaceableTextures\\CommandButtons\\BTNCancel.blp",0, true)
                    set k = true
                    set cyclA = cyclAEnd
                endif
                set cyclA = cyclA + 1
            endloop
        endif
        if not(k) then
            set cyclA = 1
            set cyclAEnd = udg_DB_HeroFrame_Number[4]
            loop
                exitwhen cyclA > cyclAEnd
                if GetUnitTypeId( udg_hero[i] ) == udg_DB_HeroFrame_Hybrid[cyclA] and GetUnitTypeId( udg_hero[i] ) != 'O00T' then
                    call BlzFrameSetTexture( hero4v[cyclA], "ReplaceableTextures\\CommandButtons\\BTNCancel.blp",0, true)
                    set k = true
                    set cyclA = cyclAEnd
                endif
                set cyclA = cyclA + 1
            endloop
        endif
        if not(k) then
            set cyclA = 1
            set cyclAEnd = udg_DB_HeroFrame_Number[5]
            loop
                exitwhen cyclA > cyclAEnd
                if GetUnitTypeId( udg_hero[i] ) == udg_DB_HeroFrame_Maraduer[cyclA] then
                    call BlzFrameSetTexture( hero5v[cyclA], "ReplaceableTextures\\CommandButtons\\BTNCancel.blp",0, true)
                    set k = true
                    set cyclA = cyclAEnd
                endif
                set cyclA = cyclA + 1
            endloop
        endif
        if not(k) then
            set cyclA = 1
            set cyclAEnd = udg_DB_HeroFrame_Number[6]
            loop
                exitwhen cyclA > cyclAEnd
                if GetUnitTypeId( udg_hero[i] ) == udg_DB_HeroFrame_Killer[cyclA] then
                    call BlzFrameSetTexture( hero6v[cyclA], "ReplaceableTextures\\CommandButtons\\BTNCancel.blp",0, true)
                    set k = true
                    set cyclA = cyclAEnd
                endif
                set cyclA = cyclA + 1
            endloop
        endif
        if not(k) then
            set cyclA = 1
            set cyclAEnd = udg_DB_HeroFrame_Number[7]
            loop
                exitwhen cyclA > cyclAEnd
                if GetUnitTypeId( udg_hero[i] ) == udg_DB_HeroFrame_Elemental[cyclA] then
                    call BlzFrameSetTexture( hero7v[cyclA], "ReplaceableTextures\\CommandButtons\\BTNCancel.blp",0, true)
                    set k = true
                    set cyclA = cyclAEnd
                endif
                set cyclA = cyclA + 1
            endloop
        endif
        if not(k) then
            set cyclA = 1
            set cyclAEnd = udg_DB_HeroFrame_Number[8]
            loop
                exitwhen cyclA > cyclAEnd
                if GetUnitTypeId( udg_hero[i] ) == udg_DB_HeroFrame_Healer[cyclA] then
                    call BlzFrameSetTexture( hero8v[cyclA], "ReplaceableTextures\\CommandButtons\\BTNCancel.blp",0, true)
                    set k = true
                    set cyclA = cyclAEnd
                endif
                set cyclA = cyclA + 1
            endloop
        endif
        if not(k) then
            set cyclA = 1
            set cyclAEnd = udg_DB_HeroFrame_Number[9]
            loop
                exitwhen cyclA > cyclAEnd
                if GetUnitTypeId( udg_hero[i] ) == udg_DB_HeroFrame_Debuffer[cyclA] then
                    call BlzFrameSetTexture( hero9v[cyclA], "ReplaceableTextures\\CommandButtons\\BTNCancel.blp",0, true)
                    set cyclA = cyclAEnd
                endif
                set cyclA = cyclA + 1
            endloop
        endif
    endif

    if GetLocalPlayer() == pl then
        if not(udg_logic[77]) and not(udg_logic[9]) then
            call BlzFrameSetVisible( rpkmod,true)
        endif
        call BlzFrameSetVisible( fon,true)
        call BlzFrameSetVisible( butbk,true)
        call BlzFrameSetVisible( iconframe[1],true)
        call BlzFrameSetVisible( iconframe[2],true)
        call BlzFrameSetVisible( iconframe[3],true)
        call BlzFrameSetVisible( iconframe[4],true)
        if GetPlayerSlotState( Player( 0 ) ) == PLAYER_SLOT_STATE_PLAYING then
            call BlzFrameSetVisible( faceframe[1],true)
        endif
        if GetPlayerSlotState( Player( 1 ) ) == PLAYER_SLOT_STATE_PLAYING then
            call BlzFrameSetVisible( faceframe[2],true)
        endif
        if GetPlayerSlotState( Player( 2 ) ) == PLAYER_SLOT_STATE_PLAYING then
            call BlzFrameSetVisible( faceframe[3],true)
        endif
        if GetPlayerSlotState( Player( 3 ) ) == PLAYER_SLOT_STATE_PLAYING then
            call BlzFrameSetVisible( faceframe[4],true)
        endif
    endif

    if udg_number[i + 100] == 7 then
        call spdst( GetEnteringUnit(), 10 )
    endif

    if udg_SkinUsed[i] != 0 and not(udg_logic[8]) and not(udg_logic[77]) then
        call SetUnitSkin( udg_hero[i], udg_SkinUsed[i] )
    endif
    if not(udg_combatlogic[i]) and udg_Boss_LvL == 1 and (udg_Player_Color_Int[i] != i or udg_SkinUsed[i] != 0) then
        call KillUnit( udg_hero[i] )
    endif

    call SetUnitPosition(GetEnteringUnit(), x, y )
    call SetUnitFacing(GetEnteringUnit(), fac )
    call PanCameraToTimedForPlayer( Player( GetPlayerId(GetOwningPlayer( GetEnteringUnit() ) ) ), x, y, 0 )
    if GetLocalPlayer() == GetOwningPlayer( GetEnteringUnit() ) then
        call SetCameraField(CAMERA_FIELD_TARGET_DISTANCE, 2225, 0)
    endif
    call SetUnitState( GetEnteringUnit(), UNIT_STATE_MANA, GetUnitState( GetEnteringUnit(), UNIT_STATE_MAX_MANA ) )
endfunction

//===========================================================================
function InitTrig_HeroesChoise takes nothing returns nothing
    set gg_trg_HeroesChoise = CreateTrigger(  )
    call TriggerRegisterEnterRectSimple( gg_trg_HeroesChoise, gg_rct_HeroesTp )
    call TriggerAddCondition( gg_trg_HeroesChoise, Condition( function Trig_HeroesChoise_Conditions ) )
    call TriggerAddAction( gg_trg_HeroesChoise, function Trig_HeroesChoise_Actions )
endfunction

