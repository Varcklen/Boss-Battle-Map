function Trig_InfiniteSub_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A02H'
endfunction

function Trig_InfiniteSub_Actions takes nothing returns nothing
    local unit caster
    local integer cyclA = 1
    local integer cyclAEnd
    
    if CastLogic() then
        set caster = udg_Caster
    elseif RandomLogic() then
        set caster = udg_Caster
        call textst( udg_string[0] + GetObjectName('A02H'), caster, 64, 90, 10, 1.5 )
    else
        set caster = GetSpellAbilityUnit()
    endif
    
    set cyclAEnd = eyest( caster )
    call spectimeunit( caster, "Abilities\\Spells\\Human\\Heal\\HealTarget.mdl", "origin", 2 )
    loop
        exitwhen cyclA > cyclAEnd
        call healst( caster, null, 250 )
        set cyclA = cyclA + 1
    endloop
    
    set caster = null
endfunction

//===========================================================================
function InitTrig_InfiniteSub takes nothing returns nothing
    set gg_trg_InfiniteSub = CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ( gg_trg_InfiniteSub, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_InfiniteSub, Condition( function Trig_InfiniteSub_Conditions ) )
    call TriggerAddAction( gg_trg_InfiniteSub, function Trig_InfiniteSub_Actions )
endfunction

