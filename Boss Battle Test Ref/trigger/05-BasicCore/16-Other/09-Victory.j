function DelVictoy takes nothing returns nothing
    call KillUnit( GetEnumUnit() )
endfunction

function BossKill1 takes nothing returns nothing
    if udg_logic[43] then
    	call StopMusic(false)
    	call PlayThematicMusic( "music" )
    endif
endfunction

function VictoryEnd takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    
    call SetUnitAnimation( LoadUnitHandle( udg_hash, id, StringHash( "victory" ) ), "stand" )
    call FlushChildHashtable( udg_hash, id )
endfunction

function Trig_Victory_Actions takes nothing returns nothing
    local unit portal = CreateUnit( Player(PLAYER_NEUTRAL_PASSIVE), 'h004', GetRectCenterX( gg_rct_BossSpawn ), GetRectCenterY( gg_rct_BossSpawn ), 270 ) 
    local integer id = GetHandleId( portal )
    local integer cyclA = 1
    local player playerInLoop
    
    set udg_Portal = portal
    set udg_fightmod[0] = false
    set udg_fightmod[1] = false
    call TimerStart( CreateTimer(), 60, false, function BossKill1 )
    
    set udg_LastBoss = 0
    call IconFrameDel( "Last Boss" )
    
    set udg_logic[71] = false
    set udg_logic[43] = true
    
    if udg_Endgame == 1 then
        call SaveLoadStart()
    endif
	call StopMusic(false)
	call ClearMapMusic()
	call PlayMusicBJ( gg_snd_DarkVictory01 )
    call DisableTrigger( GetTriggeringTrigger() )
    call DisableTrigger( gg_trg_HeroDeath )
    call DisableTrigger( gg_trg_TimeGame )
    if not( udg_logic[0] ) and udg_logic[2] then
        call MultiSetColor( udg_multi, 3, 2, 0.00, 80.00, 0.00, 25.00 )
    endif
    call DisplayTimedTextToForce( bj_FORCE_ALL_PLAYERS, 15.00, "Congratulations! You won!" )
    call MultiSetValue( udg_multi, 1, 8, "Max damage" )
    call MultiSetColor( udg_multi, 4, 2, 0.00, 0.00, 0.00, 100.00 )
    call MultiSetColor( udg_multi, 5, 2, 0.00, 0.00, 0.00, 100.00 )
    call ForGroupBJ( GetUnitsInRectOfPlayer(gg_rct_ArenaBoss, Player(10)), function DelVictoy )
    call UnitAddAbility(gg_unit_u00F_0006, 'A03U')
    call SetUnitAnimation( portal, "birth" )
    call TriggerExecute( gg_trg_Caption )    
    
    call SaveTimerHandle( udg_hash, id, StringHash( "victory" ), CreateTimer() )
	set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "victory" ) ) ) 
	call SaveUnitHandle( udg_hash, id, StringHash( "victory" ), portal )
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( portal ), StringHash( "victory" ) ), 10, false, function VictoryEnd )

    set cyclA = 1
    loop
        exitwhen cyclA > 4
        set playerInLoop = Player( cyclA - 1 )
        if GetPlayerSlotState( playerInLoop ) == PLAYER_SLOT_STATE_PLAYING then
            call MMD_FlagPlayer(playerInLoop, MMD_FLAG_WINNER)
            call ReviveHeroLoc( udg_hero[cyclA], udg_point[cyclA + 4], true )
        endif
        set cyclA = cyclA + 1
    endloop
    
    set portal = null
    set playerInLoop = null
endfunction

//===========================================================================
function InitTrig_Victory takes nothing returns nothing
    set gg_trg_Victory = CreateTrigger(  )
    call TriggerAddAction( gg_trg_Victory, function Trig_Victory_Actions )
endfunction

