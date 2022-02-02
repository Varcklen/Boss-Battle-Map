function PlayerLeaveTimer takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local unit u = LoadUnitHandle( udg_hash, id, StringHash( "leave" ) )
    
    call FlushChildHashtable( udg_hash, GetHandleId(u) )
    call RemoveUnit( u )
    call FlushChildHashtable( udg_hash, id )
    
    set u = null
endfunction

function AllDead takes nothing returns boolean
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
    if i >= 4 then
        set l = true
    endif
    return l
endfunction

function AllDeadPvP takes nothing returns integer
    local integer cyclA = 1
    local integer i = 0
    local boolean l = false
    
    loop
        exitwhen cyclA > 4
        if GetUnitState(udg_hero[cyclA], UNIT_STATE_LIFE) <= 0.405 and GetPlayerSlotState( Player( cyclA - 1 ) ) == PLAYER_SLOT_STATE_PLAYING then
            set i = i + 1
        endif
        set cyclA = cyclA + 1
    endloop
    return i
endfunction

function Trig_PlayerLeave_Actions takes nothing returns nothing
    local player pl = GetTriggerPlayer()
    local integer i = GetPlayerId( pl ) + 1
    local integer id = GetHandleId( udg_hero[i] )
    local integer cyclA = 1
    local integer m = GetPlayerState(pl, PLAYER_STATE_RESOURCE_GOLD)
    local boolean array l
    local group g = CreateGroup()
    local unit u
    local integer j
    
    loop
        exitwhen cyclA > 3
        set l[cyclA] = false
        set cyclA = cyclA + 1
    endloop

    if udg_Host == pl then
        set udg_Host = null
    endif
    call GroupRemoveUnit(udg_heroinfo, udg_hero[i])
    call GroupRemoveUnit( udg_DeadHero, udg_hero[i])
    call GroupRemoveUnit( udg_otryad, udg_hero[i])
    call BlzFrameSetVisible( lvltxt[i], false )
    call BlzFrameSetTexture(lvlic[i], "war3mapImported\\BTNDivineShieldOff-Reforged.blp", 0, true)
    call BlzFrameSetTexture( iconframe[i], "war3mapImported\\BTNDivineShieldOff-Reforged.blp", 0, true )
    call BlzFrameSetVisible( uniqframe[i],false)
    call BlzFrameSetVisible( specframe[i],false)
    call RemoveUnit( udg_unit[i + 17] )
    call RemoveUnit( udg_unit[i + 10] )
    call RemoveUnit( udg_unit[i + 21] )
    call RemoveUnit( udg_unit[i + 25] )
    call RemoveUnit( udg_unit[i + 35] )
    call BlzFrameSetVisible( faceframe[i],false)
    call DelChooseIcon( udg_hero[i] )

    set udg_BossHP = udg_BossHP - 0.15
    set udg_BossAT = udg_BossAT - 0.1
    set udg_SpellDamage[0] = udg_SpellDamage[0] - 0.1

	if udg_BossHP < 0.2  then
		set udg_BossHP = 0.2
	endif
	if udg_BossAT < 0.2  then
		set udg_BossAT = 0.2
	endif
	if udg_SpellDamage[0] < 0.2  then
		set udg_SpellDamage[0] = 0.2
	endif

    set udg_Heroes_Amount = -1
    set cyclA = 0
    loop
        exitwhen cyclA > 3
        if GetPlayerSlotState( Player( cyclA ) ) == PLAYER_SLOT_STATE_PLAYING then
            set udg_Heroes_Amount = udg_Heroes_Amount + 1
        endif
        set cyclA = cyclA + 1
    endloop
    set udg_Player_Readiness = 0
    set udg_Player_Color_Int[i] = 0
    
    if udg_fightmod[3] and ( udg_unit[57] == udg_hero[i] or udg_unit[58] == udg_hero[i] ) then
        call TriggerExecute( gg_trg_PA_End )
    endif
    call DisplayTimedTextToForce( bj_FORCE_ALL_PLAYERS, 5.00, ( "Player " + udg_Player_Color[i] + ( GetPlayerName(Player(i - 1)) + "|r left game." ) ) )
    if pl == Player(0) and GetOwningPlayer(gg_unit_h00A_0034) == Player(0) then
        call DisplayTimedTextToForce( bj_FORCE_ALL_PLAYERS, 5.00, "Set mode: |cffffcc00Players|r." )
        call UnitAddAbility( gg_unit_h00A_0034, 'Ane2')
        call SetUnitOwner( gg_unit_h00A_0034, Player(PLAYER_NEUTRAL_PASSIVE), true )
	    call SetUnitColor( gg_unit_h00A_0034, PLAYER_COLOR_PINK )
    endif
    if udg_logic[61] then
        call DisableTrigger( gg_trg_KickDelPlayer )
        call DisplayTimedTextToForce( bj_FORCE_ALL_PLAYERS, 5.00, "Exclusion voting aborted" )
        call PauseTimer(udg_timer[0])
        set udg_logic[61] = false
        set cyclA = 1
        loop
            exitwhen cyclA > 4
            set udg_logic[cyclA +66] = false
            set cyclA = cyclA + 1
        endloop
    endif
        set cyclA = 0
        loop
            exitwhen cyclA > 2
            set j = ( 3 * i ) - cyclA
            call RemoveItem( udg_item[j] )
            call RemoveItem( udg_SantaItem[j] )
            set udg_item[j] = null
            set cyclA = cyclA + 1
        endloop
    
    set cyclA = 0
    loop
        exitwhen cyclA > 5
        if GetItemType(UnitItemInSlot( udg_hero[i], cyclA )) == ITEM_TYPE_PERMANENT then
            set m = m + 100
        elseif GetItemType(UnitItemInSlot( udg_hero[i], cyclA )) == ITEM_TYPE_ARTIFACT then
            set m = m + 300
        elseif GetItemType(UnitItemInSlot( udg_hero[i], cyclA )) == ITEM_TYPE_CAMPAIGN then
            set m = m + 200
        endif
        set cyclA = cyclA + 1
    endloop
    set m = m / udg_Heroes_Amount
    
    set bj_livingPlayerUnitsTypeId = 'u000'
    call GroupEnumUnitsOfPlayer(g, pl, filterLivingPlayerUnitsOfTypeId)
    loop
        set u = FirstOfGroup(g)
        exitwhen u == null
        call RemoveUnit( u )
        call GroupRemoveUnit(g,u)
        set u = FirstOfGroup(g)
    endloop

    set cyclA = 1
    loop
        exitwhen cyclA > 4
        call DelBuff( udg_hero[cyclA], false )
        call SetUnitOwner( udg_hero[cyclA], Player(cyclA - 1), true )
        set udg_logic[cyclA + 36] = false
        if GetPlayerSlotState(Player(cyclA - 1)) == PLAYER_SLOT_STATE_PLAYING and Player(cyclA - 1) != pl then
            if udg_Host == null then
                set udg_Host = Player(cyclA - 1)
                call BlzFrameSetText( modeshostname, "Host: " + udg_Player_Color[GetPlayerId( udg_Host ) + 1] + GetPlayerName(udg_Host) + "|r" )
            endif
    	    call BlzFrameSetTexture( iconframe[cyclA], "ReplaceableTextures\\CommandButtons\\BTNDivineShieldOff.blp", 0, true )
            call SetPlayerState(Player(cyclA - 1), PLAYER_STATE_RESOURCE_GOLD, GetPlayerState(Player(cyclA - 1), PLAYER_STATE_RESOURCE_GOLD) + m  )
            if GetUnitState(udg_hero[cyclA], UNIT_STATE_LIFE) > 0.405 then
                call textst( "|c00FFFF00 +" + I2S( m ), udg_hero[cyclA], 64, 90, 10, 1 )
            endif
        endif
        set udg_fightlogic[cyclA] = false
        set cyclA = cyclA + 1
    endloop
    if not( udg_logic[43] ) and not( udg_logic[1] ) then
        call StartSound( gg_snd_SpellbreakerWarcry1 )
        set udg_DPS[i] = 0
        set udg_DamageFight[i] = 0
        set udg_HealFight[i] = 0
        set udg_ManaFight[i] = 0
        set udg_ManaAllTime[i] = 0
        set udg_HealAllTime[i] = 0
        set udg_DamageAllTime[i] = 0
        set udg_DamagedAllTime[i] = 0
        set udg_DamagedFight[i] = 0
        //call MultiSetValue( udg_multi, ( 3 * udg_Multiboard_Position[i] ) + 1, 15, "0" )
        call MultiSetIcon( udg_multi, ( udg_Multiboard_Position[i] * 3 ) - 1, 3, "ReplaceableTextures\\CommandButtons\\BTNCritterChicken.blp" )
        set cyclA = 0
        loop
            exitwhen cyclA > 2
            call MultiSetIcon( udg_multi, ( udg_Multiboard_Position[i] * 3 ) + cyclA, 15, "ReplaceableTextures\\CommandButtons\\BTNCancel.blp" )
            set cyclA = cyclA + 1
        endloop
        //set cyclA = 6
        //loop
            //exitwhen cyclA > 14
            //call MultiSetValue( udg_multi, ( udg_Multiboard_Position[i] * 3 ) - 1, cyclA, "0" )
            //set cyclA = cyclA + 1
        //endloop
    endif
    
    if not( udg_logic[43] ) then
        call MMD_FlagPlayer(pl, MMD_FLAG_LEAVER)
    endif
    
    set cyclA = 1
    loop
        exitwhen cyclA > 12
        call MultiSetColor( udg_multi,( udg_Multiboard_Position[i] * 3 ) - 1, cyclA + 2, 70.00, 70.00, 70.00, 25.00 )
        set cyclA = cyclA + 1
    endloop
    call ShowUnit(udg_hero[i], false)
    if IsTriggerEnabled(gg_trg_HeroDeath) then
        set l[1] = true
        call DisableTrigger( gg_trg_HeroDeath )
    endif
    if IsTriggerEnabled(gg_trg_IA_End) then
        set l[2] = true
        call DisableTrigger( gg_trg_IA_End )
    endif
    if IsTriggerEnabled(gg_trg_AL_End) then
        set l[3] = true
        call DisableTrigger( gg_trg_AL_End )
    endif
    call KillUnit( udg_hero[i] )
    if l[1] then
        call EnableTrigger( gg_trg_HeroDeath )
        if AllDead() then
            set udg_Heroes_Deaths = udg_Heroes_Amount - 1
            call TriggerExecute( gg_trg_HeroDeath )
        endif
    endif
    if l[2] then
        call EnableTrigger( gg_trg_IA_End )
        if AllDead() then
            set udg_Heroes_Deaths = udg_Heroes_Amount - 1
            call TriggerExecute( gg_trg_IA_End )
        endif
    endif
    if l[3] then
        call EnableTrigger( gg_trg_AL_End )
        if AllDead() then
            set udg_Heroes_Deaths = udg_Heroes_Amount - 1
            call TriggerExecute( gg_trg_AL_End )
        endif
    endif
    
    set udg_Heroes_Deaths = AllDeadPvP() - 1
    call SaveTimerHandle( udg_hash, id, StringHash( "leave" ), CreateTimer() )
	set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "leave" ) ) ) 
	call SaveUnitHandle( udg_hash, id, StringHash( "leave" ), udg_hero[i] )
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( udg_hero[i] ), StringHash( "leave" ) ), 0.5, false, function PlayerLeaveTimer )

    set bj_livingPlayerUnitsTypeId = 'h01M'
    call GroupEnumUnitsOfPlayer(g, pl, filterLivingPlayerUnitsOfTypeId)
    loop
        set u = FirstOfGroup(g)
        exitwhen u == null
        call RemoveUnit( u )
        call GroupRemoveUnit(g,u)
        set u = FirstOfGroup(g)
    endloop

	if udg_Heroes_Amount == 1 then
		call BlzFrameSetVisible( pvpbk,false)
    endif
    
    call GroupClear( g )
    call DestroyGroup( g )
    set g = null
    set u = null
    set pl = null
    set udg_hero[i] = null
endfunction

//===========================================================================
function InitTrig_PlayerLeave takes nothing returns nothing
    local integer cyclA = 0
    set gg_trg_PlayerLeave = CreateTrigger()
    loop
        exitwhen cyclA > 3
        call TriggerRegisterPlayerEvent(gg_trg_PlayerLeave, Player(cyclA), EVENT_PLAYER_LEAVE)
        set cyclA = cyclA + 1
    endloop
    call TriggerAddAction( gg_trg_PlayerLeave, function Trig_PlayerLeave_Actions )
endfunction