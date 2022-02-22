scope MentorE initializer init

    globals
        private constant integer ID_ABILITY = 'A0NS'
        private constant integer MANA_CASTER_FIRST_LEVEL = 0
        private constant integer MANA_CASTER_LEVEL_BONUS = 2
        private constant integer MANA_ALLIES_FIRST_LEVEL = 1
        private constant integer MANA_ALLIES_LEVEL_BONUS = 1
        
        private constant string ANIMATION = "Abilities\\Spells\\Undead\\ReplenishMana\\ReplenishManaCaster.mdl"
    endglobals

    private function Trig_MentorE_Conditions takes nothing returns boolean
        return udg_IsDamageSpell == false and GetUnitAbilityLevel(udg_DamageEventSource, ID_ABILITY) > 0 and IsUnitEnemy(udg_DamageEventSource, GetOwningPlayer(udg_DamageEventTarget))
    endfunction
    
    private function Caster takes unit caster, integer level returns nothing
        local real r = MANA_CASTER_FIRST_LEVEL + (MANA_CASTER_LEVEL_BONUS * level)
    
        call manast( caster, null, r )
        call spectimeunit( caster, ANIMATION, "origin", 2 )
        
        set caster = null
    endfunction
    
    private function IsCount takes unit caster, unit target returns boolean
        local boolean isWork = true
    
        if IsUnitDead(target) then
            set isWork = false
        elseif caster == target then
            set isWork = false
        elseif IsUnitEnemy(caster, GetOwningPlayer(target)) then
            set isWork = false
        elseif target == udg_unit[57] then
            set isWork = false
        elseif target == udg_unit[58] then
            set isWork = false
        endif
        set caster = null
        set target = null
        return isWork
    endfunction
    
    private function Allies takes unit caster, integer level returns nothing
        local real r = MANA_ALLIES_FIRST_LEVEL + (MANA_ALLIES_LEVEL_BONUS * level)
        local integer i = 1
    
        loop
            exitwhen i > PLAYERS_LIMIT
            if IsCount(caster, udg_hero[i]) then
                call manast( caster, udg_hero[i], r )
                call spectimeunit( udg_hero[i], ANIMATION, "origin", 2 )
            endif
            set i = i + 1
        endloop
        
        set caster = null
    endfunction

    private function Trig_MentorE_Actions takes nothing returns nothing
        local integer level = GetUnitAbilityLevel( udg_DamageEventSource, ID_ABILITY)
        if IsUnitManaIsFull(udg_DamageEventSource) then
            call Allies(udg_DamageEventSource, level)
        else
            call Caster(udg_DamageEventSource, level)
        endif
    endfunction

    //===========================================================================
    private function init takes nothing returns nothing
         call CreateEventTrigger( "udg_AfterDamageEvent", function Trig_MentorE_Actions, function Trig_MentorE_Conditions )
    endfunction

endscope