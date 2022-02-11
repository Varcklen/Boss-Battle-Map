function Trig_IkarosQuest_Conditions takes nothing returns boolean
    return inv( udg_FightEnd_Unit, 'I099') > 0 and not(udg_fightmod[3])
endfunction

function Trig_IkarosQuest_Actions takes nothing returns nothing
    local integer i = GetPlayerId( GetOwningPlayer(udg_FightEnd_Unit) ) + 1
    local integer p = LoadInteger( udg_hash, GetHandleId(udg_FightEnd_Unit), StringHash( udg_QuestItemCode[17] ) ) + 1
    
    call SaveInteger( udg_hash, GetHandleId(udg_FightEnd_Unit), StringHash( udg_QuestItemCode[17] ), p )
    if p >= udg_QuestNum[17] then
        call SaveReal( udg_hash, GetHandleId(udg_FightEnd_Unit), StringHash( udg_QuestItemCode[17] ), 0 )
        call RemoveItem(GetItemOfTypeFromUnitBJ(udg_FightEnd_Unit, 'I099'))
        call UnitAddItem(udg_FightEnd_Unit, CreateItem( 'I03H', GetUnitX(udg_FightEnd_Unit), GetUnitY(udg_FightEnd_Unit)))
        call textst( "|c00ffffff Battle of power done!", udg_FightEnd_Unit, 64, GetRandomReal( 45, 135 ), 12, 1.5 )
        call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\Human\\ReviveHuman\\ReviveHuman.mdl", GetUnitX(udg_FightEnd_Unit), GetUnitY(udg_FightEnd_Unit) ) )
        set udg_QuestDone[i] = true
    else
        call QuestDiscription( udg_FightEnd_Unit, 'I099', p, udg_QuestNum[17] )
    endif
endfunction

//===========================================================================
function InitTrig_IkarosQuest takes nothing returns nothing
    set gg_trg_IkarosQuest = CreateTrigger(  )
    call TriggerRegisterVariableEvent( gg_trg_IkarosQuest, "udg_FightEnd_Real", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_IkarosQuest, Condition( function Trig_IkarosQuest_Conditions ) )
    call TriggerAddAction( gg_trg_IkarosQuest, function Trig_IkarosQuest_Actions )
endfunction