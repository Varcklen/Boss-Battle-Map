function Trig_ManaGive_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A14K'
endfunction

function Trig_ManaGive_Actions takes nothing returns nothing
    local unit caster
    local unit target
    local integer cyclA = 1
    local integer cyclAEnd
    local real heal
    
    if CastLogic() then
        set caster = udg_Caster
        set target = udg_Target
    elseif RandomLogic() then
        set caster = udg_Caster
        set target = randomtarget( caster, 900, "ally", "hero", "notcaster", "", "" )
        call textst( udg_string[0] + GetObjectName('A14K'), caster, 64, 90, 10, 1.5 )
        if target == null then
            set caster = null
            return
        endif
    else
        set caster = GetSpellAbilityUnit()
        set target = GetSpellTargetUnit()
    endif
    
    set heal = 50. + ( 25. * ( SetCount_GetPieces(caster, SET_MECH) - 1 ) )
    
    set cyclAEnd = eyest( caster )
    call DestroyEffect( AddSpecialEffectTarget( "Abilities\\Spells\\Other\\Charm\\CharmTarget.mdl", target, "origin") )
    loop
        exitwhen cyclA > cyclAEnd
        call manast( caster, target, heal )
        set cyclA = cyclA + 1
    endloop
    
    set caster = null
    set target = null
endfunction

//===========================================================================
function InitTrig_ManaGive takes nothing returns nothing
    set gg_trg_ManaGive = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_ManaGive, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_ManaGive, Condition( function Trig_ManaGive_Conditions ) )
    call TriggerAddAction( gg_trg_ManaGive, function Trig_ManaGive_Actions )
endfunction

