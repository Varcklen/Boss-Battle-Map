function Trig_Chaos_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A0IS' or GetSpellAbilityId() == 'A0IV' and combat( GetSpellAbilityUnit(), true, GetSpellAbilityId() ) and not( udg_fightmod[3] )
endfunction

function Trig_Chaos_Actions takes nothing returns nothing
    local unit caster
    
    if CastLogic() then
        set caster = udg_Caster
    elseif RandomLogic() then
        set caster = udg_Caster
        set udg_logic[32] = true
        call textst( udg_string[0] + GetObjectName('A0IS'), caster, 64, 90, 10, 1.5 )
    else
        set caster = GetSpellAbilityUnit()
    endif

    set udg_RandomLogic = true
    set udg_Caster = caster
    set RandomMode = true
    call TriggerExecute( udg_DB_Trigger_Spec[GetRandomInt( 1, udg_Database_NumberItems[24] )] )
    set RandomMode = false  
    
    set caster = null
endfunction

//===========================================================================
function InitTrig_Chaos takes nothing returns nothing
    set gg_trg_Chaos = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Chaos, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_Chaos, Condition( function Trig_Chaos_Conditions ) )
    call TriggerAddAction( gg_trg_Chaos, function Trig_Chaos_Actions )
endfunction

