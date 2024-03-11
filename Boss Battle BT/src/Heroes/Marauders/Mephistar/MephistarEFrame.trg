{
  "Id": 50333176,
  "Comment": "",
  "IsScript": true,
  "RunOnMapInit": false,
  "Script": "scope MepthistarExtra\r\n\r\n\tglobals\r\n\t\tframehandle array mephbut\r\n\t    framehandle array mephicon\r\n\t    framehandle array mephnum\r\n\t    framehandle mephuse\r\n\t    \r\n\t    constant real MEPHISTAR_E_BLOOD_DURATION = 20\r\n\t    \r\n\t    constant real MEPHISTAR_E_MECH_DURATION = 20\r\n\t    \r\n\t    constant real MEPHISTAR_E_MOON_DAMAGE = 225\r\n\t    constant real MEPHISTAR_E_MOON_AREA = 400\r\n\t    \r\n\t    constant integer MEPHISTAR_E_NATURE_TRIGGERS = 4\r\n\t    \r\n\t    constant real MEPHISTAR_E_RING_DURATION = 20\r\n\t    \r\n\t    constant real MEPHISTAR_E_WEAPON_DURATION = 5\r\n\tendglobals\r\n\t\r\n\tfunction MephistarEFrameGeneral takes integer number returns nothing\r\n\t    set udg_MephistarUse[number] = udg_MephistarUse[number] - 1\r\n\t    call BlzFrameSetText( mephnum[number], I2S(udg_MephistarUse[number]) )\r\n\t    if udg_MephistarUse[number] <= 0 then\r\n\t        call BlzFrameSetTexture( mephicon[number], \"ReplaceableTextures\\\\CommandButtons\\\\BTNCancel.blp\", 0, true )\r\n\t    endif\r\n\tendfunction\r\n\t\r\n\tfunction MephistarEAlchemy takes nothing returns nothing\r\n\t    local integer i\r\n\t    \r\n\t    call MephistarEFrameGeneral(1)\r\n\t    \r\n\t    set i = 1\r\n\t    loop\r\n\t        exitwhen i > PLAYERS_LIMIT\r\n\t        if unitst( udg_hero[i], udg_Mephistar, \"ally\" ) then \r\n\t            set udg_Caster = udg_hero[i]\r\n\t            set udg_RandomLogic = true\r\n\t            call TriggerExecute( udg_DB_Trigger_Pot[GetRandomInt( 1, udg_Database_NumberItems[9] )] )\r\n\t        endif\r\n\t        set i = i + 1\r\n\t    endloop\r\n\tendfunction\r\n\t\r\n\tfunction MephistarEBlood takes nothing returns nothing\r\n\t    local integer i\r\n\t    local real t\r\n\t    \r\n\t    call MephistarEFrameGeneral(2)\r\n\t    \r\n\t    set i = 1\r\n\t    loop\r\n\t        exitwhen i > PLAYERS_LIMIT\r\n\t        if unitst( udg_hero[i], udg_Mephistar, \"ally\" ) then \r\n\t            set t = timebonus(udg_Mephistar, MEPHISTAR_E_BLOOD_DURATION)\r\n\t            call DestroyEffect( AddSpecialEffect( \"Objects\\\\Spawnmodels\\\\Orc\\\\OrcSmallDeathExplode\\\\OrcSmallDeathExplode.mdl\", GetUnitX( udg_hero[i] ), GetUnitY( udg_hero[i] ) ) )\r\n\t            call bufst( udg_Mephistar, udg_hero[i], 'A145', 'B08J', \"mephb\", t )\r\n\t            call effst( udg_Mephistar, udg_hero[i], null, 1, t )\r\n\t        endif\r\n\t        set i = i + 1\r\n\t    endloop\r\n\tendfunction\r\n\t\r\n\tfunction MephistarECrystal takes nothing returns nothing\r\n\t    local integer i\r\n\t    \r\n\t    call MephistarEFrameGeneral(3)\r\n\t    \r\n\t    set i = 1\r\n\t    loop\r\n\t        exitwhen i > PLAYERS_LIMIT\r\n\t        if unitst( udg_hero[i], udg_Mephistar, \"ally\" ) then \r\n\t            call UnitReduceCooldownPercent( udg_hero[i], 0.4 )\r\n\t            call DestroyEffect( AddSpecialEffect(\"Abilities\\\\Spells\\\\Items\\\\AIil\\\\AIilTarget.mdl\", GetUnitX(udg_hero[i]), GetUnitY(udg_hero[i]) ) )\r\n\t        endif\r\n\t        set i = i + 1\r\n\t    endloop\r\n\tendfunction\r\n\t\r\n\tfunction MephistarEMech takes nothing returns nothing\r\n\t    local integer i\r\n\t    local real t\r\n\t    \r\n\t    call MephistarEFrameGeneral(4)\r\n\t    \r\n\t    set i = 1\r\n\t    loop\r\n\t        exitwhen i > PLAYERS_LIMIT\r\n\t        if unitst( udg_hero[i], udg_Mephistar, \"ally\" ) then \r\n\t            set t = timebonus(udg_Mephistar, MEPHISTAR_E_MECH_DURATION)\r\n\t            call DestroyEffect( AddSpecialEffect( \"Abilities\\\\Spells\\\\Orc\\\\FeralSpirit\\\\feralspirittarget.mdl\", GetUnitX( udg_hero[i] ), GetUnitY( udg_hero[i] ) ) )\r\n\t            call bufst( udg_Mephistar, udg_hero[i], 'A146', 'B08K', \"mephm\", t )\r\n\t            call effst( udg_Mephistar, udg_hero[i], null, 1, t )\r\n\t        endif\r\n\t        set i = i + 1\r\n\t    endloop\r\n\tendfunction\r\n\t\r\n\tfunction MephistarEMoon takes nothing returns nothing\r\n\t    local integer i\r\n\t    \r\n\t    call MephistarEFrameGeneral(5)\r\n\t    \r\n\t    set i = 1\r\n\t    loop\r\n\t        exitwhen i > PLAYERS_LIMIT\r\n\t        if unitst( udg_hero[i], udg_Mephistar, \"ally\" ) then \r\n\t            call GroupAoE( udg_Mephistar, null, GetUnitX( udg_hero[i] ), GetUnitY( udg_hero[i] ), MEPHISTAR_E_MOON_DAMAGE, MEPHISTAR_E_MOON_AREA, \"enemy\", \"war3mapImported\\\\ArcaneExplosion.mdx\", null )\r\n\t        endif\r\n\t        set i = i + 1\r\n\t    endloop\r\n\tendfunction\r\n\t\r\n\tfunction MephistarENature takes nothing returns nothing\r\n\t    local integer i\r\n\t    local unit target\r\n\t    \r\n\t    call MephistarEFrameGeneral(6)\r\n\t    \r\n\t    set i = 1\r\n\t    loop\r\n\t        exitwhen i > MEPHISTAR_E_NATURE_TRIGGERS\r\n\t        set target = HeroLessHP(udg_Mephistar)\r\n\t        if target != null then\r\n\t            call healst( udg_Mephistar, target, GetUnitState( target, UNIT_STATE_MAX_LIFE) * 0.15 )\r\n\t            call manast( udg_Mephistar, target, GetUnitState( target, UNIT_STATE_MAX_MANA) * 0.15 )\r\n\t            set target = null\r\n\t        endif\r\n\t        set i = i + 1\r\n\t    endloop\r\n\t    \r\n\t    set target = null\r\n\tendfunction\r\n\t\r\n\tfunction MephistarERing takes nothing returns nothing\r\n\t    local integer i\r\n\t    local real t\r\n\t    \r\n\t    call MephistarEFrameGeneral(7)\r\n\t    \r\n\t    set i = 1\r\n\t    loop\r\n\t        exitwhen i > PLAYERS_LIMIT\r\n\t        if unitst( udg_hero[i], udg_Mephistar, \"ally\" ) then \r\n\t            set t = timebonus(udg_Mephistar, MEPHISTAR_E_RING_DURATION)\r\n\t            call bufst( udg_Mephistar, udg_hero[i], 'A147', 'B08L', \"mephr\", t )\r\n\t            call effst( udg_Mephistar, udg_hero[i], null, 1, t )\r\n\t        endif\r\n\t        set i = i + 1\r\n\t    endloop\r\n\tendfunction\r\n\t\r\n\tfunction MephistarERune takes nothing returns nothing\r\n\t    local integer i\r\n\t    local integer runeLimit\r\n\t    \r\n\t    if udg_fightmod[3] then\r\n\t        set runeLimit = Arena_Runes_NoDuel_Count\r\n\t    else\r\n\t        set runeLimit = Arena_Runes_Count\r\n\t    endif\r\n\t    \r\n\t    call MephistarEFrameGeneral(8)\r\n\t    \r\n\t    set i = 1\r\n\t    loop\r\n\t        exitwhen i > PLAYERS_LIMIT\r\n\t        if unitst( udg_hero[i], udg_Mephistar, \"ally\" ) then \r\n\t            set bj_lastCreatedItem = CreateItem(Arena_Runes[GetRandomInt(1, runeLimit)], GetUnitX( udg_hero[i] ) + GetRandomReal( -300, 300 ), GetUnitY( udg_hero[i] ) + GetRandomReal( -300, 300 ) )\r\n\t            call DestroyEffect( AddSpecialEffect( \"Abilities\\\\Spells\\\\Orc\\\\FeralSpirit\\\\feralspirittarget.mdl\", GetItemX( bj_lastCreatedItem ), GetItemY( bj_lastCreatedItem ) ) )\r\n\t        endif\r\n\t        set i = i + 1\r\n\t    endloop\r\n\tendfunction\r\n\t\r\n\tfunction MephistarEWeapon takes nothing returns nothing\r\n\t    local integer i\r\n\t    local real t\r\n\t    \r\n\t    call MephistarEFrameGeneral(9)\r\n\t    \r\n\t    set i = 1\r\n\t    loop\r\n\t        exitwhen i > PLAYERS_LIMIT\r\n\t        if unitst( udg_hero[i], udg_Mephistar, \"ally\" ) then \r\n\t            set t = timebonus(udg_Mephistar, MEPHISTAR_E_WEAPON_DURATION)\r\n\t            call bufst( udg_Mephistar, udg_hero[i], 'A148', 'B08M', \"mephw\", t )\r\n\t            call effst( udg_Mephistar, udg_hero[i], null, 1, t )\r\n\t        endif\r\n\t        set i = i + 1\r\n\t    endloop\r\n\tendfunction\r\n\t\r\n\tfunction MephistarEFrameUse takes nothing returns nothing\r\n\t    local unit u = udg_Mephistar\r\n\t    local integer unitId = GetUnitUserData(u)\r\n\t    local boolean exit\r\n\t    \r\n\t    if GetLocalPlayer() == GetTriggerPlayer() then\r\n\t        call BlzFrameSetVisible( BlzGetTriggerFrame(),false)\r\n\t\t\tcall BlzFrameSetVisible( BlzGetTriggerFrame(),true)\r\n\t\tendif\r\n\t\r\n\t    if GetUnitState( u, UNIT_STATE_LIFE) > 0.405 and udg_combatlogic[unitId] then\r\n\t        //При оптимизации стоит учитывать, что позиции наборов и наборов Мефистара отличаются!\r\n\t        if mephbut[1] == BlzGetTriggerFrame() and udg_Set_Alchemy_Number[unitId] > 0 and udg_MephistarUse[1] > 0 then\r\n\t            call MephistarEAlchemy()\r\n\t        elseif mephbut[2] == BlzGetTriggerFrame() and udg_Set_Blood_Number[unitId] > 0 and udg_MephistarUse[2] > 0 then\r\n\t            call MephistarEBlood()\r\n\t        elseif mephbut[3] == BlzGetTriggerFrame() and udg_Set_Cristall_Number[unitId] > 0 and udg_MephistarUse[3] > 0 then\r\n\t            call MephistarECrystal()\r\n\t        elseif mephbut[4] == BlzGetTriggerFrame() and SetCount_GetPieces(u, SET_MECH) > 0 and udg_MephistarUse[4] > 0 then\r\n\t            call MephistarEMech()\r\n\t        elseif mephbut[5] == BlzGetTriggerFrame() and udg_Set_Moon_Number[unitId] > 0 and udg_MephistarUse[5] > 0 then\r\n\t            call MephistarEMoon()\r\n\t        elseif mephbut[6] == BlzGetTriggerFrame() and udg_Set_Nature_Number[unitId] > 0 and udg_MephistarUse[6] > 0 then\r\n\t            call MephistarENature()\r\n\t        elseif mephbut[7] == BlzGetTriggerFrame() and udg_Set_Ring_Number[unitId] > 0 and udg_MephistarUse[7] > 0 then\r\n\t            call MephistarERing()\r\n\t        elseif mephbut[8] == BlzGetTriggerFrame() and udg_Set_Rune_Number[unitId] > 0 and udg_MephistarUse[8] > 0 then\r\n\t            call MephistarERune()\r\n\t        elseif mephbut[9] == BlzGetTriggerFrame() and udg_Set_Weapon_Number[unitId] > 0 and udg_MephistarUse[9] > 0 then\r\n\t            call MephistarEWeapon()\r\n\t        endif\r\n\t    endif\r\n\tendfunction\r\n\t\r\n\tfunction Enable takes unit caster returns nothing\r\n\t    local integer i\r\n\t    \r\n\t    set udg_Mephistar = caster\r\n\t    \r\n\t    if GetLocalPlayer() == GetOwningPlayer( caster ) then\r\n\t        call BlzFrameSetVisible( mephuse, true )\r\n\t    endif\r\n\t    \r\n\t    set i = 1\r\n\t    loop\r\n\t        exitwhen i > 9\r\n\t        if udg_MephistarUse[i] > 0 then\r\n\t            call BlzFrameSetTexture( mephicon[i], BlzGetAbilityIcon( udg_DB_SoulContract_Set[cyclA]), 0, true )\r\n\t        else\r\n\t            call BlzFrameSetTexture( mephicon[i], \"ReplaceableTextures\\\\CommandButtons\\\\BTNCancel.blp\", 0, true )\r\n\t        endif\r\n\t        set i = i + 1\r\n\t    endloop\r\n\t    \r\n\t    set caster = null\r\n\tendfunction\r\n\t\r\n\tfunction Trig_MephistarEFrame_Actions takes nothing returns nothing\r\n\t    local trigger trig\r\n\t    local integer i\r\n\t\r\n\t    set mephuse = BlzCreateFrameByType(\"BACKDROP\", \"\", BlzGetOriginFrame(ORIGIN_FRAME_GAME_UI,0), \"StandartFrameTemplate\", 0)\r\n\t    call BlzFrameSetVisible( mephuse, false )\r\n\t    call BlzFrameSetLevel( mephuse, -2 )\r\n\t\r\n\t    set i = 1\r\n\t    loop\r\n\t        exitwhen i > udg_DB_SoulContract_SetNum\r\n\t        set mephicon[i] = BlzCreateFrameByType(\"BACKDROP\", \"\",mephuse, \"StandartFrameTemplate\", 0)\r\n\t        call BlzFrameSetSize( mephicon[i], 0.02, 0.02 )\r\n\t        call BlzFrameSetAbsPoint(mephicon[i], FRAMEPOINT_CENTER, 0.02, 0.15+(0.02*i))\r\n\t        call BlzFrameSetTexture( mephicon[i], \"ReplaceableTextures\\\\CommandButtons\\\\BTNCancel.blp\", 0, true )\r\n\t        \r\n\t        set mephnum[i] = BlzCreateFrameByType(\"TEXT\", \"\", mephuse, \"StandartFrameTemplate\", 0)\r\n\t        call BlzFrameSetSize( mephnum[i], 0.01, 0.01 )\r\n\t        call BlzFrameSetPoint(mephnum[i], FRAMEPOINT_BOTTOMLEFT, mephicon[i], FRAMEPOINT_BOTTOMLEFT, 0.001,0.001) \r\n\t        call BlzFrameSetText( mephnum[i], \"0\" )\r\n\t        \r\n\t        set mephbut[i] = BlzCreateFrameByType(\"GLUEBUTTON\", \"\", mephuse, \"ScoreScreenTabButtonTemplate\", 0)\r\n\t        call BlzFrameSetSize( mephbut[i], 0.02, 0.02 )\r\n\t        call BlzFrameSetPoint( mephbut[i], FRAMEPOINT_CENTER, mephicon[i], FRAMEPOINT_CENTER, 0,0)\r\n\t        \r\n\t        set trig = CreateTrigger()\r\n\t        call BlzTriggerRegisterFrameEvent(trig, mephbut[i], FRAMEEVENT_CONTROL_CLICK)\r\n\t        call TriggerAddAction(trig, function MephistarEFrameUse)\r\n\t        \r\n\t        call SetStableTool( mephbut[i], BlzGetAbilityTooltip(udg_DB_SoulContract_Set[i], 0), BlzGetAbilityExtendedTooltip(udg_DB_SoulContract_Set[i], 0) )\r\n\t        set i = i + 1\r\n\t    endloop\r\n\t    \r\n\t    set trig = null\r\n\tendfunction\r\n\t\r\n\t//===========================================================================\r\n\tfunction InitTrig_MephistarEFrame takes nothing returns nothing\r\n\t    set gg_trg_MephistarEFrame = CreateTrigger(  )\r\n\t    call TriggerRegisterTimerExpireEvent( gg_trg_MephistarEFrame, udg_StartTimer )\r\n\t    call TriggerAddAction( gg_trg_MephistarEFrame, function Trig_MephistarEFrame_Actions )\r\n\tendfunction\r\n\r\nendscope",
  "Events": [],
  "LocalVariables": [],
  "Conditions": [],
  "Actions": []
}