function Trig_PrismGreen_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A04D'
endfunction

function Trig_PrismGreen_Actions takes nothing returns nothing
    local integer cyclA = 1
    local integer cyclAEnd 
    local integer cyclB
    local unit caster
    
    if CastLogic() then
        set caster = udg_Caster
    elseif RandomLogic() then
        set caster = udg_Caster
        call textst( udg_string[0] + GetObjectName('A04D'), caster, 64, 90, 10, 1.5 )
    else
        set caster = GetSpellAbilityUnit()
    endif
    
    set cyclAEnd = eyest( caster )
    call AddSpecialEffectTarget("Abilities\\Spells\\Human\\Resurrect\\ResurrectTarget.mdl", caster, "origin")
    loop
        exitwhen cyclA > cyclAEnd
        call healst( caster, null, 300 )
        set cyclA = cyclA + 1
    endloop
    
    set caster = null
endfunction

//===========================================================================
function InitTrig_PrismGreen takes nothing returns nothing
    set gg_trg_PrismGreen = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_PrismGreen, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_PrismGreen, Condition( function Trig_PrismGreen_Conditions ) )
    call TriggerAddAction( gg_trg_PrismGreen, function Trig_PrismGreen_Actions )
endfunction

