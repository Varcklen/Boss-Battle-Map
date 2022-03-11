scope DealerE

    globals
        private constant integer ID_ABILITY = 'A188'
        
        private constant integer CHANCE_FIRST_LEVEL = 1
        private constant integer CHANCE_LEVEL_BONUS = 4
        
        private constant integer BANANA_SPAWN_SCATTER_ALTERNATIVE = 300
        
        private constant string ANIMATION = "war3mapImported\\TimeUpheaval.mdx"
    endglobals

    function Trig_DealerE_Conditions takes nothing returns boolean
        if IsUnitHasAbility( GetSpellAbilityUnit(), ID_ABILITY) == false then
            return false
        elseif combat(GetSpellAbilityUnit(), false, 0) == false then
            return false
        elseif LuckChance( GetSpellAbilityUnit(), CHANCE_FIRST_LEVEL+(CHANCE_LEVEL_BONUS*GetUnitAbilityLevel( GetSpellAbilityUnit(), ID_ABILITY)) ) == false then
            return false
        endif
        return true
    endfunction

    private function Alternative takes unit caster returns nothing 
        call SpawnBanana( caster, Math_GetRandomX(GetUnitX(caster), BANANA_SPAWN_SCATTER_ALTERNATIVE), Math_GetRandomY(GetUnitY(caster), BANANA_SPAWN_SCATTER_ALTERNATIVE) )
        
        set caster = null 
    endfunction
    
    private function Main takes unit caster, unit target returns nothing 
    
        call PlaySpecialEffect(ANIMATION, caster)
        set udg_CastLogic = true
        set udg_Caster = caster
        set udg_Target = target

        set udg_Level = 5
        set udg_Time = 20
        call TriggerExecute( udg_TrigNow )
        
        set caster = null 
        set target = null
    endfunction

    function Trig_DealerE_Actions takes nothing returns nothing
        local unit hero = GetSpellAbilityUnit()
        
        if Aspects_IsHeroAspectActive( hero, ASPECT_02 ) then
            call Alternative( hero )
        else
            call Main( hero, GetSpellTargetUnit() )
        endif
        
        set hero = null
    endfunction

    //===========================================================================
    function InitTrig_DealerE takes nothing returns nothing
        set gg_trg_DealerE = CreateTrigger()
        call TriggerRegisterAnyUnitEventBJ( gg_trg_DealerE, EVENT_PLAYER_UNIT_SPELL_EFFECT )
        call TriggerAddCondition( gg_trg_DealerE, Condition( function Trig_DealerE_Conditions ) )
        call TriggerAddAction( gg_trg_DealerE, function Trig_DealerE_Actions )
    endfunction

endscope