scope WandererE initializer init

    globals
        private constant integer ID_ABILITY = 'A0LD'
        
        private constant integer EFFECT = 'A0LE'
        private constant integer BUFF = 'B01W'
        
        private constant integer SPELL_POWER_BONUS = 3
        
        private constant integer DURATION_FIRST_LEVEL = 1
        private constant integer DURATION_LEVEL_BONUS = 2
        
        private constant real HEAL_PERCENT_FIRST_LEVEL = 0.01
        private constant real HEAL_PERCENT_LEVEL_BONUS = 0.01
        
        private constant integer ALTERNATIVE02_SPELL_POWER_BONUS = -1
        private constant integer ALTERNATIVE02_DURATION_BONUS = 4
        
        private constant integer ALTERNATIVE03_HEAL_PERCENT_BONUS = 2
        
        private constant string ANIMATION = "DarkSwirl.mdx"
    endglobals

    function Trig_WandererE_Conditions takes nothing returns boolean
        return GetUnitAbilityLevel(GetSpellAbilityUnit(), ID_ABILITY) > 0 and combat( GetSpellAbilityUnit(), false, 0 ) and IsUnitType( GetSpellAbilityUnit(), UNIT_TYPE_HERO)
    endfunction

    private function EndBuff takes nothing returns nothing
        local integer id = GetHandleId( GetExpiredTimer( ) )
        local integer p = LoadInteger( udg_hash, id, StringHash( "wnde" ) )
        local unit hero = LoadUnitHandle( udg_hash, id, StringHash( "wnde" ) )
        local integer heroId = GetHandleId( hero )
        local real spellPower = LoadReal( udg_hash, heroId, StringHash( "wnde" ) )

        call spdst(hero, -spellPower)
        call UnitRemoveAbility( hero, EFFECT )
        call UnitRemoveAbility( hero, BUFF )
        call RemoveSavedReal( udg_hash, heroId, StringHash( "wnde" ) )
        
        call FlushChildHashtable( udg_hash, id )
        
        set hero = null
    endfunction

    private function Alternative01 takes unit caster, real duration, real healPercent returns nothing 
        local integer id
        local integer casterId = GetHandleId( caster )
        local integer addSpellPower = SPELL_POWER_BONUS
        local integer i
        local real isum
        
        set duration = timebonus(caster, duration)
        
        call UnitAddAbility( caster, EFFECT)
        call spdst( caster, addSpellPower )
        set isum = LoadReal( udg_hash, casterId, StringHash( "wnde" ) ) + addSpellPower
        
        set id = InvokeTimerWithUnit(caster, "wnde", duration, false, function EndBuff)
        call SaveReal( udg_hash, GetHandleId( caster ), StringHash( "wnde" ), isum )
        call effst( caster, caster, null, 1, 1 )
        
        call healst( caster, caster, GetUnitState( caster, UNIT_STATE_MAX_LIFE) * healPercent )
        call manast( caster, caster, GetUnitState( caster, UNIT_STATE_MAX_MANA) * healPercent )
        
        set caster = null
    endfunction

    private function Alternative02 takes unit caster, real duration, real healPercent returns nothing 
        local integer id
        local integer casterId = GetHandleId( caster )
        local integer addSpellPower = SPELL_POWER_BONUS + ALTERNATIVE02_SPELL_POWER_BONUS
        local integer i
        local real isum
        
        set duration = duration + ALTERNATIVE02_DURATION_BONUS
        set duration = timebonus(caster, duration)
        
        call UnitAddAbility( caster, EFFECT)
        call spdst( caster, addSpellPower )
        set isum = LoadReal( udg_hash, casterId, StringHash( "wnde" ) ) + addSpellPower
        
        set id = InvokeTimerWithUnit(caster, "wnde", duration, false, function EndBuff)
        call SaveReal( udg_hash, GetHandleId( caster ), StringHash( "wnde" ), isum )
        call effst( caster, caster, null, 1, 1 )
        
        set i = 1
        loop
            exitwhen i > PLAYERS_LIMIT
            if udg_hero[i] != caster and unitst( udg_hero[i], caster, TARGET_ALLY ) then
                call healst( caster, udg_hero[i], GetUnitState( udg_hero[i], UNIT_STATE_MAX_LIFE) * healPercent )
                call manast( caster, udg_hero[i], GetUnitState( udg_hero[i], UNIT_STATE_MAX_MANA) * healPercent )
            endif
            set i = i + 1
        endloop
        
        set caster = null
    endfunction

    private function Alternative03 takes unit caster, real healPercent returns nothing 
        local integer i
        
        set healPercent = healPercent * ALTERNATIVE03_HEAL_PERCENT_BONUS
        set i = 1
        loop
            exitwhen i > PLAYERS_LIMIT
            if udg_hero[i] != caster and unitst( udg_hero[i], caster, TARGET_ALLY ) then
                call healst( caster, udg_hero[i], GetUnitState( udg_hero[i], UNIT_STATE_MAX_LIFE) * healPercent )
                call manast( caster, udg_hero[i], GetUnitState( udg_hero[i], UNIT_STATE_MAX_MANA) * healPercent )
            endif
            set i = i + 1
        endloop
        
        set caster = null
    endfunction
    
    private function Main takes unit caster, real duration, real healPercent returns nothing 
        local integer id
        local integer casterId = GetHandleId( caster )
        local integer addSpellPower = SPELL_POWER_BONUS
        local integer i
        local real isum
        
        set duration = timebonus(caster, duration)
        
        call UnitAddAbility( caster, EFFECT)
        call spdst( caster, addSpellPower )
        set isum = LoadReal( udg_hash, casterId, StringHash( "wnde" ) ) + addSpellPower
        
        set id = InvokeTimerWithUnit(caster, "wnde", duration, false, function EndBuff)
        call SaveReal( udg_hash, GetHandleId( caster ), StringHash( "wnde" ), isum )
        call effst( caster, caster, null, 1, 1 )
        
        set i = 1
        loop
            exitwhen i > PLAYERS_LIMIT
            if udg_hero[i] != caster and unitst( udg_hero[i], caster, TARGET_ALLY ) then
                call healst( caster, udg_hero[i], GetUnitState( udg_hero[i], UNIT_STATE_MAX_LIFE) * healPercent )
                call manast( caster, udg_hero[i], GetUnitState( udg_hero[i], UNIT_STATE_MAX_MANA) * healPercent )
            endif
            set i = i + 1
        endloop
        
        set caster = null
    endfunction

    function Trig_WandererE_Actions takes nothing returns nothing
        local unit caster = GetSpellAbilityUnit()
        local integer lvl = GetUnitAbilityLevel(caster, 'A0LD')
        local real duration = DURATION_FIRST_LEVEL + (DURATION_LEVEL_BONUS*lvl)
        local real healPecrent = HEAL_PERCENT_FIRST_LEVEL+(HEAL_PERCENT_LEVEL_BONUS*lvl)
        
        if Aspects_IsHeroAspectActive( caster, ASPECT_01 ) then
            call Alternative01( caster, duration, healPecrent )
        elseif Aspects_IsHeroAspectActive( caster, ASPECT_02 ) then
            call Alternative02( caster, duration, healPecrent )
        elseif Aspects_IsHeroAspectActive( caster, ASPECT_03 ) then
            call Alternative03( caster, healPecrent )
        else
            call Main( caster, duration, healPecrent )
        endif
        
        call DestroyEffect(AddSpecialEffectTarget(ANIMATION, caster, "overhead") )
        
        set caster = null
    endfunction

    private function DeleteBuff_Conditions takes nothing returns boolean
        return GetUnitAbilityLevel( Event_DeleteBuff_Unit, EFFECT) > 0
    endfunction
    
    private function DeleteBuff takes nothing returns nothing
        local unit hero = Event_DeleteBuff_Unit
        local integer heroId = GetHandleId( hero )
        local real spellPower = LoadReal( udg_hash, heroId, StringHash( "wnde" ) )

        call spdst(hero, -spellPower)
        call UnitRemoveAbility( hero, EFFECT )
        call UnitRemoveAbility( hero, BUFF )
        call RemoveSavedReal( udg_hash, heroId, StringHash( "wnde" ) )
        
        set hero = null
    endfunction

    //===========================================================================
    private function init takes nothing returns nothing
        set gg_trg_WandererE = CreateTrigger(  )
        call TriggerRegisterAnyUnitEventBJ( gg_trg_WandererE, EVENT_PLAYER_UNIT_SPELL_EFFECT )
        call TriggerAddCondition( gg_trg_WandererE, Condition( function Trig_WandererE_Conditions ) )
        call TriggerAddAction( gg_trg_WandererE, function Trig_WandererE_Actions )
        
        call CreateEventTrigger( "Event_DeleteBuff_Real", function DeleteBuff, function DeleteBuff_Conditions )
    endfunction

endscope

