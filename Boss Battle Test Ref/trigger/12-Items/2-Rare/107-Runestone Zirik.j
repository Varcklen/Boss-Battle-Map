function Trig_Runestone_Zirik_Conditions takes nothing returns boolean
    return inv(udg_FightEnd_Unit, 'I076') > 0 and UnitInventoryCount(udg_FightEnd_Unit) < 6 and udg_fightmod[3] == false
endfunction

function Trig_Runestone_Zirik_Actions takes nothing returns nothing
    local integer i = GetUnitUserData(udg_FightEnd_Unit)
    local item it
    
   set it = ItemRandomizerAll( udg_FightEnd_Unit, 0 )
    if GetItemType(it) == ITEM_TYPE_ARTIFACT or GetItemType(it) == ITEM_TYPE_CAMPAIGN then
        call DestroyEffect( AddSpecialEffectTarget("Abilities\\Spells\\Human\\ReviveHuman\\ReviveHuman.mdl", udg_FightEnd_Unit, "origin" ) )
        call statst( udg_FightEnd_Unit, 5, 5, 5, 0, true )
        call textst( "+5 stats!", udg_FightEnd_Unit, 64, GetRandomInt( 45, 135 ), 10, 2.5 )
    elseif not( udg_logic[i + 26] ) then
        call statst( udg_FightEnd_Unit, -2, -2, -2, 0, true )
        call textst( "-2 stats!", udg_FightEnd_Unit, 64, GetRandomInt( 45, 135 ), 10, 2.5 )
    endif
    
    set it = null
endfunction

//===========================================================================
function InitTrig_Runestone_Zirik takes nothing returns nothing
    set gg_trg_Runestone_Zirik = CreateTrigger(  )
    call TriggerRegisterVariableEvent( gg_trg_Runestone_Zirik, "udg_FightEnd_Real", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_Runestone_Zirik, Condition( function Trig_Runestone_Zirik_Conditions ) )
    call TriggerAddAction( gg_trg_Runestone_Zirik, function Trig_Runestone_Zirik_Actions )
endfunction