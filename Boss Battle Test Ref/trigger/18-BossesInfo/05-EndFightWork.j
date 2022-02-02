function Trig_EndFightWork_Actions takes nothing returns nothing
    local integer cyclA
    local integer cyclAEnd
    local integer cyclB
    local integer cyclBEnd
    local integer cyclC
    local boolean l = false
    local integer rand 
    local integer id
    local integer maxpvp = 0
    local boolean k = false
    local integer j = 0
    local integer p = 0
    local integer v = 0
    local integer g
    local integer array b
    
    set udg_fightmod[1] = false
    call DisableTrigger( gg_trg_HeroDeath )
    call DisableTrigger( gg_trg_Equality )
    call DisableTrigger( gg_trg_MinionsTeleportation )
    set udg_Heroes_Ressurect_Battle = 0

    if udg_Endgame == 1 then
        call MMD_LogEvent0("boss_kill" )
    endif

    if udg_Boss_LvL != 10 then
        call IconFrameDel( "boss" )
        if udg_logic[78] and udg_Boss_LvL > 1 then
            call IconFrameDel( "second boss" )
        endif
    endif

    set udg_Boss_LvL = udg_Boss_LvL + 1
    if udg_Boss_LvL > 10 then
        set udg_Boss_LvL = 10
        set k = true
    endif
    
    if udg_Boss_LvL == 10 then
        set udg_Boss_Random = udg_LastBoss
        if udg_Boss_Random == 0 then
            set udg_Boss_Random = GetRandomInt( 1, 6 )
        endif
    elseif udg_Boss_LvL == 5 or udg_Boss_LvL == 7 or udg_Boss_LvL == 4 or udg_Boss_LvL == 9 or udg_Boss_LvL == 3 or udg_Boss_LvL == 8 then
        set udg_Boss_Random = GetRandomInt( 1, 6 )
    elseif udg_Boss_LvL == 6 then
        set udg_Boss_Random = GetRandomInt( 1, 4 )
    else
        set udg_Boss_Random = GetRandomInt( 1, 5 )
    endif
    if udg_logic[89] and udg_Boss_LvL == 10 then
        set udg_Boss_Random = 1
    endif

    call MultiSetValue( udg_multi, 5, 1, I2S( udg_Boss_LvL ) + "/10" )
    call BlzFrameSetText(lvltext, I2S( udg_Boss_LvL ) + "/10")
    call RemoveItemFromStock( gg_unit_h01G_0201, 'texp' )
    if udg_worldmod[1] then
        call BlzFrameSetVisible( sklbk,false)
        call BlzFrameSetVisible( refbk,false)
    endif

    set cyclA = 1
    loop 
        exitwhen cyclA > 4
        if GetPlayerSlotState(Player( cyclA - 1) ) == PLAYER_SLOT_STATE_PLAYING then
            call MMD_UpdateValueInt ("bosses_killed", Player(cyclA-1), MMD_OP_SET, udg_Boss_LvL )
            set udg_roll[cyclA] = udg_rollbase[cyclA]
            set udg_logic[47+cyclA] = false
            if udg_Heroes_Amount > 1 and udg_number[69 + cyclA] > 0 and udg_worldmod[1] and GetLocalPlayer() == Player(cyclA-1) then
                call BlzFrameSetVisible( pvpbk,true)
            endif
            if IsUnitInGroup(udg_UnitHero[27], udg_heroinfo) and IsUnitAlly(udg_hero[cyclA], GetOwningPlayer(udg_UnitHero[27])) then
                call UnitRemoveAbility( udg_hero[cyclA], 'B04Z' )
                set udg_logic[3] = true
            endif
            call moneyst( udg_hero[cyclA], ( udg_Boss_LvL - 1 ) * 100 )
            set udg_number[cyclA + 69] = udg_number[cyclA + 69] + 1
            if not(udg_logic[95]) then
                if udg_logic[cyclA + 43] then
                    set udg_logic[cyclA + 43] = false
                else
                    call SetHeroLevel( udg_hero[cyclA], GetHeroLevel(udg_hero[cyclA]) + 1, true )
                endif
            endif
            call SetUnitPositionLoc( udg_hero[cyclA], udg_point[cyclA + 21] )
            call SetUnitFacing( udg_hero[cyclA], 90 )
            call PanCameraToTimedLocForPlayer( Player(cyclA - 1), udg_point[cyclA + 21], 0 ) 
            set cyclB = 1
            loop
                exitwhen cyclB > 6
                call UnitRemoveAbility( udg_unit[cyclA + 17], Boss_Info[udg_Boss_LvL-1][cyclB] )
                call UnitRemoveAbility( gg_unit_h00D_0024, Boss_Info[udg_Boss_LvL-1][cyclB] )
                set cyclB = cyclB + 1
            endloop
        endif
        set cyclA = cyclA + 1
    endloop
  
    if udg_Preset[0] and udg_Boss_LvL == 2 and udg_Endgame == 1 then
        set cyclA = 1
        set cyclAEnd = udg_DB_ModesFrame_RotationNum
        loop
            exitwhen cyclA > cyclAEnd
            if udg_Preset[cyclA] then
                call TriggerExecute( udg_DB_Rotation[cyclA] )
                set cyclA = cyclAEnd
            endif
            set cyclA = cyclA + 1
        endloop
        
        set cyclA = 1
        set g = 0
        loop
            exitwhen cyclA > udg_DB_ModesFrame_RotationUD
            set cyclB = 1
            loop
                exitwhen cyclB > udg_DB_ModesFrame_RotationLR
                set g = g + 1
                if udg_Preset[g] then
                    set p = DB_ModesFrame_Rotation[cyclB][cyclA]
                    call IconFrame( "Preset", BlzGetAbilityIcon(p), BlzGetAbilityTooltip(p, 0), BlzGetAbilityExtendedTooltip(p, 0) )
                endif
                set cyclB = cyclB + 1
            endloop
            set cyclA = cyclA + 1
        endloop  
        
        if udg_Preset[6] then
            call SetRaritySpawn( 0, 0 )
        endif
    endif
  
    //Rand не раньше FightSt
	call Randomizer(true,true,true,true)
    call FightEnd()
    if udg_Boss_LvL == 2 then
        call BlzFrameSetVisible( scrbk, true )
        set cyclA = 1
        loop
            exitwhen cyclA > 4
            if GetPlayerSlotState(Player( cyclA-1 ) ) == PLAYER_SLOT_STATE_PLAYING and udg_LvL[cyclA] >= 13 then
                call SetPlayerState( Player( cyclA-1 ), PLAYER_STATE_RESOURCE_GOLD, GetPlayerState( Player( cyclA-1 ), PLAYER_STATE_RESOURCE_GOLD ) + 100 )
            endif
            set cyclA = cyclA + 1
        endloop 
        if udg_logic[78] and udg_Endgame == 1 then
            call MultiSetValue( udg_multi, 3, 2, udg_Hardest + " (DT)" )
            call IconFrame( "DT", BlzGetAbilityIcon('A0JO'), BlzGetAbilityTooltip('A0JO', 0), BlzGetAbilityExtendedTooltip('A0JO', 0) )
        endif
    
        if not(udg_logic[89]) then
            set udg_LastBoss = GetRandomInt( 1, 6 )
        else
            set udg_LastBoss = 1
        endif
        set b[1] = 'A06L'
        set b[2] = 'A0VH'
        set b[3] = 'A09E'
        set b[4] = 'A09K'
        set b[5] = 'A0DF'
        set b[6] = 'A0SM'
        
        if udg_Endgame == 1 then
            call Mods_Awake()
        endif
        
        call IconFrame( "Last Boss", BlzGetAbilityIcon(b[udg_LastBoss]), BlzGetAbilityTooltip(b[udg_LastBoss], 0), BlzGetAbilityExtendedTooltip(b[udg_LastBoss], 0) )
        
        if not(AnyHasLvL(5)) then
            call DisplayTimedTextToForce( bj_FORCE_ALL_PLAYERS, 10, "Now you have access to arenas at |cffffcc00Cute Bob|r!" )
        endif
        call MultiSetColor( udg_multi, 4, 2, 20, 100, 20, 25 )
        call MultiSetColor( udg_multi, 5, 2, 20, 100, 20, 25 )
    elseif udg_Boss_LvL == 3 then
        if udg_logic[101] then
            call RemoveUnit( gg_unit_h00P_0089 )
        endif
    elseif udg_Boss_LvL == 4 then
        call DisableTrigger( gg_trg_UnitChoose )
        if not( udg_logic[33] ) then
            call MultiSetColor( udg_multi, 4, 2, 100, 100, 20, 25 )
        endif
    elseif udg_Boss_LvL == 5 then
        if not(udg_logic[101]) then
            call RemoveUnit( gg_unit_h00P_0089 )
        endif
        if not( udg_logic[31] ) then
            call MultiSetColor( udg_multi, 5, 2, 100., 100., 20., 25. )
        endif
        call MultiSetColor( udg_multi, 4, 2, 20., 100., 20., 25. )
        set udg_Arena_LvL[0] = 1
        set udg_logic[33] = false
        if not( udg_logic[71] ) and (not( udg_logic[101] ) or (udg_ArenaLim[0] == 0 and udg_logic[101])) then
            call UnitAddAbility(gg_unit_h00A_0034, 'A08B')
        endif
    elseif udg_Boss_LvL == 6 then
        call MultiSetColor( udg_multi, 5, 2, 20., 100., 20., 25. )
        set udg_Arena_LvL[1] = 1
        set udg_logic[31] = false 
        if not( udg_logic[71] )  and (not( udg_logic[101] ) or (udg_ArenaLim[1] == 0 and udg_logic[101])) then
            call UnitAddAbility(gg_unit_h00A_0034, 'A0JQ')
        endif
    elseif udg_Boss_LvL == 7 then
        if not( udg_logic[33] )  then
            call MultiSetColor( udg_multi, 4, 2, 100, 100, 20, 25 )
        endif
    elseif udg_Boss_LvL == 8 then
        set udg_Arena_LvL[0] = 2
        call MultiSetColor( udg_multi, 4, 2, 20., 100., 20., 25. )
        set udg_logic[33] = false 
        if not( udg_logic[71] ) and (not( udg_logic[101] ) or (udg_ArenaLim[0] == 0 and udg_logic[101])) then
            call UnitAddAbility(gg_unit_h00A_0034, 'A08B')
        endif
    elseif udg_Boss_LvL == 10 then
        if not( udg_logic[31] )  then
            call MultiSetColor( udg_multi, 5, 2, 100., 100., 20., 25. )
        endif
        if not( udg_logic[33] ) then
            call MultiSetColor( udg_multi, 4, 2, 100., 100., 20., 25. )
        endif
    endif
    set cyclA = 1
    loop
        exitwhen cyclA > 4
        set cyclB = 1
        loop
            exitwhen cyclB > 6
            call UnitAddAbility(udg_unit[cyclA + 17], Boss_Info[udg_Boss_LvL][cyclB] )
            call UnitAddAbility( gg_unit_h00D_0024, Boss_Info[udg_Boss_LvL][cyclB] )
            set cyclB = cyclB + 1
        endloop
        set cyclA = cyclA + 1
    endloop
    if not(udg_logic[99] ) then
    	call JuleRef()
    else
        set udg_logic[99] = false
        call BlzFrameSetVisible( julecont, true )
    endif
    if udg_modgood[27] then
        set udg_logic[42] = true
        call BlzFrameSetText( juletext[1][0], "0 G" )
    endif
    if udg_modgood[32] and udg_Boss_LvL < 10 then
        set v = Boss_Info[udg_Boss_LvL][udg_Boss_Random]
        call IconFrame( "boss", BlzGetAbilityIcon(v), BlzGetAbilityTooltip(v, 0), BlzGetAbilityExtendedTooltip(v, 0) )
    endif
endfunction

//===========================================================================
function InitTrig_EndFightWork takes nothing returns nothing
    set gg_trg_EndFightWork = CreateTrigger(  )
    call TriggerAddAction( gg_trg_EndFightWork, function Trig_EndFightWork_Actions )
endfunction

