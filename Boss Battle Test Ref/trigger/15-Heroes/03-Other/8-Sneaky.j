function Trig_Sneaky_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A0C8'
endfunction

function Trig_Sneaky_Actions takes nothing returns nothing
    local unit caster
    local unit target
    local integer id 
    
    if CastLogic() then
        set caster = udg_Caster
        set target = udg_Target
    elseif RandomLogic() then
        set caster = udg_Caster
        set target = randomtarget( caster, 900, "ally", "", "", "", "" )
        call textst( udg_string[0] + GetObjectName('A0C8'), caster, 64, 90, 10, 1.5 )
        if target == null then
            set caster = null
            return
        endif
    else
        set caster = GetSpellAbilityUnit()
        set target = GetSpellTargetUnit()
    endif
    
    call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\Human\\Invisibility\\InvisibilityTarget.mdl", GetUnitX( target ), GetUnitY( target ) ) )
    
    call dummyspawn( caster, 1, 'A0CQ', 0, 0 )
    call shadowst( target )
    call IssueTargetOrder( bj_lastCreatedUnit, "invisibility", target )
    
    if BuffLogic() then
        call effst( caster, target, "Trig_Sneaky_Actions", 1, 10 )
    endif
    
    set caster = null
    set target = null
endfunction

//===========================================================================
function InitTrig_Sneaky takes nothing returns nothing
    set gg_trg_Sneaky = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Sneaky, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_Sneaky, Condition( function Trig_Sneaky_Conditions ) )
    call TriggerAddAction( gg_trg_Sneaky, function Trig_Sneaky_Actions )
endfunction
