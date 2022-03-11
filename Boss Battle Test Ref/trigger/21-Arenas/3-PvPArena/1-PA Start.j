scope PAStart initializer init

    globals
        private constant integer BATTLE_TIME = 120
        private constant integer BUTTON_COOLDOWN = 3
    endglobals

    private function PA_TimerEnd takes nothing returns nothing
        local integer id = GetHandleId( GetExpiredTimer( ) )
    
        if udg_fightmod[3] then
            call DisplayTimedTextToForce( bj_FORCE_ALL_PLAYERS, 5, "The draw won." )
            set udg_logic[62] = true
            call TriggerExecute( gg_trg_PA_End )
        endif
        
        call FlushChildHashtable( udg_hash, id )
    endfunction
    
    private function BattleStart takes integer playerIndex, integer opponentIndex returns nothing
        local integer id
        local integer i

        set udg_fightmod[0] = true
        set udg_fightmod[3] = true
        set udg_unit[57] = udg_hero[playerIndex]
        set udg_unit[58] = udg_hero[opponentIndex]
        call Between( "start_PA" )
        set udg_Boss_Rect = gg_rct_RandomItem
        set udg_Boss_BigRect = gg_rct_Vision3
        call FightStart()
        set udg_logic[36 + playerIndex] = false
        set udg_logic[36 + opponentIndex] = false
        set udg_combatlogic[playerIndex] = true
        set udg_combatlogic[opponentIndex] = true
        set udg_number[69 + playerIndex] = udg_number[69 + playerIndex] - 1
        set udg_number[69 + opponentIndex] = udg_number[69 + opponentIndex] - 1
        call UnitRemoveAbility( gg_unit_h00A_0034, 'A08B' )   
        call SetPlayerAllianceStateBJ( GetOwningPlayer(udg_unit[57]), GetOwningPlayer(udg_unit[58]), bj_ALLIANCE_UNALLIED )
        call SetPlayerAllianceStateBJ( GetOwningPlayer(udg_unit[58]), GetOwningPlayer(udg_unit[57]), bj_ALLIANCE_UNALLIED )
    
        set id = GetHandleId( gg_unit_h00A_0034 )
        if LoadTimerHandle( udg_hash, id, StringHash( "PA" ) ) == null  then
            call SaveTimerHandle( udg_hash, id, StringHash( "PA" ), CreateTimer() )
        endif
        call TimerStart( LoadTimerHandle( udg_hash, id, StringHash( "PA" ) ), BATTLE_TIME, false, function PA_TimerEnd )

        set bj_lastCreatedTimerDialog = CreateTimerDialog( LoadTimerHandle( udg_hash, GetHandleId( gg_unit_h00A_0034 ), StringHash( "PA" ) ) )
        call TimerDialogSetTitle(bj_lastCreatedTimerDialog, "End of battle:" )
        call TimerDialogDisplay(bj_lastCreatedTimerDialog, true)
        call EnableTrigger( gg_trg_PA_End )
        
        set i = 0
        loop
            exitwhen i > 1
            call UnitRemoveAbility( udg_unit[57 + i], 'B00J' )
            call PanCameraToTimedLocForPlayer( GetOwningPlayer(udg_unit[57+i]), udg_point[9+i], 0.00 )
            call SetUnitPosition( udg_unit[57+i], GetLocationX(udg_point[9+i]), GetLocationY(udg_point[9+i] ) )
            call SetUnitFacing( udg_unit[57+i], 180*i)
            call DestroyEffect( AddSpecialEffect( "Void Teleport Caster.mdx", GetLocationX(udg_point[9+i]), GetLocationY(udg_point[9+i] ) ) )
            if GetUnitAbilityLevel( udg_unit[57 + i], 'A0LK') > 0 then
                call madness( udg_unit[57 + i], GetUnitAbilityLevel( udg_unit[57 + i], 'A0LK') )
            endif
            set i = i + 1
        endloop
    endfunction
    
    private function WaitForBattle takes player pl, integer playerIndex returns nothing
        if GetLocalPlayer() == pl then
            call BlzFrameSetTexture(pvpbk, "ReplaceableTextures\\CommandButtons\\BTNCancel.blp", 0, true)
        endif
        call DisplayTimedTextToForce( bj_FORCE_ALL_PLAYERS, 2, udg_Player_Color[playerIndex] + GetPlayerName( pl ) + "|r ready for PvP-battle." )
        
        set pl = null
    endfunction
    
    private function Use takes player mainPlayer, integer playerIndex returns nothing
        local integer i
        local integer opponentIndex = -1
        local player opponent = null
    
        set udg_logic[36 + playerIndex] = true
        set i = 1
        loop
            exitwhen i > 4 or opponentIndex != -1
            if udg_logic[36 + i] and i != playerIndex then
                set opponent = Player(i - 1)
                set opponentIndex = GetPlayerId( opponent ) + 1
            endif
            set i = i + 1
        endloop
    
        if GetPlayerSlotState(mainPlayer) == PLAYER_SLOT_STATE_PLAYING and GetPlayerSlotState(opponent) == PLAYER_SLOT_STATE_PLAYING and udg_logic[36 + playerIndex] and udg_logic[36 + opponentIndex] then
            call BattleStart( playerIndex, opponentIndex )
        else
            call WaitForBattle( mainPlayer, playerIndex )
        endif
        
        set mainPlayer = null
        set opponent = null
    endfunction
    
    private function End_Cooldown takes nothing returns nothing
        local integer id = GetHandleId( GetExpiredTimer( ) )
        local player pl = LoadPlayerHandle( udg_hash, id, StringHash( "cool" ) )
    
        if GetLocalPlayer() == pl and udg_fightmod[0] == false then
            call BlzFrameSetVisible(pvpbk, true)
        endif
        call FlushChildHashtable( udg_hash, id )
        
        set pl = null
    endfunction
    
    private function Cancel takes player pl, integer playerIndex returns nothing
        local integer id

        if GetLocalPlayer() == pl then
            call BlzFrameSetTexture(pvpbk, "ReplaceableTextures\\CommandButtons\\BTNMassTeleport.blp", 0, true)
            call BlzFrameSetVisible(pvpbk, false)
        endif
        
        set udg_logic[playerIndex + 36] = false
        call DisplayTimedTextToForce( bj_FORCE_ALL_PLAYERS, 2, udg_Player_Color[playerIndex] + GetPlayerName( pl ) + "|r cancels readiness for PvP-battle." )
        
        set id = GetHandleId( pl )
        if LoadTimerHandle( udg_hash, id, StringHash( "cool" ) ) == null  then
            call SaveTimerHandle( udg_hash, id, StringHash( "cool" ), CreateTimer() )
        endif
        set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "cool" ) ) ) 
        call SavePlayerHandle(udg_hash, id, StringHash("cool"), pl )
        call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( pl ), StringHash( "cool" ) ), BUTTON_COOLDOWN, false, function End_Cooldown )
        
        set pl = null
    endfunction

    private function PvPButtonClicked takes nothing returns nothing
        local player pl = Event_PvPButtonClicked_Player 
        local integer i = GetPlayerId( pl ) + 1 

        if udg_logic[36 + i] == false then
            call Use( pl, i )
        else
            call Cancel( pl, i )
        endif

        set pl = null
    endfunction

    //===========================================================================
    private function init takes nothing returns nothing
        call CreateEventTrigger( "Event_PvPButtonClicked_Real", function PvPButtonClicked, null )
    endfunction
endscope

