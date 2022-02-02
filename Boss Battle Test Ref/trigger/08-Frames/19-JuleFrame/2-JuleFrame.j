globals
    framehandle juleback
    framehandle juleextra1
    framehandle juleextra2
    framehandle julerefr
    framehandle julecont
    framehandle juleupgr
    framehandle bookOfOblivionCostText
    framehandle array juleicon[5][5]
    framehandle array julebut[5][5]
    framehandle array juletext[5][5]
    framehandle array julename[5][5]
    framehandle array juledisc[5][5]
    framehandle array julediscback[5][5]
    integer julenum = 0
    boolean array julebool[5][3]
    integer array julecost[5][5]
    
    integer array Book_Of_Oblivion_Cost[5]
    constant integer BOOK_OF_OBLIVION_BASE_COST = 150
endglobals

function SetStableToolJule takes integer a, integer b, string name, string disc returns nothing
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
endfunction

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
        if julenum > 4 then
            set julebool[julenum-4][2] = true
            call BlzFrameSetTexture( juleicon[julenum-4][4], "war3mapImported\\BTNfeed-icon-red-1_result.blp", 0, true )
            call BlzFrameSetText( julename[julenum-4][4], "Unlocked" )
            call BlzFrameSetText( juledisc[julenum-4][4], "The artifact will be available for purchase here soon." )
        else
            set julebool[julenum][1] = true
            call BlzFrameSetTexture( juleicon[julenum][3], "war3mapImported\\BTNfeed-icon-red-1_result.blp", 0, true )
            call BlzFrameSetText( julename[julenum][3], "Unlocked" )
            call BlzFrameSetText( juledisc[julenum][3], "The artifact will be available for purchase here soon." )
        endif
        if julenum < 8 then
            call BlzFrameSetText( juletext[3][0], I2S(300 + (100*julenum))+" G" )
        else
            call BlzFrameSetVisible( juleupgr,false)
        endif
        call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\Other\\Levelup\\LevelupCaster.mdl", GetUnitX( gg_unit_h01G_0201 ), GetUnitY( gg_unit_h01G_0201 ) ) )
        call DisplayTimedTextToForce( bj_FORCE_ALL_PLAYERS, 10, "|cffffcc00Jule|r has been upgraded." )
    endif
endfunction

function JuleUpgrade takes nothing returns nothing
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

function Book_Of_Oblivion takes nothing returns nothing
    local player p = GetTriggerPlayer()
    local integer index = GetPlayerId(GetTriggerPlayer()) + 1
    local integer cost = Book_Of_Oblivion_Cost[index]
    local unit hero = udg_hero[index]
    
    if GetLocalPlayer() == p then
        call BlzFrameSetVisible( BlzGetTriggerFrame(),false)
		call BlzFrameSetVisible( BlzGetTriggerFrame(),true)
	endif
    
    if hero == null then
        return
    endif
    
    if GetPlayerState(p, PLAYER_STATE_RESOURCE_GOLD) >= cost then
        call UnitAddItem( hero, CreateItem( 'I03S', GetUnitX(hero), GetUnitY(hero) ) )
        call SetPlayerState(p, PLAYER_STATE_RESOURCE_GOLD, IMaxBJ(0,GetPlayerState(p, PLAYER_STATE_RESOURCE_GOLD) - cost))
    endif
    
    set p = null
    set hero = null
endfunction

library BookOfOblivion
    public function Change_Cost takes player whichPlayer, integer newCost returns nothing
        local integer index = GetPlayerId(whichPlayer) + 1
        set Book_Of_Oblivion_Cost[index] = newCost
        
        if GetLocalPlayer() == whichPlayer then
            call BlzFrameSetText( bookOfOblivionCostText, I2S(newCost) + " G" )
        endif
    endfunction
endlibrary

function Trig_JuleFrame_Actions takes nothing returns nothing
    local trigger trig
    local real x = 1
    local real y = 1
    local framehandle frameback
    local framehandle framebase
    local framehandle frame
    local integer cyclA
    local integer cyclB

    set cyclA = 1
    loop
        exitwhen cyclA > 4
        set Book_Of_Oblivion_Cost[cyclA] = BOOK_OF_OBLIVION_BASE_COST
        set cyclA = cyclA + 1
    endloop

    set juleback = BlzCreateFrame("QuestButtonBaseTemplate", BlzGetOriginFrame(ORIGIN_FRAME_GAME_UI, 0), 0, 0)
    //call BlzFrameSetAbsPoint(juleback, FRAMEPOINT_CENTER, 0.4, 0.38)
    call BlzFrameSetAbsPoint(juleback, FRAMEPOINT_TOPRIGHT, 0.75, 0.53)
    call BlzFrameSetSize(juleback, x*0.27, y*0.28)
    call BlzFrameSetVisible( juleback, false )
    call BlzFrameSetLevel( juleback, -1 )
    
    //=========Команды=========
    set frameback = BlzCreateFrame("QuestButtonBackdropTemplate", juleback, 0, 0)
    call BlzFrameSetPoint(frameback, FRAMEPOINT_TOPLEFT, juleback, FRAMEPOINT_TOPLEFT, 0.005*x,-0.005*y) 
    call BlzFrameSetSize(frameback, 0.06*x, 0.27*y)
    
    //Refresh
    set julerefr = BlzCreateFrameByType("BACKDROP", "", frameback, "StandartFrameTemplate", 0)
    call BlzFrameSetSize( julerefr, 0.035*x, 0.035*y )
    call BlzFrameSetPoint(julerefr, FRAMEPOINT_CENTER, frameback, FRAMEPOINT_TOP, 0*x,-0.03*y)
    call BlzFrameSetTexture( julerefr, "ReplaceableTextures\\CommandButtons\\BTNRiderlessKodo.blp", 0, true )
    
    set framebase = BlzCreateFrameByType("GLUEBUTTON", "", julerefr, "ScoreScreenTabButtonTemplate", 0)
    call BlzFrameSetSize( framebase, 0.035*x, 0.035*y )
    call BlzFrameSetPoint(framebase, FRAMEPOINT_CENTER, julerefr, FRAMEPOINT_CENTER, 0,0)
    
    set trig = CreateTrigger()
    call BlzTriggerRegisterFrameEvent(trig, framebase, FRAMEEVENT_CONTROL_CLICK)
    call TriggerAddAction(trig, function JuleRefresh)
    
    call SetStableTool( framebase, "Refresh goods", "Refresh the goods from Jule." )
    
    set juletext[1][0] = BlzCreateFrameByType("TEXT", "", framebase, "StandartFrameTemplate", 0)
    call BlzFrameSetSize( juletext[1][0], 0.03*x, 0.01*y )
    call BlzFrameSetPoint(juletext[1][0], FRAMEPOINT_TOP, framebase, FRAMEPOINT_TOP, 0,-0.04*y) 
    call BlzFrameSetText( juletext[1][0], "400 G" )
    
    //Contract
    set julecont = BlzCreateFrameByType("BACKDROP", "", frameback, "StandartFrameTemplate", 0)
    call BlzFrameSetSize( julecont, 0.035*x, 0.035*y )
    call BlzFrameSetPoint(julecont, FRAMEPOINT_CENTER, frameback, FRAMEPOINT_BOTTOM, 0*x,0.04*y)
    call BlzFrameSetTexture( julecont, "ReplaceableTextures\\CommandButtons\\BTNScrollOfProtection.blp", 0, true )
    
    set framebase = BlzCreateFrameByType("GLUEBUTTON", "", julecont, "ScoreScreenTabButtonTemplate", 0)
    call BlzFrameSetSize( framebase, 0.035*x, 0.035*y )
    call BlzFrameSetPoint(framebase, FRAMEPOINT_CENTER, julecont, FRAMEPOINT_CENTER, 0,0)

    set trig = CreateTrigger()
    call BlzTriggerRegisterFrameEvent(trig, framebase, FRAMEEVENT_CONTROL_CLICK)
    call TriggerAddAction(trig, function JuleContract)
    
    call SetStableTool( framebase, "Contract", "Jule will not refresh artifacts after defeating a boss." )
    
    set juletext[2][0] = BlzCreateFrameByType("TEXT", "", framebase, "StandartFrameTemplate", 0)
    call BlzFrameSetSize( juletext[2][0], 0.03*x, 0.01*y )
    call BlzFrameSetPoint(juletext[2][0], FRAMEPOINT_TOP, framebase, FRAMEPOINT_TOP, 0,-0.04*y) 
    call BlzFrameSetText( juletext[2][0], "125 G" )
    
    
    //Tome of Oblivion
    set frame = BlzCreateFrameByType("BACKDROP", "", frameback, "StandartFrameTemplate", 0)
    call BlzFrameSetSize( frame, 0.035*x, 0.035*y )
    call BlzFrameSetPoint(frame, FRAMEPOINT_CENTER, frameback, FRAMEPOINT_TOP, 0*x,-0.08*y)
    call BlzFrameSetTexture( frame, "ReplaceableTextures\\CommandButtons\\BTNTomeOfRetraining.blp", 0, true )
    
    set framebase = BlzCreateFrameByType("GLUEBUTTON", "", frame, "ScoreScreenTabButtonTemplate", 0)
    call BlzFrameSetSize( framebase, 0.035*x, 0.035*y )
    call BlzFrameSetPoint(framebase, FRAMEPOINT_CENTER, frame, FRAMEPOINT_CENTER, 0,0)

    set trig = CreateTrigger()
    call BlzTriggerRegisterFrameEvent(trig, framebase, FRAMEEVENT_CONTROL_CLICK)
    call TriggerAddAction(trig, function Book_Of_Oblivion)
    
    call SetStableTool( framebase, "Tome of Oblivion", "Forces the hero to forget all abilities and allows it to learn others." )
    
    set bookOfOblivionCostText = BlzCreateFrameByType("TEXT", "", framebase, "StandartFrameTemplate", 0)
    call BlzFrameSetSize( bookOfOblivionCostText, 0.03*x, 0.01*y )
    call BlzFrameSetPoint(bookOfOblivionCostText, FRAMEPOINT_TOP, framebase, FRAMEPOINT_TOP, 0,-0.04*y) 
    call BlzFrameSetText( bookOfOblivionCostText, I2S(Book_Of_Oblivion_Cost[1]) + " G" )
    
    
    //Upgrade
    set juleupgr = BlzCreateFrameByType("BACKDROP", "", frameback, "StandartFrameTemplate", 0)
    call BlzFrameSetSize( juleupgr, 0.035*x, 0.035*y )
    call BlzFrameSetPoint(juleupgr, FRAMEPOINT_CENTER, frameback, FRAMEPOINT_BOTTOM, 0*x,0.09*y)
    call BlzFrameSetTexture( juleupgr, "ReplaceableTextures\\CommandButtons\\BTNCryptFiendUnBurrow.blp", 0, true )
    
    set framebase = BlzCreateFrameByType("GLUEBUTTON", "", juleupgr, "ScoreScreenTabButtonTemplate", 0)
    call BlzFrameSetSize( framebase, 0.035*x, 0.035*y )
    call BlzFrameSetPoint(framebase, FRAMEPOINT_CENTER, juleupgr, FRAMEPOINT_CENTER, 0,0)
    
    set trig = CreateTrigger()
    call BlzTriggerRegisterFrameEvent(trig, framebase, FRAMEEVENT_CONTROL_CLICK)
    call TriggerAddAction(trig, function JuleUpgrade)
    
    call SetStableTool( framebase, "Upgrade", "Improves the shop by increasing the assortment of artifacts." )
    
    set juletext[3][0] = BlzCreateFrameByType("TEXT", "", framebase, "StandartFrameTemplate", 0)
    call BlzFrameSetSize( juletext[3][0], 0.03*x, 0.01*y )
    call BlzFrameSetPoint(juletext[3][0], FRAMEPOINT_TOP, framebase, FRAMEPOINT_TOP, 0,-0.04*y) 
    call BlzFrameSetText( juletext[3][0], "300 G" )
    
    //=========Основные предметы=========
    set framebase = BlzCreateFrame("QuestButtonBackdropTemplate", juleback, 0, 0)
    call BlzFrameSetPoint(framebase, FRAMEPOINT_TOPLEFT, juleback, FRAMEPOINT_TOPLEFT, 0.063*x,-0.005*y) 
    call BlzFrameSetSize(framebase, 0.2*x, 0.13*y)
    
    set cyclA = 1
    loop
        exitwhen cyclA > 4
        set Book_Of_Oblivion_Cost[cyclA] = 150
        set cyclB = 1
        loop
            exitwhen cyclB > 2
            set julecost[cyclA][cyclB] = 0

            set juleicon[cyclA][cyclB] = BlzCreateFrameByType("BACKDROP", "", framebase, "StandartFrameTemplate", 0)
            call BlzFrameSetSize( juleicon[cyclA][cyclB], 0.035*x, 0.035*y )
            call BlzFrameSetPoint(juleicon[cyclA][cyclB], FRAMEPOINT_TOP, framebase, FRAMEPOINT_TOP, (-0.115+(cyclA*0.045))*x,(0.05+(-0.06*cyclB))*y)
            
            set julebut[cyclA][cyclB] = BlzCreateFrameByType("GLUEBUTTON", "", juleicon[cyclA][cyclB], "ScoreScreenTabButtonTemplate", 0)
            call BlzFrameSetSize( julebut[cyclA][cyclB], 0.035*x, 0.035*y )
            call BlzFrameSetPoint(julebut[cyclA][cyclB], FRAMEPOINT_CENTER, juleicon[cyclA][cyclB], FRAMEPOINT_CENTER, 0,0)
            
            set trig = CreateTrigger()
            call BlzTriggerRegisterFrameEvent(trig, julebut[cyclA][cyclB], FRAMEEVENT_CONTROL_CLICK)
            call TriggerAddAction(trig, function JuleItemUse)
            
            call SetStableToolJule( cyclA, cyclB, "", "" )
            
            set juletext[cyclA][cyclB] = BlzCreateFrameByType("TEXT", "", juleicon[cyclA][cyclB], "StandartFrameTemplate", 0)
            call BlzFrameSetSize( juletext[cyclA][cyclB], 0.04*x, 0.01*y )
            call BlzFrameSetPoint(juletext[cyclA][cyclB], FRAMEPOINT_TOP, juleicon[cyclA][cyclB], FRAMEPOINT_TOP, 0.01*x,-0.04*y) 
            
            call BlzFrameSetVisible( juleicon[cyclA][cyclB], false )
            set cyclB = cyclB + 1
        endloop
        set cyclA = cyclA + 1
    endloop 
    
    //=========Дополнительные предметы=========
    set juleextra1 = BlzCreateFrame("QuestButtonBackdropTemplate", juleback, 0, 0)
    call BlzFrameSetPoint(juleextra1, FRAMEPOINT_TOPLEFT, juleback, FRAMEPOINT_TOPLEFT, 0.063*x,-0.135*y) 
    call BlzFrameSetSize(juleextra1, 0.2*x, 0.07*y)
    
    set cyclA = 1
    loop
        exitwhen cyclA > 4
            set julebool[cyclA][1] = false
            set julecost[cyclA][3] = 0
            set juleicon[cyclA][3] = BlzCreateFrameByType("BACKDROP", "", juleextra1, "StandartFrameTemplate", 0)
            call BlzFrameSetSize( juleicon[cyclA][3], 0.035*x, 0.035*y )
            call BlzFrameSetPoint(juleicon[cyclA][3], FRAMEPOINT_TOP, juleextra1, FRAMEPOINT_TOP, (-0.115+(cyclA*0.045))*x,-0.01*y)
            call BlzFrameSetTexture( juleicon[cyclA][3], "war3mapImported\\BTNIconLock.blp", 0, true )
            
            set julebut[cyclA][3] = BlzCreateFrameByType("GLUEBUTTON", "", juleicon[cyclA][3], "ScoreScreenTabButtonTemplate", 0)
            call BlzFrameSetSize( julebut[cyclA][3], 0.035*x, 0.035*y )
            call BlzFrameSetPoint(julebut[cyclA][3], FRAMEPOINT_CENTER, juleicon[cyclA][3], FRAMEPOINT_CENTER, 0,0)
            
            set trig = CreateTrigger()
            call BlzTriggerRegisterFrameEvent(trig, julebut[cyclA][3], FRAMEEVENT_CONTROL_CLICK)
            call TriggerAddAction(trig, function JuleItemUse)
            
            call SetStableToolJule( cyclA, 3, "Locked", "Upgrade this store to open." )
            
            set juletext[cyclA][3] = BlzCreateFrameByType("TEXT", "", juleicon[cyclA][3], "StandartFrameTemplate", 0)
            call BlzFrameSetSize( juletext[cyclA][3], 0.04*x, 0.01*y )
            call BlzFrameSetPoint(juletext[cyclA][3], FRAMEPOINT_TOP, juleicon[cyclA][3], FRAMEPOINT_TOP, 0.01*x,-0.04*y) 

            //call BlzFrameSetVisible( juleicon[cyclA][3], false )
        set cyclA = cyclA + 1
    endloop 
    
    //=========Наборные предметы=========
    set juleextra2 = BlzCreateFrame("QuestButtonBackdropTemplate", juleback, 0, 0)
    call BlzFrameSetPoint(juleextra2, FRAMEPOINT_TOPLEFT, juleback, FRAMEPOINT_TOPLEFT, 0.063*x,-0.205*y) 
    call BlzFrameSetSize(juleextra2, 0.2*x, 0.07*y)
    
    set cyclA = 1
    loop
        exitwhen cyclA > 4
            set julebool[cyclA][2] = false
            set julecost[cyclA][4] = 0
            set juleicon[cyclA][4] = BlzCreateFrameByType("BACKDROP", "", juleextra2, "StandartFrameTemplate", 0)
            call BlzFrameSetSize( juleicon[cyclA][4], 0.035*x, 0.035*y )
            call BlzFrameSetPoint(juleicon[cyclA][4], FRAMEPOINT_TOP, juleextra2, FRAMEPOINT_TOP, (-0.115+(cyclA*0.045))*x,-0.01*y)
            call BlzFrameSetTexture( juleicon[cyclA][4], "war3mapImported\\BTNIconLock.blp", 0, true )
            
            set julebut[cyclA][4] = BlzCreateFrameByType("GLUEBUTTON", "", juleicon[cyclA][4], "ScoreScreenTabButtonTemplate", 0)
            call BlzFrameSetSize( julebut[cyclA][4], 0.035*x, 0.035*y )
            call BlzFrameSetPoint(julebut[cyclA][4], FRAMEPOINT_CENTER, juleicon[cyclA][4], FRAMEPOINT_CENTER, 0,0)
            
            set trig = CreateTrigger()
            call BlzTriggerRegisterFrameEvent(trig, julebut[cyclA][4], FRAMEEVENT_CONTROL_CLICK)
            call TriggerAddAction(trig, function JuleItemUse)
            
            call SetStableToolJule( cyclA, 4, "Locked", "Upgrade this store to open." )
            
            set juletext[cyclA][4] = BlzCreateFrameByType("TEXT", "", juleicon[cyclA][4], "StandartFrameTemplate", 0)
            call BlzFrameSetSize( juletext[cyclA][4], 0.04*x, 0.01*y )
            call BlzFrameSetPoint(juletext[cyclA][4], FRAMEPOINT_TOP, juleicon[cyclA][4], FRAMEPOINT_TOP, 0.01*x,-0.04*y) 

            //call BlzFrameSetVisible( juleicon[cyclA][4], false )
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
function InitTrig_JuleFrame takes nothing returns nothing
    set gg_trg_JuleFrame = CreateTrigger(  )
    call TriggerRegisterTimerExpireEvent( gg_trg_JuleFrame, udg_StartTimer )
    call TriggerAddAction( gg_trg_JuleFrame, function Trig_JuleFrame_Actions )
endfunction