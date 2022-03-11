scope War03 initializer init

    globals
        private constant integer HEALTH_CHECK = 70
        private constant integer AREA = 300
        private constant integer BERSERK_DURATION = 10
        private constant integer AREA_DEVIATION = 400
        private constant integer COOLDOWN = 15
        private constant integer DELAY = 3
        
        private constant string ANIMATION = "Abilities\\Spells\\NightElf\\BattleRoar\\RoarCaster.mdl"
    endglobals

    function Trig_War3_Conditions takes nothing returns boolean
        return GetUnitTypeId(udg_DamageEventTarget) == War01_ID_BOSS and GetUnitLifePercent(udg_DamageEventTarget) <= HEALTH_CHECK
    endfunction

    function War3End takes nothing returns nothing
        local integer id = GetHandleId( GetExpiredTimer() )
        local effect area = LoadEffectHandle( udg_hash, id, StringHash( "bswr4" ) )
        local unit boss = LoadUnitHandle(udg_hash, id, StringHash("bswr4b") )
        local group g = CreateGroup()
        local unit u
        
        call GroupEnumUnitsInRange( g, BlzGetLocalSpecialEffectX( area ), BlzGetLocalSpecialEffectY( area ), AREA, null )
        loop
            set u = FirstOfGroup(g)
            exitwhen u == null
            if unitst( u, boss, TARGET_ENEMY ) and combat(u, false, 0) then
                if not(IsUnitType( u, UNIT_TYPE_ANCIENT)) and not(IsUnitType( u, UNIT_TYPE_HERO)) then
                    call SetUnitOwner( u, Player(PLAYER_NEUTRAL_AGGRESSIVE), true )
                    call PlaySpecialEffect(ANIMATION, u)
                else
                    call AddTemporaryBerserk(u, BERSERK_DURATION)
                    call PlaySpecialEffect(ANIMATION, u)
                endif
            endif
            call GroupRemoveUnit(g,u)
        endloop
        
        call DestroyEffect(area)
        call FlushChildHashtable( udg_hash, id )
        
        call GroupClear( g )
        call DestroyGroup( g )
        set u = null
        set g = null
        set area = null
        set boss = null
    endfunction

    function War3Cast takes nothing returns nothing
        local integer id = GetHandleId( GetExpiredTimer() )
        local unit boss = LoadUnitHandle( udg_hash, id, StringHash( "bswr3" ) )
        local effect area
        local integer id1
        
        if IsUnitDead(boss) or not( udg_fightmod[0] ) then
            call FlushChildHashtable( udg_hash, id )
            call DestroyTimer( GetExpiredTimer() )
        else
            set area = AddSpecialEffect(DEATH_AREA, Math_GetUnitRandomX(boss, AREA_DEVIATION), Math_GetUnitRandomY(boss, AREA_DEVIATION))
            call BlzSetSpecialEffectScale( area, AREA/100 )
            
            set id1 = InvokeTimerWithEffect(area, "bswr4", bosscast(DELAY), false, function War3End )
            call SaveUnitHandle(udg_hash, id1, StringHash("bswr4b"), boss)
        endif
        
        set boss = null
        set area = null
    endfunction 

    function Trig_War3_Actions takes nothing returns nothing
        call DisableTrigger( GetTriggeringTrigger() )
        call InvokeTimerWithUnit(udg_DamageEventTarget, "bswr3", bosscast(COOLDOWN), true, function War3Cast)
    endfunction

    //===========================================================================
    private function init takes nothing returns nothing
        set gg_trg_War3 = CreateEventTrigger( "udg_AfterDamageEvent", function Trig_War3_Actions, function Trig_War3_Conditions )
        call DisableTrigger( gg_trg_War3 )
    endfunction

endscope

