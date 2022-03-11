scope ArmsmasterQ initializer init

    globals
        private constant integer ID_ARMSMASTER_Q = 'A05Q'
        
        private constant integer ARMSMASTER_Q_DAMAGE_FIRST_LEVEL = 60
        private constant integer ARMSMASTER_Q_DAMAGE_LEVEL_BONUS = 20
        private constant integer ARMSMASTER_Q_SHIELD_FIRST_LEVEL = 60
        private constant integer ARMSMASTER_Q_SHIELD_LEVEL_BONUS = 20
        
        private constant integer ARMSMASTER_Q_SHIELD_BONUS_ALTERNATIVE = 2
        
        private constant string ARMSMASTER_Q_ANIMATION = "Abilities\\Spells\\Human\\Defend\\DefendCaster.mdl"
    endglobals

    function Trig_ArmsQ_Conditions takes nothing returns boolean
        return GetSpellAbilityId() == ID_ARMSMASTER_Q
    endfunction
    
    private function ArmsQ_Alternative takes unit caster, unit target, real sh returns nothing
        set sh = sh * ARMSMASTER_Q_SHIELD_BONUS_ALTERNATIVE
        call shield( caster, null, sh, 60 )
    
        set caster = null
        set target = null
    endfunction
    
    private function ArmsQ takes unit caster, unit target, real sh, real damage returns nothing
        call UnitTakeDamage(caster, target, damage, DAMAGE_TYPE_MAGIC)
        call shield( caster, null, sh, 60 )
    
        set caster = null
        set target = null
    endfunction

    function Trig_ArmsQ_Actions takes nothing returns nothing
        local unit caster
        local unit target
        local integer lvl
        local real dmg
        local real sh
        
        if CastLogic() then
            set caster = udg_Caster
            set target = udg_Target
            set lvl = udg_Level
        elseif RandomLogic() then
            set caster = udg_Caster
            set target = randomtarget( caster, 300, "enemy", "", "", "", "" )
            set lvl = udg_Level
            call textst( udg_string[0] + GetObjectName(ID_ARMSMASTER_Q), caster, 64, 90, 10, 1.5 )
            if target == null then
                set caster = null
                return
            endif
        else
            set caster = GetSpellAbilityUnit()
            set target = GetSpellTargetUnit()
            set lvl = GetUnitAbilityLevel(GetSpellAbilityUnit(), GetSpellAbilityId())
        endif
        set dmg = ARMSMASTER_Q_DAMAGE_FIRST_LEVEL + ( ARMSMASTER_Q_DAMAGE_LEVEL_BONUS * lvl )
        set sh = ARMSMASTER_Q_SHIELD_FIRST_LEVEL + ( ARMSMASTER_Q_SHIELD_LEVEL_BONUS * lvl )
        
        call DestroyEffect( AddSpecialEffectTarget(ARMSMASTER_Q_ANIMATION, target, "origin") )
        
        if Aspects_IsHeroAspectActive( caster, ASPECT_01 ) then
            call ArmsQ_Alternative( caster, target, sh )
        else
            call ArmsQ( caster, target, sh, dmg )
        endif
        
        set caster = null
        set target = null
    endfunction

    //===========================================================================
    private function init takes nothing returns nothing
        set gg_trg_ArmsQ = CreateTrigger(  )
        call TriggerRegisterAnyUnitEventBJ( gg_trg_ArmsQ, EVENT_PLAYER_UNIT_SPELL_EFFECT )
        call TriggerAddCondition( gg_trg_ArmsQ, Condition( function Trig_ArmsQ_Conditions ) )
        call TriggerAddAction( gg_trg_ArmsQ, function Trig_ArmsQ_Actions )
    endfunction

endscope

