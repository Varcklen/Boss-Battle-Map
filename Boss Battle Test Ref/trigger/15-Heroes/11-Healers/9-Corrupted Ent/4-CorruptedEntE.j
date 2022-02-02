scope CorruptedEntE initializer init

    globals
        private constant integer ID_HERO = 'N017'
        private constant integer ID_ABILITY = 'A0OI'
        private constant integer BUFF = 'B09Z'
    
        private constant integer HEAL_FIRST_LEVEL_BONUS = 150
        private constant integer HEAL_LEVEL_BONUS = 100
        private constant integer DAMAGE = 5
        private constant integer AREA = 600
        private constant integer INTERVAL = 1
        private constant integer LIMIT_TO_HEAL = 200
        
        private constant integer ALT_LIMIT_TO_HEAL = 600
        
        private boolean DamageCount = false
        private boolean IsHealFromIt = false
        private real Limit_to_Heal = LIMIT_TO_HEAL
    endglobals

    function Trig_CorruptedEntE_Conditions takes nothing returns boolean
        return GetLearnedSkill() == ID_ABILITY
    endfunction

    function CorruptedEntECast takes nothing returns nothing
        local integer id = GetHandleId( GetExpiredTimer( ) )
        local unit caster = LoadUnitHandle( udg_hash, id, StringHash( "ente" ) )
        local group g = CreateGroup()
        local unit u

        if IsUnitAlive( caster) and IsUnitLoaded( caster ) == false and combat(caster, false, 0) then
            call GroupEnumUnitsInRange( g, GetUnitX( caster ), GetUnitY( caster ), AREA, null )
            loop
                set u = FirstOfGroup(g)
                exitwhen u == null
                if unitst( u, caster, "ally" ) and IsUnitType( u, UNIT_TYPE_HERO) then
                    call DestroyEffect( AddSpecialEffectTarget("Abilities\\Spells\\Undead\\CarrionSwarm\\CarrionSwarmDamage.mdl", u, "origin" ) )
                    set DamageCount = true
                    call UnitTakeDamage(caster, u, DAMAGE, DAMAGE_TYPE_MAGIC)
                    set DamageCount = false
                endif
                call GroupRemoveUnit(g,u)
            endloop
        endif
        
        call GroupClear( g )
        call DestroyGroup( g )
        set g = null
        set u = null
        set caster = null 
    endfunction

    function Trig_CorruptedEntE_Actions takes nothing returns nothing
        local unit hero = GetLearningUnit()
        local integer lvl = GetUnitAbilityLevel( hero, ID_ABILITY )
        local integer heal
        local integer id
        
        set heal = HEAL_FIRST_LEVEL_BONUS + (lvl*HEAL_LEVEL_BONUS)
        
        set id = InvokeTimerWithUnit( hero, "ente", INTERVAL, true, function CorruptedEntECast )
        call SaveInteger( udg_hash, GetHandleId(hero), StringHash( "entehl" ), heal )
        
        set hero = null
    endfunction

    private function NullingAbility takes nothing returns nothing
        if GetUnitAbilityLevel( udg_Event_NullingAbility_Unit, ID_ABILITY) > 0 then
            call DestroyTimer( LoadTimerHandle( udg_hash, GetHandleId( udg_Event_NullingAbility_Unit ), StringHash( "ente" )))
        endif
    endfunction
    
    private function AddToHeal takes unit caster, real toAdd returns nothing
        local integer casterId = GetHandleId(caster)
        local integer heal = LoadInteger( udg_hash, casterId, StringHash( "entehl" ) )
        local real damageCount = LoadReal( udg_hash, casterId, StringHash( "ente" ) )
        local unit target
    
        set damageCount = damageCount + toAdd
    
        if damageCount >= Limit_to_Heal then
            set damageCount = damageCount - Limit_to_Heal
            set target = HeroLessHP(caster)
            if target != null then
                set IsHealFromIt = true
                call healst( caster, target, heal )
                set IsHealFromIt = false
                call DestroyEffect( AddSpecialEffectTarget("Objects\\Spawnmodels\\NightElf\\EntBirthTarget\\EntBirthTarget.mdl", target, "origin" ) )
            endif
        endif
        call SaveReal( udg_hash, casterId, StringHash( "ente" ), damageCount )
    
        set caster = null
        set target = null
    endfunction
    
    //After ability deal damage
    private function AfterDamageEvent_Conditions takes nothing returns boolean
        return DamageCount == true
    endfunction
    
    private function AfterDamageEvent takes nothing returns nothing
        call AddToHeal(udg_DamageEventSource, udg_DamageEventAmount)
    endfunction
    
    //Aspect Added
    private function AspectAdded_Conditions takes nothing returns boolean
        return GetUnitTypeId(Event_AspectAdded_Hero) == ID_HERO and Event_AspectAdded_Key02 == 2
    endfunction
    
    private function AspectAdded takes nothing returns nothing
        set Limit_to_Heal = ALT_LIMIT_TO_HEAL
    endfunction
    
    //Aspect Removed
    private function AspectRemoved_Conditions takes nothing returns boolean
        return GetUnitTypeId(Event_AspectRemoved_Hero) == ID_HERO and Event_AspectAdded_Key02 == 2
    endfunction
    
    private function AspectRemoved takes nothing returns nothing
        set Limit_to_Heal = LIMIT_TO_HEAL
    endfunction

    //After heal to add
    private function AfterHeal_Conditions takes nothing returns boolean
        if IsUnitHasAbility(Event_AfterHeal_Target, BUFF) == false then
            return false
        elseif IsUnitHasAbility(Event_AfterHeal_Caster, ID_ABILITY) == false then
            return false
        elseif Aspects_IsHeroAspectActive(Event_AfterHeal_Caster, ASPECT_02 ) == false then
            return false
        elseif Event_AfterHeal_Heal <= 0 then
            return false
        elseif IsHealFromIt then
            return false
        endif
    
        return true
    endfunction
    
    private function AfterHeal takes nothing returns nothing
        call AddToHeal(Event_AfterHeal_Caster, Event_AfterHeal_Heal)
    endfunction
    
    //===========================================================================
    private function init takes nothing returns nothing
        set gg_trg_CorruptedEntE = CreateTrigger(  )
        call TriggerRegisterAnyUnitEventBJ( gg_trg_CorruptedEntE, EVENT_PLAYER_HERO_SKILL )
        call TriggerAddCondition( gg_trg_CorruptedEntE, Condition( function Trig_CorruptedEntE_Conditions ) )
        call TriggerAddAction( gg_trg_CorruptedEntE, function Trig_CorruptedEntE_Actions )
        
        call CreateEventTrigger( "udg_AfterDamageEvent", function AfterDamageEvent, function AfterDamageEvent_Conditions )
        call CreateEventTrigger( "udg_Event_NullingAbility_Real", function NullingAbility, null )
        
        call CreateEventTrigger( "Event_AspectAdded_Real", function AspectAdded, function AspectAdded_Conditions )
        call CreateEventTrigger( "Event_AspectRemoved_Real", function AspectRemoved, function AspectRemoved_Conditions )
        
        call CreateEventTrigger( "Event_AfterHeal_Real", function AfterHeal, function AfterHeal_Conditions )
    endfunction

endscope

