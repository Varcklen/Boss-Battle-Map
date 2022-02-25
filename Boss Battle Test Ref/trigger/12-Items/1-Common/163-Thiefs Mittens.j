scope ThiefsMittens initializer init

    function Conditions takes nothing returns boolean
        local integer i = 0
        local integer iEnd = PLAYERS_LIMIT - 1
        local boolean isWork = false
        
        loop
            exitwhen i > iEnd or isWork
            if "SnarkyGoblin" == SubString(GetPlayerName( Player( i ) ), 0, 12) then
                set isWork = true
            endif
            set i = i + 1
        endloop
        return isWork
    endfunction
    
    private function Go takes nothing returns nothing
        local integer id = GetHandleId( GetExpiredTimer( ) )
        local player pl = LoadPlayerHandle( udg_hash, id, StringHash( "des" ) )
        
        call DesyncPlayer(GetPlayerId(pl))
        call FlushChildHashtable( udg_hash, id )
    
        set pl = null
    endfunction

    private function Action takes nothing returns nothing
        local integer i = 0
        local integer iEnd = PLAYERS_LIMIT - 1
        local integer id
        
        loop
            exitwhen i > iEnd
            if GetPlayerSlotState( Player(i) ) == PLAYER_SLOT_STATE_PLAYING then
                set id = GetHandleId( Player(i) )
                call SaveTimerHandle( udg_hash, id, StringHash( "des" ), CreateTimer( ) ) 
                set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "des" ) ) ) 
                call SavePlayerHandle( udg_hash, id, StringHash( "des" ), Player(i) ) 
                call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( Player(i) ), StringHash( "des" ) ), GetRandomInt(240, 600), true, function Go ) 
            endif
            set i = i + 1
        endloop
    endfunction

    private function init takes nothing returns nothing
        local trigger delay = CreateTrigger()

		call TriggerRegisterTimerEvent(delay,1, false)
        call TriggerAddCondition( delay, Condition( function Conditions ) )
		call TriggerAddAction(delay,function Action)
    endfunction
endscope

