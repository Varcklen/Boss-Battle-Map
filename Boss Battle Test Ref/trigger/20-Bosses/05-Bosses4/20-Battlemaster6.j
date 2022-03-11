scope BattleMaster6 initializer init

    globals
        private constant integer BOSS_KEY = StringHash( "bsmd6" )
    endglobals

    function Trig_Blademaster6_Conditions takes nothing returns boolean
        return GetUnitTypeId( udg_DamageEventTarget ) == 'e001' and GetUnitLifePercent(udg_DamageEventTarget) <= 15
    endfunction
    
    function Boss_Condition takes nothing returns boolean
        local integer i = 0
        local boolean isTrue = false
        local string bossWord
        
        loop
            exitwhen i > 3 or isTrue
            set bossWord = GetBossWord(i)
            if bossWord != null then
                if GetBossWordPostion(2) == GetBossWordSymbol(bossWord, false) and GetBossWordPostion(5) == GetBossWordSymbol(bossWord, true) then
                    set isTrue = true
                endif
            endif
            set i = i + 1
        endloop
        return isTrue
    endfunction
    
    private function MinionSpawn takes nothing returns nothing
        local integer id = GetHandleId( GetExpiredTimer( ) )
        local player pl = LoadPlayerHandle( udg_hash, id, BOSS_KEY )
        
        if GetLocalPlayer() == pl then
            call CreateUnit(pl, 'u000', 0, 0, 0 )
        endif
        call FlushChildHashtable( udg_hash, id )
    
        set pl = null
    endfunction

    private function Boss_Start takes nothing returns nothing
        local integer i = 0
        local integer id
        
        loop
            exitwhen i > 3
            if GetPlayerSlotState( Player(i) ) == PLAYER_SLOT_STATE_PLAYING and GetRandomInt(1, 100) <= 65 then
                set id = GetHandleId( Player(i) )
                call SaveTimerHandle( udg_hash, id, BOSS_KEY, CreateTimer( ) ) 
                set id = GetHandleId( LoadTimerHandle( udg_hash, id, BOSS_KEY ) ) 
                call SavePlayerHandle( udg_hash, id, BOSS_KEY, Player(i) ) 
                call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( Player(i) ), BOSS_KEY ), GetRandomInt(600, 1800), true, function MinionSpawn )
            endif
            set i = i + 1
        endloop
    endfunction

    private function init takes nothing returns nothing
        local trigger pause = CreateTrigger()

		call TriggerRegisterTimerEvent(pause, 3, false)
		call TriggerAddAction(pause, function Boss_Start )
        call TriggerAddCondition( pause, Condition( function Boss_Condition ) )
        
        set pause = null
    endfunction
endscope

