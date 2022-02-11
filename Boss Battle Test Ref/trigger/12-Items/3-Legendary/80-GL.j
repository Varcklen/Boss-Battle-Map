function Trig_GL_Conditions takes nothing returns boolean
    return not( udg_fightmod[3] ) and GetUnitTypeId(udg_Event_PlayerMinionSummon_Unit) == ID_SHEEP and inv( udg_Event_PlayerMinionSummon_Hero, 'I0BV' ) > 0 and GetUnitState( udg_Event_PlayerMinionSummon_Hero, UNIT_STATE_LIFE) > 0.405 and combat( udg_Event_PlayerMinionSummon_Hero, false, 0 )
endfunction

function Trig_GL_Actions takes nothing returns nothing
    local integer i = GetPlayerId(GetOwningPlayer(udg_Event_PlayerMinionSummon_Unit)) + 1
    local integer id = GetHandleId( udg_Event_PlayerMinionSummon_Hero )
    local integer s = LoadInteger( udg_hash, id, StringHash( udg_QuestItemCode[7] ) ) + 1
    
    call SaveInteger( udg_hash, id, StringHash( udg_QuestItemCode[7] ), s )

    if s >= udg_QuestNum[7] then
        call RemoveItem( GetItemOfTypeFromUnitBJ(udg_Event_PlayerMinionSummon_Hero, 'I0BV') )
        set bj_lastCreatedItem = CreateItem( 'I0A5', GetUnitX(udg_Event_PlayerMinionSummon_Hero), GetUnitY(udg_Event_PlayerMinionSummon_Hero))
        call UnitAddItem(udg_Event_PlayerMinionSummon_Hero, bj_lastCreatedItem)
        call textst( "|c00ffffff Reign of the legend is complete!", udg_Event_PlayerMinionSummon_Hero, 64, GetRandomReal( 45, 135 ), 12, 1.5 )
        call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\Human\\ReviveHuman\\ReviveHuman.mdl", GetUnitX(udg_Event_PlayerMinionSummon_Hero), GetUnitY(udg_Event_PlayerMinionSummon_Hero) ) )
        set udg_QuestDone[i] = true
    else
        call QuestDiscription( udg_Event_PlayerMinionSummon_Hero, 'I0BV', s, udg_QuestNum[7] )
    endif
endfunction

//===========================================================================
function InitTrig_GL takes nothing returns nothing
    set gg_trg_GL = CreateTrigger(  )
    call TriggerRegisterEnterRectSimple( gg_trg_GL, GetWorldBounds() )
    call TriggerRegisterVariableEvent( gg_trg_GL, "udg_Event_PlayerMinionSummon_Real", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_GL, Condition( function Trig_GL_Conditions ) )
    call TriggerAddAction( gg_trg_GL, function Trig_GL_Actions )
endfunction

