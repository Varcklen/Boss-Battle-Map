scope ArmsmasterE initializer init

    globals
        private constant integer ID_HERO = 'N055'
        private constant integer ID_ABILITY = 'A09I'
        private constant integer ID_ARMOR_BONUS_ABILITY = 'A09J'
        private constant integer ID_ITEM_REWARD = 'I03X'
    
        private constant integer ATTACK_BONUS = 4
        
        private constant integer POSITION_TO_CREATE_ITEM_REWARD = 1
        private constant integer CHANCE_FIRST_LEVEL = 4
        private constant integer CHANCE_LEVEL_BONUS = 2
        
        private constant integer ALTERNATIVE_CHANCE_BONUS = 2
        
        private integer WeaponSum = 0
    endglobals

    function Trig_ArmsE_Conditions takes nothing returns boolean
        return GetLearnedSkill() == ID_ABILITY
    endfunction
    
    private function AddAttack takes unit hero, integer attackBonus returns nothing
        if Aspects_IsHeroAspectActive( hero, ASPECT_03 ) == false then
            call BlzSetUnitBaseDamage( hero, BlzGetUnitBaseDamage(hero, 0) + attackBonus, 0 )
        endif
        set hero = null
    endfunction

    function Trig_ArmsE_Actions takes nothing returns nothing
        local unit hero = GetLearningUnit()
        local integer index = GetUnitUserData(hero)
        local integer bonus = ATTACK_BONUS*udg_Set_Weapon_Number[index]
        local integer level = GetUnitAbilityLevel( hero, ID_ABILITY)

        call UnitAddAbility( hero, ID_ARMOR_BONUS_ABILITY)
        call SetUnitAbilityLevel(hero, ID_ARMOR_BONUS_ABILITY, level )
        if level == 1 then
            //call BlzSetUnitBaseDamage( hero, BlzGetUnitBaseDamage(hero, 0) + bonus, 0 )
            call AddAttack(hero, bonus)
            set WeaponSum = bonus
        endif
        
        set hero = null
    endfunction
    
    //Ability Removed
    private function NullingAbility_Conditions takes nothing returns boolean
        return GetUnitAbilityLevel( udg_Event_NullingAbility_Unit, ID_ABILITY) > 0
    endfunction
    
    private function NullingAbility takes nothing returns nothing
        call UnitRemoveAbility( udg_Event_NullingAbility_Unit, ID_ARMOR_BONUS_ABILITY)
        //call BlzSetUnitBaseDamage( udg_Event_NullingAbility_Unit, BlzGetUnitBaseDamage(udg_Event_NullingAbility_Unit, 0) - WeaponSum, 0 )
        call AddAttack(udg_Event_NullingAbility_Unit, -WeaponSum)
        set WeaponSum = 0
    endfunction
    
    //Add Weapon
    private function UnitAddWeapon_Conditions takes nothing returns boolean
        return GetUnitAbilityLevel( Event_UnitAddWeapon_Hero, ID_ABILITY) > 0
    endfunction
    
    private function UnitAddWeapon takes nothing returns nothing
        //call BlzSetUnitBaseDamage( Event_UnitAddWeapon_Hero, BlzGetUnitBaseDamage(Event_UnitAddWeapon_Hero, 0) + ATTACK_BONUS, 0 )
        call AddAttack(Event_UnitAddWeapon_Hero, ATTACK_BONUS)
        set WeaponSum = WeaponSum + ATTACK_BONUS
    endfunction

    //Lose Weapon
    private function UnitLoseWeapon_Conditions takes nothing returns boolean
        return GetUnitAbilityLevel( Event_UnitLoseWeapon_Hero, ID_ABILITY) > 0
    endfunction
    
    private function UnitLoseWeapon takes nothing returns nothing
        set WeaponSum = WeaponSum - ATTACK_BONUS
        //call BlzSetUnitBaseDamage( Event_UnitLoseWeapon_Hero, BlzGetUnitBaseDamage(Event_UnitLoseWeapon_Hero, 0) - ATTACK_BONUS, 0 )
        call AddAttack(Event_UnitLoseWeapon_Hero, -ATTACK_BONUS)
    endfunction

    //Add Ultimate Weapon
    private function UnitAddUltimateWeapon_Conditions takes nothing returns boolean
        return GetUnitAbilityLevel( Event_UnitAddUltimateWeapon_Hero, ID_ABILITY) > 0
    endfunction
    
    private function UnitAddUltimateWeapon takes nothing returns nothing
        //call BlzSetUnitBaseDamage( Event_UnitAddUltimateWeapon_Hero, BlzGetUnitBaseDamage(Event_UnitAddUltimateWeapon_Hero, 0) + WeaponSum, 0 )
        call AddAttack(Event_UnitAddUltimateWeapon_Hero, WeaponSum )
    endfunction

    //Lose Ultimate Weapon
    private function UnitLoseUltimateWeapon_Conditions takes nothing returns boolean
        return GetUnitAbilityLevel( Event_UnitLoseUltimateWeapon_Hero, ID_ABILITY) > 0
    endfunction
    
    private function UnitLoseUltimateWeapon takes nothing returns nothing
        //call BlzSetUnitBaseDamage( Event_UnitLoseUltimateWeapon_Hero, BlzGetUnitBaseDamage(Event_UnitLoseUltimateWeapon_Hero, 0) - WeaponSum, 0 )
        call AddAttack(Event_UnitLoseUltimateWeapon_Hero, -WeaponSum )
    endfunction
    
    //Create Weapon Gift
    private function ItemRewardCreate_Conditions takes nothing returns boolean
        return GetUnitAbilityLevel( Event_ItemRewardCreate_Hero, ID_ABILITY) > 0 and ItemCreate_ItemPosition(Event_ItemRewardCreate_Position, POSITION_TO_CREATE_ITEM_REWARD)
    endfunction
    
    private function Main takes unit hero, integer chance returns nothing 
        if LuckChance( hero, chance ) then
            set Event_ItemRewardCreate_ItemReward = ID_ITEM_REWARD
        endif
        set hero = null
    endfunction
    
    private function Alternative takes unit hero, integer chance returns nothing
        if IsItemsRefreshed == false then
            //call BJDebugMsg("Atlernative bonus works!")
            set chance = chance * ALTERNATIVE_CHANCE_BONUS
        endif
        call Main( hero, chance )
        set hero = null
    endfunction
    
    private function ItemRewardCreate takes nothing returns nothing
        local unit hero = Event_ItemRewardCreate_Hero
        local integer level = GetUnitAbilityLevel( hero, ID_ABILITY)
        local integer chance = CHANCE_FIRST_LEVEL+(CHANCE_LEVEL_BONUS*level)

        if Aspects_IsHeroAspectActive( hero, ASPECT_03 ) then
            call Alternative( hero, chance )
        else
            call Main( hero, chance )
        endif
        
        set hero = null
    endfunction
    
    //Aspect Added
    private function AspectAdded_Conditions takes nothing returns boolean
        return GetUnitTypeId(Event_AspectAdded_Hero) == ID_HERO and Event_AspectAdded_Key02 == 3
    endfunction
    
    private function AspectAdded takes nothing returns nothing
        call BlzSetUnitBaseDamage( Event_AspectAdded_Hero, BlzGetUnitBaseDamage(Event_AspectAdded_Hero, 0) - WeaponSum, 0 )
    endfunction
    
    //Aspect Removed
    private function AspectRemoved_Conditions takes nothing returns boolean
        return GetUnitTypeId(Event_AspectRemoved_Hero) == ID_HERO and Event_AspectAdded_Key02 == 3
    endfunction
    
    private function AspectRemoved takes nothing returns nothing
        call BlzSetUnitBaseDamage( Event_AspectRemoved_Hero, BlzGetUnitBaseDamage(Event_AspectRemoved_Hero, 0) + WeaponSum, 0 )
    endfunction

    //===========================================================================
    private function init takes nothing returns nothing
        set gg_trg_ArmsE = CreateTrigger(  )
        call TriggerRegisterAnyUnitEventBJ( gg_trg_ArmsE, EVENT_PLAYER_HERO_SKILL )
        call TriggerAddCondition( gg_trg_ArmsE, Condition( function Trig_ArmsE_Conditions ) )
        call TriggerAddAction( gg_trg_ArmsE, function Trig_ArmsE_Actions )
        
        call CreateEventTrigger( "Event_UnitAddWeapon_Real", function UnitAddWeapon, function UnitAddWeapon_Conditions )
        call CreateEventTrigger( "Event_UnitLoseWeapon_Real", function UnitLoseWeapon, function UnitLoseWeapon_Conditions )
        call CreateEventTrigger( "Event_UnitAddUltimateWeapon_Real", function UnitAddUltimateWeapon, function UnitAddUltimateWeapon_Conditions )
        call CreateEventTrigger( "Event_UnitLoseUltimateWeapon_Real", function UnitLoseUltimateWeapon, function UnitLoseUltimateWeapon_Conditions )
        
        call CreateEventTrigger( "udg_Event_NullingAbility_Real", function NullingAbility, function NullingAbility_Conditions )
        call CreateEventTrigger( "Event_ItemRewardCreate_Real", function ItemRewardCreate, function ItemRewardCreate_Conditions )
        
        call CreateEventTrigger( "Event_AspectAdded_Real", function AspectAdded, function AspectAdded_Conditions )
        call CreateEventTrigger( "Event_AspectRemoved_Real", function AspectRemoved, function AspectRemoved_Conditions )
    endfunction

endscope