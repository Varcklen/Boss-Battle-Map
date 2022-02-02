scope SunKingR initializer init

    globals
        private constant integer ID_ABILITY = 'A03H'
        
        private constant integer DURATION = 20
        private constant integer SPELL_POWER_BONUS_FIRST_LEVEL = 0
        private constant integer SPELL_POWER_BONUS_LEVEL_BONUS = 10
        
        private constant integer BATTLE_RESSURECT_HEALTH_PERCENT = 50
        
        private constant integer EFFECT = 'A03I'
        private constant integer BUFF = 'B08T'
        
        private constant string ANIMATION = "Abilities\\Spells\\NightElf\\Starfall\\StarfallCaster.mdl"
    endglobals

    function Trig_SunKingR_Conditions takes nothing returns boolean
        return GetSpellAbilityId() == ID_ABILITY and combat( GetSpellAbilityUnit(), true, GetSpellAbilityId() ) and not(udg_fightmod[3])
    endfunction

    function SunKingRCast takes nothing returns nothing
        local integer id = GetHandleId( GetExpiredTimer( ) )
        local unit u = LoadUnitHandle( udg_hash, id, StringHash( "snkr" ) )
        local real spellPowerBonus = LoadReal( udg_hash, GetHandleId( u ), StringHash( "snkr" ) )

        call spdst( u, -spellPowerBonus )
        if GetUnitAbilityLevel( u, EFFECT) > 0 then
            call moonst( -1 )
        endif
        call UnitRemoveAbility( u, EFFECT )
        call UnitRemoveAbility( u, BUFF )
        call RemoveSavedReal( udg_hash, GetHandleId( u ), StringHash( "snkr" ) )
        call FlushChildHashtable( udg_hash, id )
        
        set u = null
    endfunction

    function Trig_SunKingR_Actions takes nothing returns nothing
        local real spellPowerBonus
        local real rsum
        local integer lvl
        local unit caster
        local real t
        
        if CastLogic() then
            set caster = udg_Caster
            set t = udg_Time
            set lvl = udg_Level
        elseif RandomLogic() then
            set caster = udg_Caster
            call textst( udg_string[0] + GetObjectName(ID_ABILITY), caster, 64, 90, 10, 1.5 )
            set lvl = udg_Level
            set t = DURATION
        else
            set caster = GetSpellAbilityUnit()
            set lvl = GetUnitAbilityLevel(GetSpellAbilityUnit(), GetSpellAbilityId())
            set t = DURATION
        endif
        
        set t = timebonus(caster, t)
        set spellPowerBonus = SPELL_POWER_BONUS_FIRST_LEVEL + (SPELL_POWER_BONUS_LEVEL_BONUS*lvl)
        
        if IsUnitType( caster, UNIT_TYPE_HERO) then
            set rsum = LoadReal( udg_hash, GetHandleId( caster ), StringHash( "snkr" ) ) + spellPowerBonus
            call spdst( caster, spellPowerBonus )
            if GetUnitAbilityLevel( caster, EFFECT) == 0 then
                call moonst( 1 )
            endif
            call UnitAddAbility( caster, EFFECT )
            
            call coldstop( caster )
            
            call spectime( ANIMATION, GetUnitX(caster), GetUnitY(caster), t )
            
            call ResInBattle(caster, GroupPickRandomUnit(udg_DeadHero), BATTLE_RESSURECT_HEALTH_PERCENT )

            call InvokeTimerWithUnit(caster, "snkr", t, false, function SunKingRCast)
            call SaveReal( udg_hash, GetHandleId( caster ), StringHash( "snkr" ), rsum )
            
            call effst( caster, caster, null, lvl, t )
        endif
        
        set caster = null
    endfunction
    
     private function DeleteBuff_Conditions takes nothing returns boolean
        return GetUnitAbilityLevel( Event_DeleteBuff_Unit, EFFECT) > 0
    endfunction
    
    private function DeleteBuff takes nothing returns nothing
        local unit hero = Event_DeleteBuff_Unit
        local real spellPowerBonus = LoadReal( udg_hash, GetHandleId( hero ), StringHash( "snkr" ) )

        call spdst( hero, -spellPowerBonus )
        if GetUnitAbilityLevel( hero, EFFECT) > 0 then
            call moonst( -1 )
        endif
        call UnitRemoveAbility( hero, EFFECT )
        call UnitRemoveAbility( hero, BUFF )
        call RemoveSavedReal( udg_hash, GetHandleId( hero ), StringHash( "snkr" ) )
        
        set hero = null
    endfunction

    //===========================================================================
    private function init takes nothing returns nothing
        set gg_trg_SunKingR = CreateTrigger(  )
        call TriggerRegisterAnyUnitEventBJ( gg_trg_SunKingR, EVENT_PLAYER_UNIT_SPELL_EFFECT )
        call TriggerAddCondition( gg_trg_SunKingR, Condition( function Trig_SunKingR_Conditions ) )
        call TriggerAddAction( gg_trg_SunKingR, function Trig_SunKingR_Actions )
        
        call CreateEventTrigger( "Event_DeleteBuff_Real", function DeleteBuff, function DeleteBuff_Conditions )
    endfunction
endscope
