function Trig_Dushvorot_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A0OO'
endfunction

function Trig_Dushvorot_Actions takes nothing returns nothing
    local unit caster
    local integer cyclA = 1
    local integer cyclAEnd 
    local real mp
    local real hp
    
    if CastLogic() then
        set caster = udg_Caster
    elseif RandomLogic() then
        set caster = udg_Caster
        call textst( udg_string[0] + GetObjectName('A0OO'), caster, 64, 90, 10, 1.5 )
    else
        set caster = GetSpellAbilityUnit()
    endif

    set cyclAEnd = eyest( caster )
    call DestroyEffect( AddSpecialEffectTarget("Abilities\\Spells\\Human\\MarkOfChaos\\MarkOfChaosTarget.mdl", caster, "origin" ) )
    loop
        exitwhen cyclA > cyclAEnd
        set hp = GetUnitState( caster, UNIT_STATE_LIFE) / RMaxBJ(0,GetUnitState( caster, UNIT_STATE_MAX_LIFE))
        set mp = GetUnitState( caster, UNIT_STATE_MANA) / RMaxBJ(0,GetUnitState( caster, UNIT_STATE_MAX_MANA))
        call SetUnitState( caster, UNIT_STATE_LIFE, GetUnitState(caster, UNIT_STATE_MAX_LIFE) * mp)
        call SetUnitState( caster, UNIT_STATE_MANA, GetUnitState(caster, UNIT_STATE_MAX_MANA) * hp)
        set cyclA = cyclA + 1
    endloop

    set caster = null
endfunction

//===========================================================================
function InitTrig_Dushvorot takes nothing returns nothing
    set gg_trg_Dushvorot = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Dushvorot, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_Dushvorot, Condition( function Trig_Dushvorot_Conditions ) )
    call TriggerAddAction( gg_trg_Dushvorot, function Trig_Dushvorot_Actions )
endfunction

