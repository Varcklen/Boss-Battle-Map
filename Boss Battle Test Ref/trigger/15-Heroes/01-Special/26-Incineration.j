scope Incineration

    globals
        private constant integer ID_INCINERATION_ABILITY = 'A12Y'
        
        private constant string INCINERATION_ANIMATION = "BarbarianSkinR.mdx"
    endglobals

    function Trig_Incineration_Conditions takes nothing returns boolean
        return GetSpellAbilityId() == ID_INCINERATION_ABILITY
    endfunction

    function Trig_Incineration_Actions takes nothing returns nothing
        local unit caster
        local unit target
        
        if CastLogic() then
            set caster = udg_Caster
            set target = udg_Target
        elseif RandomLogic() then
            set caster = udg_Caster
            set target = randomtarget( caster, 900, "all", "pris", "", "", "" )
            call textst( udg_string[0] + GetObjectName(ID_INCINERATION_ABILITY), caster, 64, 90, 10, 1.5 )
            if target == null then
                set caster = null
                return
            endif
        else
            set caster = GetSpellAbilityUnit()
            set target = GetSpellTargetUnit()
        endif
        
        call DestroyEffect( AddSpecialEffect(INCINERATION_ANIMATION, GetUnitX(target), GetUnitY(target) ) )
        call KillUnit(target)
        
        set caster = null
        set target = null
    endfunction

    //===========================================================================
    function InitTrig_Incineration takes nothing returns nothing
        set gg_trg_Incineration = CreateTrigger(  )
        call TriggerRegisterAnyUnitEventBJ( gg_trg_Incineration, EVENT_PLAYER_UNIT_SPELL_EFFECT )
        call TriggerAddCondition( gg_trg_Incineration, Condition( function Trig_Incineration_Conditions ) )
        call TriggerAddAction( gg_trg_Incineration, function Trig_Incineration_Actions )
    endfunction

endscope
