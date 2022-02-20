function Trig_Fish_Soup_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A0AH'
endfunction

function Trig_Fish_Soup_Actions takes nothing returns nothing
    local integer cyclA = 1
    local integer cyclAEnd
    local integer cyclB
    local unit caster
    
    if CastLogic() then
        set caster = udg_Caster
    elseif RandomLogic() then
        set caster = udg_Caster
        call textst( udg_string[0] + GetObjectName('A0AH'), caster, 64, 90, 10, 1.5 )
    else
        set caster = GetSpellAbilityUnit()
    endif
    
    set cyclAEnd = eyest( caster )
    
    loop
        exitwhen cyclA > cyclAEnd
        set cyclB = 1
        loop
            exitwhen cyclB > 4
            if unitst( udg_hero[cyclB], caster, "ally" ) then
                call healst( GetSpellAbilityUnit(), udg_hero[cyclB], 0.08 * GetUnitState( udg_hero[cyclB], UNIT_STATE_MAX_LIFE) )
                call spectimeunit( udg_hero[cyclB], "Abilities\\Spells\\Human\\Heal\\HealTarget.mdl", "origin", 2 )
            endif
            set cyclB = cyclB + 1
        endloop
        set cyclA = cyclA + 1
    endloop
    
    set caster = null
endfunction

//===========================================================================
function InitTrig_Fish_Soup takes nothing returns nothing
    set gg_trg_Fish_Soup = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Fish_Soup, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_Fish_Soup, Condition( function Trig_Fish_Soup_Conditions ) )
    call TriggerAddAction( gg_trg_Fish_Soup, function Trig_Fish_Soup_Actions )
endfunction

