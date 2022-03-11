function Trig_MinW_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A0DW'
endfunction

function Trig_MinW_Actions takes nothing returns nothing
    local real r 
    local integer lvl
    local unit caster
    
    if CastLogic() then
        set caster = udg_Caster
        set lvl = udg_Level
    elseif RandomLogic() then
        set caster = udg_Caster
        set lvl = udg_Level
        call textst( udg_string[0] + GetObjectName('A0DW'), caster, 64, 90, 10, 1.5 )
    else
        set caster = GetSpellAbilityUnit()
        set lvl = GetUnitAbilityLevel(GetSpellAbilityUnit(), GetSpellAbilityId())
    endif    
    set r = GetUnitState( caster, UNIT_STATE_MANA ) / 2
    call healst( caster, null, r * ( 1 + lvl ) )
    call spectimeunit( caster, "Abilities\\Spells\\Orc\\AncestralSpirit\\AncestralSpiritCaster.mdl", "origin", 1.5 ) 
    call SetUnitState( caster, UNIT_STATE_MANA, RMaxBJ(0,GetUnitState( caster, UNIT_STATE_MANA) - r ) )
    
    set caster = null
endfunction

//===========================================================================
function InitTrig_MinW takes nothing returns nothing
    set gg_trg_MinW = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_MinW, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_MinW, Condition( function Trig_MinW_Conditions ) )
    call TriggerAddAction( gg_trg_MinW, function Trig_MinW_Actions )
endfunction

