function Trig_Runestone_Info_Conditions takes nothing returns boolean
    return inv( udg_Event_PlayerMinionSummon_Hero, 'I0G7') > 0 and GetUnitState( udg_Event_PlayerMinionSummon_Hero, UNIT_STATE_LIFE) > 0.405
endfunction

function Trig_Runestone_Info_Actions takes nothing returns nothing
    local real hp = BlzGetUnitMaxHP(udg_Event_PlayerMinionSummon_Unit)*0.4
    local real at = BlzGetUnitBaseDamage(udg_Event_PlayerMinionSummon_Unit, 0)*0.4
    
    call DestroyEffect( AddSpecialEffectTarget( "Abilities\\Spells\\Undead\\VampiricAura\\VampiricAuraTarget.mdl", udg_Event_PlayerMinionSummon_Unit, "origin") )
    call BlzSetUnitMaxHP( udg_Event_PlayerMinionSummon_Unit, R2I(BlzGetUnitMaxHP(udg_Event_PlayerMinionSummon_Unit) + hp) )
    call SetUnitState(udg_Event_PlayerMinionSummon_Unit, UNIT_STATE_LIFE, GetUnitState(udg_Event_PlayerMinionSummon_Unit, UNIT_STATE_LIFE) + hp)
    call BlzSetUnitBaseDamage( udg_Event_PlayerMinionSummon_Unit, R2I(BlzGetUnitBaseDamage(udg_Event_PlayerMinionSummon_Unit, 0) + at), 0 )

    if not(udg_logic[GetPlayerId( GetOwningPlayer( udg_Event_PlayerMinionSummon_Unit ) ) + 1 + 26]) then
        call UnitAddAbility(udg_Event_PlayerMinionSummon_Unit, 'A19Y')
    endif
endfunction

//===========================================================================
function InitTrig_Runestone_Info takes nothing returns nothing
    set gg_trg_Runestone_Info = CreateTrigger(  )
    //call TriggerRegisterEnterRectSimple( gg_trg_Runestone_Info, GetWorldBounds() )
    call TriggerRegisterVariableEvent( gg_trg_Runestone_Info, "udg_Event_PlayerMinionSummon_Real", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_Runestone_Info, Condition( function Trig_Runestone_Info_Conditions ) )
    call TriggerAddAction( gg_trg_Runestone_Info, function Trig_Runestone_Info_Actions )
endfunction