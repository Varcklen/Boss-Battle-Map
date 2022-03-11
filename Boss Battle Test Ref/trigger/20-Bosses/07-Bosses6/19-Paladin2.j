scope Paladin02

    globals
        private constant integer PALADIN_HEALTH_CHECK = 70
    
        private constant integer PALADIN_LIGHT_DAMAGE = 150
        private constant integer PALADIN_LIGHT_AREA = 900
        
        private constant string PALADIN_LIGHT_ANIMATION_BOSS = "Abilities\\Spells\\Human\\Resurrect\\ResurrectCaster.mdl"
        private constant string PALADIN_LIGHT_ANIMATION_TARGET = "Abilities\\Spells\\Undead\\AnimateDead\\AnimateDeadTarget.mdl"
    endglobals

    function Trig_Paladin2_Conditions takes nothing returns boolean
        return GetUnitTypeId( udg_DamageEventTarget ) == 'h00M' and GetUnitLifePercent(udg_DamageEventTarget) <= PALADIN_HEALTH_CHECK
    endfunction

    private function Paladin2AoE takes unit boss returns nothing
            local group g = CreateGroup()
            local unit u
        
            call DestroyEffect( AddSpecialEffectToUnit( PALADIN_LIGHT_ANIMATION_BOSS, boss ) )
            call GroupEnumUnitsInRange( g, GetUnitX( boss ), GetUnitY( boss ), 900, null )
            loop
                set u = FirstOfGroup(g)
                exitwhen u == null
                if unitst( u, boss, "enemy" ) then
                    call DestroyEffect( AddSpecialEffectToUnit( PALADIN_LIGHT_ANIMATION_TARGET, u ) )
                    call UnitTakeDamage(boss, u, PALADIN_LIGHT_DAMAGE, DAMAGE_TYPE_MAGIC)
                endif
                call GroupRemoveUnit(g,u)
            endloop
        
            call GroupClear( g )
            call DestroyGroup( g )
            set u = null
            set g = null
            set boss = null
        endfunction

    function Paladin2Cast takes nothing returns nothing
        local integer id = GetHandleId( GetExpiredTimer( ) )
        local unit boss = LoadUnitHandle( udg_hash, id, StringHash( "bspl1" ) )
        
        if GetUnitState( boss, UNIT_STATE_LIFE) <= 0.405 or not( udg_fightmod[0] ) then
            call DestroyTimer( GetExpiredTimer() )
            call FlushChildHashtable( udg_hash, id )
        else
            call Paladin2AoE(boss)
        endif
        
        set boss = null
    endfunction

    function Trig_Paladin2_Actions takes nothing returns nothing
        call DisableTrigger( GetTriggeringTrigger() )
        call InvokeTimerWithUnit(udg_DamageEventTarget, "bspl1", bosscast(10), true, function Paladin2Cast)
    endfunction

    //===========================================================================
    function InitTrig_Paladin2 takes nothing returns nothing
        set gg_trg_Paladin2 = CreateTrigger(  )
        call DisableTrigger( gg_trg_Paladin2 )
        call TriggerRegisterVariableEvent( gg_trg_Paladin2, "udg_AfterDamageEvent", EQUAL, 1.00 )
        call TriggerAddCondition( gg_trg_Paladin2, Condition( function Trig_Paladin2_Conditions ) )
        call TriggerAddAction( gg_trg_Paladin2, function Trig_Paladin2_Actions )
    endfunction

endscope
