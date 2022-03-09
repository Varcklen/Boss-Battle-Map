scope Totem2 initializer init

    globals
        private constant integer ID_SHADOW = 'n035'
    
        private constant integer ACTIVATE_DISTANCE = 300
        private constant integer DISTANCE = 1200
        private constant integer HEALTH_CHECK = 75
        private constant integer DAMAGE = 45
        
        private constant real TICK_CHECK = 0.5
    endglobals

    private function Trig_Totem2_Conditions takes nothing returns boolean
        return GetUnitTypeId( udg_DamageEventTarget ) == Totem1_ID_BOSS and GetUnitLifePercent( udg_DamageEventTarget ) <= HEALTH_CHECK
    endfunction

    private function Totem2Cast takes nothing returns nothing
        local integer id = GetHandleId( GetExpiredTimer() )
        local integer i = 1
        local unit boss = LoadUnitHandle( udg_hash, id, StringHash( "bstm3t" ) )
        local unit shadow = LoadUnitHandle( udg_hash, id, StringHash( "bstm3" ) )
        
        if IsUnitDead( boss ) or IsUnitDead( shadow ) or udg_fightmod[0] == false then
            call FlushChildHashtable( udg_hash, id )
            call DestroyTimer( GetExpiredTimer() )
        elseif DistanceBetweenUnits(boss, shadow) <= ACTIVATE_DISTANCE then
            call KillUnit( shadow )
            loop
                exitwhen i > PLAYERS_LIMIT
                if IsUnitAlive( udg_hero[i] ) then
                    call Totem1_SpawnFireArea(boss, GetUnitX( udg_hero[i] ), GetUnitY( udg_hero[i] ), DAMAGE )
                endif
                set i = i + 1
            endloop
            call FlushChildHashtable( udg_hash, id )
            call DestroyTimer( GetExpiredTimer() )
        endif
        
        set boss = null
        set shadow = null
    endfunction

    public function SpawnShadows takes unit boss returns nothing
        local integer id
        local integer i = 1
        local real x
        local real y
    
        loop
            exitwhen i > PLAYERS_LIMIT
            if IsUnitAlive( udg_hero[i] ) then
                set x = GetUnitX(boss) + DISTANCE * Cos((45 + ( 90 * i )) * bj_DEGTORAD)
                set y = GetUnitY(boss) + DISTANCE * Sin((45 + ( 90 * i )) * bj_DEGTORAD)
                set bj_lastCreatedUnit = CreateUnit( GetOwningPlayer( boss ), ID_SHADOW, x, y, 270)
                call PingMinimapLocForForceEx( bj_FORCE_ALL_PLAYERS, GetUnitLoc(bj_lastCreatedUnit), 5, bj_MINIMAPPINGSTYLE_ATTACK, 100, 50, 50 )
                call IssuePointOrder( bj_lastCreatedUnit, "move", GetUnitX( boss ), GetUnitY( boss ) )

                set id = InvokeTimerWithUnit(bj_lastCreatedUnit, "bstm3", TICK_CHECK, true, function Totem2Cast )
                call SaveUnitHandle( udg_hash, id, StringHash( "bstm3t" ), boss )
            endif
            set i = i + 1
        endloop
        
        set boss = null
    endfunction
    
    private function Trig_Totem2_Actions takes nothing returns nothing
        call DisableTrigger( GetTriggeringTrigger() )
        call SpawnShadows(udg_DamageEventTarget)
    endfunction

    //===========================================================================
    private function init takes nothing returns nothing
        set gg_trg_Totem2 = CreateEventTrigger( "udg_AfterDamageEvent", function Trig_Totem2_Actions, function Trig_Totem2_Conditions )
        call DisableTrigger( gg_trg_Totem2 )
    endfunction

endscope