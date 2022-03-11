globals
	framehandle array mephbut
    framehandle array mephicon
    framehandle array mephnum
    framehandle mephuse
    
    constant real MEPHISTAR_E_BLOOD_DURATION = 20
    
    constant real MEPHISTAR_E_MECH_DURATION = 20
    
    constant real MEPHISTAR_E_MOON_DAMAGE = 225
    constant real MEPHISTAR_E_MOON_AREA = 400
    
    constant integer MEPHISTAR_E_NATURE_TRIGGERS = 4
    
    constant real MEPHISTAR_E_RING_DURATION = 20
    
    constant real MEPHISTAR_E_WEAPON_DURATION = 5
endglobals

function MephistarEFrameGeneral takes integer number returns nothing
    set udg_MephistarUse[number] = udg_MephistarUse[number] - 1
    call BlzFrameSetText( mephnum[number], I2S(udg_MephistarUse[number]) )
    if udg_MephistarUse[number] <= 0 then
        call BlzFrameSetTexture( mephicon[number], "ReplaceableTextures\\CommandButtons\\BTNCancel.blp", 0, true )
    endif
endfunction

function MephistarEAlchemy takes nothing returns nothing
    local integer i
    
    call MephistarEFrameGeneral(1)
    
    set i = 1
    loop
        exitwhen i > PLAYERS_LIMIT
        if unitst( udg_hero[i], udg_Mephistar, "ally" ) then 
            set udg_Caster = udg_hero[i]
            set udg_RandomLogic = true
            call TriggerExecute( udg_DB_Trigger_Pot[GetRandomInt( 1, udg_Database_NumberItems[9] )] )
        endif
        set i = i + 1
    endloop
endfunction

function MephistarEBlood takes nothing returns nothing
    local integer i
    local real t
    
    call MephistarEFrameGeneral(2)
    
    set i = 1
    loop
        exitwhen i > PLAYERS_LIMIT
        if unitst( udg_hero[i], udg_Mephistar, "ally" ) then 
            set t = timebonus(udg_Mephistar, MEPHISTAR_E_BLOOD_DURATION)
            call DestroyEffect( AddSpecialEffect( "Objects\\Spawnmodels\\Orc\\OrcSmallDeathExplode\\OrcSmallDeathExplode.mdl", GetUnitX( udg_hero[i] ), GetUnitY( udg_hero[i] ) ) )
            call bufst( udg_Mephistar, udg_hero[i], 'A145', 'B08J', "mephb", t )
            call effst( udg_Mephistar, udg_hero[i], null, 1, t )
        endif
        set i = i + 1
    endloop
endfunction

function MephistarECrystal takes nothing returns nothing
    local integer i
    
    call MephistarEFrameGeneral(3)
    
    set i = 1
    loop
        exitwhen i > PLAYERS_LIMIT
        if unitst( udg_hero[i], udg_Mephistar, "ally" ) then 
            call UnitReduceCooldownPercent( udg_hero[i], 0.4 )
            call DestroyEffect( AddSpecialEffect("Abilities\\Spells\\Items\\AIil\\AIilTarget.mdl", GetUnitX(udg_hero[i]), GetUnitY(udg_hero[i]) ) )
        endif
        set i = i + 1
    endloop
endfunction

function MephistarEMech takes nothing returns nothing
    local integer i
    local real t
    
    call MephistarEFrameGeneral(4)
    
    set i = 1
    loop
        exitwhen i > PLAYERS_LIMIT
        if unitst( udg_hero[i], udg_Mephistar, "ally" ) then 
            set t = timebonus(udg_Mephistar, MEPHISTAR_E_MECH_DURATION)
            call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\Orc\\FeralSpirit\\feralspirittarget.mdl", GetUnitX( udg_hero[i] ), GetUnitY( udg_hero[i] ) ) )
            call bufst( udg_Mephistar, udg_hero[i], 'A146', 'B08K', "mephm", t )
            call effst( udg_Mephistar, udg_hero[i], null, 1, t )
        endif
        set i = i + 1
    endloop
endfunction

function MephistarEMoon takes nothing returns nothing
    local integer i
    
    call MephistarEFrameGeneral(5)
    
    set i = 1
    loop
        exitwhen i > PLAYERS_LIMIT
        if unitst( udg_hero[i], udg_Mephistar, "ally" ) then 
            call GroupAoE( udg_Mephistar, null, GetUnitX( udg_hero[i] ), GetUnitY( udg_hero[i] ), MEPHISTAR_E_MOON_DAMAGE, MEPHISTAR_E_MOON_AREA, "enemy", "war3mapImported\\ArcaneExplosion.mdx", null )
        endif
        set i = i + 1
    endloop
endfunction

function MephistarENature takes nothing returns nothing
    local integer i
    local unit target
    
    call MephistarEFrameGeneral(6)
    
    set i = 1
    loop
        exitwhen i > MEPHISTAR_E_NATURE_TRIGGERS
        set target = HeroLessHP(udg_Mephistar)
        if target != null then
            call healst( udg_Mephistar, target, GetUnitState( target, UNIT_STATE_MAX_LIFE) * 0.15 )
            call manast( udg_Mephistar, target, GetUnitState( target, UNIT_STATE_MAX_MANA) * 0.15 )
            set target = null
        endif
        set i = i + 1
    endloop
    
    set target = null
endfunction

function MephistarERing takes nothing returns nothing
    local integer i
    local real t
    
    call MephistarEFrameGeneral(7)
    
    set i = 1
    loop
        exitwhen i > PLAYERS_LIMIT
        if unitst( udg_hero[i], udg_Mephistar, "ally" ) then 
            set t = timebonus(udg_Mephistar, MEPHISTAR_E_RING_DURATION)
            call bufst( udg_Mephistar, udg_hero[i], 'A147', 'B08L', "mephr", t )
            call effst( udg_Mephistar, udg_hero[i], null, 1, t )
        endif
        set i = i + 1
    endloop
endfunction

function MephistarERune takes nothing returns nothing
    local integer i
    local integer runeLimit
    
    if udg_fightmod[3] then
        set runeLimit = Arena_Runes_NoDuel_Count
    else
        set runeLimit = Arena_Runes_Count
    endif
    
    call MephistarEFrameGeneral(8)
    
    set i = 1
    loop
        exitwhen i > PLAYERS_LIMIT
        if unitst( udg_hero[i], udg_Mephistar, "ally" ) then 
            set bj_lastCreatedItem = CreateItem(Arena_Runes[GetRandomInt(1, runeLimit)], GetUnitX( udg_hero[i] ) + GetRandomReal( -300, 300 ), GetUnitY( udg_hero[i] ) + GetRandomReal( -300, 300 ) )
            call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\Orc\\FeralSpirit\\feralspirittarget.mdl", GetItemX( bj_lastCreatedItem ), GetItemY( bj_lastCreatedItem ) ) )
        endif
        set i = i + 1
    endloop
endfunction

function MephistarEWeapon takes nothing returns nothing
    local integer i
    local real t
    
    call MephistarEFrameGeneral(9)
    
    set i = 1
    loop
        exitwhen i > PLAYERS_LIMIT
        if unitst( udg_hero[i], udg_Mephistar, "ally" ) then 
            set t = timebonus(udg_Mephistar, MEPHISTAR_E_WEAPON_DURATION)
            call bufst( udg_Mephistar, udg_hero[i], 'A148', 'B08M', "mephw", t )
            call effst( udg_Mephistar, udg_hero[i], null, 1, t )
        endif
        set i = i + 1
    endloop
endfunction

function MephistarEFrameUse takes nothing returns nothing
    local unit u = udg_Mephistar
    local integer unitId = GetUnitUserData(u)
    local boolean exit
    
    if GetLocalPlayer() == GetTriggerPlayer() then
        call BlzFrameSetVisible( BlzGetTriggerFrame(),false)
		call BlzFrameSetVisible( BlzGetTriggerFrame(),true)
	endif

    if GetUnitState( u, UNIT_STATE_LIFE) > 0.405 and udg_combatlogic[unitId] then
        //При оптимизации стоит учитывать, что позиции наборов и наборов Мефистара отличаются!
        if mephbut[1] == BlzGetTriggerFrame() and udg_Set_Alchemy_Number[unitId] > 0 and udg_MephistarUse[1] > 0 then
            call MephistarEAlchemy()
        elseif mephbut[2] == BlzGetTriggerFrame() and udg_Set_Blood_Number[unitId] > 0 and udg_MephistarUse[2] > 0 then
            call MephistarEBlood()
        elseif mephbut[3] == BlzGetTriggerFrame() and udg_Set_Cristall_Number[unitId] > 0 and udg_MephistarUse[3] > 0 then
            call MephistarECrystal()
        elseif mephbut[4] == BlzGetTriggerFrame() and SetCount_GetPieces(u, SET_MECH) > 0 and udg_MephistarUse[4] > 0 then
            call MephistarEMech()
        elseif mephbut[5] == BlzGetTriggerFrame() and udg_Set_Moon_Number[unitId] > 0 and udg_MephistarUse[5] > 0 then
            call MephistarEMoon()
        elseif mephbut[6] == BlzGetTriggerFrame() and udg_Set_Nature_Number[unitId] > 0 and udg_MephistarUse[6] > 0 then
            call MephistarENature()
        elseif mephbut[7] == BlzGetTriggerFrame() and udg_Set_Ring_Number[unitId] > 0 and udg_MephistarUse[7] > 0 then
            call MephistarERing()
        elseif mephbut[8] == BlzGetTriggerFrame() and udg_Set_Rune_Number[unitId] > 0 and udg_MephistarUse[8] > 0 then
            call MephistarERune()
        elseif mephbut[9] == BlzGetTriggerFrame() and udg_Set_Weapon_Number[unitId] > 0 and udg_MephistarUse[9] > 0 then
            call MephistarEWeapon()
        endif
    endif
endfunction

function Trig_MephistarEFrame_Actions takes nothing returns nothing
    local trigger trig
    local integer i

    set mephuse = BlzCreateFrameByType("BACKDROP", "", BlzGetOriginFrame(ORIGIN_FRAME_GAME_UI,0), "StandartFrameTemplate", 0)
    call BlzFrameSetVisible( mephuse, false )
    call BlzFrameSetLevel( mephuse, -2 )

    set i = 1
    loop
        exitwhen i > udg_DB_SoulContract_SetNum
        set mephicon[i] = BlzCreateFrameByType("BACKDROP", "",mephuse, "StandartFrameTemplate", 0)
        call BlzFrameSetSize( mephicon[i], 0.02, 0.02 )
        call BlzFrameSetAbsPoint(mephicon[i], FRAMEPOINT_CENTER, 0.02, 0.15+(0.02*i))
        call BlzFrameSetTexture( mephicon[i], "ReplaceableTextures\\CommandButtons\\BTNCancel.blp", 0, true )
        
        set mephnum[i] = BlzCreateFrameByType("TEXT", "", mephuse, "StandartFrameTemplate", 0)
        call BlzFrameSetSize( mephnum[i], 0.01, 0.01 )
        call BlzFrameSetPoint(mephnum[i], FRAMEPOINT_BOTTOMLEFT, mephicon[i], FRAMEPOINT_BOTTOMLEFT, 0.001,0.001) 
        call BlzFrameSetText( mephnum[i], "0" )
        
        set mephbut[i] = BlzCreateFrameByType("GLUEBUTTON", "", mephuse, "ScoreScreenTabButtonTemplate", 0)
        call BlzFrameSetSize( mephbut[i], 0.02, 0.02 )
        call BlzFrameSetPoint( mephbut[i], FRAMEPOINT_CENTER, mephicon[i], FRAMEPOINT_CENTER, 0,0)
        
        set trig = CreateTrigger()
        call BlzTriggerRegisterFrameEvent(trig, mephbut[i], FRAMEEVENT_CONTROL_CLICK)
        call TriggerAddAction(trig, function MephistarEFrameUse)
        
        call SetStableTool( mephbut[i], BlzGetAbilityTooltip(udg_DB_SoulContract_Set[i], 0), BlzGetAbilityExtendedTooltip(udg_DB_SoulContract_Set[i], 0) )
        set i = i + 1
    endloop
    
    set trig = null
endfunction

//===========================================================================
function InitTrig_MephistarEFrame takes nothing returns nothing
    set gg_trg_MephistarEFrame = CreateTrigger(  )
    call TriggerRegisterTimerExpireEvent( gg_trg_MephistarEFrame, udg_StartTimer )
    call TriggerAddAction( gg_trg_MephistarEFrame, function Trig_MephistarEFrame_Actions )
endfunction