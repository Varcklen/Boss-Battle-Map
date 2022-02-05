function Trig_ChaosLordP_Conditions takes nothing returns boolean
    return udg_logic[34] and IsUnitInGroup( GetSpellAbilityUnit(), udg_heroinfo ) and udg_combatlogic[GetPlayerId( GetOwningPlayer( GetSpellAbilityUnit() ) ) + 1]
endfunction

function Trig_ChaosLordP_Actions takes nothing returns nothing
    call CastRandomAbility(GetSpellAbilityUnit(), GetRandomInt( 1, 5 ), udg_DB_Trigger_One[GetRandomInt( 1, udg_Database_NumberItems[13 + GetRandomInt( 1, 3 )])] )
endfunction

//===========================================================================
function InitTrig_ChaosLordP takes nothing returns nothing
    set gg_trg_ChaosLordP = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_ChaosLordP, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_ChaosLordP, Condition( function Trig_ChaosLordP_Conditions ) )
    call TriggerAddAction( gg_trg_ChaosLordP, function Trig_ChaosLordP_Actions )
endfunction

