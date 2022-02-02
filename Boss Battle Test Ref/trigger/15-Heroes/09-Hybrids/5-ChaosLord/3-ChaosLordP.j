function Trig_ChaosLordP_Conditions takes nothing returns boolean
    return udg_logic[34] and IsUnitInGroup( GetSpellAbilityUnit(), udg_heroinfo ) and udg_combatlogic[GetPlayerId( GetOwningPlayer( GetSpellAbilityUnit() ) ) + 1]
endfunction

function Trig_ChaosLordP_Actions takes nothing returns nothing
    local integer rand = GetRandomInt( 1, 3 )
    
    set udg_RandomLogic = true
    set udg_Caster = GetSpellAbilityUnit()
    set udg_Level = GetRandomInt( 1, 5 )
    if rand == 1 then
        call TriggerExecute( udg_DB_Trigger_One[GetRandomInt( 1, udg_Database_NumberItems[14])] )
    elseif rand == 2 then
        call TriggerExecute( udg_DB_Trigger_Two[GetRandomInt( 1, udg_Database_NumberItems[15])] )
    else
        call TriggerExecute( udg_DB_Trigger_Three[GetRandomInt( 1, udg_Database_NumberItems[16])] )
    endif
endfunction

//===========================================================================
function InitTrig_ChaosLordP takes nothing returns nothing
    set gg_trg_ChaosLordP = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_ChaosLordP, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_ChaosLordP, Condition( function Trig_ChaosLordP_Conditions ) )
    call TriggerAddAction( gg_trg_ChaosLordP, function Trig_ChaosLordP_Actions )
endfunction

