scope SoulMarry

    globals
        private constant integer ID_SOULMARRY_ABILITY = 'AZ01'
    endglobals

    function Trig_SoulMarry_Conditions takes nothing returns boolean
        return GetSpellAbilityId() == ID_SOULMARRY_ABILITY and combat( GetSpellAbilityUnit(), true, GetSpellAbilityId() ) and not(udg_fightmod[3])
    endfunction

    function Trig_SoulMarry_Actions takes nothing returns nothing
        local unit caster
        
        if CastLogic() then
            set caster = udg_Caster
        elseif RandomLogic() then
            set caster = udg_Caster
            call textst( udg_string[0] + GetObjectName(ID_SOULMARRY_ABILITY), caster, 64, 90, 10, 1.5 )
        else
            set caster = GetSpellAbilityUnit()
        endif
        call heroswap()
        call shield(caster, caster, 100*(udg_Heroes_Amount-CountUnitsInGroup(udg_DeadHero)), 60)
        set caster = null
    endfunction

    //===========================================================================
    function InitTrig_SoulMarry takes nothing returns nothing
        set gg_trg_SoulMarry = CreateTrigger(  )
        call TriggerRegisterAnyUnitEventBJ( gg_trg_SoulMarry, EVENT_PLAYER_UNIT_SPELL_EFFECT )
        call TriggerAddCondition( gg_trg_SoulMarry, Condition( function Trig_SoulMarry_Conditions ) )
        call TriggerAddAction( gg_trg_SoulMarry, function Trig_SoulMarry_Actions )
    endfunction

endscope
