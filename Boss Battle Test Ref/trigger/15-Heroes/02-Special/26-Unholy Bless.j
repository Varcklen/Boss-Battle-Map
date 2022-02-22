scope UnholyBless

    globals
        private constant integer ID_ABILITY = 'A12G'
        
        private constant integer HEAL_TO_CHECK = 20
        private constant integer COOLDOWN_BONUS = 1
        private constant real PERCENT_RESTORED = 0.5
        
        
        private constant string ANIMATION = "EarthDetonation.mdx"
    endglobals

    function Trig_Unholy_Bless_Conditions takes nothing returns boolean
        return GetSpellAbilityId() == ID_ABILITY
    endfunction
    
    private function AddDuration takes nothing returns nothing
        local integer id = GetHandleId( GetExpiredTimer() )
        local unit u = LoadUnitHandle( udg_hash, id, StringHash( "unbs" ) )
        local real extraTime = LoadReal( udg_hash, id, StringHash( "unbs" ))
        
        if GetUnitAbilityLevel( u, ID_ABILITY) > 0 and extraTime > 0 then
            call BlzStartUnitAbilityCooldown( u, ID_ABILITY, BlzGetUnitAbilityCooldownRemaining(u, ID_ABILITY) + extraTime )
        endif
        call FlushChildHashtable( udg_hash, id )
    
        set u = null
    endfunction

    function Trig_Unholy_Bless_Actions takes nothing returns nothing
        local unit caster
        local unit target
        local real heal
        local real healed
        local real extraTime = 0
        local integer id
        
        if CastLogic() then
            set caster = udg_Caster
            set target = udg_Target
        elseif RandomLogic() then
            set caster = udg_Caster
            set target = randomtarget( caster, 900, "ally", "notfull", "", "", "" )
            call textst( udg_string[0] + GetObjectName(ID_ABILITY), caster, 64, 90, 10, 1.5 )
            if target == null then
                set caster = null
                return
            endif
        else
            set caster = GetSpellAbilityUnit()
            set target = GetSpellTargetUnit()
        endif
        
        set healed = PERCENT_RESTORED * GetUnitState(target, UNIT_STATE_MAX_LIFE)
        
        if GetUnitState(target, UNIT_STATE_LIFE) + healed >= GetUnitState(target, UNIT_STATE_MAX_LIFE) then
            set heal = RMaxBJ(0, GetUnitState(target, UNIT_STATE_MAX_LIFE) - GetUnitState(target, UNIT_STATE_LIFE)) 
        else
            set heal = healed
        endif
        
        call healst( caster, target, heal )
        call DestroyEffect( AddSpecialEffectTarget( ANIMATION, target, "origin" ) )
        
        set extraTime = COOLDOWN_BONUS * R2I(heal/HEAL_TO_CHECK)
        
        set id = InvokeTimerWithUnit(caster, "unbs", 0.01, false, function AddDuration )
        call SaveReal( udg_hash, id, StringHash( "unbs" ), extraTime )
        
        set caster = null
        set target = null
    endfunction

    //===========================================================================
    function InitTrig_Unholy_Bless takes nothing returns nothing
        set gg_trg_Unholy_Bless = CreateTrigger(  )
        call TriggerRegisterAnyUnitEventBJ( gg_trg_Unholy_Bless, EVENT_PLAYER_UNIT_SPELL_EFFECT )
        call TriggerAddCondition( gg_trg_Unholy_Bless, Condition( function Trig_Unholy_Bless_Conditions ) )
        call TriggerAddAction( gg_trg_Unholy_Bless, function Trig_Unholy_Bless_Actions )
    endfunction

endscope

