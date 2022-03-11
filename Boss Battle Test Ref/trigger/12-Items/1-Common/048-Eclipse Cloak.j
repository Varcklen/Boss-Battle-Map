function Trig_Eclipse_Cloak_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A0ZS'
endfunction

function Trig_Eclipse_Cloak_Actions takes nothing returns nothing
    local unit caster
    local integer cyclA = 1
    local integer cyclAEnd 
    local real mp

    if CastLogic() then
        set caster = udg_Caster
    elseif RandomLogic() then
        set caster = udg_Caster
        call textst( udg_string[0] + GetObjectName('A0ZS'), caster, 64, 90, 10, 1.5 )
    else
        set caster = GetSpellAbilityUnit()
    endif
    
    if udg_Set_Moon_Number[GetPlayerId(GetOwningPlayer(caster)) + 1] > 1 then
        set mp = GetUnitState( caster, UNIT_STATE_MAX_MANA) * 0.20
    else
        set mp = GetUnitState( caster, UNIT_STATE_MAX_MANA) * 0.10
    endif
    
    call DestroyEffect( AddSpecialEffectTarget( "Abilities\\Spells\\Items\\AIma\\AImaTarget.mdl", caster, "origin") )
    set cyclAEnd = eyest( caster )
    loop
        exitwhen cyclA > cyclAEnd
        call manast( caster, null, mp )
        set cyclA = cyclA + 1
    endloop
    
    set caster = null
endfunction

//===========================================================================
function InitTrig_Eclipse_Cloak takes nothing returns nothing
    set gg_trg_Eclipse_Cloak = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Eclipse_Cloak, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_Eclipse_Cloak, Condition( function Trig_Eclipse_Cloak_Conditions ) )
    call TriggerAddAction( gg_trg_Eclipse_Cloak, function Trig_Eclipse_Cloak_Actions )
endfunction

