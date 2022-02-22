globals
	unit uret
    boolean RandomMode = false
endglobals

function StringSizeTool takes string s returns real
	return 0.05+(0.0003*StringLength(s))
endfunction

function StringSizeSkill takes string s returns real
	return (0.0005*StringLength(s))+0.05
endfunction

function StringSizeSmall takes string s returns real
	return (0.0002*StringLength(s))+0.05
endfunction

// Число исключение
function exept takes integer i, integer min, integer max returns integer
	local integer cyclA = 1
	local integer rand

    if min == max then
        return min
    endif
	loop
		exitwhen cyclA > 1
		set rand = GetRandomInt( min, max )
		if rand == i and min != max then
			set cyclA = cyclA - 1
		endif
		set cyclA = cyclA + 1
	endloop

    return rand
endfunction

//Провокация
function tauntCast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local unit u = LoadUnitHandle( udg_hash, id, StringHash( "taunt" ) )

    call UnitRemoveAbility( u, 'A09H' )
    call UnitRemoveAbility( u, 'B059' )
    if GetUnitAbilityLevel( u, 'Avul') == 0 then
        call IssueImmediateOrder( u, "stop" )
    endif
    call FlushChildHashtable( udg_hash, id )

	set u = null
endfunction

function taunt takes unit caster, unit target, real t returns nothing
    local integer id = GetHandleId( target )
    
    if GetUnitTypeId( target ) != 'h01K' and GetUnitTypeId( target ) != 'n04O' then
        call IssueTargetOrder( target, "attack", caster )
        call UnitAddAbility( target, 'A09H' )
        
        if LoadTimerHandle( udg_hash, id, StringHash( "taunt" ) ) == null then
            call SaveTimerHandle( udg_hash, id, StringHash( "taunt" ), CreateTimer() )
        endif
        set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "taunt" ) ) ) 
        call SaveUnitHandle( udg_hash, id, StringHash( "taunt" ), target )
        call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( target ), StringHash( "taunt" ) ), t, false, function tauntCast )
    endif
    call debuffst( caster, target, null, 1, t )
    
    set caster = null
    set target = null
endfunction

// Повышение случайного стата
function RandomStat takes unit caster, integer i, integer data, boolean l returns nothing
    local integer rand
    local integer r = data
    //if not( udg_fightmod[3] ) and combat( caster, false, 0 ) then
        set rand = GetRandomInt(1, 3)
        if rand == 1 then
            call statst( caster, i, 0, 0, r, l )
            call textst( "|c00FF2020 +" + I2S(i) + " strength", caster, 64, 90, 10, 1 )
        elseif rand == 2 then
            if r != 0 then
                set r = r + 4
            endif
            call statst( caster, 0, i, 0, r, l )
            call textst( "|c0020FF20 +" + I2S(i) + " agility", caster, 64, 90, 10, 1 )
        elseif rand == 3 then
            if r != 0 then
                set r = r + 8
            endif
            call statst( caster, 0, 0, i, r, l )
            call textst( "|c002020FF +" + I2S(i) + " intelligence", caster, 64, 90, 10, 1 )
        endif
    //endif
    
    set caster = null
endfunction

// Выбор цели для противников
function aggroIf takes unit u returns boolean
    return IsUnitEnemy( u, Player( 10 ) ) and GetUnitState( u, UNIT_STATE_LIFE ) > 0.405
endfunction

function aggro takes unit u returns nothing
    local real rand = GetRandomReal(0, 100)
    local unit target = null
    local integer cyclA
    local integer k

    if GetUnitAbilityLevel( u, 'B059') == 0 and not(IsUnitPaused(u)) then
        if rand <= udg_AggroChance[1] and aggroIf(udg_hero[1]) then
            call IssueTargetOrder( u, "attackonce", udg_hero[1] )
        elseif rand > udg_AggroChance[1] and rand <= ( udg_AggroChance[1] + udg_AggroChance[2] ) and aggroIf(udg_hero[2]) then
            call IssueTargetOrder( u, "attackonce", udg_hero[2] )
        elseif rand > ( udg_AggroChance[1] + udg_AggroChance[2] ) and rand <= ( udg_AggroChance[1] + udg_AggroChance[2] + udg_AggroChance[3] ) and aggroIf(udg_hero[3]) then
            call IssueTargetOrder( u, "attackonce", udg_hero[3] )
        elseif rand > ( udg_AggroChance[1] + udg_AggroChance[2] + udg_AggroChance[3] ) and rand <= ( udg_AggroChance[1] + udg_AggroChance[2] + udg_AggroChance[3] + udg_AggroChance[4] ) and aggroIf(udg_hero[4]) then
            call IssueTargetOrder( u, "attackonce", udg_hero[4] )
        else
            set cyclA = 1
            set k = 0
            loop
                exitwhen cyclA > 1
                set k = k + 1
                set target = GroupPickRandomUnit(udg_otryad)
                if k < 10 then
                    if aggroIf(target) or CountUnitsInGroup(udg_otryad) <= 1 then
                        call IssueTargetOrder( u, "attackonce", target )
                    else
                        set cyclA = cyclA - 1
                    endif
                endif
                set cyclA = cyclA + 1
            endloop
        endif
    endif
    
    set target = null
    set u = null
endfunction

// Создание плавающего текста
function CreateText takes string s, location loc, real zOffset, real size, real red, real green, real blue, real transparency returns texttag
    local integer array i
    local integer cyclA = 0
    
    set i[0] = R2I( red * 2.25 )
    set i[1] = R2I( green * 2.25 )
    set i[2] = R2I( blue * 2.25 )
    set i[3] = R2I( (100-transparency) * 2.25 )
    
    loop
        exitwhen cyclA > 3
        if i[cyclA] < 0 then
            set i[cyclA] = 0
        elseif i[cyclA] > 255 then
            set i[cyclA] = 255
        endif
        set cyclA = cyclA + 1
    endloop
    
    set bj_lastCreatedTextTag = CreateTextTag()
    call SetTextTagText(bj_lastCreatedTextTag, s, size * 0.023 / 10)
    call SetTextTagPos(bj_lastCreatedTextTag, GetLocationX(loc), GetLocationY(loc), zOffset)
    call SetTextTagColor(bj_lastCreatedTextTag, i[0], i[1], i[2], i[3])

    set loc = null
    return bj_lastCreatedTextTag
endfunction

// Иконка набора
function iconon takes integer i, string str, string ic returns nothing
    local integer cyclA = 0
    
    loop
        exitwhen cyclA > 2
        if udg_Multiboard_Sets[( ( udg_Multiboard_Position[i] * 3 ) - 2 ) + cyclA] == "" then
            set udg_Multiboard_Sets[( ( udg_Multiboard_Position[i] * 3 ) - 2 ) + cyclA] = str
            call MultiSetIcon( udg_multi, ( ( udg_Multiboard_Position[i] * 3 ) - 1 ) + cyclA, 15, ic )
            set cyclA = 2
        endif
        set cyclA = cyclA + 1
    endloop
endfunction

function iconoff takes integer i, string str returns nothing
    local integer cyclA = 0
    
    loop
        exitwhen cyclA > 2
        if not( udg_logic[43] ) and udg_Multiboard_Sets[( ( udg_Multiboard_Position[i] * 3 ) - 2 ) + cyclA] == str then
            set udg_Multiboard_Sets[( ( udg_Multiboard_Position[i] * 3 ) - 2 ) + cyclA] = ""
            call MultiSetIcon( udg_multi, ( ( udg_Multiboard_Position[i] * 3 ) - 1 ) + cyclA, 15, "ReplaceableTextures\\CommandButtons\\BTNCancel.blp" )
            set cyclA = 2
        endif
        set cyclA = cyclA + 1
    endloop
endfunction

//Наборы
function Potion_Logic takes item t returns boolean
    local integer cyclA = 1
    local integer cyclAEnd = udg_Database_NumberItems[9]
    local boolean l = false
    
    loop
        exitwhen cyclA > cyclAEnd
        if GetItemTypeId(t) == udg_Database_Item_Potion[cyclA] then
            set l = true
            set cyclA = cyclAEnd
        endif
        set cyclA = cyclA + 1
    endloop
    set t = null
    return l
endfunction

function Orb_Logic takes item t returns boolean
    local integer cyclA = 1
    local integer cyclAEnd = udg_Database_NumberItems[8]
    local boolean l = false
    
    loop
        exitwhen cyclA > cyclAEnd
        if GetItemTypeId(t) == udg_DB_Orb[cyclA] then
            set l = true
            set cyclA = cyclAEnd
        endif
        set cyclA = cyclA + 1
    endloop
    set t = null
    return l
endfunction

function Mech_Logic takes item t returns boolean
    local integer cyclA = 1
    local integer cyclAEnd = udg_DB_SetItems_Num[1]
    local boolean l = false
    
    loop
        exitwhen cyclA > cyclAEnd
        if GetItemTypeId(t) == DB_SetItems[1][cyclA] then
            set l = true
            set cyclA = cyclAEnd
        endif
        set cyclA = cyclA + 1
    endloop
    set t = null
    return l
endfunction

function CristallLogic takes item t returns boolean
    local integer cyclA = 1
    local integer cyclAEnd = udg_DB_SetItems_Num[9]
    local boolean l = false
    
    loop
        exitwhen cyclA > cyclAEnd
        if GetItemTypeId(t) == DB_SetItems[9][cyclA] then
            set l = true
            set cyclA = cyclAEnd
        endif
        set cyclA = cyclA + 1
    endloop
    set t = null
    return l
endfunction

function BloodLogic takes item t returns boolean
    local integer cyclA = 1
    local integer cyclAEnd = udg_DB_SetItems_Num[4]
    local boolean l = false
    
    loop
        exitwhen cyclA > cyclAEnd
        if GetItemTypeId(t) == DB_SetItems[4][cyclA] then
            set l = true
            set cyclA = cyclAEnd
        endif
        set cyclA = cyclA + 1
    endloop
    set t = null
    return l
endfunction

function RuneLogic takes item t returns boolean
    local integer cyclA = 1
    local integer cyclAEnd = udg_DB_SetItems_Num[5]
    local boolean l = false
    
    loop
        exitwhen cyclA > cyclAEnd
        if GetItemTypeId(t) == DB_SetItems[5][cyclA] then
            set l = true
            set cyclA = cyclAEnd
        endif
        set cyclA = cyclA + 1
    endloop
    set t = null
    return l
endfunction

function MoonLogic takes item t returns boolean
    local integer cyclA = 1
    local integer cyclAEnd = udg_DB_SetItems_Num[6]
    local boolean l = false
    
    loop
        exitwhen cyclA > cyclAEnd
        if GetItemTypeId(t) == DB_SetItems[6][cyclA] then
            set l = true
            set cyclA = cyclAEnd
        endif
        set cyclA = cyclA + 1
    endloop
    set t = null
    return l
endfunction

function NatureLogic takes item t returns boolean
    local integer cyclA = 1
    local integer cyclAEnd = udg_DB_SetItems_Num[7]
    local boolean l = false
    
    loop
        exitwhen cyclA > cyclAEnd
        if GetItemTypeId(t) == DB_SetItems[7][cyclA] then
            set l = true
            set cyclA = cyclAEnd
        endif
        set cyclA = cyclA + 1
    endloop
    set t = null
    return l
endfunction

function AlchemyLogic takes item t returns boolean
    local integer cyclA = 1
    local integer cyclAEnd = udg_DB_SetItems_Num[8]
    local boolean l = false
    
    loop
        exitwhen cyclA > cyclAEnd
        if GetItemTypeId(t) == DB_SetItems[8][cyclA] then
            set l = true
            set cyclA = cyclAEnd
        endif
        set cyclA = cyclA + 1
    endloop
    set t = null
    return l
endfunction

function Weapon_Logic takes item t returns boolean
    local integer cyclA = 1
    local integer cyclAEnd = udg_DB_SetItems_Num[2]
    local boolean l = false
    
    loop
        exitwhen cyclA > cyclAEnd
        if GetItemTypeId(t) == DB_SetItems[2][cyclA] then
            set l = true
            set cyclA = cyclAEnd
        endif
        set cyclA = cyclA + 1
    endloop
    set t = null
    return l
endfunction

function Ring_Logic takes item t returns boolean
    local integer cyclA = 1
    local integer cyclAEnd = udg_DB_SetItems_Num[3]
    local boolean l = false
    
    loop
        exitwhen cyclA > cyclAEnd
        if GetItemTypeId(t) == DB_SetItems[3][cyclA] then
            set l = true
            set cyclA = cyclAEnd
        endif
        set cyclA = cyclA + 1
    endloop
    set t = null
    return l
endfunction

//Условие "Только алхимия"
function AlchemyOnly takes unit caster returns boolean
    local integer cyclA = 0
    local integer k = 0
    local boolean l = false
    local item it

    loop
        exitwhen cyclA > 5
        set it = UnitItemInSlot(caster, cyclA) 
        if not(AlchemyLogic(it)) and GetItemType(it) != ITEM_TYPE_POWERUP and GetItemType(it) != ITEM_TYPE_PURCHASABLE and UnitItemInSlot(caster, cyclA) != null then
            set k = k + 1
        endif
        set cyclA = cyclA + 1
    endloop
    if k <= 0 then
        set l = true
    endif
    set caster = null
    set it = null
    return l
endfunction

// Логика срабатывания доп.заклинания
function TheFollower takes unit caster returns nothing
    local integer id = GetHandleId(caster)
    local integer s = LoadInteger( udg_hash, id, StringHash( "wizi" )) + 1
    local boolean n = LoadBoolean( udg_hash, id, StringHash( "wizi" ))
    local integer i = GetPlayerId(GetOwningPlayer( caster ))
    local integer j = (5*i)+s
    local integer h
    local integer cyclA = 1
    local boolean k = true

    set udg_Wizari[j] = GetTriggeringTrigger()
    
    if s >= 4 then
        call SaveInteger( udg_hash, id, StringHash( "wizi" ), 0 )
        loop
            exitwhen cyclA > s
            if udg_Wizari[j] == udg_Wizari[j-cyclA] then
                set n = true
                set cyclA = s
            endif
            set udg_Wizari[j-cyclA] = null
            set cyclA = cyclA + 1
        endloop
        if n then
            call SaveBoolean( udg_hash, id, StringHash( "wizi" ), false )
            set k = false
        endif
        if k then
            call textst( "|c0020FF20 +", caster, 64, GetRandomInt( 90, 120 ), 15, 1.5 )
            call healst( caster, null, GetUnitState( caster, UNIT_STATE_MAX_LIFE) * 0.2 )
            call manast( caster, null, GetUnitState( caster, UNIT_STATE_MAX_MANA) * 0.2 )
            call DestroyEffect( AddSpecialEffectTarget( "Abilities\\Spells\\Undead\\VampiricAura\\VampiricAuraTarget.mdl", caster, "origin") )
        else
            call textst( "|c00FF0000 _", caster, 64, GetRandomInt( 90, 120 ), 15, 1.5 )
        endif
    else
        call SaveInteger( udg_hash, id, StringHash( "wizi" ), s )
        loop
            exitwhen cyclA > s
            if udg_Wizari[j] == udg_Wizari[j-cyclA] then
                set k = false
                call SaveBoolean( udg_hash, id, StringHash( "wizi" ), true )
                set n = LoadBoolean( udg_hash, id, StringHash( "wizi" ))
                set cyclA = s
            endif
            set cyclA = cyclA + 1
        endloop
        if k and not(n) then
            call textst( "|c0020FF20 " + I2S(s), caster, 64, GetRandomInt( 90, 120 ), 12, 1.5 )
        else
            call textst( "|c00FF0000 " + I2S(s), caster, 64, GetRandomInt( 90, 120 ), 12, 1.5 )
        endif
    endif
    set caster = null
endfunction

function CastLogic takes nothing returns boolean
    local boolean l = false
    local integer i = GetPlayerId(GetOwningPlayer( GetTriggerUnit() ))

    if udg_CastLogic then
        set l = true
        set udg_CastLogic = false
    elseif RandomMode == false then
        set udg_TrigNow = GetTriggeringTrigger()
    endif
    if inv( GetTriggerUnit(), 'I0EF' ) > 0 and udg_combatlogic[GetPlayerId(GetOwningPlayer( GetTriggerUnit() ))+1] then
        call TheFollower(GetTriggerUnit())
    endif
    return l
endfunction

function RandomLogic takes nothing returns boolean
    local boolean l = false
    
    if udg_RandomLogic then
        set udg_RandomLogic = false
        set l = true
    endif
    return l
endfunction

function GetBossWordPostion takes integer position returns string
    if position == 1 then
        return "B"
    elseif position == 2 then
        return "G"
    elseif position == 3 then
        return "J"
    elseif position == 4 then
        return "L"
    elseif position == 5 then
        return "S"
    elseif position == 6 then
        return "Z"
    elseif position == 7 then
        return "T"
    elseif position == 8 then
        return "U"
    elseif position == 9 then
        return "C"
    endif
    return "D"
endfunction

// Невидимость
function RiverEyeCast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local unit u = LoadUnitHandle( udg_hash, id, StringHash( "rvey" ) )
    
    if IsUnitVisible( u, Player(PLAYER_NEUTRAL_AGGRESSIVE)) then
        call UnitRemoveAbility( u, 'A0E7' )
        call FlushChildHashtable( udg_hash, id )
        call DestroyTimer( GetExpiredTimer() )
    endif
    
    set u = null
endfunction

function LorderBadgeCast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local unit u = LoadUnitHandle( udg_hash, id, StringHash( "ldbg" ) )
    
    if IsUnitVisible( u, Player(PLAYER_NEUTRAL_AGGRESSIVE)) then
        call UnitRemoveAbility( u, 'A0TQ' )
        call FlushChildHashtable( udg_hash, id )
        call DestroyTimer( GetExpiredTimer() )
    endif
    
    set u = null
endfunction

function CrownCast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local unit u = LoadUnitHandle( udg_hash, id, StringHash( "crwn" ) )
    
    if IsUnitInvisible( u, Player(PLAYER_NEUTRAL_AGGRESSIVE)) then
        call bufst( u, u, 'A0YE', 'B088', "crwn1", 6 )
    else
        call FlushChildHashtable( udg_hash, id )
        call DestroyTimer( GetExpiredTimer() )
    endif
    
    set u = null
endfunction

function Stealth takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    call UnitRemoveAbility( LoadUnitHandle( udg_hash, id, StringHash( "stlth" ) ), 'A10C' )
    call FlushChildHashtable( udg_hash, id )
endfunction

function shadowst takes unit u returns nothing
    local integer i = GetPlayerId( GetOwningPlayer( u ) ) + 1
    local integer id = GetHandleId( u )
    
    if inv( u, 'I07F') > 0 then
        call UnitAddAbility( u, 'A0E7' )

        if LoadTimerHandle( udg_hash, id, StringHash( "rvey" ) ) == null then
            call SaveTimerHandle( udg_hash, id, StringHash( "rvey" ), CreateTimer() )
        endif
        set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "rvey" ) ) ) 
        call SaveUnitHandle( udg_hash, id, StringHash( "rvey" ), u )
        call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( u ), StringHash( "rvey" ) ), 1, true, function RiverEyeCast )
    endif
    if inv( u, 'I08O') > 0 then
        call UnitAddAbility( u, 'A0TQ' )

        if LoadTimerHandle( udg_hash, id, StringHash( "ldbg" ) ) == null then
            call SaveTimerHandle( udg_hash, id, StringHash( "ldbg" ), CreateTimer() )
        endif
        set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "ldbg" ) ) ) 
        call SaveUnitHandle( udg_hash, id, StringHash( "ldbg" ), u )
        call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( u ), StringHash( "ldbg" ) ), 1, true, function LorderBadgeCast )
    endif
    if inv( u, 'I00R') > 0 then
        call bufst( u, u, 'A0YE', 'B088', "crwn1", 6 )
        set id = GetHandleId( u )
        if LoadTimerHandle( udg_hash, id, StringHash( "crwn" ) ) == null then
            call SaveTimerHandle( udg_hash, id, StringHash( "crwn" ), CreateTimer() )
        endif
        set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "crwn" ) ) ) 
        call SaveUnitHandle( udg_hash, id, StringHash( "crwn" ), u )
        call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( u ), StringHash( "crwn" ) ), 1, true, function CrownCast )
    endif
    
    call UnitAddAbility( u, 'A10C' )
    
    set id = GetHandleId( u )
    if LoadTimerHandle( udg_hash, id, StringHash( "stlth" ) ) == null  then
        call SaveTimerHandle( udg_hash, id, StringHash( "stlth" ), CreateTimer() )
    endif
	set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "stlth" ) ) ) 
	call SaveUnitHandle( udg_hash, id, StringHash( "stlth" ), u )
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( u ), StringHash( "stlth" ) ), 3, false, function Stealth )
    
    set u = null
endfunction

// Отслеживаение убийств
/*function kills takes unit caster, unit target returns nothing
    local integer i = GetPlayerId(GetOwningPlayer(caster)) + 1
    local integer id = GetHandleId( udg_hero[i] )
    local integer s = LoadInteger( udg_hash, id, StringHash( "kill" ) ) + 1
    
    if GetUnitState( target, UNIT_STATE_LIFE) <= 0.405 and IsUnitEnemy( target, GetOwningPlayer( caster ) )  then
        call SaveInteger( udg_hash, id, StringHash( "kill" ), s )

        if inv(udg_hero[i], 'I07Z') > 0 then
            if s >= 50 then
                call SetWidgetLife( GetItemOfTypeFromUnitBJ(udg_hero[i], 'I07Z'), 0. )
                set bj_lastCreatedItem = CreateItem( 'I080', GetUnitX(udg_hero[i]), GetUnitY(udg_hero[i]))
                call UnitAddItem(udg_hero[i], bj_lastCreatedItem)
                call textst( "|c00ffffff Emperor upgraded!", udg_hero[i], 64, GetRandomReal( 45, 135 ), 8, 1.5 )
                call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\Other\\Transmute\\PileofGold.mdl", GetUnitX(udg_hero[i]), GetUnitY(udg_hero[i]) ) )
            else
                call textst( "|c00ffffff " + I2S( s ) + "/50", udg_hero[i], 64, GetRandomReal( 45, 135 ), 8, 1.5 )
            endif
        endif
    endif
    set caster = null
    set target = null
endfunction*/

// Удаление предметов
function RemoveItems takes integer i returns nothing
    local integer j
    local integer cyclA = 0
    local integer s

    if GetLocalPlayer() == Player(i-1) then
        call BlzFrameSetVisible( sklbk,false)
        call BlzFrameSetVisible( refbk,false)
        if udg_Heroes_Amount > 1 and udg_number[69 + i] > 0 then
            call BlzFrameSetVisible( pvpbk,true)
        endif
    endif
    
    if inv(udg_hero[i], 'I0EU' ) > 0 and not(udg_ItemGetChoosed[i]) and udg_ItemGetActive[i] then
        set s = LoadInteger( udg_hash, GetHandleId(udg_hero[i]), StringHash( udg_QuestItemCode[14] ) ) + 1
        call SaveInteger( udg_hash, GetHandleId(udg_hero[i]), StringHash( udg_QuestItemCode[14] ), s )

        if s >= udg_QuestNum[14] then
            call SaveReal( udg_hash, GetHandleId(udg_hero[i]), StringHash( udg_QuestItemCode[14] ), 0 )
            call SetWidgetLife( GetItemOfTypeFromUnitBJ(udg_hero[i], 'I0EU'), 0 )
            set bj_lastCreatedItem = CreateItem( 'I0EV', GetUnitX(udg_hero[i]), GetUnitY(udg_hero[i]))
            call UnitAddItem(udg_hero[i], bj_lastCreatedItem)
            call textst( "|c00ffffff Blacksmith craft done!", udg_hero[i], 64, GetRandomReal( 45, 135 ), 12, 1.5 )
            call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\Human\\ReviveHuman\\ReviveHuman.mdl", GetUnitX(udg_hero[i]), GetUnitY(udg_hero[i]) ) )
            set udg_QuestDone[i] = true
        else
            call QuestDiscription( udg_hero[i], 'I0EU', s, udg_QuestNum[14] )
        endif
    endif
    
    set cyclA = 0
    loop
        exitwhen cyclA > 2
        set j = ( 3 * i ) - cyclA
        call DestroyEffect( AddSpecialEffectLoc( "Abilities\\Spells\\Human\\Polymorph\\PolyMorphDoneGround.mdl", Location(GetItemX(udg_item[j]), GetItemY(udg_item[j]) ) ) )
        call RemoveItem( udg_item[j] )
        set udg_item[j] = null
        set cyclA = cyclA + 1
    endloop
    //Не раньше квеста
    set udg_ItemGetActive[i] = false
endfunction

function GetBossWord takes integer number returns string
    return GetPlayerName( Player( number ) )
endfunction

// Cлучайный бонус
function buffrandomCast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local integer SH = StringHash( LoadStr( udg_hash, id, 1 ) )
    call UnitRemoveAbility( LoadUnitHandle( udg_hash, id, SH ), LoadInteger( udg_hash, id, SH ) )
    call UnitRemoveAbility( LoadUnitHandle( udg_hash, id, SH ), LoadInteger( udg_hash, id, StringHash( LoadStr( udg_hash, id, 1 ) + "1" ) ) )
    call FlushChildHashtable( udg_hash, id )
endfunction

function buffrandom takes unit caster, unit target, integer spell, integer buf, string str, integer time, boolean logic returns nothing
    local integer id = GetHandleId( target )
    
    call UnitAddAbility( target, spell )

    if LoadTimerHandle( udg_hash, id, StringHash( str ) ) == null then
        call SaveTimerHandle( udg_hash, id, StringHash( str ), CreateTimer() )
    endif
	set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( str ) ) ) 
    call SaveStr( udg_hash, id, 1, str )
	call SaveUnitHandle( udg_hash, id, StringHash( str ), target )
    call SaveInteger( udg_hash, id, StringHash( str ), spell )
    call SaveInteger( udg_hash, id, StringHash( str + "1" ), buf )
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( target ), StringHash( str ) ), time, false, function buffrandomCast )
    set caster = null
    set target = null
endfunction

// Активация
function eyest takes unit u returns integer
    local integer k = 1
    local integer s
    local integer i = GetPlayerId(GetOwningPlayer( u ) ) + 1
    local integer id
    
    if inv( u, 'I0BX' ) > 0 and combat( u, false, 0 ) and not( udg_fightmod[3] ) then
        set s = LoadInteger( udg_hash, GetHandleId( u ), StringHash( udg_QuestItemCode[8] ) ) + 1
        call SaveInteger( udg_hash, GetHandleId( u ), StringHash( udg_QuestItemCode[8] ), s )

        if s >= udg_QuestNum[8] then
            call SetWidgetLife( GetItemOfTypeFromUnitBJ( u, 'I0BX'), 0 )
            set bj_lastCreatedItem = CreateItem( 'I0BY', GetUnitX(u), GetUnitY(u))
            call UnitAddItem(u, bj_lastCreatedItem)
            call textst( "|c00ffffff Scientific discovery completed!", u, 64, GetRandomReal( 45, 135 ), 12, 1.5 )
            call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\Human\\ReviveHuman\\ReviveHuman.mdl", GetUnitX(u), GetUnitY(u) ) )
            set udg_QuestDone[GetPlayerId( GetOwningPlayer(u) ) + 1] = true
        else
            call QuestDiscription( u, 'I0BX', s, udg_QuestNum[8] )
        endif
    endif
    
    if udg_modgood[1] and udg_combatlogic[i] and not(udg_fightmod[3]) then
        set id = GetHandleId( u )
    	set s = LoadInteger( udg_hash, id, StringHash( "mdgd1" ) ) + 1
        if s >= 4 then
            call SaveInteger( udg_hash, id, StringHash( "mdgd1" ), 0 )
            set k = k + 1
        elseif GetUnitState( u, UNIT_STATE_LIFE) > 0.405 then
            call SaveInteger( udg_hash, id, StringHash( "mdgd1" ), s )
            call textst( I2S( s ) + "/4", u, 64, GetRandomReal( 45, 135 ), 10, 1.5 )
        endif
    endif
    if GetUnitAbilityLevel( u, 'B06M') > 0 then
        set k = k * 3
        call UnitRemoveAbility( u, 'A0PN' )
        call UnitRemoveAbility( u, 'B06M' )
    elseif GetUnitAbilityLevel( u, 'B032') > 0 then
        set k = k * 2
    endif
    if GetUnitAbilityLevel( u, 'A054' ) > 0 and inv( u, 'I040' ) == 0 then
        call UnitRemoveAbility( u, 'A054' )
        call UnitRemoveAbility( u, 'B032' )
    endif
    set u = null
    return k
endfunction

// Пылающие кристаллы
function crist takes unit caster, integer i returns nothing
    local integer at = 0
    local integer m
    
    set m = 1

    if ( i + udg_cristal ) > 500 then
        set at = 500 - udg_cristal
        set udg_cristal = 500
    elseif ( i + udg_cristal ) < 0 then
        set at = -udg_cristal
        set udg_cristal = 0
    else
        set at = i
        set udg_cristal = udg_cristal + i
    endif
    if at != 0 then
        call BlzSetUnitBaseDamage( caster, BlzGetUnitBaseDamage(caster, 0) + at, 0 )
        call LeaderboardSetItemValue( udg_panel[m], LeaderboardGetPlayerIndex( udg_panel[m] , Player(4)), udg_cristal )
        call spectime("Abilities\\Spells\\Orc\\EtherealForm\\SpiritWalkerChange.mdl", GetUnitX( caster ), GetUnitY( caster ), 1 )
    endif
    set caster = null
endfunction

// Энтропия
function entropy takes unit caster, integer i returns nothing
    local integer k = GetPlayerId( GetOwningPlayer( caster ) ) + 1
    local integer at = 0
    local integer m

    if ( i + udg_entropy[k] ) > 500 then
        set at = 500 - udg_entropy[k]
        set udg_entropy[k] = 500
    elseif ( i + udg_entropy[k] ) < 0 then
        set at = -udg_entropy[k]
        set udg_entropy[k] = 0
    else
        set at = i
        set udg_entropy[k] = udg_entropy[k] + i
    endif
    if at != 0 and GetUnitTypeId(caster) == 'O016' then
        set m = 3
        call spdst( caster, at )
        call BlzSetUnitMaxMana( caster, BlzGetUnitMaxMana(caster) + (at*2) )
        call LeaderboardSetItemValue( udg_panel[m], LeaderboardGetPlayerIndex( udg_panel[m] , Player(4)), udg_entropy[k] )
        call spectime("Abilities\\Spells\\Orc\\EtherealForm\\SpiritWalkerChange.mdl", GetUnitX( caster ), GetUnitY( caster ), 1 )
    endif
    set caster = null
endfunction

// Призыв скелетов
function skeletsp takes unit caster, unit target returns nothing
    local integer lvl = GetUnitAbilityLevel( caster, 'A0CK')
    local real size
    
    if lvl < 1 then
        set lvl = 1
    endif
    set size = 0.75+(0.05*lvl)
    
    set bj_lastCreatedUnit = CreateUnit( GetOwningPlayer( caster ), 'u013', GetUnitX( target ), GetUnitY( target ), GetRandomReal( 0, 360 ) )
    call SetUnitAnimation( bj_lastCreatedUnit, "birth" )
    call QueueUnitAnimation( bj_lastCreatedUnit, "stand" )
    call UnitApplyTimedLife( bj_lastCreatedUnit , 'BTLF', 15 )
    call DestroyEffect(AddSpecialEffectTarget("war3mapImported\\SoulRitual.mdx", bj_lastCreatedUnit, "origin"))
    
    call BlzSetUnitMaxHP( bj_lastCreatedUnit, R2I(BlzGetUnitMaxHP(bj_lastCreatedUnit)+((lvl-1)*60)) )
    call BlzSetUnitBaseDamage( bj_lastCreatedUnit, R2I(BlzGetUnitBaseDamage(bj_lastCreatedUnit, 0)+((lvl-1)*3)), 0 )
    call SetUnitState( bj_lastCreatedUnit, UNIT_STATE_LIFE, GetUnitState( bj_lastCreatedUnit, UNIT_STATE_MAX_LIFE) )
    call SetUnitScale( bj_lastCreatedUnit, size, size, size )
    
    set caster = null
    set target = null
endfunction

function AdventurerQMotion takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local unit target = LoadUnitHandle( udg_hash, id, StringHash( "advqt" ) )
    local unit dummy = LoadUnitHandle( udg_hash, id, StringHash( "advq" ) )
    local real dmg = LoadReal( udg_hash, id, StringHash( "advq" ) )
    local real x = GetUnitX( target )
    local real y = GetUnitY( target )
    local real angle = Atan2( y - GetUnitY( dummy ), x - GetUnitX( dummy ) )
    local real NewX = GetUnitX( dummy ) + 30 * Cos( angle )
    local real NewY = GetUnitY( dummy ) + 30 * Sin( angle )
    local real IfX = ( x - GetUnitX( dummy ) ) * ( x - GetUnitX( dummy ) )
    local real IfY = ( y - GetUnitY( dummy ) ) * ( y - GetUnitY( dummy ) )
    
    if SquareRoot( IfX + IfY ) > 100 and GetUnitState( target, UNIT_STATE_LIFE ) > 0.405 and target != null then
        call SetUnitPosition( dummy, NewX, NewY )
        call GetUnitLoc( target )
    else
        call DestroyEffect( AddSpecialEffect( "Abilities\\Weapons\\FrostWyrmMissile\\FrostWyrmMissile.mdl", GetUnitX( target ), GetUnitY( target ) ) )
        call UnitDamageTarget( dummy, target, dmg, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS )
        call RemoveUnit( dummy )
        call PauseTimer( GetExpiredTimer() )
        call DestroyTimer( GetExpiredTimer() )
        call FlushChildHashtable( udg_hash, id )
    endif
    
    set dummy = null
    set target = null
endfunction 

function GetBossWordSymbol takes string word, boolean isLeft returns string
    if isLeft then
        return SubString(word, 0, 1)
    else
        return SubString(word, 6, 7)
    endif
endfunction

//Огр
function OgreQEnd takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer( ) )
    local unit u = LoadUnitHandle( udg_hash, id, StringHash( "ogrqd" ) )

    call UnitRemoveAbility( u, 'A0DP' )
    call UnitRemoveAbility( u, 'B067' )
    call FlushChildHashtable( udg_hash, id )

    set u = null
endfunction

// Безумие
function sheepCast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local unit caster = LoadUnitHandle( udg_hash, id, StringHash( "sheepmad" ) )
    local rect r = LoadRectHandle( udg_hash, id, StringHash( "sheepm" ) )
    
    if not( udg_combatlogic[GetPlayerId( GetOwningPlayer( caster ) ) + 1] ) then
        call DestroyTimer( GetExpiredTimer() )
        call FlushChildHashtable( udg_hash, id )
    else
        set bj_lastCreatedUnit = CreateUnitAtLoc( GetOwningPlayer( caster ), ID_SHEEP, Location(GetRandomReal(GetRectMinX(r), GetRectMaxX(r)), GetRandomReal(GetRectMinY(r), GetRectMaxY(r))), GetRandomReal( 0, 360 ) )
        call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\Human\\Polymorph\\PolyMorphDoneGround.mdl", GetUnitX( bj_lastCreatedUnit ), GetUnitY( bj_lastCreatedUnit ) ) )
    endif
    
    set r = null
    set caster = null
endfunction

function RemorseCast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local unit caster = LoadUnitHandle( udg_hash, id, StringHash( "remmad" ) )
    local integer lvl = LoadInteger( udg_hash, id, StringHash( "remmad" ) )
    local group g = CreateGroup()
    local unit u
    
    call GroupEnumUnitsInRect( g, udg_Boss_Rect, null )
    loop
        set u = FirstOfGroup(g)
        exitwhen u == null
        if unitst( u, caster, "all" ) then
            call DestroyEffect(AddSpecialEffect("Abilities\\Spells\\Undead\\AnimateDead\\AnimateDeadTarget.mdl", GetUnitX( u ), GetUnitY( u ) ) )
            call SetUnitState( u, UNIT_STATE_LIFE, RMaxBJ(0,GetUnitState( u, UNIT_STATE_LIFE) - ( GetUnitState( u, UNIT_STATE_MAX_LIFE) * (0.05*lvl) ) ) )
        endif
        call GroupRemoveUnit(g,u)
        set u = FirstOfGroup(g)
    endloop
    
    call GroupClear( g )
    call DestroyGroup( g )
    set g = null
    set u = null
    set caster = null
endfunction

function madness takes unit caster, integer lvl returns nothing
    local integer rand
    local integer cyclA = 1
    local integer cyclAEnd
    local integer cyclB
    local integer i
    local integer id = GetHandleId( caster )
    local string txt
    local group g = CreateGroup()
    local unit u

    if not(udg_fightmod[3]) then
        set rand = GetRandomInt( 1,10 )
    else
        set rand = GetRandomInt( 4,10 )
    endif

    if rand == 1 then
        call textst( "|c00FF6000 Resurrection!", caster, 64, 90, 15, 3 )
        if lvl == 1 or lvl == 2 then
            set i = 1
        elseif lvl == 3 or lvl == 4 then
            set i = 2
        elseif lvl == 5 then
            set i = 3
        endif
        call RessurectionPoints( i, false )
    elseif rand == 2 then
        call textst( "|c00FF6000 Chests!", caster, 64, 90, 15, 3 )
        set cyclA = 1
        set cyclAEnd = lvl
        loop
            exitwhen cyclA > cyclAEnd
            call CreateNUnitsAtLoc( 1, 'h01L', Player(PLAYER_NEUTRAL_AGGRESSIVE), GetRandomLocInRect(udg_Boss_Rect), 270 )
            set cyclA = cyclA + 1
        endloop
    elseif rand == 3 then
        call textst( "|c00FF6000 Legendary gifts!", caster, 64, 90, 15, 3 )
        
        set cyclB = 1
        loop
            exitwhen cyclB > 4
            set cyclA = 1
            set cyclAEnd = lvl
            loop
                exitwhen cyclA > cyclAEnd 
                if GetUnitState( udg_hero[cyclB], UNIT_STATE_LIFE) > 0.405 then
                    if UnitInventoryCount(udg_hero[cyclB]) < 6 then
                        call ItemRandomizer( udg_hero[cyclB], "legendary" )
                        call BlzSetItemIconPath( bj_lastCreatedItem, "|cffC71585Cursed|r|n" + BlzGetItemExtendedTooltip(bj_lastCreatedItem) )
                    else
                        set cyclA = cyclAEnd
                    endif
                endif 
                set cyclA = cyclA + 1
            endloop
            set cyclB = cyclB + 1
        endloop
    elseif rand == 4 then
        call textst( "|c00FF6000 Wrath!", caster, 64, 90, 15, 3 )
        call UnitAddAbility( caster, 'A0QM' )
        call SetUnitAbilityLevel( caster, 'A0NB', lvl )
    elseif rand == 5 then
        call textst( "|c00FF6000 Remorse!", caster, 64, 90, 15, 3 )
                
        if LoadTimerHandle( udg_hash, id, StringHash( "remmad" ) ) == null  then
            call SaveTimerHandle( udg_hash, id, StringHash( "remmad" ), CreateTimer() )
        endif
        set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "remmad" ) ) ) 
        call SaveUnitHandle( udg_hash, id, StringHash( "remmad" ), caster )
        call SaveInteger( udg_hash, id, StringHash( "remmad" ), lvl )
        call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( caster ), StringHash( "remmad" ) ), 1, false, function RemorseCast )
    elseif rand == 6 then
        call textst( "|c00FF6000 Apocalypse of Magic!", caster, 64, 90, 15, 3 )
        set udg_logic[34] = true
    elseif rand == 7 then
        call textst( "|c00FF6000 Runes!", caster, 64, 90, 15, 3 )
        if udg_fightmod[3] then
            set i = 5
        else
            set i = 1
        endif
        set cyclAEnd = 7 * lvl
        loop
            exitwhen cyclA > cyclAEnd
            call CreateItem( 'I03J' + GetRandomInt( i, 6 ), GetRandomReal(GetRectMinX(udg_Boss_Rect), GetRectMaxX(udg_Boss_Rect)), GetRandomReal(GetRectMinY(udg_Boss_Rect), GetRectMaxY(udg_Boss_Rect)) )
            set cyclA = cyclA + 1
        endloop
    elseif rand == 8 then
        call textst( "|c00FF6000 Superbot!", caster, 64, 90, 15, 3 )
        if lvl == 1 or lvl == 2 then
            set i = 1
        elseif lvl == 3  then
            set i = 2
        elseif lvl == 4 then
            set i = 3
        elseif lvl == 5 then
            set i = 4
        endif
        if i > udg_Heroes_Amount then
            set i = udg_Heroes_Amount
        endif
        set bj_groupAddGroupDest = g
        call ForGroup(udg_otryad, function GroupAddGroupEnum)
        loop
            set u = GroupPickRandomUnit(g)
            exitwhen u == null
            if i > 0 and GetUnitState( u, UNIT_STATE_LIFE) > 0.405 and IsUnitAlly( u, GetOwningPlayer( caster ) ) then
                call Superbot( u )
                set i = i - 1
            endif
            call GroupRemoveUnit(g,u)
        endloop
    elseif rand == 9 then
        call textst( "|c00FF6000 Sheep landing!", caster, 64, 90, 15, 3 )
        
        if LoadTimerHandle( udg_hash, id, StringHash( "sheepmad" ) ) == null  then
            call SaveTimerHandle( udg_hash, id, StringHash( "sheepmad" ), CreateTimer() )
        endif
        set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "sheepmad" ) ) ) 
        call SaveUnitHandle( udg_hash, id, StringHash( "sheepmad" ), caster )
        call SaveRectHandle( udg_hash, id, StringHash( "sheepm" ), udg_Boss_Rect )
        call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( caster ), StringHash( "sheepmad" ) ), 10/lvl, true, function sheepCast )
    elseif rand == 10 then
        call textst( "|c00FF6000 Tentacles!", caster, 64, 90, 15, 3 )
        set cyclAEnd = 10 * lvl
        loop
            exitwhen cyclA > cyclAEnd
            set bj_lastCreatedUnit = CreateUnitAtLoc( GetOwningPlayer( caster ), 'n03F', Location(GetRandomReal(GetRectMinX(udg_Boss_Rect), GetRectMaxX(udg_Boss_Rect)), GetRandomReal(GetRectMinY(udg_Boss_Rect), GetRectMaxY(udg_Boss_Rect))), 270 )
            call DestroyEffect(AddSpecialEffect("Abilities\\Spells\\Undead\\AnimateDead\\AnimateDeadTarget.mdl", GetUnitX( bj_lastCreatedUnit ), GetUnitY( bj_lastCreatedUnit ) ) )
            set cyclA = cyclA + 1
        endloop
    endif
    
    call GroupClear( g )
    call DestroyGroup( g )
    set g = null
    set u = null
    set caster = null
endfunction

globals
    real Event_CooldownReset_Real
    unit Event_CooldownReset_Hero
endglobals

// Cброс перезарядки
function coldstop takes unit u returns nothing
    local integer unitId =  GetHandleId( u )
	if inv( u, 'I0DR') > 0 then
		call SaveBoolean( udg_hash,unitId, StringHash( "wtii" ), false )
	endif
    if inv( u, 'I0DK') > 0 then
        call SaveBoolean( udg_hash, unitId, StringHash( "orbkm" ), false )
    endif
    if inv( u, 'I0ES') > 0 then
        call SaveBoolean( udg_hash, unitId, StringHash( "orbavh" ), false )
    endif
    if inv(u, 'I0ET') > 0 then
        call SaveBoolean( udg_hash, unitId, StringHash( "orbnt" ), false )
    endif
    if inv(u, 'I0F3') > 0 then
        call SaveBoolean( udg_hash, unitId, StringHash( "orbew" ), false )
    endif
    if inv(u, 'I0F5') > 0 then
        call SaveBoolean( udg_hash, unitId, StringHash( "orbth" ), false )
    endif
    if inv(u, 'I0FL') > 0 then
        call SaveBoolean( udg_hash, unitId, StringHash( "orbcn" ), false )
    endif
    /*if GetUnitAbilityLevel( u, 'A1BK') > 0 then
        call SaveInteger( udg_hash, unitId, StringHash( "dualch" ), 3 )
        if GetLocalPlayer() == GetOwningPlayer(u) then
            call BlzFrameSetText( dualtext, I2S(3) )
        endif
    endif*/
    if GetUnitAbilityLevel( u, 'A0OE') > 0 then
        call SaveInteger( udg_hash, unitId, StringHash( "entqch" ), 3 )
        if GetLocalPlayer() == GetOwningPlayer(u) then
            call BlzFrameSetText( entQText, I2S(CorruptedEntQ_CHARGE_LIMIT) )
        endif
    endif
    
	//if inv( u, 'I0B3') > 0 then
		//call SaveBoolean( udg_hash, unitId, StringHash( "drct" ), false )
	//endif
    set Event_CooldownReset_Hero = u
    set Event_CooldownReset_Real = 0.00
    set Event_CooldownReset_Real = 1.00
    set Event_CooldownReset_Real = 0.00

    call UnitResetCooldown( u )
    
    set u = null
endfunction

// Лунный мотылек
function mnbtflyCast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer( ) )
    local unit u = LoadUnitHandle( udg_hash, id, StringHash( "mbfl" ) )
    
    call UnitRemoveAbility( u, 'A0B1' )
    call UnitRemoveAbility( u, 'A0C3' )
    call UnitRemoveAbility( u, 'B04L' )
    call FlushChildHashtable( udg_hash, id )
    
    set u = null
endfunction

function mnbtfly takes unit caster returns nothing
    local integer id = GetHandleId( caster )

    call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\Items\\TomeOfRetraining\\TomeOfRetrainingCaster.mdl", GetUnitX( caster ), GetUnitY( caster ) ) )
    call UnitAddAbility( caster, 'A0B1' )
    call UnitAddAbility( caster, 'A0C3' )
    call shadowst( caster )
    
    if LoadTimerHandle( udg_hash, id, StringHash( "mbfl" ) ) == null then
        call SaveTimerHandle( udg_hash, id, StringHash( "mbfl" ), CreateTimer() )
    endif
	set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "mbfl" ) ) ) 
	call SaveUnitHandle( udg_hash, id, StringHash( "mbfl" ), caster )
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( caster ), StringHash( "mbfl" ) ), timebonus(caster, 30), false, function mnbtflyCast )
    
    set caster = null
endfunction

globals
    integer array PotionsUsedPerBattle[5]
endglobals

function potionst takes unit caster returns nothing
    local integer id = GetHandleId( LoadTimerHandle( udg_hash, GetHandleId( caster ), StringHash( "lqsf" ) ) )
    local integer i = GetPlayerId( GetOwningPlayer( caster ) ) + 1
    local string str
    local item it
    
    if udg_combatlogic[i] and not(udg_fightmod[3]) then
        set udg_PotionsUsed[i] = udg_PotionsUsed[i] + 1 
        if inv( caster, 'I0BA' ) > 0 then
            set it = GetItemOfTypeFromUnitBJ(caster, 'I0BA')
            if udg_PotionsUsed[i] == 5 then
                call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\Human\\Polymorph\\PolyMorphDoneGround.mdl", GetUnitX( caster ), GetUnitY( caster ) ) )
                set str = words( caster, BlzGetItemDescription(it), "|cFF959697(", ")|r", "Active!" )
                call BlzSetItemIconPath( it, str )
            elseif udg_PotionsUsed[i] < 5 then
                set str = words( caster, BlzGetItemDescription(it), "|cFF959697(", ")|r", I2S( udg_PotionsUsed[i] ) + "/5" )
                call BlzSetItemIconPath( it, str )
            endif
        endif
    endif
    if inv(caster, 'I01Y') > 0 then
        set PotionsUsedPerBattle[i] = PotionsUsedPerBattle[i] + 1
    endif
    
    set it = null
    set caster = null
endfunction

// Случайный герой
function RandomHero takes player p returns nothing
    local integer cyclA = 1
    local integer rand
    local integer i = GetPlayerId(p) + 1
    local integer s = LoadInteger( udg_hash, i, StringHash( "randpick" ) ) + 1

    if s <= 3 then
        if udg_Boss_LvL == 1 then
        	call DisplayTimedTextToPlayer( p, 0, 0, 10., "Attempts left: " + I2S( 3 - s ) )
        endif
        loop
            exitwhen cyclA > 1
            set rand = GetRandomInt(1, udg_Database_InfoNumberHeroes)
            if CountUnitsInGroup(GetUnitsOfTypeIdAll(udg_Database_Hero[rand])) == 0 and udg_UnitHeroLogic[rand] == false and IsBanned[rand] == false then
                set udg_logic[8] = true
                call CreateUnit( p, udg_Database_Hero[rand], GetRectCenterX(gg_rct_HeroesTp), GetRectCenterY(gg_rct_HeroesTp), 270 )
            else
                set cyclA = cyclA - 1
            endif
            set cyclA = cyclA + 1
        endloop
    endif
    call SaveInteger( udg_hash, i, StringHash( "randpick" ), s )
    
    set p = null
endfunction

// Фейерверк
function FeerverkEnd takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer( ) )
    local integer counter = LoadInteger( udg_hash, id, StringHash( "frvr" ) ) + 1
    local integer cyclA
    local integer cyclAEnd
    local effect fx
    
    if udg_fightmod[0] or counter > 20 then
        call FlushChildHashtable( udg_hash, id )
        call DestroyTimer( GetExpiredTimer() )
    else
        call SaveInteger( udg_hash, id, StringHash( "frvr" ), counter )
        set cyclA = 1
        set cyclAEnd = GetRandomInt(2, 5)
        loop
            exitwhen cyclA > cyclAEnd
            set fx = AddSpecialEffect(udg_Database_Feerverk[GetRandomInt(1, 4)], GetRectCenterX(gg_rct_Feerverk) + GetRandomReal( -2320, 2320 ), GetRectCenterY(gg_rct_Feerverk) + GetRandomReal( -656, 656 ) )
            call BlzSetSpecialEffectZ( fx, GetRandomReal(350,450) )
            call DestroyEffect( fx )
            set cyclA = cyclA + 1
        endloop
    endif
    
    set fx = null
endfunction

function Feerverk takes nothing returns nothing
    local timer t = CreateTimer()
    local integer id = GetHandleId( t )

	call TimerStart( t, 0.25, true, function FeerverkEnd )
endfunction

// Создание предметов
function DelItemsLogic takes nothing returns boolean
    local integer cyclA = 1
    local boolean l = false
    
    loop
        exitwhen cyclA > 12
        if GetFilterItem() != udg_item[cyclA] then
            set l = true
            set cyclA = 12
        endif
        set cyclA = cyclA + 1
    endloop
    return l
endfunction

function DelItems takes nothing returns nothing
    if not( RectContainsItem(GetFilterItem(), gg_rct_Feerverk) ) then
        call RemoveItem( GetFilterItem() )
    endif
endfunction

// Переход из режима в режим
function DelItem takes nothing returns nothing
    call RemoveItem( GetFilterItem() )
endfunction

globals
    real Event_EndOfLostBattle_Real
    unit Event_EndOfLostBattle_Hero
endglobals

function BetweenEnd takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local string str = LoadStr( udg_hash, id, StringHash( "waitend" ) )
    local integer cyclA = 1
    local integer cyclAEnd
    local integer cyclB
    local integer i
    local group g = CreateGroup()
    local unit u
    local unit h
    
    call EnableTrigger( gg_trg_Debug )
    set Battle_Ended = false
    
    call GroupEnumUnitsInRect( g, bj_mapInitialPlayableArea, null )
    loop
        set u = FirstOfGroup(g)
        exitwhen u == null
        if GetUnitTypeId( u ) == 'n059' or GetUnitTypeId( u ) == 'n01Z' or GetUnitTypeId( u ) == 'h009' or GetUnitTypeId( u ) == 'h01F' or GetUnitTypeId( u ) == 'h00C' then
            call KillUnit( u )
        endif
        call GroupRemoveUnit(g,u)
    endloop
    
    loop
        exitwhen cyclA > 4
            if GetPlayerSlotState(Player(cyclA - 1)) == PLAYER_SLOT_STATE_PLAYING then
                call ShowUnitShow( udg_hero[cyclA] )
                set udg_fightlogic[cyclA] = false
                if not( udg_fightmod[3] ) or udg_hero[cyclA] == udg_unit[57] or udg_hero[cyclA] == udg_unit[58] then
                    set udg_logic[cyclA + 36] = false
                    call ReviveHeroLoc( udg_hero[cyclA], udg_point[cyclA + 21], true )
                    call DestroyEffect( AddSpecialEffect( "Void Teleport Caster.mdx", GetUnitX(udg_hero[cyclA]), GetUnitY(udg_hero[cyclA]) ) )
                    call SetUnitState( udg_hero[cyclA], UNIT_STATE_LIFE, GetUnitState( udg_hero[cyclA], UNIT_STATE_MAX_LIFE) )
                    call SetUnitState( udg_hero[cyclA], UNIT_STATE_MANA, GetUnitState( udg_hero[cyclA], UNIT_STATE_MAX_MANA) )
                    call UnitResetCooldown( udg_hero[cyclA] )
                    call IssueImmediateOrder( udg_hero[cyclA], "stop" )
                    call GroupAddUnit( udg_otryad, udg_hero[cyclA] )
                    call DelBuff( udg_hero[cyclA], true )
                    call SetUnitOwner( udg_hero[cyclA], Player(cyclA - 1), true )
                    if LoadUnitHandle( udg_hash, GetHandleId( LoadTimerHandle( udg_hash, GetHandleId( udg_hero[cyclA] ), StringHash( "mad" ) ) ), StringHash( "mad" ) ) == udg_hero[cyclA] then
                        call DestroyTimer( LoadTimerHandle( udg_hash, GetHandleId( udg_hero[cyclA] ), StringHash( "mad" ) ) )
                        call FlushChildHashtable( udg_hash, GetHandleId( LoadTimerHandle( udg_hash, GetHandleId( udg_hero[cyclA] ), StringHash( "mad" ) ) ) )
                    endif
                    if LoadUnitHandle( udg_hash, GetHandleId( LoadTimerHandle( udg_hash, GetHandleId( udg_hero[cyclA] ), StringHash( "sheepmad" ) ) ), StringHash( "sheepmad" ) ) == udg_hero[cyclA] then
                        call DestroyTimer( LoadTimerHandle( udg_hash, GetHandleId( udg_hero[cyclA] ), StringHash( "sheepmad" ) ) )
                        call FlushChildHashtable( udg_hash, GetHandleId( LoadTimerHandle( udg_hash, GetHandleId( udg_hero[cyclA] ), StringHash( "sheepmad" ) ) ) )
                    endif
                    set bj_livingPlayerUnitsTypeId = 'u000'
                    call GroupEnumUnitsOfPlayer(g, Player(cyclA - 1), filterLivingPlayerUnitsOfTypeId)
                    loop
                        set u = FirstOfGroup(g)
                        exitwhen u == null
                        call RemoveUnit( u )
                        call GroupRemoveUnit(g,u)
                    endloop
                    call GroupEnumUnitsOfPlayer(g, Player(cyclA - 1), null )
                    loop
                        set u = FirstOfGroup(g)
                        exitwhen u == null
                        if not( IsUnitType( u, UNIT_TYPE_HERO) ) and not( IsUnitType( u, UNIT_TYPE_STRUCTURE) ) and GetUnitTypeId(u) != 'o01F' and GetUnitTypeId(u) != 'h01F' then
                            if GetUnitTypeId(u) == 'u00X' then
                                set h = LoadUnitHandle( udg_hash, GetHandleId(u), StringHash( "sldg" ) )
                                if h != null then
                                    call BlzSetUnitMaxHP( h, R2I(BlzGetUnitMaxHP(h)+BlzGetUnitMaxHP(u)) )
                                    call BlzSetUnitBaseDamage( h, R2I(BlzGetUnitBaseDamage(h, 0)+BlzGetUnitBaseDamage(u, 0)+1), 0 )
                                endif
                            endif
                            call RemoveUnit( u )
                        endif
                        call GroupRemoveUnit(g,u)
                    endloop
                    
                    if str == "res_boss" or str == "end_IA" or str == "end_AL" then
                        set Event_EndOfLostBattle_Hero = udg_hero[cyclA]
                        set Event_EndOfLostBattle_Real = 0.00
                        set Event_EndOfLostBattle_Real = 1.00
                        set Event_EndOfLostBattle_Real = 0.00
                    endif
                endif
            endif
        set cyclA = cyclA + 1
    endloop
    call GroupEnumUnitsInRect( g, udg_Boss_BigRect, null )
    loop
        set u = FirstOfGroup(g)
        exitwhen u == null
        if not( IsUnitType( u, UNIT_TYPE_HERO) ) then
            call RemoveUnit( u )
        endif
        call GroupRemoveUnit(g,u)
    endloop
    call GroupEnumUnitsOfPlayer(g, Player(4), null )
    loop
        set u = FirstOfGroup(g)
        exitwhen u == null
        if u != gg_unit_u00F_0006 then
            call RemoveUnit( u )
        endif
        call GroupRemoveUnit(g,u)
    endloop
    call EnumItemsInRect( udg_Boss_BigRect, null, function DelItem )
    
    set bj_livingPlayerUnitsTypeId = 'u000'
    call GroupEnumUnitsOfPlayer(g, Player(10), filterLivingPlayerUnitsOfTypeId)
    loop
        set u = FirstOfGroup(g)
        exitwhen u == null
        call RemoveUnit( u )
        call GroupRemoveUnit(g,u)
    endloop

    call GroupEnumUnitsInRect( g, gg_rct_Vision1, null )
    loop
        set u = FirstOfGroup(g)
        exitwhen u == null
        if GetUnitTypeId( u ) == 'n031' or GetUnitTypeId( u ) == 'n05B' or GetUnitTypeId( u ) == 'n04S' or GetUnitTypeId( u ) == 'h022' or GetUnitTypeId( u ) == 'n01K' or GetUnitTypeId( u ) == 'n043' or GetUnitTypeId( u ) == 'n058' or GetUnitTypeId( u ) == 'n044' or GetUnitTypeId( u ) == 'n042' or GetUnitTypeId( u ) == 'o013' or GetUnitTypeId( u ) == 'h01J' or GetUnitTypeId( u ) == 'n04G' then
            call RemoveUnit( u )
        endif
        call GroupRemoveUnit(g,u)
    endloop
    
    if str == "end_boss" then
        call TriggerExecute( gg_trg_EndFightWork )
    elseif str == "res_boss" then
        call TriggerExecute( gg_trg_Ressurect )
    elseif str == "end_IA" then
        call TriggerExecute( gg_trg_IA_EndWork )
    elseif str == "end_AL" then
        call TriggerExecute( gg_trg_AL_EndWork )
    elseif str == "end_PA" then
        call TriggerExecute( gg_trg_PA_EndWork )
    endif
    
    call FlushChildHashtable( udg_hash, id )
    
    call GroupClear( g )
    call DestroyGroup( g )
    set u = null
    set g = null
    set h = null
endfunction

function RemoveBots takes nothing returns nothing
    local group g = CreateGroup()
    local unit u

    call GroupEnumUnitsInRect( g, bj_mapInitialPlayableArea, null )
    loop
        set u = FirstOfGroup(g)
        exitwhen u == null
        if GetUnitTypeId( u ) == 'n01Z' or GetUnitTypeId( u ) == 'n059' then
            call KillUnit( u )
        endif
        call GroupRemoveUnit(g,u)
    endloop
    
    call GroupClear( g )
    call DestroyGroup( g )
    set u = null
    set g = null
endfunction

globals
    boolean Battle_Ended = false
endglobals

function Between takes string str returns nothing
    local integer cyclA = 1
    local integer cyclAEnd
    local integer cyclB
    local integer i
    local boolean l = false
    local integer id

    set udg_Heroes_Deaths = 0
    set udg_Player_Readiness = 0
    set udg_Pattern = udg_Pattern + 1
    set udg_real[0] = 1

    set udg_logic[73] = false
    call GroupClear( udg_NecroWool )
    call GroupClear( udg_YoricSkull )
    if str != "res_boss" or str != "end_LA"  then
        call GroupClear( udg_Bosses )
    endif
    call DisableTrigger( gg_trg_IA_End )
    call DisableTrigger( gg_trg_PA_End )
    call DisableTrigger( gg_trg_HeroDeath )
    
    set cyclA = 1
    loop
        exitwhen cyclA > 4
        if GetPlayerSlotState(Player(cyclA - 1)) == PLAYER_SLOT_STATE_PLAYING then
            set PotionsUsedPerBattle[cyclA] = 0
    	    call GroupRemoveUnit( udg_DeadHero, udg_hero[cyclA])
            call DelBuff( udg_hero[cyclA], true )
            call UnitRemoveAbility( udg_hero[cyclA], 'B00J' )
            call SetUnitOwner( udg_hero[cyclA], Player(cyclA - 1), true )
            if BlzGetUnitMaxHP(udg_hero[cyclA]) < 0.405 and udg_hero[cyclA] != null then
                call BlzSetUnitMaxHP( udg_hero[cyclA], 100 )
            endif
            if not( udg_fightmod[3] ) or udg_hero[cyclA] == udg_unit[57] or udg_hero[cyclA] == udg_unit[58] then
                set udg_logic[cyclA + 36] = false
                call GroupAddUnit( udg_otryad, udg_hero[cyclA] )
                if SubString( str, 0, 5 ) == "start" then
                    call SetUnitState( udg_hero[cyclA], UNIT_STATE_LIFE, GetUnitState( udg_hero[cyclA], UNIT_STATE_MAX_LIFE) )
                    call SetUnitState( udg_hero[cyclA], UNIT_STATE_MANA, GetUnitState( udg_hero[cyclA], UNIT_STATE_MAX_MANA) )
                    call ReviveHeroLoc( udg_hero[cyclA], udg_point[cyclA + 21], true )
                    call coldstop( udg_hero[cyclA] )
                    call IssueImmediateOrder( udg_hero[cyclA], "stop" )
                endif
                if GetUnitAbilityLevel(udg_hero[cyclA], 'B03D') > 0 then
                    call UnitRemoveAbility( udg_hero[cyclA], 'A0HU' )
                    call UnitRemoveAbility( udg_hero[cyclA], 'B03D' )   
                    call spdst( udg_hero[cyclA], -20 )
                endif
                if LoadUnitHandle( udg_hash, GetHandleId( LoadTimerHandle( udg_hash, GetHandleId( udg_hero[cyclA] ), StringHash( "mad" ) ) ), StringHash( "mad" ) ) == udg_hero[cyclA] then
                    call DestroyTimer( LoadTimerHandle( udg_hash, GetHandleId( udg_hero[cyclA] ), StringHash( "mad" ) ) )
                    call FlushChildHashtable( udg_hash, GetHandleId( LoadTimerHandle( udg_hash, GetHandleId( udg_hero[cyclA] ), StringHash( "mad" ) ) ) )
                endif
                if LoadUnitHandle( udg_hash, GetHandleId( LoadTimerHandle( udg_hash, GetHandleId( udg_hero[cyclA] ), StringHash( "sheepmad" ) ) ), StringHash( "sheepmad" ) ) == udg_hero[cyclA] then
                    call DestroyTimer( LoadTimerHandle( udg_hash, GetHandleId( udg_hero[cyclA] ), StringHash( "sheepmad" ) ) )
                    call FlushChildHashtable( udg_hash, GetHandleId( LoadTimerHandle( udg_hash, GetHandleId( udg_hero[cyclA] ), StringHash( "sheepmad" ) ) ) )
                endif
                if GetUnitAbilityLevel( udg_hero[cyclA], 'A1A5') > 0 then
                    call platest(udg_hero[cyclA], 10 )
                    call SaveReal( udg_hash, GetHandleId( udg_hero[cyclA] ), StringHash( "infen" ), GetUnitState( udg_hero[cyclA], UNIT_STATE_MAX_LIFE) * 0.2 )
                endif
                if LoadInteger( udg_hash, GetHandleId( udg_hero[cyclA] ), StringHash( "dgca" ) ) > 0 then
                    call UnitRemoveAbility( udg_hero[cyclA], 'A1AH' )
                    call UnitRemoveAbility( udg_hero[cyclA], 'B05S' )
                    call SpellUniqueUnit(udg_hero[cyclA], -20*LoadInteger( udg_hash, GetHandleId( udg_hero[cyclA] ), StringHash( "dgca" ) ))
                    call SaveInteger( udg_hash, GetHandleId( udg_hero[cyclA] ), StringHash( "dgca" ), 0 )
                endif
            endif
        set cyclB = 0
        loop
            exitwhen cyclB > 3
            if cyclA-1 != cyclB then
                call SetPlayerAllianceStateBJ( Player(cyclA-1), Player(cyclB), bj_ALLIANCE_ALLIED_VISION )
            endif
            set cyclB = cyclB + 1
        endloop
        endif
        set cyclA = cyclA + 1
    endloop
   
    if str == "start_boss" then
        call TriggerExecute( gg_trg_StartFightWork )
    elseif str == "start_IA" then
        call TriggerExecute( gg_trg_IA_StartWork )
    elseif str == "start_AL" then
        call TriggerExecute( gg_trg_AL_StartWork )
    elseif str == "end_boss" or str == "res_boss" or str == "end_IA" or str == "end_AL" or str == "end_PA" then
        call DisableTrigger( gg_trg_Debug )
        set l = true
        call StartSound( gg_snd_ovations )
        set cyclA = 0
        loop
            exitwhen cyclA > 3
            if GetPlayerSlotState(Player(cyclA)) == PLAYER_SLOT_STATE_PLAYING then
                call DisplayTimedTextToPlayer( Player(cyclA), 0, 0, 3., "|cffffcc00END OF BATTLE" )
            endif
            set cyclA = cyclA + 1
        endloop
    endif
    
    call RemoveBots()
    
    if GetUnitAbilityLevel(gg_unit_u00F_0006, 'A153') > 0 then
        call rainst( -1 )
        call UnitRemoveAbility( gg_unit_u00F_0006, 'A153' )
        call UnitRemoveAbility( gg_unit_u00F_0006, 'A13E' )
    endif
    
    if l then
        set Battle_Ended = true
        set id = GetHandleId( gg_unit_h00A_0034 )
        if LoadTimerHandle( udg_hash, id, StringHash( "waitend" ) ) == null  then
            call SaveTimerHandle( udg_hash, id, StringHash( "waitend" ), CreateTimer() )
        endif
        set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "waitend" ) ) ) 
        call SaveStr( udg_hash, id, StringHash( "waitend" ), str )
        call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( gg_unit_h00A_0034 ), StringHash( "waitend" ) ), 2, false, function BetweenEnd )
    endif
    
    
endfunction

// Начало боя
function ModBad5 takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer( ) )
    local unit u = LoadUnitHandle( udg_hash, id, StringHash( "mdb5" ) )
    local real r = ( GetUnitState( u, UNIT_STATE_MANA) / RMaxBJ(0,GetUnitState( u, UNIT_STATE_MAX_MANA)) ) * 100

    if not( udg_combatlogic[GetPlayerId( GetOwningPlayer( u ) ) + 1] ) then
        call FlushChildHashtable( udg_hash, id )
        call DestroyTimer( GetExpiredTimer() )
    elseif r <= 20 and GetUnitState( u, UNIT_STATE_LIFE) > 0.405 then
        call SetUnitState( u, UNIT_STATE_MANA, 0 ) 
        call DestroyEffect( AddSpecialEffectTarget( "Objects\\Spawnmodels\\NightElf\\NECancelDeath\\NECancelDeath.mdl", u, "origin" ) )
        call FlushChildHashtable( udg_hash, id )
        call DestroyTimer( GetExpiredTimer() )
    endif
    
    set u = null
endfunction

function ModBad8Cast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    call UnitRemoveAbility( LoadUnitHandle( udg_hash, id, StringHash( "mdb8db" ) ), 'A0I5' )
    call UnitRemoveAbility( LoadUnitHandle( udg_hash, id, StringHash( "mdb8db" ) ), 'B03F' )
    call FlushChildHashtable( udg_hash, id )
endfunction

function ModBad12 takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer( ) )
    local integer cyclA = 1
    local boolean l

    if not( udg_fightmod[0] ) then
        call FlushChildHashtable( udg_hash, id )
        call DestroyTimer( GetExpiredTimer() )
    else
		loop
			exitwhen cyclA > 4
			if GetPlayerSlotState( Player( cyclA - 1 ) ) == PLAYER_SLOT_STATE_PLAYING and GetUnitState( udg_hero[cyclA], UNIT_STATE_LIFE) > 0.405 then
                set l = false
				if (GetUnitState( udg_hero[cyclA], UNIT_STATE_LIFE)/RMaxBJ(1,GetUnitState( udg_hero[cyclA], UNIT_STATE_MAX_LIFE))) > 0.8 then
					call SetUnitState( udg_hero[cyclA], UNIT_STATE_LIFE, GetUnitState( udg_hero[cyclA], UNIT_STATE_LIFE ) * 0.8 )
                    set l = true
				endif
				if (GetUnitState( udg_hero[cyclA], UNIT_STATE_MANA)/RMaxBJ(1,GetUnitState( udg_hero[cyclA], UNIT_STATE_MAX_MANA))) > 0.8 then
					call SetUnitState( udg_hero[cyclA], UNIT_STATE_MANA, GetUnitState( udg_hero[cyclA], UNIT_STATE_MANA ) * 0.8 )
                    set l = true
				endif
                if l then
                    call DestroyEffect( AddSpecialEffect( "war3mapImported\\SoulRitual.mdx", GetUnitX( udg_hero[cyclA] ), GetUnitY( udg_hero[cyclA] ) ) )
                endif
			endif
			set cyclA = cyclA + 1
		endloop
    endif
endfunction

function ModBad16End takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local unit dummy = LoadUnitHandle( udg_hash, id, StringHash( "mdb16e" ) )
    local group g = CreateGroup()
    local unit u
    
    call DestroyEffect( AddSpecialEffect( "Objects\\Spawnmodels\\Naga\\NagaDeath\\NagaDeath.mdl", GetUnitX( dummy ), GetUnitY( dummy ) + 70 ) )
    call DestroyEffect( AddSpecialEffect( "Objects\\Spawnmodels\\Naga\\NagaDeath\\NagaDeath.mdl", GetUnitX( dummy ) + 100, GetUnitY( dummy ) - 100 ) )
    call DestroyEffect( AddSpecialEffect( "Objects\\Spawnmodels\\Naga\\NagaDeath\\NagaDeath.mdl", GetUnitX( dummy ) - 100, GetUnitY( dummy ) - 100 ) )
    call GroupEnumUnitsInRange( g, GetUnitX( dummy ), GetUnitY( dummy ), 250, null )
    loop
        set u = FirstOfGroup(g)
        exitwhen u == null
        if unitst( u, dummy, "enemy" ) then
            call UnitDamageTarget( dummy, u, GetUnitState( u, UNIT_STATE_MAX_LIFE) * 0.2, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS)
        endif
        call GroupRemoveUnit(g,u)
    endloop
    
    call RemoveUnit( dummy )
    
    call FlushChildHashtable( udg_hash, id )
    call GroupClear( g )
    call DestroyGroup( g )
    set u = null
    set g = null
    set dummy = null
endfunction 

function ModBad16 takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local integer id1
    local unit u = GroupPickRandomUnit(udg_otryad)

    if not( udg_fightmod[0] ) then
        call DestroyTimer( GetExpiredTimer() )
        call FlushChildHashtable( udg_hash, id )
    elseif u != null then
        set bj_lastCreatedUnit = CreateUnit( Player(10), 'u000', GetUnitX( u ) + GetRandomReal(-300, 300), GetUnitY( u ) + GetRandomReal(-300, 300), 270 )
        call SetUnitScale(bj_lastCreatedUnit, 2.5, 2.5, 2.5 )
        call UnitAddAbility( bj_lastCreatedUnit, 'A136')
        
        set id1 = GetHandleId( bj_lastCreatedUnit )
        if LoadTimerHandle( udg_hash, id1, StringHash( "mdb16e" ) ) == null  then
            call SaveTimerHandle( udg_hash, id1, StringHash( "mdb16e" ), CreateTimer() )
        endif
        set id1 = GetHandleId( LoadTimerHandle( udg_hash, id1, StringHash( "mdb16e" ) ) ) 
        call SaveUnitHandle( udg_hash, id1, StringHash( "mdb16e" ), bj_lastCreatedUnit )
        call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( bj_lastCreatedUnit ), StringHash( "mdb16e" ) ), 4, false, function ModBad16End )
    endif
    
    set u = null
endfunction

function ModBad24End takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer( ) )
    local unit dummy = LoadUnitHandle( udg_hash, id, StringHash( "mdb24e" ) )
    local unit target = LoadUnitHandle( udg_hash, id, StringHash( "mdb24et" ) )
    
    if GetUnitState( target, UNIT_STATE_LIFE) > 0.405 then
        if DistanceBetweenUnits(target, dummy) < 50 then
            call DestroyEffect( AddSpecialEffect("Abilities\\Spells\\Other\\Incinerate\\FireLordDeathExplode.mdl", GetUnitX(target), GetUnitY(target)) )
            call UnitDamageTarget(dummy, target, GetUnitState( target, UNIT_STATE_MAX_LIFE) * 0.1, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS)
            if GetUnitState( target, UNIT_STATE_LIFE) > 0.405 then
                call UnitStun(dummy, target, 2 )
            endif
            call RemoveUnit( dummy )
            call FlushChildHashtable( udg_hash, id )
            call DestroyTimer( GetExpiredTimer() )
        else
            call IssuePointOrder( dummy, "move", GetUnitX( target ), GetUnitY( target ) )
        endif
    else
        call DestroyEffect( AddSpecialEffect("Abilities\\Spells\\Orc\\MirrorImage\\MirrorImageDeathCaster.mdl", GetUnitX(dummy), GetUnitY(dummy)) )
        call RemoveUnit( dummy )
        call FlushChildHashtable( udg_hash, id )
        call DestroyTimer( GetExpiredTimer() )
    endif
    
    set target = null
    set dummy = null
endfunction

function ModBad24 takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local integer id1
    local unit u = GroupPickRandomUnit(udg_otryad)
    local real x
    local real y

    if not( udg_fightmod[0] ) then
        call DestroyTimer( GetExpiredTimer() )
        call FlushChildHashtable( udg_hash, id )
    elseif u != null then
        set x = GetRandomReal(-800, 800)
        if x > -400 then
            set x = -400
        elseif x < 400 then
            set x = 400
        endif
        set y = GetRandomReal(-800, 800)
        if y > -400 then
            set y = -400
        elseif y < 400 then
            set y = 400
        endif
        set bj_lastCreatedUnit = CreateUnit( Player(10), 'u000', GetUnitX( u ) + x, GetUnitY( u ) + y, 270 )
        call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\Orc\\MirrorImage\\MirrorImageDeathCaster.mdl", GetUnitX( bj_lastCreatedUnit ), GetUnitY( bj_lastCreatedUnit ) ) )
        call SetUnitScale(bj_lastCreatedUnit, 2, 2, 2 )
        call UnitAddAbility( bj_lastCreatedUnit, 'A0Z7')
        call SetUnitMoveSpeed( bj_lastCreatedUnit, 200 )
        call IssuePointOrder( bj_lastCreatedUnit, "move", GetUnitX( u ), GetUnitY( u ) )
        
        set id1 = GetHandleId( bj_lastCreatedUnit )
        if LoadTimerHandle( udg_hash, id1, StringHash( "mdb24e" ) ) == null then
            call SaveTimerHandle( udg_hash, id1, StringHash( "mdb24e" ), CreateTimer() )
        endif
        set id1 = GetHandleId( LoadTimerHandle( udg_hash, id1, StringHash( "mdb24e" ) ) ) 
        call SaveUnitHandle( udg_hash, id1, StringHash( "mdb24e" ), bj_lastCreatedUnit )
        call SaveUnitHandle( udg_hash, id1, StringHash( "mdb24et" ), u )
        call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( bj_lastCreatedUnit ), StringHash( "mdb24e" ) ), 0.2, true, function ModBad24End )
    endif
    
    set u = null
endfunction

function ModBad17End takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local unit dummy = LoadUnitHandle( udg_hash, id, StringHash( "mdb17e" ) )
    
    if not( udg_fightmod[0] ) or GetUnitState( dummy, UNIT_STATE_LIFE) <= 0.405 or not(RectContainsUnit(udg_Boss_Rect, dummy)) then
    	call RemoveUnit( dummy )
        call DestroyTimer( GetExpiredTimer() )
        call FlushChildHashtable( udg_hash, id )
    endif
    
    set dummy = null
endfunction 

function ModBad17 takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local integer id1
    local real x
    local real y

    if not( udg_fightmod[0] ) then
        call DestroyTimer( GetExpiredTimer() )
        call FlushChildHashtable( udg_hash, id )
    else
	if udg_Boss_Rect == gg_rct_ArenaBossSmall then
		set x = GetRectCenterX( udg_Boss_Rect ) + 1200
		set y = GetRectCenterY( udg_Boss_Rect ) + GetRandomReal( -1200, 1200 )
	else
		set x = GetRectCenterX( udg_Boss_Rect ) + 1800
		set y = GetRectCenterY( udg_Boss_Rect ) + GetRandomReal( -1800, 1800 )
	endif
        set bj_lastCreatedUnit = CreateUnit( Player(10), 'u000', x, y, 270 )
        call SetUnitScale(bj_lastCreatedUnit, 2, 2, 2 )
        call UnitAddAbility( bj_lastCreatedUnit, 'A0M7')
        call UnitAddAbility( bj_lastCreatedUnit, 'A0M5')
    	call SetUnitMoveSpeed( bj_lastCreatedUnit, 100 )
        call IssuePointOrder( bj_lastCreatedUnit, "move", GetUnitX( bj_lastCreatedUnit ) - 5000, GetUnitY( bj_lastCreatedUnit ) )

        set id1 = GetHandleId( bj_lastCreatedUnit )
        if LoadTimerHandle( udg_hash, id1, StringHash( "mdb17e" ) ) == null  then
            call SaveTimerHandle( udg_hash, id1, StringHash( "mdb17e" ), CreateTimer() )
        endif
        set id1 = GetHandleId( LoadTimerHandle( udg_hash, id1, StringHash( "mdb17e" ) ) ) 
        call SaveUnitHandle( udg_hash, id1, StringHash( "mdb17e" ), bj_lastCreatedUnit )
        call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( bj_lastCreatedUnit ), StringHash( "mdb17e" ) ), 1, true, function ModBad17End )
    endif
endfunction

function ModGood20 takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer( ) )
    local unit u = LoadUnitHandle( udg_hash, id, StringHash( "mdg20" ) )
    local real r = ( GetUnitState( u, UNIT_STATE_LIFE) / RMaxBJ(0,GetUnitState( u, UNIT_STATE_MAX_LIFE)) ) * 100
    local integer cyclA = 1

    if not( udg_combatlogic[GetPlayerId( GetOwningPlayer( u ) ) + 1] ) then
        call FlushChildHashtable( udg_hash, id )
        call DestroyTimer( GetExpiredTimer() )
    elseif r <= 20 and GetUnitState( u, UNIT_STATE_LIFE) > 0.405 then
        call healst( u, null, GetUnitState( u, UNIT_STATE_MAX_LIFE) * 0.2 )
        call DestroyEffect( AddSpecialEffectTarget("Abilities\\Spells\\Human\\ReviveHuman\\ReviveHuman.mdl", u, "origin" ) )
        call FlushChildHashtable( udg_hash, id )
        call DestroyTimer( GetExpiredTimer() )
    endif
    
    set u = null
endfunction

function ModGood25 takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer( ) )

    if not( udg_fightmod[0] ) then
        call FlushChildHashtable( udg_hash, id )
        call DestroyTimer( GetExpiredTimer() )
    else
        set bj_lastCreatedUnit = CreateUnitAtLoc( Player(4), 'u000', Location(GetRandomReal(GetRectMinX(udg_Boss_Rect), GetRectMaxX(udg_Boss_Rect)), GetRandomReal(GetRectMinY(udg_Boss_Rect), GetRectMaxY(udg_Boss_Rect))), 270 )
        call UnitApplyTimedLife( bj_lastCreatedUnit, 'BTLF', 1. )
        call UnitAddAbility( bj_lastCreatedUnit, 'A11D' )
        call IssuePointOrder( bj_lastCreatedUnit, "dreadlordinferno", GetUnitX( bj_lastCreatedUnit ), GetUnitY( bj_lastCreatedUnit ) )
    endif
endfunction

function AllDeadIdol takes nothing returns boolean
    local integer cyclA = 1
    local integer i = 0
    local boolean l = false
    
    loop
        exitwhen cyclA > 4
        if GetUnitState(udg_hero[cyclA], UNIT_STATE_LIFE) <= 0.405 then
            set i = i + 1
        endif
        set cyclA = cyclA + 1
    endloop
    if i >= 3 then
        set l = true
    endif
    return l
endfunction

function ModBad8 takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer( ) )
    local integer id1
    local unit u

    if not( udg_fightmod[1] ) then
        call FlushChildHashtable( udg_hash, id )
        call DestroyTimer( GetExpiredTimer() )
    else
        set u = GroupPickRandomUnit(udg_otryad)
        
        set id1 = GetHandleId( u )
        call UnitAddAbility( u, 'A0I5' )
        call DestroyEffect( AddSpecialEffectTarget( "Abilities\\Spells\\Other\\HowlOfTerror\\HowlCaster.mdl", u, "origin") )
        call textst( "|c00FF6000 FATIGUE!", u, 64, 90, 15, 1.5 )
        
        if LoadTimerHandle( udg_hash, id1, StringHash( "mdb8db" ) ) == null  then
            call SaveTimerHandle( udg_hash, id1, StringHash( "mdb8db" ), CreateTimer() )
        endif
        set id1 = GetHandleId( LoadTimerHandle( udg_hash, id1, StringHash( "mdb8db" ) ) ) 
        call SaveUnitHandle( udg_hash, id1, StringHash( "mdb8db" ), u )
        call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( u ), StringHash( "mdb8db" ) ), 10, false, function ModBad8Cast )
    endif
    
    set u = null
endfunction

function GlassTooth takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer( ) )
    local unit caster = LoadUnitHandle( udg_hash, id, StringHash( "gltz" ) )
    
    if GetUnitState( caster, UNIT_STATE_LIFE) > 0.405 and GetUnitAbilityLevel( caster, 'B05K') > 0 then
        call DestroyEffect( AddSpecialEffectTarget("Abilities\\Spells\\Items\\AIma\\AImaTarget.mdl", caster, "origin" ) )
        call healst( caster, null, GetUnitState( caster, UNIT_STATE_MAX_LIFE) )
        call manast( caster, null, GetUnitState( caster, UNIT_STATE_MAX_MANA) )
    endif 
    call UnitRemoveAbility( caster, 'A0XG' )
    call UnitRemoveAbility( caster, 'B05K' )
    call FlushChildHashtable( udg_hash, id )
    
    set caster = null
endfunction

function OctopusEnd takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer( ) )
    local unit caster = LoadUnitHandle( udg_hash, id, StringHash( "octo" ) )
    local integer cyclB = 1
    local integer cyclBEnd = LoadInteger( udg_hash, id, StringHash( "octo" ) )
    
    loop
        exitwhen cyclB > cyclBEnd
        set bj_lastCreatedUnit = CreateUnitAtLoc( GetOwningPlayer( caster ), 'n03F', Location(GetRandomReal(GetRectMinX(udg_Boss_Rect), GetRectMaxX(udg_Boss_Rect)), GetRandomReal(GetRectMinY(udg_Boss_Rect), GetRectMaxY(udg_Boss_Rect))), 270 )
        call DestroyEffect(AddSpecialEffect("Abilities\\Spells\\Undead\\AnimateDead\\AnimateDeadTarget.mdl", GetUnitX( bj_lastCreatedUnit ), GetUnitY( bj_lastCreatedUnit ) ) )
        set cyclB = cyclB + 1
    endloop
    call FlushChildHashtable( udg_hash, id )
    
    set caster = null
endfunction

function WitchLoveEnd takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer( ) )
    local unit caster = LoadUnitHandle( udg_hash, id, StringHash( "wilv" ) )
    
	set bj_lastCreatedUnit = CreateUnitAtLoc( GetOwningPlayer( caster ), 'h021', Location(GetRandomReal(GetRectMinX(udg_Boss_Rect), GetRectMaxX(udg_Boss_Rect)), GetRandomReal(GetRectMinY(udg_Boss_Rect), GetRectMaxY(udg_Boss_Rect))), 270 )
    call DestroyEffect(AddSpecialEffect("Abilities\\Spells\\Undead\\AnimateDead\\AnimateDeadTarget.mdl", GetUnitX( bj_lastCreatedUnit ), GetUnitY( bj_lastCreatedUnit ) ) )
    call FlushChildHashtable( udg_hash, id )
    
    set caster = null
endfunction

function Prvz takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local integer p = LoadInteger( udg_hash, id, StringHash( "prvz" ) )
    call textst( "|c00FF0000 +"+I2S(p)+" strength", LoadUnitHandle( udg_hash, id, StringHash( "prvz" ) ), 64, GetRandomReal( 0, 360 ), 8, 1.5 )
    call FlushChildHashtable( udg_hash, id )
endfunction

function Icemove takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local integer id1
    local unit caster = LoadUnitHandle( udg_hash, id, StringHash( "icemove" ) )
    local real dmg = LoadReal( udg_hash, id, StringHash( "icemove" ) )
    local group g = CreateGroup()
    local unit u

    call DestroyEffect( AddSpecialEffect( "Abilities\\Weapons\\FrostWyrmMissile\\FrostWyrmMissile.mdl", GetUnitX( caster ), GetUnitY( caster ) ) )
    call GroupEnumUnitsOfPlayer(g, Player(10), null )
    loop
        set u = FirstOfGroup(g)
        exitwhen u == null
        if IsUnitType( u, UNIT_TYPE_ANCIENT) and GetUnitState( u, UNIT_STATE_LIFE) > 0.405 then
            call dummyspawn( caster, 0, 0, 'A12K', 'A0N5' )
            set id1 = GetHandleId( bj_lastCreatedUnit )

            call SaveTimerHandle( udg_hash, id1, StringHash( "advq" ), CreateTimer() )
            set id1 = GetHandleId( LoadTimerHandle( udg_hash, id1, StringHash( "advq" ) ) )
            call SaveUnitHandle( udg_hash, id1, StringHash( "advqt" ), u )
            call SaveUnitHandle( udg_hash, id1, StringHash( "advq" ), bj_lastCreatedUnit )
            call SaveReal( udg_hash, id1, StringHash( "advq" ), dmg )
            call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( bj_lastCreatedUnit ), StringHash( "advq" ) ), 0.04, true, function AdventurerQMotion )
        endif
        call GroupRemoveUnit(g,u)
        set u = FirstOfGroup(g)
    endloop
    call FlushChildHashtable( udg_hash, id )
    
    call GroupClear( g )
    call DestroyGroup( g )
    set u = null
    set g = null
    set caster = null
endfunction

function PigSum takes nothing returns nothing
    set bj_lastCreatedUnit = CreateUnitAtLoc( Player(4), 'n045', Location(GetRandomReal(GetRectMinX(udg_Boss_Rect), GetRectMaxX(udg_Boss_Rect)), GetRandomReal(GetRectMinY(udg_Boss_Rect), GetRectMaxY(udg_Boss_Rect))), GetRandomReal( 0, 360 ) )
    call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\NightElf\\BattleRoar\\RoarCaster.mdl", GetUnitX( bj_lastCreatedUnit ), GetUnitY( bj_lastCreatedUnit ) ) )
    call IssueTargetOrder( bj_lastCreatedUnit, "attackonce", GroupPickRandomUnit(GetUnitsInRectOfPlayer(udg_Boss_Rect, Player(10))) )
    call FlushChildHashtable( udg_hash, GetHandleId( GetExpiredTimer() ) )
endfunction

function CCard takes nothing returns nothing
	local integer cyclA = 1
	local integer cyclAEnd = udg_Boss_LvL

	loop
		exitwhen cyclA > cyclAEnd
    		set bj_lastCreatedUnit = CreateUnitAtLoc( Player(10), 'n04D', Location(GetRandomReal(GetRectMinX(udg_Boss_Rect), GetRectMaxX(udg_Boss_Rect)), GetRandomReal(GetRectMinY(udg_Boss_Rect), GetRectMaxY(udg_Boss_Rect))), GetRandomReal( 0, 360 ) )
    		call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\NightElf\\BattleRoar\\RoarCaster.mdl", GetUnitX( bj_lastCreatedUnit ), GetUnitY( bj_lastCreatedUnit ) ) )
    		call IssueTargetOrder( bj_lastCreatedUnit, "attackonce", GroupPickRandomUnit(udg_otryad) )
		set cyclA = cyclA + 1
	endloop
    call FlushChildHashtable( udg_hash, GetHandleId( GetExpiredTimer() ) )
endfunction

function MagicMeat takes unit u returns nothing
    local integer cyclB = 0
    local item it
    
    set cyclB = 0
    loop
        exitwhen cyclB > 5
        set it = UnitItemInSlot(u, cyclB)
        if SubString(BlzGetItemExtendedTooltip(it), 0, 16) == "|cff088a08Potion" then
            call BlzSetItemIntegerFieldBJ( it, ITEM_IF_NUMBER_OF_CHARGES, BlzGetItemIntegerField(it, ITEM_IF_NUMBER_OF_CHARGES) + 3 )
            call BlzSetItemIconPath( it, "|cffC71585Cursed|r|n" + BlzGetItemExtendedTooltip(it) )
        endif
        set cyclB = cyclB + 1
    endloop
    
    set it = null
    set u = null
endfunction

function FightStart takes nothing returns nothing
    local integer cyclA = 1
    local integer cyclB
    local integer cyclBEnd
    local integer cyclC
    local integer cyclCEnd
    local integer lim
    local integer id
    local integer rand
    local unit u
    local group g = CreateGroup()
    local unit n
    local real x
    local real y
    local integer p
    local integer m
    local integer j

	if udg_Boss_LvL >= 10 and udg_fightmod[1] then
		call StopMusic(false)
		call ClearMapMusic()
		call PlayMusicBJ( gg_snd_PursuitTheme )
	else
		call StopMusic( false )
		call ClearMapMusic()
        if GetRandomInt( 1, 2 ) == 1 then
            call PlayMusicBJ( gg_snd_ArthasTheme )
        else
            call PlayMusicBJ( gg_snd_OrcX1 )
        endif
		call VolumeGroupSetVolume( SOUND_VOLUMEGROUP_MUSIC, 0.7 )
	endif
    
    call GroupEnumUnitsInRect( g, bj_mapInitialPlayableArea, null )
    loop
        set u = FirstOfGroup(g)
        exitwhen u == null
        if GetUnitTypeId( u ) == 'n01Z' or GetUnitTypeId( u ) == 'n059' then
            call KillUnit( u )
        endif
        call GroupRemoveUnit(g,u)
    endloop
    if not(udg_fightmod[3]) then
        set bj_livingPlayerUnitsTypeId = 'h009'
        call GroupEnumUnitsOfPlayer(g, Player( PLAYER_NEUTRAL_AGGRESSIVE ), filterLivingPlayerUnitsOfTypeId)
        loop
            set n = FirstOfGroup(g)
            exitwhen n == null
            call SetUnitOwner( n, Player(PLAYER_NEUTRAL_PASSIVE), true )
            call GroupRemoveUnit(g,n)
        endloop
        set bj_livingPlayerUnitsTypeId = 'h01F'
        call GroupEnumUnitsOfPlayer(g, Player( PLAYER_NEUTRAL_AGGRESSIVE ), filterLivingPlayerUnitsOfTypeId)
        loop
            set n = FirstOfGroup(g)
            exitwhen n == null
            call SetUnitOwner( n, Player(PLAYER_NEUTRAL_PASSIVE), true )
            call GroupRemoveUnit(g,n)
        endloop
    endif
    
    if not( udg_logic[53] ) then
        call RessurectionPoints( -100, false )
        if udg_Heroes_Ressurect > 0 then
            call RessurectionPoints( udg_Heroes_Ressurect, false )
            call BlzFrameSetVisible( resback, true )
            call BlzFrameSetText( restext, I2S(udg_Heroes_Ressurect_Battle) )
        endif
        //set udg_Heroes_Ressurect_Battle = udg_Heroes_Ressurect
    endif
    call SetUnitOwner( udg_unit[32], Player(PLAYER_NEUTRAL_PASSIVE), true )
    set udg_fightmod[0] = true
    call UnitRemoveAbility( gg_unit_u00F_0006, 'A03U' )
    call UnitRemoveAbility( gg_unit_h00A_0034, 'A08B' ) 
    call UnitRemoveAbility( gg_unit_h00A_0034, 'A10O' ) 
    call UnitRemoveAbility( gg_unit_h00A_0034, 'A10N' ) 
    call UnitRemoveAbility( gg_unit_h00A_0034, 'A0JQ' )
    if not(udg_logic[54]) then
    	call PauseTimer( udg_timer[1] )
    	call PauseTimer( udg_timer[2] )
        call PauseTimer( udg_timer[3] )
    endif
    call TimerDialogDisplay( udg_timerdialog[2], false )

    if udg_logic[7] and not(udg_fightmod[3]) then
    	call DisplayTimedTextToForce( GetPlayersAll(), 5.00, "Enemies have become stronger +5" + udg_perc + "!" )
    	set udg_BossHP = udg_BossHP + 0.05
    	set udg_BossAT = udg_BossAT + 0.05
        call SpellPower_AddBossSpellPower(0.05)
        call TimerStart( udg_timer[4], 180, true, null )
    endif
    set udg_KillUnit = udg_KillInBattle
    if udg_modgood[23] then
        set udg_KillUnit = udg_KillUnit + 3
    endif

    set cyclA = 1
    loop
        exitwhen cyclA > 4
        call BlzFrameSetVisible( iconframe[cyclA],false)
        if GetPlayerSlotState( Player( cyclA - 1 ) ) == PLAYER_SLOT_STATE_PLAYING then
            call SaveBoolean( udg_hash, GetHandleId( udg_hero[cyclA] ), StringHash( "pheg" ), false )
            call BlzSetUnitRealFieldBJ( udg_hero[cyclA], UNIT_RF_ACQUISITION_RANGE, 900 )
            call SelectUnitForPlayerSingle( udg_hero[cyclA], Player(cyclA - 1) )
            if GetUnitAbilityLevel(udg_hero[cyclA], 'B06Z') > 0 then
                call UnitRemoveAbility( udg_hero[cyclA], 'A18E' )
                call UnitRemoveAbility( udg_hero[cyclA], 'B06Z' )         
            endif
            call BlzFrameSetVisible( faceframe[cyclA],false)
            call BlzFrameSetTexture( iconframe[cyclA], "ReplaceableTextures\\CommandButtons\\BTNDivineShieldOff.blp", 0, true )
            if not( udg_logic[43] ) then
                set udg_DPS[cyclA] = 0
                set udg_DamageFight[cyclA] = 0
                set udg_HealFight[cyclA] = 0
                set udg_ManaFight[cyclA] = 0
                set udg_DamagedFight[cyclA] = 0
                set udg_Info_DamageMagic[cyclA] = 0
                set udg_Info_DamagePhysical[cyclA] = 0
                set udg_Info_Time = 0
                call MultiSetValue( udg_multi, ( udg_Multiboard_Position[cyclA] * 3 ) - 1, 7, I2S(R2I(udg_DamageFight[cyclA])) )
                call MultiSetValue( udg_multi, ( udg_Multiboard_Position[cyclA] * 3 ) - 1, 8, I2S(R2I(udg_DPS[cyclA])) )
                call MultiSetValue( udg_multi, ( udg_Multiboard_Position[cyclA] * 3 ) - 1, 10, I2S(R2I(udg_HealFight[cyclA])) )
                call MultiSetValue( udg_multi, ( udg_Multiboard_Position[cyclA] * 3 ) - 1, 12, I2S(R2I(udg_ManaFight[cyclA])) )
                call MultiSetValue( udg_multi, ( udg_Multiboard_Position[cyclA] * 3 ) - 1, 14, I2S(R2I(udg_DamagedFight[cyclA])) )
                if inv(udg_hero[cyclA], 'I0E3') > 0 then
                    call ChangeToolItem( udg_hero[cyclA], 'I0E3', "|cffbe81f7", "|r", "0" )
                endif
            endif
            set udg_fightlogic[cyclA] = false
            set udg_combatlogic[cyclA] = true
            
            set udg_FightStart_Unit = udg_hero[cyclA]
            set udg_FightStart_Real = 0
            set udg_FightStart_Real = 1
            set udg_FightStart_Real = 0
 
            call SetUnitOwner( udg_artifzone[cyclA], Player(PLAYER_NEUTRAL_PASSIVE), true )
            // Держать вместе
            if udg_auctionlogic[cyclA] then
                call SetPlayerState(Player( cyclA - 1 ), PLAYER_STATE_RESOURCE_GOLD, GetPlayerState(Player( cyclA - 1 ), PLAYER_STATE_RESOURCE_GOLD) + 125)
            endif
            set udg_auctionlogic[cyclA] = false
            if udg_auctionartif[cyclA] != null then
                if UnitInventoryCount(udg_hero[cyclA]) >= 6 then
                    set rand = GetRandomInt(0, 5)
                    call RemoveItem( UnitItemInSlot( udg_hero[cyclA], rand ) )
                    call DisplayTimedTextToPlayer(Player(cyclA - 1), 0, 0, 10., "|cffffcc00WARNING!|r There is not enough space in the inventory for the artifact from the exchanger. Artifact " + GetItemName( UnitItemInSlot( udg_hero[cyclA], rand ) ) + " was removed." )
                endif
                call SetItemPosition( udg_auctionartif[cyclA], GetUnitX(udg_hero[cyclA]), GetUnitY(udg_hero[cyclA]) )
                call UnitAddItem( udg_hero[cyclA], udg_auctionartif[cyclA] )
                set udg_auctionartif[cyclA] = null
            endif
            if inv( udg_hero[cyclA], 'I0F8') > 0 then
                call bufst( udg_hero[cyclA], udg_hero[cyclA], 'A05W', 'B09J', "issc", timebonus( udg_hero[cyclA], 20 ) )
            endif
            if inv( udg_hero[cyclA], 'I0A4') > 0 then
                call UnitAddAbility( udg_hero[cyclA], 'A0XG' )
            
                set id = GetHandleId( udg_hero[cyclA] )
                if LoadTimerHandle( udg_hash, id, StringHash( "gltz" ) ) == null  then
                    call SaveTimerHandle( udg_hash, id, StringHash( "gltz" ), CreateTimer() )
                endif
                set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "gltz" ) ) ) 
                call SaveUnitHandle( udg_hash, id, StringHash( "gltz" ), udg_hero[cyclA] )
                call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( udg_hero[cyclA] ), StringHash( "gltz" ) ), timebonus(udg_hero[cyclA], 30), false, function GlassTooth )
            endif
            if GetUnitAbilityLevel( udg_hero[cyclA], 'A0ZK') > 0 then
                set m = GetUnitAbilityLevel( udg_hero[cyclA], 'A0ZK') - 1
                if m < 0 then
                    set m = 0
                endif
                
                set cyclB = 1
                loop
                    exitwhen cyclB > 9
                    set udg_MephistarUse[cyclB] = 0
                    set cyclB = cyclB + 1
                endloop
                
                set udg_MephistarUse[1] = udg_Set_Alchemy_Number[cyclA]
                set udg_MephistarUse[2] = udg_Set_Blood_Number[cyclA]
                set udg_MephistarUse[3] = udg_Set_Cristall_Number[cyclA]
                set udg_MephistarUse[4] = SetCount_GetPieces(udg_hero[cyclA], SET_MECH)
                set udg_MephistarUse[5] = udg_Set_Moon_Number[cyclA]
                set udg_MephistarUse[6] = udg_Set_Nature_Number[cyclA]
                set udg_MephistarUse[7] = udg_Set_Ring_Number[cyclA]
                set udg_MephistarUse[8] = udg_Set_Rune_Number[cyclA]
                set udg_MephistarUse[9] = udg_Set_Weapon_Number[cyclA]
                
                set cyclB = 1
                loop
                    exitwhen cyclB > 9
                    if udg_MephistarUse[cyclB] > 0 then
                        set udg_MephistarUse[cyclB] = udg_MephistarUse[cyclB] + m
                    endif
                    call BlzFrameSetText( mephnum[cyclB], I2S(udg_MephistarUse[cyclB]) )
                    set cyclB = cyclB + 1
                endloop
                
                if udg_Set_Alchemy_Number[cyclA] > 0 then
                    call BlzFrameSetTexture( mephicon[1], BlzGetAbilityIcon( udg_DB_SoulContract_Set[1]), 0, true )
                else
                    call BlzFrameSetTexture( mephicon[1], "ReplaceableTextures\\CommandButtons\\BTNCancel.blp", 0, true )
                endif
                if udg_Set_Blood_Number[cyclA] > 0 then
                    call BlzFrameSetTexture( mephicon[2], BlzGetAbilityIcon( udg_DB_SoulContract_Set[2]), 0, true )
                else
                    call BlzFrameSetTexture( mephicon[2], "ReplaceableTextures\\CommandButtons\\BTNCancel.blp", 0, true )
                endif
                if udg_Set_Cristall_Number[cyclA] > 0 then
                    call BlzFrameSetTexture( mephicon[3], BlzGetAbilityIcon( udg_DB_SoulContract_Set[3]), 0, true )
                else
                    call BlzFrameSetTexture( mephicon[3], "ReplaceableTextures\\CommandButtons\\BTNCancel.blp", 0, true )
                endif
                if SetCount_GetPieces(udg_hero[cyclA], SET_MECH) > 0 then
                    call BlzFrameSetTexture( mephicon[4], BlzGetAbilityIcon( udg_DB_SoulContract_Set[4]), 0, true )
                else
                    call BlzFrameSetTexture( mephicon[4], "ReplaceableTextures\\CommandButtons\\BTNCancel.blp", 0, true )
                endif
                if udg_Set_Moon_Number[cyclA] > 0 then
                    call BlzFrameSetTexture( mephicon[5], BlzGetAbilityIcon( udg_DB_SoulContract_Set[5]), 0, true )
                else
                    call BlzFrameSetTexture( mephicon[5], "ReplaceableTextures\\CommandButtons\\BTNCancel.blp", 0, true )
                endif
                if udg_Set_Nature_Number[cyclA] > 0 then
                    call BlzFrameSetTexture( mephicon[6], BlzGetAbilityIcon( udg_DB_SoulContract_Set[6]), 0, true )
                else
                    call BlzFrameSetTexture( mephicon[6], "ReplaceableTextures\\CommandButtons\\BTNCancel.blp", 0, true )
                endif
                if udg_Set_Ring_Number[cyclA] > 0 then
                    call BlzFrameSetTexture( mephicon[7], BlzGetAbilityIcon( udg_DB_SoulContract_Set[7]), 0, true )
                else
                    call BlzFrameSetTexture( mephicon[7], "ReplaceableTextures\\CommandButtons\\BTNCancel.blp", 0, true )
                endif
                if udg_Set_Rune_Number[cyclA] > 0 then
                    call BlzFrameSetTexture( mephicon[8], BlzGetAbilityIcon( udg_DB_SoulContract_Set[8]), 0, true )
                else
                    call BlzFrameSetTexture( mephicon[8], "ReplaceableTextures\\CommandButtons\\BTNCancel.blp", 0, true )
                endif
                if udg_Set_Weapon_Number[cyclA] > 0 then
                    call BlzFrameSetTexture( mephicon[9], BlzGetAbilityIcon( udg_DB_SoulContract_Set[9]), 0, true )
                else
                    call BlzFrameSetTexture( mephicon[9], "ReplaceableTextures\\CommandButtons\\BTNCancel.blp", 0, true )
                endif
            endif
            if GetUnitAbilityLevel(udg_hero[cyclA], 'A082') > 0 then
                set p = 55 - (5*GetUnitAbilityLevel(udg_hero[cyclA], 'A082'))

                set udg_outcast[1] = false
                set udg_outcast[2] = false
                set udg_outcast[3] = false
                if GetLocalPlayer() == GetOwningPlayer(udg_hero[cyclA]) then
                    call BlzFrameSetVisible( outballframe[1], false )
                    call BlzFrameSetVisible( outballframe[2], false )
                    call BlzFrameSetVisible( outballframe[3], false )
                endif
                call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( udg_hero[cyclA] ), StringHash( "outeq" ) ), p, true, function OutcastEQEnd )
                call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( udg_hero[cyclA] ), StringHash( "outew" ) ), p, true, function OutcastEWEnd )
                call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( udg_hero[cyclA] ), StringHash( "outer" ) ), p, true, function OutcastEREnd )
            endif
            if inv(udg_hero[cyclA], 'I07E') > 0 then
                call mnbtfly( udg_hero[cyclA] )
            endif
            if inv(udg_hero[cyclA], 'I0AG') > 0 then
                set cyclB = 1
                set cyclBEnd = 6
                loop
                    exitwhen cyclB > cyclBEnd
                    if UnitInventoryCount(udg_hero[cyclA]) < 6 then
                        call UnitAddItem( udg_hero[cyclA], CreateItem('I0DW', GetUnitX(udg_hero[cyclA]), GetUnitY(udg_hero[cyclA]) ) )
                    else
                        set cyclB = cyclBEnd
                    endif
                    set cyclB = cyclB + 1
                endloop
            endif
            if inv(udg_hero[cyclA], 'I0C9') > 0 then
                set id = GetHandleId( udg_hero[cyclA] )
    
                if LoadTimerHandle( udg_hash, id, StringHash( "octo" ) ) == null  then
                    call SaveTimerHandle( udg_hash, id, StringHash( "octo" ), CreateTimer() )
                endif
                set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "octo" ) ) ) 
                call SaveUnitHandle( udg_hash, id, StringHash( "octo" ), udg_hero[cyclA] )
                call SaveInteger( udg_hash, id, StringHash( "octo" ), 2*GetHeroLevel(udg_hero[cyclA]) )
                call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( udg_hero[cyclA] ), StringHash( "octo" ) ), 0.5, false, function OctopusEnd )
            endif
            if inv(udg_hero[cyclA], 'I0E7') > 0 then
                set id = GetHandleId( udg_hero[cyclA] )
    
                if LoadTimerHandle( udg_hash, id, StringHash( "wilv" ) ) == null  then
                    call SaveTimerHandle( udg_hash, id, StringHash( "wilv" ), CreateTimer() )
                endif
                set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "wilv" ) ) ) 
                call SaveUnitHandle( udg_hash, id, StringHash( "wilv" ), udg_hero[cyclA] )
                call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( udg_hero[cyclA] ), StringHash( "wilv" ) ), 0.5, false, function WitchLoveEnd )
            endif
            if udg_modgood[20]  then
                set id = GetHandleId( udg_hero[cyclA] )
    
                if LoadTimerHandle( udg_hash, id, StringHash( "mdg20" ) ) == null  then
                    call SaveTimerHandle( udg_hash, id, StringHash( "mdg20" ), CreateTimer() )
                endif
                set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "mdg20" ) ) ) 
                call SaveUnitHandle( udg_hash, id, StringHash( "mdg20" ), udg_hero[cyclA] )
                call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( udg_hero[cyclA] ), StringHash( "mdg20" ) ), 1, true, function ModGood20 )
            endif
            if inv(udg_hero[cyclA], 'I0AJ') > 0 then
                set cyclB = 1
                loop
                    exitwhen cyclB > 4
                    if unitst( udg_hero[cyclB], udg_hero[cyclA], "ally" ) then
                        call shield( udg_hero[cyclA], udg_hero[cyclB], 300, 60 )
                    endif
                    set cyclB = cyclB + 1
                endloop
            endif
            if inv(udg_hero[cyclA], 'I01Z') > 0 then
                set rand = GetRandomInt( 1, 5 )
                if rand == 1 then//Fire
                    call UnitAddAbility(udg_hero[cyclA], 'A1BN')
                    call UnitAddAbility(udg_hero[cyclA], 'A1BO')
                elseif rand == 2 then//Ice
                    call UnitAddAbility(udg_hero[cyclA], 'A1BP')
                    call UnitAddAbility(udg_hero[cyclA], 'A1BT')
                elseif rand == 3 then//Air
                    call UnitAddAbility(udg_hero[cyclA], 'A1BR')
                    call UnitAddAbility(udg_hero[cyclA], 'A1BU')
                elseif rand == 4 then//Earth
                    call UnitAddAbility(udg_hero[cyclA], 'A1BQ')
                    call luckyst(udg_hero[cyclA], 25)
                elseif rand == 5 then//Shadow
                    call UnitAddAbility(udg_hero[cyclA], 'A1BS')
                    call spdst(udg_hero[cyclA], 25)
                endif
            endif
            if not(udg_fightmod[3]) then
                set cyclB = 0
                loop
                    exitwhen cyclB > 5
                    if SubString(BlzGetItemExtendedTooltip(UnitItemInSlot(udg_hero[cyclA], cyclB)), 0, 19) == "|cff00cceeChameleon" then
                        call Inventory_ReplaceItemByNew(udg_hero[cyclA], UnitItemInSlot(udg_hero[cyclA], cyclB), udg_DB_Item_Activate[GetRandomInt(1,udg_Database_NumberItems[31])])
                    endif
                    set cyclB = cyclB + 1
                endloop
                if inv( udg_hero[cyclA], 'I08Q' ) > 0 then
                    set cyclB = 0
                    loop
                        exitwhen cyclB > 5
                        if SubString(BlzGetItemExtendedTooltip(UnitItemInSlot(udg_hero[cyclA], cyclB)), 0, 16) == "|cff088a08Potion" then
                            set p = BlzGetItemIntegerField(UnitItemInSlot(udg_hero[cyclA], cyclB), ITEM_IF_NUMBER_OF_CHARGES)
                            call RemoveItem( UnitItemInSlot(udg_hero[cyclA], cyclB) )
                            set bj_lastCreatedItem = CreateItem(udg_Database_Item_Potion[GetRandomInt(1,udg_Database_NumberItems[9])], GetUnitX(udg_hero[cyclA]), GetUnitY(udg_hero[cyclA]))
                            call UnitAddItem(udg_hero[cyclA], bj_lastCreatedItem)
                            call BlzSetItemIntegerFieldBJ( bj_lastCreatedItem, ITEM_IF_NUMBER_OF_CHARGES, p + 1 )
                        endif
                        set cyclB = cyclB + 1
                    endloop
                endif
                if inv( udg_hero[cyclA], 'I044' ) > 0 then
                    call MagicMeat( udg_hero[cyclA] )
                endif
                if udg_modbad[5] then
                    set id = GetHandleId( udg_hero[cyclA] )
        
                    if LoadTimerHandle( udg_hash, id, StringHash( "mdb5" ) ) == null  then
                        call SaveTimerHandle( udg_hash, id, StringHash( "mdb5" ), CreateTimer() )
                    endif
                    set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "mdb5" ) ) ) 
                    call SaveUnitHandle( udg_hash, id, StringHash( "mdb5" ), udg_hero[cyclA] )
                    call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( udg_hero[cyclA] ), StringHash( "mdb5" ) ), 1, true, function ModBad5 )
                endif
                if inv(udg_hero[cyclA], 'I06L') > 0 then
                    set p = 2

                    if p < 1 then
                        set p = 1
                    endif
                    call statst( udg_hero[cyclA], p, 0, 0, 56, true )
                    
                    set id = GetHandleId( udg_hero[cyclA] )
                    if LoadTimerHandle( udg_hash, id, StringHash( "prvz" ) ) == null  then
                        call SaveTimerHandle( udg_hash, id, StringHash( "prvz" ), CreateTimer() )
                    endif
                    set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "prvz" ) ) ) 
                    call SaveUnitHandle( udg_hash, id, StringHash( "prvz" ), udg_hero[cyclA] )
                    call SaveInteger( udg_hash, id, StringHash( "prvz" ), p )
                    call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( udg_hero[cyclA] ), StringHash( "prvz" ) ), 1, false, function Prvz )
                endif
                if inv( udg_hero[cyclA], 'I0EJ') > 0 then
                    call UnitAddAbility( udg_hero[cyclA], 'A0VX' )
                endif
                if udg_dmgboss[GetPlayerId(GetOwningPlayer( udg_hero[cyclA] ) ) + 1] > 0 then
                    set id = GetHandleId( udg_hero[cyclA] )
                    if LoadTimerHandle( udg_hash, id, StringHash( "icemove" ) ) == null  then
                        call SaveTimerHandle( udg_hash, id, StringHash( "icemove" ), CreateTimer() )
                    endif
                    set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "icemove" ) ) ) 
                    call SaveUnitHandle( udg_hash, id, StringHash( "icemove" ), udg_hero[cyclA] )
                    call SaveReal( udg_hash, id, StringHash( "icemove" ), udg_dmgboss[GetPlayerId(GetOwningPlayer( udg_hero[cyclA] ) ) + 1] )
                    call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( udg_hero[cyclA] ), StringHash( "icemove" ) ), 1, false, function Icemove )
                    
                    set udg_dmgboss[GetPlayerId(GetOwningPlayer( udg_hero[cyclA] ) ) + 1] = 0
                endif
            endif

            set bj_livingPlayerUnitsTypeId = 'u000'
            call GroupEnumUnitsOfPlayer(g, Player(cyclA - 1), filterLivingPlayerUnitsOfTypeId)
            loop
                set u = FirstOfGroup(g)
                exitwhen u == null
                call RemoveUnit( u )
                call GroupRemoveUnit(g,u)
            endloop
            call GroupEnumUnitsOfPlayer(g, Player(cyclA - 1), null )
            loop
                set u = FirstOfGroup(g)
                exitwhen u == null
                if not( IsUnitType( u, UNIT_TYPE_HERO) ) and not( IsUnitType( u, UNIT_TYPE_STRUCTURE) ) and GetUnitTypeId(u) != 'o01F' then
                    if GetUnitTypeId(u) == 'u00X' then
                        set n = LoadUnitHandle( udg_hash, GetHandleId(u), StringHash( "sldg" ) )
                        if n != null then
                            call BlzSetUnitMaxHP( n, R2I(BlzGetUnitMaxHP(n)+BlzGetUnitMaxHP(u)) )
                            call BlzSetUnitBaseDamage( n, R2I(BlzGetUnitBaseDamage(n, 0)+BlzGetUnitBaseDamage(u, 0)+1), 0 )
                            call SetUnitState( n, UNIT_STATE_LIFE, GetUnitState( n, UNIT_STATE_MAX_LIFE ) )
                        endif
                    endif
                    call RemoveUnit( u )
                endif
                call GroupRemoveUnit(g,u)
            endloop
        endif
        set cyclA = cyclA + 1
    endloop
    
    set udg_FightStartGlobal_Real = 0.00
    set udg_FightStartGlobal_Real = 1.00
    set udg_FightStartGlobal_Real = 0.00
    
    if not( udg_fightmod[3] ) then
        if udg_modbad[12] then
            set id = GetHandleId( gg_unit_h00A_0034 )

            if LoadTimerHandle( udg_hash, id, StringHash( "mdb12" ) ) == null then 
                call SaveTimerHandle( udg_hash, id, StringHash( "mdb12" ), CreateTimer() )
            endif
            set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "mdb12" ) ) ) 
            call SaveUnitHandle( udg_hash, id, StringHash( "mdb12" ), gg_unit_h00A_0034 )
            call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( gg_unit_h00A_0034 ), StringHash( "mdb12" ) ), 30, true, function ModBad12 )
        endif
        if udg_modbad[16] then
            set id = GetHandleId( gg_unit_h00A_0034 )

            if LoadTimerHandle( udg_hash, id, StringHash( "mdb16" ) ) == null then 
                call SaveTimerHandle( udg_hash, id, StringHash( "mdb16" ), CreateTimer() )
            endif
            set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "mdb16" ) ) ) 
            call SaveUnitHandle( udg_hash, id, StringHash( "mdb16" ), gg_unit_h00A_0034 )
            call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( gg_unit_h00A_0034 ), StringHash( "mdb16" ) ), 10, true, function ModBad16 )
        endif
        if udg_modbad[24] then
            set id = GetHandleId( gg_unit_h00A_0034 )

            if LoadTimerHandle( udg_hash, id, StringHash( "mdb24" ) ) == null then 
                call SaveTimerHandle( udg_hash, id, StringHash( "mdb24" ), CreateTimer() )
            endif
            set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "mdb24" ) ) ) 
            call SaveUnitHandle( udg_hash, id, StringHash( "mdb24" ), gg_unit_h00A_0034 )
            call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( gg_unit_h00A_0034 ), StringHash( "mdb24" ) ), 30, true, function ModBad24 )
        endif
        if udg_modbad[17] then
            set id = GetHandleId( gg_unit_h00A_0034 )

            if udg_Boss_Rect == gg_rct_ArenaBossSmall then
                set p = 8
            else
                set p = 4
            endif

            if LoadTimerHandle( udg_hash, id, StringHash( "mdb17" ) ) == null then 
                call SaveTimerHandle( udg_hash, id, StringHash( "mdb17" ), CreateTimer() )
            endif
            set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "mdb17" ) ) ) 
            call SaveUnitHandle( udg_hash, id, StringHash( "mdb17" ), gg_unit_h00A_0034 )
            call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( gg_unit_h00A_0034 ), StringHash( "mdb17" ) ), p, true, function ModBad17 )
        endif
        if udg_modgood[26] then
            call CreateNUnitsAtLoc( 1, 'h01L', Player(PLAYER_NEUTRAL_AGGRESSIVE), GetRandomLocInRect(udg_Boss_Rect), 270 )
        endif
        if udg_modbad[6] then
            set u = GroupPickRandomUnit(udg_otryad)
            call SetUnitState( u, UNIT_STATE_LIFE, GetUnitState( u, UNIT_STATE_LIFE) - (GetUnitState( u, UNIT_STATE_MAX_LIFE) * 0.3) )
            call SetUnitState( u, UNIT_STATE_MANA, GetUnitState( u, UNIT_STATE_MANA) - (GetUnitState( u, UNIT_STATE_MAX_MANA) * 0.3) )
            call DestroyEffect( AddSpecialEffectTarget( "Abilities\\Spells\\Orc\\MirrorImage\\MirrorImageCaster.mdl", u, "origin") )
        endif
        if udg_modbad[8] then
            set id = GetHandleId( gg_unit_h00A_0034 )
        
            if LoadTimerHandle( udg_hash, id, StringHash( "mbd8" ) ) == null  then
                call SaveTimerHandle( udg_hash, id, StringHash( "mbd8" ), CreateTimer() )
            endif
            set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "mbd8" ) ) ) 
            call SaveUnitHandle( udg_hash, id, StringHash( "mbd8" ), gg_unit_h00A_0034 )
            call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( gg_unit_h00A_0034 ), StringHash( "mbd8" ) ), 45, true, function ModBad8 )
        endif
        if udg_logic[5] then
            set udg_logic[5] = false
            set id = GetHandleId( gg_unit_h00A_0034 )
        
            if LoadTimerHandle( udg_hash, id, StringHash( "ccard" ) ) == null  then
                call SaveTimerHandle( udg_hash, id, StringHash( "ccard" ), CreateTimer() )
            endif
            set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "ccard" ) ) ) 
            call SaveUnitHandle( udg_hash, id, StringHash( "ccard" ), gg_unit_h00A_0034 )
            call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( gg_unit_h00A_0034 ), StringHash( "ccard" ) ), 3, false, function CCard )
        endif
        if udg_modgood[6] then
            set u = GroupPickRandomUnit(udg_otryad)
            call UnitAddAbility( u, 'A0HU' )
            call spdst( u, 20 )
            call DestroyEffect( AddSpecialEffectTarget( "Abilities\\Spells\\Undead\\DeathPact\\DeathPactTarget.mdl", u, "origin") )
        endif
        if udg_logic[96] then
            set udg_logic[96] = false
            call SaveTimerHandle( udg_hash, GetHandleId( gg_unit_h00A_0034 ), StringHash( "pigsum" ), CreateTimer() )
            call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( gg_unit_h00A_0034 ), StringHash( "pigsum" ) ), 1, false, function PigSum )
        endif
        if udg_modgood[25] then
            set id = GetHandleId( gg_unit_h00A_0034 )

            if LoadTimerHandle( udg_hash, id, StringHash( "mg25" ) ) == null then 
                call SaveTimerHandle( udg_hash, id, StringHash( "mg25" ), CreateTimer() )
            endif
            set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "mg25" ) ) ) 
            call SaveUnitHandle( udg_hash, id, StringHash( "mg25" ), gg_unit_h00A_0034 )
            call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( gg_unit_h00A_0034 ), StringHash( "mg25" ) ), 45, true, function ModGood25 )
        endif
        if udg_modgood[33] then
            set cyclB = 1
            loop
                exitwhen cyclB > 6
                set bj_lastCreatedItem = CreateItem( udg_ArenaRunes[GetRandomInt(1, udg_Database_NumberItems[27])], GetRandomReal(GetRectMinX(udg_Boss_Rect), GetRectMaxX(udg_Boss_Rect)), GetRandomReal(GetRectMinY(udg_Boss_Rect), GetRectMaxY(udg_Boss_Rect)) )
                call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\Orc\\FeralSpirit\\feralspirittarget.mdl", GetItemX( bj_lastCreatedItem ), GetItemY( bj_lastCreatedItem ) ) )
                set cyclB = cyclB + 1
            endloop
        endif
    endif

	call BlzFrameSetVisible( fon,false)
	call BlzFrameSetVisible( sklbk,false)
    call BlzFrameSetVisible( refbk,false)
	call BlzFrameSetVisible( pvpbk,false)
	call BlzFrameSetVisible(unitfon, false)
	call BlzFrameSetVisible(fastbut, false)
	call BlzFrameSetVisible(itemfon, false)
    call BlzFrameSetVisible( juleIcon,false)

	call BlzFrameSetVisible(bgfrgfon[1], false)
	call BlzFrameSetVisible(bgfrgfon[2], false)
	call BlzFrameSetVisible(bgfrgfon[3], false)
	call BlzFrameSetVisible(forgebut, false)
    call BlzFrameSetVisible( modesbut, false )
    call BlzFrameSetVisible( modeslight, false )
    call BlzFrameSetVisible( modesback, false )
    call BlzFrameSetVisible( quartback, false )
    call BlzFrameSetVisible( specback, false )
    call BlzFrameSetVisible( juleback, false )

    call BlzFrameSetTexture(pvpbk, "ReplaceableTextures\\CommandButtons\\BTNMassTeleport.blp", 0, true)
	call BlzFrameSetTexture(butbk, "ReplaceableTextures\\CommandButtons\\BTNArcaniteMelee.blp", 0, true)

    call GroupClear( g )
    call DestroyGroup( g )
    set n = null
    set g = null
    set u = null
endfunction

function RandHero takes nothing returns nothing
    local integer cyclA = 1
    local integer cyclAEnd = udg_Database_InfoNumberHeroes
    
    call resethero()
    call GroupClear( udg_otryad )
    call GroupClear( udg_heroinfo )
    set cyclA = 1
    loop
        exitwhen cyclA > 4
        if GetPlayerSlotState(Player(cyclA - 1)) == PLAYER_SLOT_STATE_PLAYING then
            if udg_number[cyclA + 100] == 7 then
                call spdst( udg_hero[cyclA], -10 )
            endif
            call delspellpas( udg_hero[cyclA + 1] )
            if GetUnitTypeId(udg_hero[cyclA]) == udg_Database_Hero[1] then
                call DestroyLeaderboard( udg_panel[1] )
            elseif GetUnitTypeId(udg_hero[cyclA]) == 'O016' then
                call DestroyLeaderboard( udg_panel[3] )
            endif
            call RemoveUnit( udg_hero[cyclA] )
            set udg_hero[cyclA] = null
        endif
        set cyclA = cyclA + 1
    endloop

    set cyclA = 1
    loop
        exitwhen cyclA > cyclAEnd
    	set udg_UnitHeroLogic[cyclA] = false
	set cyclA = cyclA + 1
    endloop

    set cyclA = 0
    loop
        exitwhen cyclA > 3
        if GetPlayerSlotState(Player(cyclA)) == PLAYER_SLOT_STATE_PLAYING then
            call RandomHero( Player(cyclA) )
        endif
        set cyclA = cyclA + 1
    endloop
endfunction

function Curse20 takes nothing returns nothing
    local integer cyclA
    local integer i = 0
    local unit array k
    local unit u
    
    set cyclA = 1
    loop
        exitwhen cyclA > 4
        set k[cyclA] = null
        if UnitInventoryCount(udg_hero[cyclA]) < 6 and udg_hero[cyclA] != null then
            set i = i + 1
            set k[i] = udg_hero[cyclA]
        endif
        set cyclA = cyclA + 1
    endloop

    if i > 0 then
        set u = k[GetRandomInt(1,i)]
        if u != null then
            call UnitAddItem(u, CreateItem('I0B5', GetUnitX(u), GetUnitY(u)))
        endif
    endif
    
    set cyclA = 1
    loop
        exitwhen cyclA > 4
        set k[cyclA] = null
        set cyclA = cyclA + 1
    endloop
endfunction

function FightEndDelBuff takes unit u returns nothing
    if GetUnitAbilityLevel( u, 'A1BN' ) > 0 then//Fire
        call UnitRemoveAbility(u, 'A1BN')
        call UnitRemoveAbility(u, 'A1BO')
        call UnitRemoveAbility(u, 'B09Q')
    endif
    if GetUnitAbilityLevel( u, 'A1BP' ) > 0 then//Ice
        call UnitRemoveAbility(u, 'A1BP')
        call UnitRemoveAbility(u, 'A1BT')
        call UnitRemoveAbility(u, 'B09R')
    endif
    if GetUnitAbilityLevel( u, 'A1BR' ) > 0 then//Air
        call UnitRemoveAbility(u, 'A1BR')
        call UnitRemoveAbility(u, 'A1BU')
        call UnitRemoveAbility(u, 'B09T')
    endif
    if GetUnitAbilityLevel( u, 'A1BQ' ) > 0 then//Earth
        call UnitRemoveAbility(u, 'A1BQ')
        call UnitRemoveAbility(u, 'B09S')
        call luckyst(u, -25)
    endif
    if GetUnitAbilityLevel( u, 'A1BS' ) > 0 then//Shadow
        call UnitRemoveAbility(u, 'A1BS')
        call UnitRemoveAbility(u, 'B09U')
        call spdst(u, -25)
    endif

    set u = null
endfunction

// Конец боя
function FightEnd takes nothing returns nothing
    local integer cyclA
    local integer cyclB
    local integer cyclBEnd
    local integer rand 
    local integer spec
    local integer id
    local integer i
    local string text
    local string str
    local group g = CreateGroup()
    local unit n
    local integer array st
    local integer array ag
    local integer array in
    local integer array lvl
    local integer array t
    local integer j
    local item it
    local unit u
    local integer p

    if not(udg_logic[43]) then
    	call StopMusic( false )
        set rand = GetRandomInt( 1, 3)
        call ClearMapMusic()
        if rand == 1 then
            //call PlayThematicMusic( gg_snd_Human1 )
		call PlayMusicBJ( gg_snd_Human1 )
        elseif rand == 2 then
            //call PlayThematicMusic( gg_snd_Human2 )
		call PlayMusicBJ( gg_snd_Human2 )
        else
            //call PlayThematicMusic( gg_snd_Human3 )
	    call PlayMusicBJ( gg_snd_Human3 )
        endif
	call VolumeGroupSetVolume( SOUND_VOLUMEGROUP_MUSIC, 0.7 )
    endif
    call ShowUnitShow( gg_unit_h00A_0034 )
    
    if AnyHasLvL(8) and not(udg_fightmod[3]) then
        if AnyHasLvL(11) then
            set j = 1
        else
            set j = 0
        endif
        set p = 21
        if udg_modgood[31] then
            set p = p - 3
        endif
        set rand = GetRandomInt( 1, p )
        if rand <= 11 then
            if rand == 1 then
                call CreateUnitAtLoc(Player(PLAYER_NEUTRAL_PASSIVE), 'n043', GetRandomLocInRect(gg_rct_Spawn), GetRandomReal(0, 360))
            elseif rand == 2 then
                call CreateUnitAtLoc(Player(PLAYER_NEUTRAL_PASSIVE), 'h01J', GetRandomLocInRect(gg_rct_Spawn), GetRandomReal(0, 360))
            elseif rand == 3 then
                set bj_lastCreatedUnit = CreateUnitAtLoc(Player(PLAYER_NEUTRAL_PASSIVE), 'n042', GetRandomLocInRect(gg_rct_Spawn), GetRandomReal(0, 360))
                set cyclA = 1
                loop 
                    exitwhen cyclA > 3
                    call AddItemToStock( bj_lastCreatedUnit, udg_DB_Item_Destroyed[GetRandomInt(1, udg_Database_NumberItems[29] )], 1, 1 )
                    set cyclA = cyclA + 1
                endloop
            elseif rand == 4 then
                call CreateUnitAtLoc(Player(PLAYER_NEUTRAL_PASSIVE), 'o013', GetRandomLocInRect(gg_rct_Spawn), 270 )
            elseif rand == 5 and j >= 1 then
                call CreateUnitAtLoc(Player(PLAYER_NEUTRAL_AGGRESSIVE), 'n044', GetRandomLocInRect(gg_rct_Spawn), 270 )
            elseif rand == 6 and j >= 1 then
                set bj_lastCreatedUnit = CreateUnitAtLoc(Player(PLAYER_NEUTRAL_PASSIVE), 'n04G', GetRandomLocInRect(gg_rct_Spawn), GetRandomReal(0, 360))
                call AddItemToStock( bj_lastCreatedUnit, 'I05N', 1, 1 )
                call AddItemToStock( bj_lastCreatedUnit, 'I05G', 1, 1 )
                call AddItemToStock( bj_lastCreatedUnit, 'I0CL', 1, 1 )
                call AddItemToStock( bj_lastCreatedUnit, 'I06Y', 1, 1 )
                call AddItemToStock( bj_lastCreatedUnit, 'I03Q', 1, 1 )
                call AddItemToStock( bj_lastCreatedUnit, 'I04V', 1, 1 )
                call AddItemToStock( bj_lastCreatedUnit, 'I04N', 1, 1 )
                call AddItemToStock( bj_lastCreatedUnit, 'I04M', 1, 1 )
                call AddItemToStock( bj_lastCreatedUnit, 'I03X', 1, 1 )
            elseif rand == 7 and udg_Endgame == 1 then
                set bj_lastCreatedUnit = CreateUnitAtLoc(Player(PLAYER_NEUTRAL_PASSIVE), 'n01K', GetRandomLocInRect(gg_rct_Spawn), GetRandomReal(0, 360))
            elseif rand == 8 then
                call CreateUnitAtLoc(Player(PLAYER_NEUTRAL_AGGRESSIVE), 'h022', GetRandomLocInRect(gg_rct_Spawn), 270 )
            elseif rand == 9 and j >= 1 then
                set bj_lastCreatedUnit = CreateUnitAtLoc(Player(PLAYER_NEUTRAL_PASSIVE), 'n04S', GetRandomLocInRect(gg_rct_Spawn), GetRandomReal(0, 360))
                set cyclA = 1
                loop 
                    exitwhen cyclA > 3
                    call AddItemToStock( bj_lastCreatedUnit, udg_BD_Item_Sheep[GetRandomInt(1, udg_Database_NumberItems[30] )], 1, 1 )
                    set cyclA = cyclA + 1
                endloop
            elseif rand == 10 then
                call CreateUnitAtLoc(Player(PLAYER_NEUTRAL_PASSIVE), 'n058', GetRandomLocInRect(gg_rct_Spawn), 270 )
            elseif rand == 11 and j >= 1 then
                call CreateUnitAtLoc(Player(PLAYER_NEUTRAL_PASSIVE), 'n05B', GetRandomLocInRect(gg_rct_Spawn), 270 )
            elseif rand == 12 then
                call CreateUnitAtLoc(Player(PLAYER_NEUTRAL_PASSIVE), 'n031', GetRandomLocInRect(gg_rct_Spawn), GetRandomReal(0, 360))
            endif
        endif
    endif

    set bj_livingPlayerUnitsTypeId = 'h009'
    call GroupEnumUnitsOfPlayer(g, Player( PLAYER_NEUTRAL_PASSIVE ), filterLivingPlayerUnitsOfTypeId)
    loop
        set n = FirstOfGroup(g)
        exitwhen n == null
        call SetUnitOwner( n, Player(PLAYER_NEUTRAL_AGGRESSIVE), true )
        call GroupRemoveUnit(g,n)
    endloop
    set bj_livingPlayerUnitsTypeId = 'h01F'
    call GroupEnumUnitsOfPlayer(g, Player( PLAYER_NEUTRAL_PASSIVE ), filterLivingPlayerUnitsOfTypeId)
    loop
        set n = FirstOfGroup(g)
        exitwhen n == null
        call SetUnitOwner( n, Player(PLAYER_NEUTRAL_AGGRESSIVE), true )
        call GroupRemoveUnit(g,n)
    endloop

    set udg_fightmod[0] = false
    call SetUnitOwner( udg_unit[32], Player(0), true )
    call PauseTimer( LoadTimerHandle( udg_hash, GetHandleId( gg_unit_u00F_0006 ), StringHash( "bssdtimer" ) ) )
    call TimerDialogDisplay( udg_timerdialog[0], false )
    call UnitRemoveAbility( gg_unit_h00A_0034, 'A0JQ' )
    call UnitAddAbility( gg_unit_u00F_0006, 'A03U' )
    if udg_real[1] > 0 and not( udg_logic[43] ) and not(udg_logic[97] ) and not( udg_logic[54] ) then
        call TimerStart( udg_timer[1], udg_real[1], false, null )
        call TimerStart( udg_timer[2], udg_real[1]-20, false, null )
        set udg_timerdialog[2] = CreateTimerDialog(udg_timer[1])
        call TimerDialogSetTitle(udg_timerdialog[2], "Start of the battle:" )
        call TimerDialogDisplay(udg_timerdialog[2], true)
    endif
    if not( udg_logic[31] ) and ( not(udg_logic[71]) or udg_logic[43] ) and udg_Boss_LvL != 1 and (not( udg_logic[101] ) or (udg_ArenaLim[1] == 0 and udg_logic[101])) then
        call UnitAddAbility( gg_unit_h00A_0034, 'A0JQ' )
    endif
    if not( udg_logic[33] ) and not( udg_logic[43] ) and not(udg_logic[71]) and udg_Boss_LvL != 1 and (not( udg_logic[101] ) or (udg_ArenaLim[0] == 0 and udg_logic[101])) then
        call UnitAddAbility( gg_unit_h00A_0034, 'A08B' )
    endif
    if not( udg_logic[43] ) then
        if udg_logic[71] then
            call UnitAddAbility( gg_unit_h00A_0034, 'A10O' ) 
        else
            call UnitAddAbility( gg_unit_h00A_0034, 'A10N' ) 
        endif
    endif

    if udg_logic[7]  then
        call PauseTimer( udg_timer[4] )
    endif

    call Feerverk()
    set cyclA = 1
    loop
        exitwhen cyclA > 4
        call BlzFrameSetVisible( iconframe[cyclA],true)
        if GetPlayerSlotState( Player( cyclA - 1 ) ) == PLAYER_SLOT_STATE_PLAYING then
            call FightEndDelBuff(udg_hero[cyclA])
            call SaveBoolean( udg_hash, GetHandleId( udg_hero[cyclA] ), StringHash( "kill" ), false )
            call BlzSetUnitRealFieldBJ( udg_hero[cyclA], UNIT_RF_ACQUISITION_RANGE, 600 )
            call SelectUnitForPlayerSingle( udg_hero[cyclA], Player(cyclA - 1) )
            set cyclB = 1
            loop
                exitwhen cyclB > 10
                set dps[cyclA][cyclB] = 0
                set cyclB = cyclB + 1
            endloop
            set udg_dpslast[cyclA] = 0
            call UnitRemoveAbility( udg_hero[cyclA], 'A031' )
            if not(udg_logic[43]) then
                call BlzFrameSetVisible( faceframe[cyclA],true)
            endif
            set i = GetPlayerId(GetOwningPlayer(udg_hero[cyclA])) + 1
            set udg_combatlogic[cyclA] = false
            set cyclB = 1
            set cyclBEnd = deadminionlim[cyclA]
            loop
                exitwhen cyclB > cyclBEnd
                set deadminion[cyclA][cyclB] = 0
                set cyclB = cyclB + 1
            endloop
            set deadminionnum[cyclA] = 0
            set deadminionlim[cyclA] = 0
            if LoadInteger( udg_hash, GetHandleId( udg_hero[cyclA] ), StringHash( "spig" ) ) >= 5 and inv( udg_hero[cyclA], 'I097' ) > 0 then
                call SetWidgetLife( GetItemOfTypeFromUnitBJ(udg_hero[cyclA], 'I097'), 0 )
                set bj_lastCreatedItem = CreateItem( 'I03F', GetUnitX(udg_hero[cyclA]), GetUnitY(udg_hero[cyclA]))
                call UnitAddItem(udg_hero[cyclA], bj_lastCreatedItem)
                call textst( "|c00ffffff Ground comparison done!", udg_hero[cyclA], 64, GetRandomReal( 45, 135 ), 12, 1.5 )
                call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\Human\\ReviveHuman\\ReviveHuman.mdl", GetUnitX(udg_hero[cyclA]), GetUnitY(udg_hero[cyclA]) ) )
                set udg_QuestDone[GetPlayerId( GetOwningPlayer(udg_hero[cyclA]) ) + 1] = true
            endif
            
            set udg_FightEnd_Unit = udg_hero[cyclA]
            set udg_FightEnd_Real = 0
            set udg_FightEnd_Real = 1
            set udg_FightEnd_Real = 0
            
            if GetUnitAbilityLevel( udg_hero[cyclA], 'A0IK' ) > 0 or GetUnitAbilityLevel( udg_hero[cyclA], 'A0IJ' ) > 0 or GetUnitAbilityLevel( udg_hero[cyclA], 'A0IL' ) > 0 or GetUnitAbilityLevel( udg_hero[cyclA], 'A0IM' ) > 0 or GetUnitAbilityLevel( udg_hero[cyclA], 'A0IN' ) > 0 or GetUnitAbilityLevel( udg_hero[cyclA], 'A0IO' ) > 0 then
                set spec = udg_Ability_Uniq[cyclA]
                set cyclB = 1
                loop
                    exitwhen cyclB > 1
                    set rand = GetRandomInt( 1, 3 )
                    if udg_DB_Hero_SpecAb[10 + rand] != spec and udg_DB_Hero_SpecAbPlus[10 + rand] != spec then
                        call NewUniques( udg_hero[cyclA], udg_DB_Hero_SpecAb[10 + rand] )
                    else
                        set cyclB = cyclB - 1
                    endif
                    set cyclB = cyclB + 1
                endloop
            endif
            if udg_logic[10] then
                set cyclB = 0
                loop
                    exitwhen cyclB > 5
                    set it = UnitItemInSlot(udg_hero[cyclA], cyclB)
                    if it != null then
                        if GetItemType(it) == ITEM_TYPE_PERMANENT then
                            call RemoveItem(it)
                            call ItemRandomizer( udg_hero[cyclA], "common" )
                        elseif GetItemType(it) == ITEM_TYPE_CAMPAIGN then
                            call RemoveItem(it)
                            call ItemRandomizer( udg_hero[cyclA], "rare" )
                        elseif GetItemType(it) == ITEM_TYPE_ARTIFACT then
                            call RemoveItem(it)
                            call ItemRandomizer( udg_hero[cyclA], "legendary" )
                        endif
                    endif
                    set cyclB = cyclB + 1
                endloop
            endif
            if udg_ItemGetActive[cyclA] then
                if GetLocalPlayer() == Player(cyclA-1) then
                    call BlzFrameSetVisible( sklbk,true)
                    if udg_roll[cyclA] > 0 then
                        call BlzFrameSetVisible( refbk,true)
                    endif
                endif
            elseif udg_Heroes_Amount > 1 and udg_number[69 + cyclA] > 0 and not(udg_ItemGetActive[cyclA]) then
                if GetLocalPlayer() == Player(cyclA-1) then
                    call BlzFrameSetVisible( pvpbk,true)
                endif
            endif
            if GetUnitAbilityLevel(udg_hero[cyclA], 'A1BW') > 0 then
                call NewSpecial( udg_hero[cyclA], 'A1BV' )
            endif
            if not( udg_fightmod[3] ) then
                set cyclB = 0
                loop
                    exitwhen cyclB > 5
                    if SubString(BlzGetItemExtendedTooltip(UnitItemInSlot(udg_hero[cyclA], cyclB)), 0, 18) == "|cffC71585Cursed|r" then
                        call RemoveItem( UnitItemInSlot(udg_hero[cyclA], cyclB) )
                    endif
                    set cyclB = cyclB + 1
                endloop
                if udg_logic[51] and inv(udg_hero[cyclA], 'I0FB') == 0 then
                    if UnitInventoryCount(udg_hero[cyclA]) >= 6 then
                        call RemoveItem( UnitItemInSlot( udg_hero[cyclA], GetRandomInt(0, 5) ) )
                    endif
                    call UnitAddItem( udg_hero[cyclA], CreateItem( 'I0FB', GetUnitX( udg_hero[cyclA] ), GetUnitY( udg_hero[cyclA] ) ) )
                endif
                if udg_logic[80] then
                    call skillst( cyclA, -1 )
                endif
                if inv(udg_hero[cyclA], 'I027') > 0 then
                    call BlzSetUnitBaseDamage( udg_hero[cyclA], ( BlzGetUnitBaseDamage(udg_hero[cyclA], 0) + 3 ), 0 )
                    set udg_Data[cyclA + 8] = udg_Data[cyclA + 8] + 3
                    call textst( "|c00808080 +3 attack power", udg_hero[cyclA], 64, GetRandomReal( 0, 360 ), 10, 2.5 )
                endif
                if GetUnitAbilityLevel(udg_hero[cyclA], 'B04J') > 0 then
                    call UnitRemoveAbility(udg_hero[cyclA], 'A08Q')
                    call UnitRemoveAbility(udg_hero[cyclA], 'B04J')  
                endif
                if GetUnitAbilityLevel(udg_hero[cyclA], 'B085') > 0 then
                    call UnitRemoveAbility(udg_hero[cyclA], 'A0VX')
                    call UnitRemoveAbility(udg_hero[cyclA], 'B085')  
                endif
                if inv(udg_hero[cyclA], 'I0AC') > 0 then
                    set cyclB = 1
                    loop
                        exitwhen cyclB > 5
                        call CreateItem( 'I03J' + GetRandomInt( 1, 6 ), GetLocationX( udg_point[21 + cyclA] ) + GetRandomReal( -100, 100 ), GetLocationY( udg_point[21 + cyclA] ) + GetRandomReal( -100, 100 ) )
                        set cyclB = cyclB + 1
                    endloop
                endif
                if inv(udg_hero[cyclA], 'I0G3') > 0 and UnitInventoryCount(udg_hero[cyclA]) < 6 then
                    call UnitAddItem( udg_hero[cyclA], CreateItem(DB_SetItems[3][GetRandomInt(1,udg_DB_SetItems_Num[3])], GetUnitX(udg_hero[cyclA]), GetUnitY(udg_hero[cyclA]) ) )
                endif
                if inv(udg_hero[cyclA], 'I08G') > 0 then
                    set p = 100 + ( 50 * ( SetCount_GetPieces(udg_hero[cyclA], SET_MECH) - 1 ) )
                    call moneyst( udg_hero[cyclA], p )
                    set udg_Data[cyclA] = udg_Data[cyclA] + p
                    call textst( "|c00FFFF00 +" + I2S( p ) + " gold", udg_hero[cyclA], 64, GetRandomReal( 0, 360 ), 10, 2.5 )
                endif
                if inv(udg_hero[cyclA], 'I01L') > 0 then
                    set cyclB = 1
                    loop
                        exitwhen cyclB > 3
                        set rand = GetRandomInt(( udg_luckychance[cyclA] - 10 ), 10)
                        if rand > 10 then
                            set rand = 10
                        endif
                        if cyclB == 1 then
                            call statst( udg_hero[cyclA], rand, 0, 0, 68, true )
                            if rand >= 0 then
                                set str = "+"
                            else
                                set str = ""
                            endif
                            call textst( "|c00FF2020 " + str + I2S(rand) + " strength", udg_hero[cyclA], 64, 30, 10, 2.5 )
                        elseif cyclB == 2 then
                            call statst( udg_hero[cyclA], 0, rand, 0, 72, true )
                            if rand >= 0 then
                                set str = "+"
                            else
                                set str = ""
                            endif
                            call textst( "|c0020FF20 " + str + I2S(rand) + " agility", udg_hero[cyclA], 64, 150, 10, 2.5 )
                        elseif cyclB == 3 then
                            call statst( udg_hero[cyclA], 0, 0, rand, 76, true )
                            if rand >= 0 then
                                set str = "+"
                            else
                                set str = ""
                            endif
                            call textst( "|c002020FF " + str + I2S(rand) + " intelligence", udg_hero[cyclA], 64, 270, 10, 2.5 )
                        endif
                        set cyclB = cyclB + 1
                    endloop
                endif
                if inv(udg_hero[cyclA], 'I07B') > 0 then
                    set rand = GetRandomInt(1, 4)
                    if rand == 1 then
                        call SetHeroLevel( udg_hero[cyclA], GetHeroLevel(udg_hero[cyclA]) + 1, false)
                        call textst( "|c00ffffff +1 level", udg_hero[cyclA], 64, GetRandomReal( 0, 360 ), 10, 1.5 )
                        set udg_Data[cyclA + 12] = udg_Data[cyclA + 12] + 1
                    elseif rand == 2 then
                        call statst( udg_hero[cyclA], 2, 2, 2, 0, true )
                        call textst( "|c00ffffff +2 stats", udg_hero[cyclA], 64, GetRandomReal( 0, 360 ), 10, 1.5 )
                        set udg_Data[cyclA + 16] = udg_Data[cyclA + 16] + 2
                    elseif rand == 3 then
                        call moneyst( udg_hero[cyclA], 100 )
                        call textst( "|c00ffffff +100 gold", udg_hero[cyclA], 64, GetRandomReal( 0, 360 ), 10, 1.5 )
                        set udg_Data[cyclA + 20] = udg_Data[cyclA + 20] + 100
                    elseif rand == 4 then
                        call UnitAddAbility( udg_hero[cyclA], 'A08Q' )
                        call textst( "|c00ffffff Extra attack power!", udg_hero[cyclA], 64, GetRandomReal( 0, 360 ), 10, 1.5 )
                    endif
                endif
                if inv(udg_hero[cyclA], 'I086') > 0 then
                    set st[0] = 0
                    set st[1] = 0
                    set cyclB = 2
                    loop
                        exitwhen cyclB > 4
                        set st[cyclB] = DB_SetItems[5][GetRandomInt( 1, udg_DB_SetItems_Num[5] )]
                        if (st[cyclB] == st[cyclB-1] or st[cyclB] == st[cyclB-2]) then
                            set cyclB = cyclB - 1
                        endif
                        set cyclB = cyclB + 1
                    endloop
                    call forge( udg_hero[cyclA], GetItemOfTypeFromUnitBJ( udg_hero[cyclA], 'I086'), st[4], st[2], st[3], true )
                endif
                if inv(udg_hero[cyclA], 'I03Y') > 0 then
                    set cyclB = 1
                    set cyclBEnd = inv(udg_hero[cyclA], 'I03Y')
                    loop
                        exitwhen cyclB > cyclBEnd
                        if UnitInventoryCount(udg_hero[cyclA]) < 6 then
                            call UnitAddItem( udg_hero[cyclA], CreateItem('I03Y', GetUnitX(udg_hero[cyclA]), GetUnitY(udg_hero[cyclA]) ) )
                        else
                            set cyclB = cyclBEnd
                        endif
                        set cyclB = cyclB + 1
                    endloop
                endif
		        /// Last
                if inv(udg_hero[cyclA], 'I082') > 0 then
                    set cyclB = 1
                    loop
                        exitwhen cyclB > 6
                        if UnitInventoryCount(udg_hero[cyclA]) < 6 then
                            set bj_lastCreatedItem = CreateItem( udg_Database_Item_Potion[GetRandomInt(1, udg_Database_NumberItems[9])], GetUnitX( udg_hero[cyclA] ), GetUnitY(udg_hero[cyclA]))
                            call UnitAddItem(udg_hero[cyclA], bj_lastCreatedItem )
                        else
                            set cyclB = 6
                        endif
                        set cyclB = cyclB + 1
                    endloop
                endif
                if GetHeroStr( udg_hero[cyclA], false) < 1 then
                    call SetHeroStr( udg_hero[cyclA], 1, true)
                endif
                if GetHeroAgi( udg_hero[cyclA], false) < 1 then
                    call SetHeroAgi( udg_hero[cyclA], 1, true)
                endif
                if GetHeroInt( udg_hero[cyclA], false) < 1 then
                    call SetHeroInt( udg_hero[cyclA], 1, true)
                endif
            endif
            set udg_Death[cyclA] = false
            if udg_number[1] > 0 then
                if inv(udg_hero[cyclA], 'I0CX') > 0 then
                    call RemoveItem( GetItemOfTypeFromUnitBJ( udg_hero[cyclA], 'I0CX') )
                    call UnitAddItem( udg_hero[cyclA], CreateItem(DB_Items[3][GetRandomInt( 1, udg_Database_NumberItems[3] )], GetUnitX(udg_hero[cyclA]), GetUnitY(udg_hero[cyclA]) ) )
                endif
            endif
        endif
        set cyclA = cyclA + 1
    endloop

    set udg_FightEndGlobal_Real = 0.00
    set udg_FightEndGlobal_Real = 1.00
    set udg_FightEndGlobal_Real = 0.00

    if udg_modbad[20] and not( udg_fightmod[3] ) then
        call Curse20()
    endif

    if udg_modgood[12] and not( udg_fightmod[3] ) and udg_number[1] > 0 then
        set n = GroupPickRandomUnit(udg_heroinfo)
        call statst( n, 1, 1, 1, 0, false )
        call textst( "|c00ffffff +1 stats", n, 64, GetRandomReal( 0, 360 ), 10, 1.5 )
    endif

    call BlzFrameSetVisible( resback, false )
	call AUI_HpBarHide()
	call BlzFrameSetVisible( bonusframe[-1], false ) 

	if not( udg_logic[43] ) then
		call BlzFrameSetVisible( fon,true)
		call BlzFrameSetVisible( butbk,true)
	endif
    
    if AnyHasLvL(3) then
        call BlzFrameSetVisible( juleIcon,true)
    endif
    
    call BlzFrameSetVisible( gqfone, false )

    //Держать здесь
    set udg_number[1] = 0 
    if udg_logic[4] and not(udg_fightmod[3]) then
        set udg_logic[4] = false
        call IconFrameDel( "Credit Card" )
    endif
    if udg_logic[80] and not(udg_fightmod[3]) then
        set udg_logic[80] = false
        call IconFrameDel( "World" )
    endif
    if udg_logic[34] and not(udg_fightmod[3]) then
        set udg_logic[34] = false
        call IconFrameDel( "Hermit" )
    endif 

    set udg_KillUnit = 0

    call GroupClear( g )
    call DestroyGroup( g )
    set n = null
    set g = null
endfunction