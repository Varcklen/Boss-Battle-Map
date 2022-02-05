function Trig_ChaosLordQ_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A0F9' and combat( GetSpellAbilityUnit(), true, GetSpellAbilityId() )
endfunction

function Trig_ChaosLordQ_Actions takes nothing returns nothing
    local integer lvl
    local unit caster
    
    if CastLogic() then
        set caster = udg_Caster
        set lvl = udg_Level
    elseif RandomLogic() then
        set caster = udg_Caster
        set lvl = udg_Level
        set udg_logic[32] = true
        call textst( udg_string[0] + GetObjectName('A0F9'), caster, 64, 90, 10, 1.5 )
    else
        set caster = GetSpellAbilityUnit()
        set lvl = GetUnitAbilityLevel(GetSpellAbilityUnit(), GetSpellAbilityId())
    endif
    
    /*set udg_RandomLogic = true
    set udg_Caster = caster
    set udg_Level = lvl
    set RandomMode = true
    call TriggerExecute( udg_DB_Trigger_One[GetRandomInt( 1, udg_Database_NumberItems[14])] )
    set RandomMode = false*/
    
    call CastRandomAbility(caster, lvl, udg_DB_Trigger_One[GetRandomInt( 1, udg_Database_NumberItems[14])] )
    
    set caster = null
endfunction

//===========================================================================
function InitTrig_ChaosLordQ takes nothing returns nothing
    set gg_trg_ChaosLordQ = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_ChaosLordQ, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_ChaosLordQ, Condition( function Trig_ChaosLordQ_Conditions ) )
    call TriggerAddAction( gg_trg_ChaosLordQ, function Trig_ChaosLordQ_Actions )
endfunction

