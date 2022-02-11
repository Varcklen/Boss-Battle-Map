function Trig_DMCG_Conditions takes nothing returns boolean
    return inv( udg_Event_PlayerMinionSummon_Hero, 'I095' ) > 0 and GetUnitState( udg_Event_PlayerMinionSummon_Hero, UNIT_STATE_LIFE) > 0.405 and combat( udg_Event_PlayerMinionSummon_Hero, false, 0 ) and not( udg_fightmod[3] )
endfunction

function Trig_DMCG_Actions takes nothing returns nothing
    local integer i = GetPlayerId(GetOwningPlayer(udg_Event_PlayerMinionSummon_Unit)) + 1
    local integer id = GetHandleId( udg_Event_PlayerMinionSummon_Hero )
    local integer s = LoadInteger( udg_hash, id, StringHash( udg_QuestItemCode[4] ) ) + 1
    
    call SaveInteger( udg_hash, id, StringHash( udg_QuestItemCode[4] ), s )

    if s >= udg_QuestNum[4] then
        call RemoveItem(GetItemOfTypeFromUnitBJ(udg_Event_PlayerMinionSummon_Hero, 'I095'))
        set bj_lastCreatedItem = CreateItem( 'I03D', GetUnitX(udg_Event_PlayerMinionSummon_Hero), GetUnitY(udg_Event_PlayerMinionSummon_Hero))
        call UnitAddItem(udg_Event_PlayerMinionSummon_Hero, bj_lastCreatedItem)
        call textst( "|c00ffffff General fee done!", udg_Event_PlayerMinionSummon_Hero, 64, GetRandomReal( 45, 135 ), 12, 1.5 )
        call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\Human\\ReviveHuman\\ReviveHuman.mdl", GetUnitX(udg_Event_PlayerMinionSummon_Hero), GetUnitY(udg_Event_PlayerMinionSummon_Hero) ) )
        set udg_QuestDone[i] = true
    else
        call QuestDiscription( udg_Event_PlayerMinionSummon_Hero, 'I095', s, udg_QuestNum[4] )
    endif
endfunction

//===========================================================================
function InitTrig_DMCG takes nothing returns nothing
    set gg_trg_DMCG = CreateTrigger(  )
    call TriggerRegisterVariableEvent( gg_trg_DMCG, "udg_Event_PlayerMinionSummon_Real", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_DMCG, Condition( function Trig_DMCG_Conditions ) )
    call TriggerAddAction( gg_trg_DMCG, function Trig_DMCG_Actions )
endfunction

