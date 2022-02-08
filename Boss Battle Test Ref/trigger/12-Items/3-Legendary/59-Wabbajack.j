function Trig_Wabbajack_Conditions takes nothing returns boolean
    return inv( GetSpellAbilityUnit(), 'I03E' ) > 0 and udg_combatlogic[GetPlayerId( GetOwningPlayer( GetSpellAbilityUnit() ) ) + 1]
endfunction

function Trig_Wabbajack_Actions takes nothing returns nothing
    local integer rand = GetRandomInt( 1, 3 )
    
    if rand == 1 then
        call CastRandomAbility(GetSpellAbilityUnit(), 3, udg_DB_Trigger_One[GetRandomInt( 1, udg_Database_NumberItems[14])] )
    elseif rand == 2 then
        call CastRandomAbility(GetSpellAbilityUnit(), 3, udg_DB_Trigger_Two[GetRandomInt( 1, udg_Database_NumberItems[15])] )
    else
        call CastRandomAbility(GetSpellAbilityUnit(), 3, udg_DB_Trigger_Three[GetRandomInt( 1, udg_Database_NumberItems[16])] )
    endif
endfunction

//===========================================================================
function InitTrig_Wabbajack takes nothing returns nothing
    set gg_trg_Wabbajack = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Wabbajack, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_Wabbajack, Condition( function Trig_Wabbajack_Conditions ) )
    call TriggerAddAction( gg_trg_Wabbajack, function Trig_Wabbajack_Actions )
endfunction

