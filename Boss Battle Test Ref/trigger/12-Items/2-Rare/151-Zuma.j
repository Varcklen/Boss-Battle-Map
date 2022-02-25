scope Zuma initializer init
    globals
        private constant integer ZUMA_DAMAGE = 300
        private constant integer ZUMA_BONUS_DAMAGE = 100
        
        private constant integer ID_ZUMA_ITEM = 'I0GR'
        private constant integer ID_ZUMA_ABILITY = 'A12E'
        
        private integer array Zuma_Damage[PLAYERS_LIMIT_ARRAYS]
    endglobals

    private function Conditions takes nothing returns boolean
        return GetSpellAbilityId() == ID_ZUMA_ABILITY
    endfunction

    private function Use takes unit caster, unit target, real damage returns nothing
        local integer index = GetUnitUserData(caster)
        local item it = GetItemOfTypeFromUnitBJ( caster, ID_ZUMA_ITEM)
    
        call DestroyEffect( AddSpecialEffect( "Blink Blue Target.mdx", GetUnitX(target), GetUnitY(target) ) )
        call UnitTakeDamage(caster, target, damage, DAMAGE_TYPE_MAGIC)
        
        if combat(caster, false, 0) then
            set Zuma_Damage[index] = Zuma_Damage[index] + ZUMA_BONUS_DAMAGE
            call BlzSetItemIconPath( it, words( caster, BlzGetItemExtendedTooltip(it), "|cffbe81f7", "|r", I2S( ZUMA_DAMAGE + Zuma_Damage[index] ) ) )
        endif
        
        set caster = null
        set target = null
        set it = null
    endfunction

    private function Actions takes nothing returns nothing
        local unit caster
        local unit target
        local integer cyclA = 1
        local integer cyclAEnd 
        local real damage
        
        if CastLogic() then
            set caster = udg_Caster
            set target = udg_Target
        elseif RandomLogic() then
            set caster = udg_Caster
            set target = randomtarget( caster, 900, "all", "", "", "", "" )
            call textst( udg_string[0] + GetObjectName(ID_ZUMA_ABILITY), caster, 64, 90, 10, 1.5 )
            if target == null then
                set caster = null
                return
            endif
        else
            set caster = GetSpellAbilityUnit()
            set target = GetSpellTargetUnit()
        endif
        
        set damage = ZUMA_DAMAGE + Zuma_Damage[GetUnitUserData(caster)]
        
        set cyclAEnd = eyest( caster )
        loop
            exitwhen cyclA > cyclAEnd
            call Use(caster, target, damage)
            set cyclA = cyclA + 1
        endloop
        
        set caster = null
        set target = null
    endfunction
    
    private function FightEnd_Conditions takes nothing returns boolean
        return Zuma_Damage[GetUnitUserData(udg_FightEnd_Unit)] > 0
    endfunction
    
    private function FightEnd takes nothing returns nothing
        local unit hero = udg_FightEnd_Unit
        local item it = GetItemOfTypeFromUnitBJ( hero, ID_ZUMA_ITEM)
        local integer index = GetUnitUserData(hero)

        set Zuma_Damage[index] = 0
        if it != null then
            call BlzSetItemIconPath( it, words( hero, BlzGetItemDescription(it), "|cffbe81f7", "|r", I2S( ZUMA_DAMAGE + Zuma_Damage[index] ) ) )
        endif
        
        set it = null
        set hero = null
    endfunction

    private function init takes nothing returns nothing
        set gg_trg_Zuma = CreateTrigger(  )
        call TriggerRegisterAnyUnitEventBJ( gg_trg_Zuma, EVENT_PLAYER_UNIT_SPELL_EFFECT )
        call TriggerAddCondition( gg_trg_Zuma, Condition( function Conditions ) )
        call TriggerAddAction( gg_trg_Zuma, function Actions )
        
        call CreateEventTrigger( "udg_FightEnd_Real", function FightEnd, function FightEnd_Conditions )
    endfunction
endscope