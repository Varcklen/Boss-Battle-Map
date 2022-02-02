scope BaseTooltip initializer init

    globals 
         framehandle fon
         framehandle butbk
         framehandle sklbk
         framehandle scrbk
         framehandle pvpbk
         framehandle refbk
         framehandle but
         framehandle skl
         framehandle scr
         framehandle pvp
         framehandle rpkmod
         framehandle juleIcon
         framehandle reselectionButton
         framehandle array iconframe
         framehandle array faceframe
         framehandle array uniqframe
         framehandle array specframe
         
         real Event_PvPButtonClicked_Real
         player Event_PvPButtonClicked_Player
    endglobals

    //PvP
    function PvPButton takes nothing returns nothing
        if GetLocalPlayer() == GetTriggerPlayer() then
            call BlzFrameSetVisible( pvpbk,false)
            call BlzFrameSetVisible( pvpbk,true)
        endif
        
        set Event_PvPButtonClicked_Player = GetTriggerPlayer() 
        set Event_PvPButtonClicked_Real = 0.00
        set Event_PvPButtonClicked_Real = 1.00
        set Event_PvPButtonClicked_Real = 0.00
    endfunction

    //Info
    function click2 takes nothing returns nothing
        local player p = GetTriggerPlayer()
        local integer i = GetPlayerId( p ) + 1
        local unit u = udg_hero[i]
        local integer id = GetHandleId( u )

        if GetLocalPlayer() == p then
            call BlzFrameSetVisible( scrbk,false)
            call BlzFrameSetVisible( scrbk,true)
        endif
        
        call DisplayTimedTextToPlayer( p, 0, 0, 10, "|cffffcc00Level|r: " + I2S( udg_LvL[i] ) )
        call DisplayTimedTextToPlayer( p, 0, 0, 10, "|cffffcc00Experience|r: " + I2S( udg_Exp[i] ) )
        call DisplayTimedTextToPlayer( p, 0, 0, 10, "|cffffcc00Kills|r: " + I2S( LoadInteger( udg_hash, id, StringHash( "kill" ) ) ) )
        call DisplayTimedTextToPlayer( p, 0, 0, 10, "|cffffcc00Gold|r: " + I2S( udg_GoldAllTime[i] ) )
        
        if GetUnitTypeId(u) == 'N02P' then
            call DisplayTimedTextToPlayer( p, 0, 0, 10, "|cffffcc00Pyromagic|r: Extra damage: " + I2S( R2I(PyrolordExtraDamage) ) )
        endif    
        if udg_Data[i + 92] != 0 then
            call DisplayTimedTextToPlayer( p, 0, 0, 10, "|cffffcc00Now mine!|r: Gold: " + I2S( udg_Data[i + 92] ) )
        endif
        if udg_Data[i + 96] != 0 then
            call DisplayTimedTextToPlayer( p, 0, 0, 10, "|cffffcc00Goblin mood|r: Luck: " + I2S( udg_Data[i + 96] ) )
        endif
        if udg_Data[i + 100] != 0 then
            call DisplayTimedTextToPlayer( p, 0, 0, 10, "|cffffcc00Strengthening|r: Health: " + I2S( udg_Data[i + 100] ) )
        endif
        if udg_Data[i + 104] != 0 then
            call DisplayTimedTextToPlayer( p, 0, 0, 10, "|cffffcc00Seal of fate|r: Agility: " + I2S( udg_Data[i + 104] ) )
        endif
        if udg_Data[i + 112] != 0 then
            call DisplayTimedTextToPlayer( p, 0, 0, 10, "|cffffcc00Malice|r: Spell power: " + R2SW( 0.15 * udg_Data[i + 112], 1, 2 ) + "%" )
        endif
        if udg_Data[i + 116] != 0 then
            call DisplayTimedTextToPlayer( p, 0, 0, 10, "|cffffcc00Harnessing anger|r: Attack: " + I2S( udg_Data[i + 116] ) )
        endif
        if udg_Data[i + 136] != 0 then
            call DisplayTimedTextToPlayer( p, 0, 0, 10, "|cffffcc00Black mark|r: Gold: " + I2S( udg_Data[i + 136] ) )
        endif
        if udg_Data[i] != 0 or inv( u, 'I08G' ) > 0 then
            call DisplayTimedTextToPlayer( p, 0, 0, 10, "|cffffcc00Automatron 'Income'|r: Gold: " + I2S( udg_Data[i] ) )
        endif
        if udg_Data[i + 4] != 0 or inv( u, 'I07K' ) > 0 then
            call DisplayTimedTextToPlayer( p, 0, 0, 10, "|cffffcc00Frozen blood|r: Stats: " + I2S( udg_Data[i + 4] ) )
        endif
        if udg_Data[i + 8] != 0 or inv( u, 'I027' ) > 0 then
            call DisplayTimedTextToPlayer( p, 0, 0, 10, "|cffffcc00Sharpened|r: Attack: " + I2S( udg_Data[i + 8] ) )
        endif
        if udg_Data[i + 12] != 0 or udg_Data[i + 16] != 0 or udg_Data[i + 20] != 0 or inv( u, 'I07B' ) > 0 then
            call DisplayTimedTextToPlayer( p, 0, 0, 10, "|cffffcc00Runestone Pan|r: Level: " + I2S( udg_Data[i + 12] ) + ", Stats: " + I2S( udg_Data[i + 16] ) + ", Gold: " + I2S( udg_Data[i + 20] ) )
        endif
        if udg_Data[i + 24] != 0 or udg_Data[i + 28] != 0 or udg_Data[i + 32] != 0 or inv( u, 'I047' ) > 0 then
            call DisplayTimedTextToPlayer( p, 0, 0, 10, "|cffffcc00Banner|r: Strength: " + I2S( udg_Data[i + 24] ) + ", Agility: " + I2S( udg_Data[i + 28] ) + ", Intelligence: " + I2S( udg_Data[i + 32] ) )
        endif
        if udg_Data[i + 40] != 0 or inv( u, 'I02L' ) > 0 then
            call DisplayTimedTextToPlayer( p, 0, 0, 10, "|cffffcc00Boom machine|r: Health: " + I2S( udg_Data[i + 40] ) )
        endif
        if udg_Data[i + 56] != 0 or inv( u, 'I06L' ) > 0 then
            call DisplayTimedTextToPlayer( p, 0, 0, 10, "|cffffcc00Toy train|r: Strength: " + I2S( udg_Data[i + 56] ) )
        endif
        if udg_Data[i + 60] != 0 then
            call DisplayTimedTextToPlayer( p, 0, 0, 10, "|cffffcc00Solar Eclipse|r: Intelligence: " + I2S( udg_Data[i + 60] ) )
        endif
        if udg_Data[i + 64] != 0 or inv( u, 'I04R' ) > 0 then
            call DisplayTimedTextToPlayer( p, 0, 0, 10, "|cffffcc00Tesseract|r: Spell power: " + R2SW( 0.3 * udg_Data[i + 64], 1, 1 ) + "%" )
        endif
        if udg_Data[i + 68] != 0 or udg_Data[i + 72] != 0 or udg_Data[i + 76] != 0 or inv( u, 'I01L' ) > 0 then
            call DisplayTimedTextToPlayer( p, 0, 0, 10, "|cffffcc00Slippers of Madness|r: Strength: " + I2S( udg_Data[i + 68] ) + ", Agility: " + I2S( udg_Data[i + 72] ) + ", Intelligence: " + I2S( udg_Data[i + 76] ) )
        endif
        if udg_Data[i + 80] != 0 then
            call DisplayTimedTextToPlayer( p, 0, 0, 10, "|cffffcc00Voodoo explosion|r: Luck: " + I2S( udg_Data[i + 80] ) )
        endif
        if udg_Data[i + 180] != 0 then
            call DisplayTimedTextToPlayer( p, 0, 0, 10, "|cffffcc00Bloody coin|r: Gold: " + I2S( udg_Data[i + 180] ) )
        endif
        if udg_Data[i + 168] != 0 or udg_Data[i + 172] != 0 or udg_Data[i + 176] != 0 then
            call DisplayTimedTextToPlayer( p, 0, 0, 10, "|cffffcc00Devour|r: Strength: " + I2S( udg_Data[i + 168] ) + ", Agility: " + I2S( udg_Data[i + 172] ) + ", Intelligence: " + I2S( udg_Data[i + 176] ) )
        endif
        if inv( u, 'I09E' ) > 0 then
            call DisplayTimedTextToPlayer( p, 0, 0, 10, "|cffffcc00Bloody figurine|r: Strength: " + I2S( udg_Data[i + 120] ) + ", Agility: " + I2S( udg_Data[i + 124] ) + ", Intelligence: " + I2S( udg_Data[i + 128] ) )
        endif
        if udg_Data[i + 192] != 0 or udg_Data[i + 196] != 0 or udg_Data[i + 200] != 0 then
            call DisplayTimedTextToPlayer( p, 0, 0, 10, "|cffffcc00Snow boost|r: Strength: " + I2S( udg_Data[i + 192] ) + ", Agility: " + I2S( udg_Data[i + 196] ) + ", Intelligence: " + I2S( udg_Data[i + 200] ) )
        endif
        if udg_Data[i + 204] > 0 or udg_Data[i + 208] > 0 then
            call DisplayTimedTextToPlayer( p, 0, 0, 10, "|cffffcc00Device|r: Agility: " + I2S( udg_Data[i + 204] ) + ", Intellect: " + I2S( udg_Data[i + 208] ) )
        endif
        if udg_Data[i + 212] > 0 or udg_Data[i + 216] > 0 then
            call DisplayTimedTextToPlayer( p, 0, 0, 10, "|cffffcc00Devouring flesh|r: Health: " + I2S( udg_Data[i + 212] ) + ", Attack power: " + I2S( udg_Data[i + 216] ) )
        endif
        if udg_Data[i + 220] != 0 or udg_Data[i + 224] != 0 or udg_Data[i + 228] != 0 then
            call DisplayTimedTextToPlayer( p, 0, 0, 10, "|cffffcc00Crystal Barrage|r: Strength: " + I2S( udg_Data[i + 220] ) + ", Agility: " + I2S( udg_Data[i + 224] ) + ", Intelligence: " + I2S( udg_Data[i + 228] ) )
        endif
        if udg_Data[i + 232] != 0 or udg_Data[i + 236] != 0 or udg_Data[i + 240] != 0 then
            call DisplayTimedTextToPlayer( p, 0, 0, 10, "|cffffcc00Denial of the Past|r: Strength: " + I2S( udg_Data[i + 232] ) + ", Agility: " + I2S( udg_Data[i + 236] ) + ", Intelligence: " + I2S( udg_Data[i + 240] ) )
        endif
        
        set u = null
        set p = null
    endfunction

    //Remove item
    function click1 takes nothing returns nothing
        if GetLocalPlayer() == GetTriggerPlayer() then
            call BlzFrameSetVisible( sklbk,false)
            call BlzFrameSetVisible( sklbk,true)
        endif

        call RemoveItems( GetPlayerId(GetTriggerPlayer()) + 1 )
    endfunction

    //Refresh item
    function ItemsRefresh takes integer i returns nothing
        local integer cyclA
        local integer j
        
        set cyclA = 0
        loop
            exitwhen cyclA > 2
            set j = ( 3 * i ) - cyclA
            call DestroyEffect( AddSpecialEffectLoc( "Abilities\\Spells\\Human\\Polymorph\\PolyMorphDoneGround.mdl", Location(GetItemX(udg_item[j]), GetItemY(udg_item[j]) ) ) )
            call RemoveItem( udg_item[j] )
            set udg_item[j] = null
            set cyclA = cyclA + 1
        endloop
        set IsItemsRefreshed = true
        if i == 1 then
            call Randomizer(true,false,false,false)
        elseif i == 2 then
            call Randomizer(false,true,false,false)
        elseif i == 3 then
            call Randomizer(false,false,true,false)
        elseif i == 4 then
            call Randomizer(false,false,false,true)
        endif
        set IsItemsRefreshed = false
    endfunction

    function click4 takes nothing returns nothing
        local integer i = GetPlayerId(GetTriggerPlayer())
        local integer k = i+1

        if GetPlayerState(Player(i), PLAYER_STATE_RESOURCE_GOLD) >= 100 and udg_roll[k] > 0 then
            set udg_roll[k] = udg_roll[k] - 1
            if udg_roll[k] <= 0 then
                if GetLocalPlayer() == GetTriggerPlayer() then
                    call BlzFrameSetVisible( refbk,false)
                endif
            endif
            call ItemsRefresh(k)
            
            call SetPlayerState( Player(i), PLAYER_STATE_RESOURCE_GOLD, IMaxBJ( 0, GetPlayerState( Player(i), PLAYER_STATE_RESOURCE_GOLD) - 100 ) )
        endif
    endfunction

    //Start fight
    function click takes nothing returns nothing
        local player p = GetTriggerPlayer()
        local integer i = GetPlayerId(p) + 1
        local string icon

        if GetLocalPlayer() == p then
            call BlzFrameSetVisible( butbk,false)
            call BlzFrameSetVisible( butbk,true)
            call BlzFrameSetVisible( arrowframe, false )
        endif
            
        if not(udg_fightlogic[i]) then
            call BlzFrameSetTexture( iconframe[i], "ReplaceableTextures\\CommandButtons\\BTNDivineIntervention.blp", 0, true )
            set udg_fightlogic[i] = true
            set udg_Player_Readiness = udg_Player_Readiness + 1
            if GetLocalPlayer() == p then
                call BlzFrameSetTexture(butbk, "ReplaceableTextures\\CommandButtons\\BTNSteelMelee.blp", 0, true)
            endif
            call RemoveItems( i )
            if udg_Player_Readiness >= udg_Heroes_Amount then
                call BlzFrameSetVisible( rpkmod,false)
                call TriggerExecute( gg_trg_StartFight )
            endif
        else
            call BlzFrameSetTexture( iconframe[i], "ReplaceableTextures\\CommandButtons\\BTNDivineShieldOff.blp", 0, true )
            set udg_fightlogic[i] = false
            set udg_Player_Readiness = udg_Player_Readiness - 1
            if GetLocalPlayer() == p then
                call BlzFrameSetTexture(butbk, "ReplaceableTextures\\CommandButtons\\BTNArcaniteMelee.blp", 0, true)
            endif
        endif
        
        set p = null
    endfunction

    //Repick
    function buttonmod1 takes nothing returns nothing
        call Repick( GetTriggerPlayer() )
    endfunction

    //Jule pick
    function JulePick takes nothing returns nothing
        local player p = GetTriggerPlayer()

        if GetLocalPlayer() == p then
            call BlzFrameSetVisible( juleIcon,false)
            call BlzFrameSetVisible( juleIcon,true)
        endif
        
        if not(IsUnitHiddenBJ(gg_unit_h01G_0201)) then
            call SelectUnitForPlayerSingle( gg_unit_h01G_0201, p )
        endif
        
        set p = null
    endfunction

    function Trig_BaseTooltip_Actions takes nothing returns nothing
        local trigger trig
        local framehandle h
        local framehandle tooltip
        local string text
        local integer cyclA = 1
        local real i

        set fon = BlzCreateFrame("EscMenuBackdrop", BlzGetOriginFrame(ORIGIN_FRAME_GAME_UI, 0), 0, 0)
        call BlzFrameSetAbsPoint(fon, FRAMEPOINT_CENTER, 0.398, 0.16)
        call BlzFrameSetSize(fon, 0.22, 0.075)
        call BlzFrameSetLevel( fon, -1 )
        loop
            exitwhen cyclA > 4
            if cyclA < 3 then
                set i = 0
            else
                set i = 0.06
            endif
            set iconframe[cyclA] = BlzCreateFrameByType("BACKDROP", "", fon, "StandartFrameTemplate", 0)
            call BlzFrameSetAbsPoint(iconframe[cyclA], FRAMEPOINT_CENTER, 0.22 + (0.06*cyclA) + i, 0.55)	
            call BlzFrameSetSize(iconframe[cyclA], 0.04, 0.04)
            call BlzFrameSetVisible( iconframe[cyclA],false)
            
            if GetPlayerSlotState(Player(cyclA-1)) == PLAYER_SLOT_STATE_PLAYING then
                call BlzFrameSetTexture( iconframe[cyclA], "ReplaceableTextures\\CommandButtons\\BTNDivineShieldOff.blp", 0, true )
            
                set faceframe[cyclA] = BlzCreateFrameByType("BACKDROP", "", fon, "StandartFrameTemplate", 0)
                call BlzFrameSetTexture( faceframe[cyclA], "ReplaceableTextures\\CommandButtons\\BTNSelectHeroOn.blp", 0, true )
                call BlzFrameSetAbsPoint(faceframe[cyclA], FRAMEPOINT_CENTER, 0.22 + (0.06*cyclA) + i, 0.53)
                call BlzFrameSetSize(faceframe[cyclA], 0.02, 0.02)
                call BlzFrameSetLevel( faceframe[cyclA], 1 )
                call BlzFrameSetVisible( faceframe[cyclA],false)
            
                set uniqframe[cyclA] = BlzCreateFrameByType("BACKDROP", "", fon, "StandartFrameTemplate", 0)
                call BlzFrameSetAbsPoint(uniqframe[cyclA], FRAMEPOINT_CENTER, 0.20 + (0.06*cyclA) + i, 0.53)	
                call BlzFrameSetSize(uniqframe[cyclA], 0.015, 0.015)
                call BlzFrameSetLevel( uniqframe[cyclA], 1 )
                call BlzFrameSetVisible( uniqframe[cyclA],false)

                set specframe[cyclA] = BlzCreateFrameByType("BACKDROP", "", fon, "StandartFrameTemplate", 0)
                call BlzFrameSetAbsPoint(specframe[cyclA], FRAMEPOINT_CENTER, 0.24 + (0.06*cyclA) + i, 0.53)	
                call BlzFrameSetSize(specframe[cyclA], 0.015, 0.015)
                call BlzFrameSetLevel( specframe[cyclA], 1 )
                call BlzFrameSetVisible( specframe[cyclA],false)
            else
                call BlzFrameSetTexture( iconframe[cyclA], "war3mapImported\\BTNDivineShieldOff-Reforged.blp", 0, true )
            endif
            set cyclA = cyclA + 1
        endloop
        //Jule icon
        set juleIcon = BlzCreateFrameByType("BACKDROP", "", fon, "StandartFrameTemplate", 0)
        call BlzFrameSetAbsPoint(juleIcon, FRAMEPOINT_CENTER, 0.4, 0.54)	
        call BlzFrameSetSize(juleIcon, 0.02, 0.02)
        call BlzFrameSetVisible( juleIcon,false)
        call BlzFrameSetTexture( juleIcon, "ReplaceableTextures\\CommandButtons\\BTNDarkTroll.blp", 0, true )
            
        set h = BlzCreateFrameByType("GLUEBUTTON", "", juleIcon, "ScoreScreenTabButtonTemplate", 0)
        call BlzFrameSetSize( h, 0.02, 0.02 )
        call BlzFrameSetPoint(h, FRAMEPOINT_CENTER, juleIcon, FRAMEPOINT_CENTER, 0.0,0.0)
        set trig = CreateTrigger()
        call BlzTriggerRegisterFrameEvent(trig, h, FRAMEEVENT_CONTROL_CLICK)
        call TriggerAddAction(trig, function JulePick)

        call SetStableTool( h, "Jule", "Opens a window from the Jule store." )

        //Readiness button
        set butbk = BlzCreateFrameByType("BACKDROP", "", fon, "StandartFrameTemplate", 0)
        call BlzFrameSetSize(butbk, 0.04, 0.04)
        call BlzFrameSetTexture(butbk, "ReplaceableTextures\\CommandButtons\\BTNArcaniteMelee.blp", 0, true)
        call BlzFrameSetLevel( butbk, -1 )
        
        set h = BlzCreateFrameByType("GLUEBUTTON", "", butbk, "ScoreScreenTabButtonTemplate", 0)
        call BlzFrameSetSize( h, 0.04, 0.04 )
        call BlzFrameSetPoint( h, FRAMEPOINT_CENTER, fon, FRAMEPOINT_CENTER, 0.0, 0.0 )
        call BlzFrameSetPoint(butbk, FRAMEPOINT_CENTER, h, FRAMEPOINT_CENTER, 0.0,0.0)
        
        set trig = CreateTrigger()
        call BlzTriggerRegisterFrameEvent(trig, h, FRAMEEVENT_CONTROL_CLICK)
        call TriggerAddAction(trig, function click)
        
        set text = "You confirm your readiness. You will begin the battle when all players confirm their readiness.\n\n|cffffcc00If you do not select an artifact-reward, these artifacts will disappear.|r"
        call SetStableTool( h, "Readiness", text )

        //Refuse button
        set sklbk = BlzCreateFrameByType("BACKDROP", "", fon, "StandartFrameTemplate", 0)
        call BlzFrameSetSize(sklbk, 0.04, 0.04)
        call BlzFrameSetTexture(sklbk, "ReplaceableTextures\\CommandButtons\\BTNSacrificialSkull.blp", 0, true)
        call BlzFrameSetLevel( sklbk, -1 )
        
        set h = BlzCreateFrameByType("GLUEBUTTON", "", sklbk, "ScoreScreenTabButtonTemplate", 0)
        call BlzFrameSetSize( h, 0.04, 0.04 )
        call BlzFrameSetPoint( h, FRAMEPOINT_CENTER, fon, FRAMEPOINT_CENTER, 0.05, 0.0 )
        call BlzFrameSetPoint(sklbk, FRAMEPOINT_CENTER, h, FRAMEPOINT_CENTER, 0.0,0.0)
        set trig = CreateTrigger()
        call BlzTriggerRegisterFrameEvent(trig, h, FRAMEEVENT_CONTROL_CLICK)
        call TriggerAddAction(trig, function click1)
        
        set text = "You refuse artifacts in the room. You can’t pick them up, but you can use the exchanger and arenas at Cute Bob."
        call SetStableTool( h, "Refuse artifacts", text )

        //Data button
        set scrbk = BlzCreateFrameByType("BACKDROP", "", fon, "StandartFrameTemplate", 0)
        call BlzFrameSetSize(scrbk, 0.04, 0.04)
        call BlzFrameSetTexture(scrbk, "ReplaceableTextures\\CommandButtons\\BTNBansheeMaster.blp", 0, true)
        call BlzFrameSetLevel( scrbk, -1 )

        set h = BlzCreateFrameByType("GLUEBUTTON", "", scrbk, "ScoreScreenTabButtonTemplate", 0)
        call BlzFrameSetSize( h, 0.04, 0.04 )
        call BlzFrameSetPoint( h, FRAMEPOINT_CENTER, fon, FRAMEPOINT_CENTER, -0.05, 0.0 )
        call BlzFrameSetPoint(scrbk, FRAMEPOINT_CENTER, h, FRAMEPOINT_CENTER, 0.0,0.0)
        set trig = CreateTrigger()
        call BlzTriggerRegisterFrameEvent(trig, h, FRAMEEVENT_CONTROL_CLICK)
        call TriggerAddAction(trig, function click2)
        
        set text = "Shows changes in all data of the hero per match."
        call SetStableTool( h, "Data", text )

        //Duel button
        set pvpbk = BlzCreateFrameByType("BACKDROP", "", fon, "StandartFrameTemplate", 0)
        call BlzFrameSetSize(pvpbk, 0.04, 0.04)
        call BlzFrameSetTexture(pvpbk, "ReplaceableTextures\\CommandButtons\\BTNMassTeleport.blp", 0, true)
        call BlzFrameSetLevel( pvpbk, -1 )

        set h = BlzCreateFrameByType("GLUEBUTTON", "", pvpbk, "ScoreScreenTabButtonTemplate", 0)
        call BlzFrameSetSize( h, 0.04, 0.04 )
        call BlzFrameSetPoint( h, FRAMEPOINT_CENTER, fon, FRAMEPOINT_CENTER, 0.05, 0.0 )
        call BlzFrameSetPoint(pvpbk, FRAMEPOINT_CENTER, h, FRAMEPOINT_CENTER, 0.0,0.0)
        set trig = CreateTrigger()
        call BlzTriggerRegisterFrameEvent(trig, h, FRAMEEVENT_CONTROL_CLICK)
        call TriggerAddAction(trig, function PvPButton)

        set text = "Your hero may fight with another player. The match ends when one of the heroes dies or time runs out. The duration of the battles is 120 seconds.\n\n|cffffcc00Tries give the end of the battle with the boss.|r"
        call SetStableTool( h, "Duel", text )
        
        //Change artifact button
        set refbk = BlzCreateFrameByType("BACKDROP", "", fon, "StandartFrameTemplate", 0)
        call BlzFrameSetSize(refbk, 0.02, 0.02)
        call BlzFrameSetTexture(refbk, "war3mapImported\\BTNAchievement_BG_returnXflags_def_WSG.blp", 0, true)
        call BlzFrameSetLevel( refbk, -1 )
        
        set h = BlzCreateFrameByType("GLUEBUTTON", "", refbk, "ScoreScreenTabButtonTemplate", 0)
        call BlzFrameSetSize( h, 0.02, 0.02 )
        call BlzFrameSetPoint( h, FRAMEPOINT_TOPRIGHT, fon, FRAMEPOINT_TOPRIGHT, -0.018, -0.018 )
        call BlzFrameSetPoint(refbk, FRAMEPOINT_CENTER, h, FRAMEPOINT_CENTER, 0.0,0.0)
        set trig = CreateTrigger()
        call BlzTriggerRegisterFrameEvent(trig, h, FRAMEEVENT_CONTROL_CLICK)
        call TriggerAddAction(trig, function click4)

        set text = "Changes reward artifacts to other artifacts one time per selection.\n|cffffcc00Cost:|r 100 gold."
        call SetStableTool( h, "Change artifacts", text )

        //Hero reselection button
        set rpkmod = BlzCreateFrameByType("BACKDROP", "", BlzGetOriginFrame(ORIGIN_FRAME_GAME_UI, 0), "StandartFrameTemplate", 0)
        call BlzFrameSetSize(rpkmod, 0.04, 0.04)
        call BlzFrameSetTexture(rpkmod, "ReplaceableTextures\\CommandButtons\\BTNDispelMagic.blp", 0, true)
        
        set reselectionButton = BlzCreateFrameByType("GLUEBUTTON", "", rpkmod, "ScoreScreenTabButtonTemplate", 0)
        call BlzFrameSetSize( reselectionButton, 0.04, 0.04 )
        call BlzFrameSetPoint( rpkmod, FRAMEPOINT_CENTER, fon, FRAMEPOINT_CENTER, -0.05, 0.0 )
        call BlzFrameSetPoint(reselectionButton, FRAMEPOINT_CENTER, rpkmod, FRAMEPOINT_CENTER, 0.0,0.0)
        
        set trig = CreateTrigger()
        call BlzTriggerRegisterFrameEvent(trig, reselectionButton, FRAMEEVENT_CONTROL_CLICK)
        call TriggerAddAction(trig, function buttonmod1)
        
        call SetStableTool( reselectionButton, "Re-selection", "Allows you to choose another hero." )
        call BlzFrameSetVisible( rpkmod,false)
        call BlzFrameSetVisible( fon,false)
        call BlzFrameSetVisible( sklbk, false )
        call BlzFrameSetVisible( scrbk, false )
        call BlzFrameSetVisible( pvpbk, false )
        call BlzFrameSetVisible( refbk, false )

        set trig = null
        set tooltip = null
        set h = null
    endfunction

    //===========================================================================
    private function init takes nothing returns nothing
        call TimerStart( CreateTimer(), 0.1, false, function Trig_BaseTooltip_Actions )
    endfunction

endscope