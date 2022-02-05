scope JuleFrame initializer init

    globals
        private constant real SIZE = 1

        framehandle juleback
        framehandle juleextra1
        framehandle juleextra2
        framehandle julerefr
        framehandle julecont
        framehandle juleupgr
        framehandle bookOfOblivionCostText
        framehandle array juleicon[ROW_LIMIT_ARRAYS][COLUMN_LIMIT_ARRAYS]
        framehandle array julebut[ROW_LIMIT_ARRAYS][COLUMN_LIMIT_ARRAYS]
        framehandle array juletext[ROW_LIMIT_ARRAYS][COLUMN_LIMIT_ARRAYS]
        //framehandle array julename[ROW_LIMIT_ARRAYS][COLUMN_LIMIT_ARRAYS]
        //framehandle array juledisc[ROW_LIMIT_ARRAYS][COLUMN_LIMIT_ARRAYS]
        //framehandle array julediscback[ROW_LIMIT_ARRAYS][COLUMN_LIMIT_ARRAYS]
        
        boolean array julebool[ROW_LIMIT_ARRAYS][3]
        integer array julecost[ROW_LIMIT_ARRAYS][COLUMN_LIMIT_ARRAYS]
        
        integer julenum = 0
        private integer Index = 1
    endglobals
        
    /*function SetStableToolJule takes integer a, integer b, string name, string disc returns nothing
        set julediscback[a][b] = BlzCreateFrame( "QuestButtonBaseTemplate", julebut[a][b], 0, 0 )
        call BlzFrameSetAbsPoint(julediscback[a][b], FRAMEPOINT_BOTTOM, 0.7, 0.16)
        call BlzFrameSetTooltip( julebut[a][b], julediscback[a][b] )
        call BlzFrameSetSize( julediscback[a][b], 0.35, StringSizeStableTool(disc) )

        set julename[a][b] = BlzCreateFrameByType("TEXT", "",  julediscback[a][b], "StandartFrameTemplate", 0)
        call BlzFrameSetPoint( julename[a][b], FRAMEPOINT_TOPLEFT, julediscback[a][b], FRAMEPOINT_TOPLEFT, 0.008,-0.008) 
        call BlzFrameSetSize(julename[a][b], 0.25, StringSizeStableTool(disc)+0.05)
        call BlzFrameSetText( julename[a][b], name )

        set juledisc[a][b] = BlzCreateFrameByType("TEXT", "",  julediscback[a][b], "StandartFrameTemplate", 0)
        call BlzFrameSetPoint( juledisc[a][b], FRAMEPOINT_TOPLEFT, julediscback[a][b], FRAMEPOINT_TOPLEFT, 0.008,-0.023) 
        call BlzFrameSetSize(juledisc[a][b], 0.25, StringSizeStableTool(disc)+0.05)
        call BlzFrameSetText( juledisc[a][b], disc )
    endfunction*/

    function ButtonExitJule takes nothing returns nothing
        if GetLocalPlayer() == GetTriggerPlayer() then
            call BlzFrameSetVisible( juleback,false)
        endif
    endfunction

    function JuleAddItem takes unit u, integer index returns item
        set udg_it = CreateItem( index, GetUnitX(u), GetUnitY(u) )
        call SaveBoolean( udg_hash, GetHandleId( udg_it ), StringHash( "jule" ), true ) 
        return udg_it
    endfunction

    function JuleItemUse takes nothing returns nothing
        local player p = GetTriggerPlayer()
        local unit u = udg_hero[GetPlayerId(GetTriggerPlayer()) + 1]
        local integer cyclA
        local integer cyclB
        local integer f = 0
        
        if GetLocalPlayer() == p then
            call BlzFrameSetVisible( BlzGetTriggerFrame(),false)
            call BlzFrameSetVisible( BlzGetTriggerFrame(),true)
        endif
        
        if UnitInventoryCount(u) < 6 then
            set cyclB = 1
            loop
                exitwhen cyclB > 4
                set cyclA = 1
                loop
                    exitwhen cyclA > 4
                    set f = f + 1
                    if julebut[cyclA][cyclB] == BlzGetTriggerFrame() and GetPlayerState(p, PLAYER_STATE_RESOURCE_GOLD) >= julecost[cyclA][cyclB] and udg_JuleItem[f] != 0 then
                        call BlzFrameSetVisible( juleicon[cyclA][cyclB], false )
                        call SetPlayerState(p, PLAYER_STATE_RESOURCE_GOLD, IMaxBJ(0,GetPlayerState(p, PLAYER_STATE_RESOURCE_GOLD) - julecost[cyclA][cyclB]))
                        call UnitAddItem( u, JuleAddItem(u, udg_JuleItem[f]) )
                        set udg_JuleItem[f] = 0
                        set cyclA = 4
                        set cyclB = 4
                    endif
                    set cyclA = cyclA + 1
                endloop
                set cyclB = cyclB + 1
            endloop 
        endif

        set p = null
    endfunction

    function JuleRefresh takes nothing returns nothing
        local player p = GetTriggerPlayer()
        if GetLocalPlayer() == p then
            call BlzFrameSetVisible( BlzGetTriggerFrame(),false)
            call BlzFrameSetVisible( BlzGetTriggerFrame(),true)
        endif

        if GetPlayerState(p, PLAYER_STATE_RESOURCE_GOLD) >= 400 or udg_logic[42] then
            call JuleRef()
            if udg_logic[42] then
                set udg_logic[42] = false
                call BlzFrameSetText( juletext[1][0], "400 G" )
            else
                call SetPlayerState(p, PLAYER_STATE_RESOURCE_GOLD, IMaxBJ(0,GetPlayerState(p, PLAYER_STATE_RESOURCE_GOLD) - 400))
            endif
        endif
        set p = null
    endfunction

    function JuleContract takes nothing returns nothing
        local effect fx
        local player p = GetTriggerPlayer()
        
        if GetLocalPlayer() == p then
            call BlzFrameSetVisible( BlzGetTriggerFrame(),false)
            call BlzFrameSetVisible( BlzGetTriggerFrame(),true)
        endif
        if GetPlayerState(p, PLAYER_STATE_RESOURCE_GOLD) >= 125 then
            if not(udg_logic[99] ) then
                set udg_logic[99] = true
                set fx = AddSpecialEffectTarget( "Boomer Scroll SD.mdx", gg_unit_h01G_0201, "origin" )
                call BlzSetSpecialEffectScale( fx, 0.5 )
                call DestroyEffect( fx )
                call DisplayTimedTextToForce( bj_FORCE_ALL_PLAYERS, 10, "|cffffcc00Contract|r with Jule is signed." )
                call StartSound(gg_snd_QuestLog)	
                call SetPlayerState(p, PLAYER_STATE_RESOURCE_GOLD, IMaxBJ(0,GetPlayerState(p, PLAYER_STATE_RESOURCE_GOLD) - 125))
                call BlzFrameSetVisible( julecont, false )
            else
                call textst( "Already active", gg_unit_h01G_0201, 64, 90, 8, 1 )
            endif
        endif
        
        set fx = null
        set p = null
    endfunction

    function JuleUpgradeUse takes nothing returns nothing
        if julenum < 8 then
            set julenum = julenum + 1
            set JuleLib_Item_Name[8+julenum] = "Unlocked"
            set JuleLib_Item_Description[8+julenum] = "The artifact will be available for purchase here soon."
            if julenum > 4 then
                set julebool[julenum-4][2] = true
                call BlzFrameSetTexture( juleicon[julenum-4][4], "war3mapImported\\BTNfeed-icon-red-1_result.blp", 0, true )
            else
                set julebool[julenum][1] = true
                call BlzFrameSetTexture( juleicon[julenum][3], "war3mapImported\\BTNfeed-icon-red-1_result.blp", 0, true )
            endif
            if julenum < 8 then
                call BlzFrameSetText( juletext[0][0], I2S(300 + (100*julenum))+" G" )
            else
                call BlzFrameSetVisible( juleupgr,false)
            endif
            call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\Other\\Levelup\\LevelupCaster.mdl", GetUnitX( gg_unit_h01G_0201 ), GetUnitY( gg_unit_h01G_0201 ) ) )
            call DisplayTimedTextToForce( bj_FORCE_ALL_PLAYERS, 10, "|cffffcc00Jule|r has been upgraded." )
        endif
    endfunction

    private function JuleUpgrade takes nothing returns nothing
        local player p = GetTriggerPlayer()
        local integer cost = 300 + (100*julenum)
        
        if GetLocalPlayer() == p then
            call BlzFrameSetVisible( BlzGetTriggerFrame(),false)
            call BlzFrameSetVisible( BlzGetTriggerFrame(),true)
        endif
        
        if GetPlayerState(p, PLAYER_STATE_RESOURCE_GOLD) >= cost then
            call JuleUpgradeUse()
            call SetPlayerState(p, PLAYER_STATE_RESOURCE_GOLD, IMaxBJ(0,GetPlayerState(p, PLAYER_STATE_RESOURCE_GOLD) - cost))
        endif
        
        set p = null
    endfunction
    
    private function EnableTooltip takes nothing returns nothing
        local integer index = LoadInteger(udg_hash, GetHandleId(BlzGetTriggerFrame()), StringHash("index") )
 
        call Tooltip_SetLocalTooltipText(GetTriggerPlayer(), JuleLib_Item_Name[index], JuleLib_Item_Description[index])
    endfunction
    
    private function CreateJuleButton takes integer raw, integer column, framehandle parent, real x, real y, string name, string description returns nothing
        set julecost[raw][column] = 0
        set juleicon[raw][column] = BlzCreateFrameByType("BACKDROP", "", parent, "StandartFrameTemplate", 0)
        call BlzFrameSetSize( juleicon[raw][column], 0.035*SIZE, 0.035*SIZE )
        call BlzFrameSetPoint(juleicon[raw][column], FRAMEPOINT_TOP, parent, FRAMEPOINT_TOP, x, y)
        call BlzFrameSetTexture( juleicon[raw][column], "war3mapImported\\BTNIconLock.blp", 0, true )
        
        set julebut[raw][column] = BlzCreateFrameByType("GLUEBUTTON", "", juleicon[raw][column], "ScoreScreenTabButtonTemplate", 0)
        call BlzFrameSetSize( julebut[raw][column], 0.035*SIZE, 0.035*SIZE )
        call BlzFrameSetPoint(julebut[raw][column], FRAMEPOINT_CENTER, juleicon[raw][column], FRAMEPOINT_CENTER, 0,0)
        
        set JuleLib_Item_Name[Index] = name
        set JuleLib_Item_Description[Index] = description
        
        call Tooltip_AddMouseEvent( julebut[raw][column], function EnableTooltip, function JuleItemUse, Index )
        set Index = Index + 1
        
        set juletext[raw][column] = BlzCreateFrameByType("TEXT", "", juleicon[raw][column], "StandartFrameTemplate", 0)
        call BlzFrameSetSize( juletext[raw][column], 0.04*SIZE, 0.01*SIZE )
        call BlzFrameSetPoint(juletext[raw][column], FRAMEPOINT_TOP, juleicon[raw][column], FRAMEPOINT_TOP, 0.01*SIZE,-0.04*SIZE) 
        
        set parent = null
    endfunction
    
    private function Action takes nothing returns nothing
        local trigger trig
        local framehandle frameback
        local framehandle framebase
        local framehandle frame
        local integer cyclA
        local integer cyclB

        set cyclA = 1
        loop
            exitwhen cyclA > PLAYERS_LIMIT
            set Book_Of_Oblivion_Cost[cyclA] = BOOK_OF_OBLIVION_BASE_COST
            set cyclA = cyclA + 1
        endloop

        set juleback = BlzCreateFrame("QuestButtonBaseTemplate", BlzGetOriginFrame(ORIGIN_FRAME_GAME_UI, 0), 0, 0)
        call BlzFrameSetAbsPoint(juleback, FRAMEPOINT_TOPRIGHT, 0.75, 0.53)
        call BlzFrameSetSize(juleback, SIZE*0.27, SIZE*0.28)
        call BlzFrameSetVisible( juleback, false )
        call BlzFrameSetLevel( juleback, -1 )
        
        
        //=========Команды=========
        set frameback = BlzCreateFrame("QuestButtonBackdropTemplate", juleback, 0, 0)
        call BlzFrameSetPoint(frameback, FRAMEPOINT_TOPLEFT, juleback, FRAMEPOINT_TOPLEFT, 0.005*SIZE,-0.005*SIZE) 
        call BlzFrameSetSize(frameback, 0.06*SIZE, 0.27*SIZE)
        
        
        //Refresh
        set julerefr = BlzCreateFrameByType("BACKDROP", "", frameback, "StandartFrameTemplate", 0)
        call BlzFrameSetSize( julerefr, 0.035*SIZE, 0.035*SIZE )
        call BlzFrameSetPoint(julerefr, FRAMEPOINT_CENTER, frameback, FRAMEPOINT_TOP, 0*SIZE,-0.03*SIZE)
        call BlzFrameSetTexture( julerefr, "ReplaceableTextures\\CommandButtons\\BTNRiderlessKodo.blp", 0, true )
        
        set framebase = BlzCreateFrameByType("GLUEBUTTON", "", julerefr, "ScoreScreenTabButtonTemplate", 0)
        call BlzFrameSetSize( framebase, 0.035*SIZE, 0.035*SIZE )
        call BlzFrameSetPoint(framebase, FRAMEPOINT_CENTER, julerefr, FRAMEPOINT_CENTER, 0,0)
        
        set trig = CreateTrigger()
        call BlzTriggerRegisterFrameEvent(trig, framebase, FRAMEEVENT_CONTROL_CLICK)
        call TriggerAddAction(trig, function JuleRefresh)
        
        call SetStableTool( framebase, "Refresh goods", "Refresh the goods from Jule." )
        
        set juletext[1][0] = BlzCreateFrameByType("TEXT", "", framebase, "StandartFrameTemplate", 0)
        call BlzFrameSetSize( juletext[1][0], 0.03*SIZE, 0.01*SIZE )
        call BlzFrameSetPoint(juletext[1][0], FRAMEPOINT_TOP, framebase, FRAMEPOINT_TOP, 0,-0.04*SIZE) 
        call BlzFrameSetText( juletext[1][0], "400 G" )
        
        
        //Contract
        set julecont = BlzCreateFrameByType("BACKDROP", "", frameback, "StandartFrameTemplate", 0)
        call BlzFrameSetSize( julecont, 0.035*SIZE, 0.035*SIZE )
        call BlzFrameSetPoint(julecont, FRAMEPOINT_CENTER, frameback, FRAMEPOINT_BOTTOM, 0*SIZE,0.04*SIZE)
        call BlzFrameSetTexture( julecont, "ReplaceableTextures\\CommandButtons\\BTNScrollOfProtection.blp", 0, true )
        
        set framebase = BlzCreateFrameByType("GLUEBUTTON", "", julecont, "ScoreScreenTabButtonTemplate", 0)
        call BlzFrameSetSize( framebase, 0.035*SIZE, 0.035*SIZE )
        call BlzFrameSetPoint(framebase, FRAMEPOINT_CENTER, julecont, FRAMEPOINT_CENTER, 0,0)

        set trig = CreateTrigger()
        call BlzTriggerRegisterFrameEvent(trig, framebase, FRAMEEVENT_CONTROL_CLICK)
        call TriggerAddAction(trig, function JuleContract)
        
        call SetStableTool( framebase, "Contract", "Jule will not refresh artifacts after defeating a boss." )
        
        set juletext[2][0] = BlzCreateFrameByType("TEXT", "", framebase, "StandartFrameTemplate", 0)
        call BlzFrameSetSize( juletext[2][0], 0.03*SIZE, 0.01*SIZE )
        call BlzFrameSetPoint(juletext[2][0], FRAMEPOINT_TOP, framebase, FRAMEPOINT_TOP, 0,-0.04*SIZE) 
        call BlzFrameSetText( juletext[2][0], "125 G" )
        
        
        //Tome of Oblivion
        set frame = BlzCreateFrameByType("BACKDROP", "", frameback, "StandartFrameTemplate", 0)
        call BlzFrameSetSize( frame, 0.035*SIZE, 0.035*SIZE )
        call BlzFrameSetPoint(frame, FRAMEPOINT_CENTER, frameback, FRAMEPOINT_TOP, 0*SIZE,-0.08*SIZE)
        call BlzFrameSetTexture( frame, "ReplaceableTextures\\CommandButtons\\BTNTomeOfRetraining.blp", 0, true )
        
        set framebase = BlzCreateFrameByType("GLUEBUTTON", "", frame, "ScoreScreenTabButtonTemplate", 0)
        call BlzFrameSetSize( framebase, 0.035*SIZE, 0.035*SIZE )
        call BlzFrameSetPoint(framebase, FRAMEPOINT_CENTER, frame, FRAMEPOINT_CENTER, 0,0)

        set trig = CreateTrigger()
        call BlzTriggerRegisterFrameEvent(trig, framebase, FRAMEEVENT_CONTROL_CLICK)
        call TriggerAddAction(trig, function Book_Of_Oblivion)
        
        call SetStableTool( framebase, "Tome of Oblivion", "Forces the hero to forget all abilities and allows it to learn others." )
        
        set bookOfOblivionCostText = BlzCreateFrameByType("TEXT", "", framebase, "StandartFrameTemplate", 0)
        call BlzFrameSetSize( bookOfOblivionCostText, 0.03*SIZE, 0.01*SIZE )
        call BlzFrameSetPoint(bookOfOblivionCostText, FRAMEPOINT_TOP, framebase, FRAMEPOINT_TOP, 0,-0.04*SIZE) 
        call BlzFrameSetText( bookOfOblivionCostText, I2S(Book_Of_Oblivion_Cost[1]) + " G" )
        
        
        //Upgrade
        set juleupgr = BlzCreateFrameByType("BACKDROP", "", frameback, "StandartFrameTemplate", 0)
        call BlzFrameSetSize( juleupgr, 0.035*SIZE, 0.035*SIZE )
        call BlzFrameSetPoint(juleupgr, FRAMEPOINT_CENTER, frameback, FRAMEPOINT_BOTTOM, 0*SIZE,0.09*SIZE)
        call BlzFrameSetTexture( juleupgr, "ReplaceableTextures\\CommandButtons\\BTNCryptFiendUnBurrow.blp", 0, true )
        
        set framebase = BlzCreateFrameByType("GLUEBUTTON", "", juleupgr, "ScoreScreenTabButtonTemplate", 0)
        call BlzFrameSetSize( framebase, 0.035*SIZE, 0.035*SIZE )
        call BlzFrameSetPoint(framebase, FRAMEPOINT_CENTER, juleupgr, FRAMEPOINT_CENTER, 0,0)
        
        set trig = CreateTrigger()
        call BlzTriggerRegisterFrameEvent(trig, framebase, FRAMEEVENT_CONTROL_CLICK)
        call TriggerAddAction(trig, function JuleUpgrade)
        
        call SetStableTool( framebase, "Upgrade", "Improves the shop by increasing the assortment of artifacts." )
        
        set juletext[0][0] = BlzCreateFrameByType("TEXT", "", framebase, "StandartFrameTemplate", 0)
        call BlzFrameSetSize( juletext[0][0], 0.03*SIZE, 0.01*SIZE )
        call BlzFrameSetPoint(juletext[0][0], FRAMEPOINT_TOP, framebase, FRAMEPOINT_TOP, 0,-0.04*SIZE) 
        call BlzFrameSetText( juletext[0][0], "300 G" )
        
        
        //=========Основные предметы=========
        set framebase = BlzCreateFrame("QuestButtonBackdropTemplate", juleback, 0, 0)
        call BlzFrameSetPoint(framebase, FRAMEPOINT_TOPLEFT, juleback, FRAMEPOINT_TOPLEFT, 0.063*SIZE,-0.005*SIZE) 
        call BlzFrameSetSize(framebase, 0.2*SIZE, 0.13*SIZE)

        set cyclB = 1
        loop
            exitwhen cyclB > 2
            set cyclA = 1
            loop
                exitwhen cyclA > ROW_LIMIT
                call CreateJuleButton( cyclA, cyclB, framebase, (-0.115+(cyclA*0.045))*SIZE, (0.05+(-0.06*cyclB))*SIZE, "Locked", "Defeat the first boss to unlock." )
                set cyclA = cyclA + 1
            endloop
            set cyclB = cyclB + 1
        endloop 
        
        
        //=========Дополнительные предметы=========
        set juleextra1 = BlzCreateFrame("QuestButtonBackdropTemplate", juleback, 0, 0)
        call BlzFrameSetPoint(juleextra1, FRAMEPOINT_TOPLEFT, juleback, FRAMEPOINT_TOPLEFT, 0.063*SIZE,-0.135*SIZE) 
        call BlzFrameSetSize(juleextra1, 0.2*SIZE, 0.07*SIZE)
        
        set cyclA = 1
        loop
            exitwhen cyclA > ROW_LIMIT
                set julebool[cyclA][1] = false
                call CreateJuleButton( cyclA, 3, juleextra1, (-0.115+(cyclA*0.045))*SIZE,-0.01*SIZE, "Locked", "Upgrade this store to open." )
            set cyclA = cyclA + 1
        endloop 
        
        
        //=========Наборные предметы=========
        set juleextra2 = BlzCreateFrame("QuestButtonBackdropTemplate", juleback, 0, 0)
        call BlzFrameSetPoint(juleextra2, FRAMEPOINT_TOPLEFT, juleback, FRAMEPOINT_TOPLEFT, 0.063*SIZE,-0.205*SIZE) 
        call BlzFrameSetSize(juleextra2, 0.2*SIZE, 0.07*SIZE)
        
        set cyclA = 1
        loop
            exitwhen cyclA > ROW_LIMIT
                set julebool[cyclA][2] = false
                call CreateJuleButton( cyclA, 4, juleextra2, (-0.115+(cyclA*0.045))*SIZE,-0.01*SIZE, "Locked", "Upgrade this store to open." )
            set cyclA = cyclA + 1
        endloop 
        
        
        //=========Выключение=========
        set framebase = BlzCreateFrameByType("BACKDROP", "", juleback, "StandartFrameTemplate", 0)
        call BlzFrameSetSize(framebase, 0.022, 0.022)
        call BlzFrameSetPoint( framebase, FRAMEPOINT_CENTER, juleback, FRAMEPOINT_TOPRIGHT, -0.008, -0.008 )
        call BlzFrameSetTexture(framebase, "war3mapImported\\BTNExit.blp", 0, true)
        
        set frame = BlzCreateFrameByType("GLUEBUTTON", "", juleback, "ScoreScreenTabButtonTemplate", 0)
        call BlzFrameSetSize( frame, 0.025, 0.025 )
        call BlzFrameSetPoint( frame, FRAMEPOINT_CENTER, framebase, FRAMEPOINT_CENTER, 0, 0 )
        
        set trig = CreateTrigger()
        call BlzTriggerRegisterFrameEvent(trig, frame, FRAMEEVENT_CONTROL_CLICK)
        call TriggerAddAction(trig, function ButtonExitJule)
        
        set trig = null
        set frame = null
        set framebase = null
    endfunction

    //===========================================================================
    private function init takes nothing returns nothing
        call TimerStart(CreateTimer(), 0.05, false, function Action)
    endfunction

endscope