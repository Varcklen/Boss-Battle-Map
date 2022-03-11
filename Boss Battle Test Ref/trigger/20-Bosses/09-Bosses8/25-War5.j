scope War05 initializer init

    globals
        private constant integer HEALTH_CHECK = 30
        private constant string ANIMATION = "Abilities\\Spells\\NightElf\\BattleRoar\\RoarCaster.mdl"
    endglobals

    function Trig_War5_Conditions takes nothing returns boolean
        return GetUnitTypeId( udg_DamageEventTarget ) == War01_ID_BOSS and GetUnitLifePercent(udg_DamageEventTarget) <= HEALTH_CHECK
    endfunction

    function Trig_War5_Actions takes nothing returns nothing
        local integer i
        local integer iEnd
        local integer k
        local integer kEnd

        call DisableTrigger( GetTriggeringTrigger() )
        call DestroyEffect( AddSpecialEffectTarget(ANIMATION, udg_DamageEventTarget, "origin" ) )
        
        set i = 0
        set iEnd = PLAYERS_LIMIT - 1
        loop
            exitwhen i > iEnd
            set k = 0
            set kEnd = PLAYERS_LIMIT - 1
            loop
                exitwhen k > kEnd
                if i != k then
                    call SetPlayerAllianceStateBJ( Player(i), Player(k), bj_ALLIANCE_UNALLIED )
                endif
                set k = k + 1
            endloop
            if IsUnitAlive(udg_hero[i+1]) then
                call PlaySpecialEffect(ANIMATION, udg_hero[i+1])
            endif
            set i = i + 1
        endloop
    endfunction

    //===========================================================================
    private function init takes nothing returns nothing
        set gg_trg_War5 = CreateEventTrigger( "udg_AfterDamageEvent", function Trig_War5_Actions, function Trig_War5_Conditions )
        call DisableTrigger( gg_trg_War5 )
    endfunction

endscope