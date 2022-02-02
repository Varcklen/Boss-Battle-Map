function Trig_TotemChoose_Conditions takes nothing returns boolean
    return GetUnitTypeId(GetTriggerUnit()) == 'o013' and GetOwningPlayer(GetTriggerUnit()) == Player(PLAYER_NEUTRAL_PASSIVE)
endfunction

function Trig_TotemChoose_Actions takes nothing returns nothing
    call DestroyEffect(AddSpecialEffectTarget( "Abilities\\Spells\\Other\\Charm\\CharmTarget.mdl", GetTriggerUnit(), "origin") )
    call SetUnitOwner( GetTriggerUnit(), Player(4), false )
endfunction

//===========================================================================
function InitTrig_TotemChoose takes nothing returns nothing
    set gg_trg_TotemChoose = CreateTrigger(  )
    call TriggerRegisterPlayerSelectionEventBJ( gg_trg_TotemChoose, Player(0), true )
    call TriggerRegisterPlayerSelectionEventBJ( gg_trg_TotemChoose, Player(1), true )
    call TriggerRegisterPlayerSelectionEventBJ( gg_trg_TotemChoose, Player(2), true )
    call TriggerRegisterPlayerSelectionEventBJ( gg_trg_TotemChoose, Player(3), true )
    call TriggerAddCondition( gg_trg_TotemChoose, Condition( function Trig_TotemChoose_Conditions ) )
    call TriggerAddAction( gg_trg_TotemChoose, function Trig_TotemChoose_Actions )
endfunction

