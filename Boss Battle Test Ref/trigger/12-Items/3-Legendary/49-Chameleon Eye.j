scope ChameleonEye initializer init

    globals
        private constant integer ID_ITEM = 'I0FI'
    
        private constant string ANIMATION = "Abilities\\Spells\\Human\\MarkOfChaos\\MarkOfChaosDone.mdl"
    endglobals

    function Trig_Chameleon_Eye_Conditions takes nothing returns boolean
        return IsHeroHasItem( GetSpellAbilityUnit(), ID_ITEM ) and combat( GetSpellAbilityUnit(), false, 0 ) and Uniques_Logic(GetSpellAbilityId())
    endfunction
    
    private function Replace takes nothing returns nothing
        local integer id = GetHandleId( GetExpiredTimer() )
        local unit hero = LoadUnitHandle( udg_hash, id, StringHash( "chml" ) )
        local real time = BlzGetUnitAbilityCooldownRemaining( hero, udg_Ability_Uniq[GetUnitUserData(hero)])
        local integer newUniq

        call PlaySpecialEffect(ANIMATION, hero )
        set newUniq = NewUniques( hero, udg_DB_Hero_SpecAbAkt[GetRandomInt( 1, udg_Database_NumberItems[24] )] )
        call BlzStartUnitAbilityCooldown( hero, newUniq, time )
        
        set hero = null
    endfunction

    function Trig_Chameleon_Eye_Actions takes nothing returns nothing
        call InvokeTimerWithUnit(GetSpellAbilityUnit(), "chml", 0.01, false, function Replace )
    endfunction

    //===========================================================================
    private function init takes nothing returns nothing
        set gg_trg_Chameleon_Eye = CreateTrigger(  )
        call TriggerRegisterAnyUnitEventBJ( gg_trg_Chameleon_Eye, EVENT_PLAYER_UNIT_SPELL_EFFECT )
        call TriggerAddCondition( gg_trg_Chameleon_Eye, Condition( function Trig_Chameleon_Eye_Conditions ) )
        call TriggerAddAction( gg_trg_Chameleon_Eye, function Trig_Chameleon_Eye_Actions )
    endfunction
endscope

