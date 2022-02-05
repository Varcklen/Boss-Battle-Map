scope War01 initializer init

    globals
        public constant integer ID_BOSS = 'o011'
        
        private constant real LIGHTNING_LIFE_TIME = 0.5
        private constant integer LIGHTNING_Z_DEVIATION = 50
        private constant integer CONSUMED_PERCENT_HEALTH = -50
        private constant integer COOLDOWN = 20
    endglobals

    function Trig_War1_Conditions takes nothing returns boolean
        return GetUnitTypeId(udg_DamageEventTarget) == ID_BOSS
    endfunction

    function War1Cast takes nothing returns nothing
        local integer id = GetHandleId( GetExpiredTimer() )
        local unit boss = LoadUnitHandle( udg_hash, id, StringHash( "bswr" ) )
        local unit u = null
        
        if IsUnitDead(boss) or not( udg_fightmod[0] ) then
            call FlushChildHashtable( udg_hash, id )
            call DestroyTimer( GetExpiredTimer() )
        else
            set u = HeroMoreHP(null)
            if u != null then
                call Lightning_CreateLightning("AFOD", GetUnitX(boss), GetUnitY(boss), GetUnitFlyHeight(boss) + LIGHTNING_Z_DEVIATION, GetUnitX(u), GetUnitY(u), GetUnitFlyHeight(u) + LIGHTNING_Z_DEVIATION, LIGHTNING_LIFE_TIME )
                call DestroyEffect( AddSpecialEffect("Objects\\Spawnmodels\\Orc\\OrcSmallDeathExplode\\OrcSmallDeathExplode.mdl", GetUnitX( u ), GetUnitY( u ) ) )
                call AddHealthPercent( u, CONSUMED_PERCENT_HEALTH )
            endif
        endif
        
        set u = null
        set boss = null
    endfunction 

    function Trig_War1_Actions takes nothing returns nothing
        call DisableTrigger( GetTriggeringTrigger() )
        call InvokeTimerWithUnit(udg_DamageEventTarget, "bswr", bosscast(COOLDOWN), true, function War1Cast)
    endfunction

    //===========================================================================
    private function init takes nothing returns nothing
        set gg_trg_War1 = CreateEventTrigger( "udg_AfterDamageEvent", function Trig_War1_Actions, function Trig_War1_Conditions )
        call DisableTrigger( gg_trg_War1 )
    endfunction

endscope
