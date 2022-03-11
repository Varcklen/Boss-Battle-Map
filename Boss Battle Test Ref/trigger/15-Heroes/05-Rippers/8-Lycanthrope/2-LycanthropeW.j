scope LycanthropeW initializer init

    globals
        public constant integer WOLF_BUFF = 'B0A3'
        
        private constant integer ID_ABILITY = 'A1CI'
        private constant integer HUMAN_FORM = 'N03P'
        private constant integer WOLF_FORM = 'N03R'
        
        private constant real BONUS_DAMAGE_FIRST_LEVEL = 0.15
        private constant real BONUS_DAMAGE_LEVEL_BONUS = 0.15
        
        private constant integer TICK = 1
        private constant integer LOST_HEALTH_PERCENT = 5
        
        private constant integer NIGHT_DURATION_FIRST_LEVEL = 16
        private constant integer NIGHT_DURATION_LEVEL_BONUS = 0
    
        private constant string ANIMATION = "Abilities\\Spells\\Orc\\FeralSpirit\\feralspirittarget.mdl"
        
        private constant integer ID_Q_ABILITY = 'A1CJ'
        private constant integer ID_Q_ABILITY_ALT = 'A1CK'
        private constant integer Q_NUMBER = 0
        
        private constant integer ID_R_ABILITY = 'A1CN'
        private constant integer ID_R_ABILITY_ALT = 'A1CO'
        private constant integer R_NUMBER = 1
        
        private constant integer ALT_LOST_HEALTH_PERCENT = 10
        private constant integer ALT_VAMPIRISM = 15
        private constant integer ALT_DAMAGE_REDUCE = 10
        
        private string array Tooltip[2][6]//ability/levels
        private string array Name[2][6]//ability/levels
    endglobals

    function Trig_LycanthropeW_Conditions takes nothing returns boolean
        return GetUnitAbilityLevel(GetOrderedUnit(), ID_ABILITY) > 0
    endfunction
    
    private function TakeHealth takes nothing returns nothing
        local integer id = GetHandleId( GetExpiredTimer() )
        local unit hero = LoadUnitHandle(udg_hash, id, StringHash("lcnw") )
        local integer healthPerc = LoadInteger(udg_hash, id, StringHash("lcnw") )

        if IsUnitAlive(hero) and IsUnitHasAbility( hero, WOLF_BUFF) then
            if IsUnitLoaded( hero ) == false and IsUnitHidden(hero) == false then
                call AddHealthPercent(hero, -healthPerc)
            endif
        else
            call FlushChildHashtable( udg_hash, id ) 
            call DestroyTimer( GetExpiredTimer() )
        endif
        
        set hero = null
    endfunction
    
    private function MoonEnd takes nothing returns nothing
        call moonst( -1 )
    endfunction
    
     private function TurnOn_Ability takes unit hero, integer abilityId, integer abilityNew, integer abilityNumber returns nothing
        local integer lv = GetUnitAbilityLevel( hero, abilityId )
        local integer lvlLow = lv - 1
        local ability heroAbility = BlzGetUnitAbility(hero, abilityId)
        local ability heroAbilityNew
        
        if IsUnitHasAbility( hero, abilityId)  then
            call UnitAddAbility( hero, abilityNew )
            set heroAbilityNew = BlzGetUnitAbility(hero, abilityNew)
            call BlzSetAbilityIcon( abilityId, BlzGetAbilityStringField(heroAbilityNew, ABILITY_SF_ICON_RESEARCH) )
            
            set Tooltip[abilityNumber][lv] = BlzGetAbilityExtendedTooltip(abilityId, lvlLow)
            call BlzSetAbilityExtendedTooltip( abilityId, BlzGetAbilityExtendedTooltip(abilityNew, lvlLow), lvlLow )
            
            set Name[abilityNumber][lv] = BlzGetAbilityStringLevelField(heroAbility, ABILITY_SLF_TOOLTIP_NORMAL, lvlLow)
            call BlzSetAbilityStringLevelFieldBJ( heroAbility, ABILITY_SLF_TOOLTIP_NORMAL, lvlLow, BlzGetAbilityStringLevelField(heroAbilityNew, ABILITY_SLF_TOOLTIP_NORMAL, lvlLow) )
            
            call UnitRemoveAbility( hero, abilityNew )
        endif
    
        set heroAbility = null
        set heroAbilityNew = null
        set hero = null
    endfunction
    
    private function LycanthropeW_Alternative takes unit hero, real damageBonus returns nothing
        local integer id
    
        set id = InvokeTimerWithUnit(hero, "lcnw", TICK, true, function TakeHealth )
        call SaveReal(udg_hash, GetHandleId(hero), StringHash("lcnw"), damageBonus )
        call SaveInteger(udg_hash, id, StringHash("lcnw"), ALT_LOST_HEALTH_PERCENT )
        
        set hero = null
    endfunction
    
    private function LycanthropeW_Main takes unit hero, real damageBonus returns nothing
        local integer id
    
        set id = InvokeTimerWithUnit(hero, "lcnw", TICK, true, function TakeHealth )
        call SaveReal(udg_hash, GetHandleId(hero), StringHash("lcnw"), damageBonus )
        call SaveInteger(udg_hash, id, StringHash("lcnw"), LOST_HEALTH_PERCENT )
        
        set hero = null
    endfunction
    
    private function TurnOn takes unit hero returns nothing
        local integer level = GetUnitAbilityLevel( hero, ID_ABILITY )
        local real damageBonus = BONUS_DAMAGE_FIRST_LEVEL + ( level * BONUS_DAMAGE_LEVEL_BONUS )
        local integer moonDuration = NIGHT_DURATION_FIRST_LEVEL + ( level * NIGHT_DURATION_LEVEL_BONUS)
        local integer lv
        local integer lvlLow

        call PlaySpecialEffect(ANIMATION, hero)
        //call BlzSetUnitSkin( hero, WOLF_FORM )
        call SetUnitSkin( hero, WOLF_FORM )
        
        if Aspects_IsHeroAspectActive(hero, ASPECT_02) then
            call LycanthropeW_Alternative( hero, damageBonus )
        else
            call LycanthropeW_Main( hero, damageBonus )
        endif
        
        call moonst( 1 )
        call TimerStart( CreateTimer(), moonDuration, false, function MoonEnd )
        
        call TurnOn_Ability(hero, ID_Q_ABILITY, ID_Q_ABILITY_ALT, Q_NUMBER)
        call TurnOn_Ability(hero, ID_R_ABILITY, ID_R_ABILITY_ALT, R_NUMBER)
        
        set hero = null
    endfunction
    
    private function TurnOff_Ability takes unit hero, integer abilityId, integer abilityNumber returns nothing
        local integer lv = GetUnitAbilityLevel( hero, abilityId )
        local integer lvlLow = lv - 1
        local ability heroAbility = BlzGetUnitAbility(hero, abilityId)
        local string tooltip = Tooltip[abilityNumber][lv]
        local string name = Name[abilityNumber][lv]
        
        if IsUnitHasAbility( hero, abilityId) then
            call BlzSetAbilityIcon( abilityId, BlzGetAbilityStringField(heroAbility, ABILITY_SF_ICON_RESEARCH) )
            if tooltip != null then
                call BlzSetAbilityExtendedTooltip( abilityId, tooltip, lvlLow )
            endif
            if name != null then
                call BlzSetAbilityStringLevelFieldBJ( heroAbility, ABILITY_SLF_TOOLTIP_NORMAL, lvlLow, name )
            endif
        endif
    
        set heroAbility = null
        set hero = null
    endfunction
    
    private function TurnOff takes unit hero returns nothing
        local integer level = GetUnitAbilityLevel( hero, ID_ABILITY )
        
        call PlaySpecialEffect(ANIMATION, hero)
        //call BlzSetUnitSkin( hero, HUMAN_FORM )
        call SetUnitSkin( hero, HUMAN_FORM )
        
        call RemoveSavedReal( udg_hash, GetHandleId( hero ), StringHash( "lcnw" ) )
        
        call TurnOff_Ability(hero, ID_Q_ABILITY, Q_NUMBER)
        call TurnOff_Ability(hero, ID_R_ABILITY, R_NUMBER)
    
        set hero = null
    endfunction

    function Trig_LycanthropeW_Actions takes nothing returns nothing
        if GetIssuedOrderId() == OrderId("immolation") and combat(GetOrderedUnit(), false, 0) then
            call TurnOn(GetOrderedUnit())
        elseif GetIssuedOrderId() == OrderId("unimmolation") then
            call TurnOff(GetOrderedUnit())
        endif
    endfunction
    
    //When ability deleted
    private function NullingAbility_Conditions takes nothing returns boolean
        return GetUnitAbilityLevel( udg_Event_NullingAbility_Unit, ID_ABILITY) > 0
    endfunction
    
    private function NullingAbility_Ability takes unit hero, integer abilityId, integer abilityNumber returns nothing
        local integer i
        local integer lowLvl
        local ability currentAbility = BlzGetUnitAbility(hero, abilityId)
        
        call BlzSetAbilityIcon( abilityId, BlzGetAbilityStringField(currentAbility, ABILITY_SF_ICON_RESEARCH) )
        set i = 1
        loop
            exitwhen i > 5
            set lowLvl = i - 1
            if Tooltip[abilityNumber][i] != null then
                call BlzSetAbilityExtendedTooltip( abilityId, Tooltip[abilityNumber][i], lowLvl )
            endif
            if Name[abilityNumber][i] != null then
                call BlzSetAbilityStringLevelFieldBJ( currentAbility, ABILITY_SLF_TOOLTIP_NORMAL, lowLvl, Name[abilityNumber][i] )
            endif
            set i = i + 1
        endloop
    
        set hero = null
        set currentAbility = null
    endfunction
    
    private function NullingAbility takes nothing returns nothing
        local unit caster = udg_Event_NullingAbility_Unit
    
        call TurnOff(caster)
        
        call NullingAbility_Ability(caster, ID_Q_ABILITY, Q_NUMBER )
        call NullingAbility_Ability(caster, ID_R_ABILITY, R_NUMBER )
        
        set caster = null
    endfunction
    
    //When hero deal damage and has buff
    private function OnDamageChange_Conditions takes nothing returns boolean
        return GetUnitAbilityLevel( udg_DamageEventSource, WOLF_BUFF) > 0 and udg_IsDamageSpell == false
    endfunction
    
    private function OnDamageChange takes nothing returns nothing
        local real bonusDamage = LoadReal(udg_hash, GetHandleId(udg_DamageEventSource), StringHash("lcnw") ) * GetHeroAgi( udg_DamageEventSource, false)
        
        set udg_DamageEventAmount = udg_DamageEventAmount + bonusDamage
        
        if Aspects_IsHeroAspectActive(udg_DamageEventSource, ASPECT_02) then
            call healst( udg_DamageEventSource, null, ALT_VAMPIRISM)
        endif
    endfunction
    
    //When Ability Upgraded
    private function SkillUp_Conditions takes nothing returns boolean
        return GetLearnedSkill() == ID_Q_ABILITY or GetLearnedSkill() == ID_R_ABILITY
    endfunction
    
    private function SkillUp_Ability takes unit hero, integer currentAbility, integer abilityNumber returns nothing
        local integer lv = GetUnitAbilityLevel( hero, currentAbility )
        local integer lowLvl = lv - 1
    
        if IsUnitHasAbility( hero, currentAbility) then
            set Tooltip[abilityNumber][lv] = BlzGetAbilityExtendedTooltip(currentAbility, lowLvl)
            set Name[abilityNumber][lv] = BlzGetAbilityStringLevelField(BlzGetUnitAbility(hero, currentAbility), ABILITY_SLF_TOOLTIP_NORMAL, lowLvl)
        endif
    
        set hero = null
    endfunction
    
    private function SkillUp takes nothing returns nothing
        local unit u = GetLearningUnit()
        
        call IssueImmediateOrderBJ( u, "unimmolation" )

        call SkillUp_Ability(u, ID_Q_ABILITY, Q_NUMBER)
        call SkillUp_Ability(u, ID_R_ABILITY, R_NUMBER)
        
        set u = null
    endfunction
    
    
    //When hero take damage, has buff and aspect
    private function OnDamageChange_Alt_Conditions takes nothing returns boolean
        if IsUnitHasAbility( udg_DamageEventTarget, WOLF_BUFF) == false then
            return false
        elseif Aspects_IsHeroAspectActive(udg_DamageEventTarget, ASPECT_02) == false then
            return false
        endif
        return true
    endfunction
    
    private function OnDamageChange_Alt takes nothing returns nothing
        set udg_DamageEventAmount = udg_DamageEventAmount - ALT_DAMAGE_REDUCE
    endfunction

    //===========================================================================
    private function init takes nothing returns nothing
        local trigger trig = CreateTrigger()
        set gg_trg_LycanthropeW = CreateTrigger(  )
        call TriggerRegisterAnyUnitEventBJ( gg_trg_LycanthropeW, EVENT_PLAYER_UNIT_ISSUED_ORDER )
        call TriggerAddCondition( gg_trg_LycanthropeW, Condition( function Trig_LycanthropeW_Conditions ) )
        call TriggerAddAction( gg_trg_LycanthropeW, function Trig_LycanthropeW_Actions )
        
        call TriggerRegisterAnyUnitEventBJ( trig, EVENT_PLAYER_HERO_SKILL )
        call TriggerAddCondition( trig, Condition( function SkillUp_Conditions ) )
        call TriggerAddAction( trig, function SkillUp )
        
        call CreateEventTrigger( "Event_OnDamageChange_Real", function OnDamageChange, function OnDamageChange_Conditions )
        call CreateEventTrigger( "udg_Event_NullingAbility_Real", function NullingAbility, function NullingAbility_Conditions )
        
        call CreateEventTrigger( "Event_OnDamageChange_Real", function OnDamageChange_Alt, function OnDamageChange_Alt_Conditions )
        
        set trig = null
    endfunction

endscope