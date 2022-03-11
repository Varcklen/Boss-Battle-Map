function Trig_MiracleBrewQ_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A0R1'
endfunction

function Trig_MiracleBrewQ_Actions takes nothing returns nothing
    local integer lvl
    local unit caster
    local integer rand
    
    if CastLogic() then
        set caster = udg_Caster
        set lvl = udg_Level
    elseif RandomLogic() then
        set caster = udg_Caster
        set lvl = udg_Level
        set udg_logic[32] = true
        call textst( udg_string[0] + GetObjectName('A0R1'), caster, 64, 90, 10, 1.5 )
    else
        set caster = GetSpellAbilityUnit()
        set lvl = GetUnitAbilityLevel(GetSpellAbilityUnit(), GetSpellAbilityId())
    endif
    set udg_Caster = caster
    set udg_Target = null
    set udg_RandomLogic = true
    set udg_CastLogic = false
    if lvl == 1 or lvl == 2 then
        set rand = GetRandomInt( 1, 4 )
    elseif lvl == 3 or lvl == 4 then
        set rand = GetRandomInt( 1, 8 )
    elseif lvl == 5 then
        set rand = GetRandomInt( 1, 10 )
    endif
    set RandomMode = true
    call TriggerExecute( udg_DB_Trigger_Pot[rand] )
    set RandomMode = false
    
    set caster = null
endfunction

//===========================================================================
function InitTrig_MiracleBrewQ takes nothing returns nothing
    set gg_trg_MiracleBrewQ = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_MiracleBrewQ, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_MiracleBrewQ, Condition( function Trig_MiracleBrewQ_Conditions ) )
    call TriggerAddAction( gg_trg_MiracleBrewQ, function Trig_MiracleBrewQ_Actions )
endfunction

