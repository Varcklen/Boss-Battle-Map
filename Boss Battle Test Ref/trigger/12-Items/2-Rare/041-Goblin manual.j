function Trig_Goblin_manual_Conditions takes nothing returns boolean
    return GetItemTypeId(GetManipulatedItem()) == 'I009'
endfunction

function Trig_Goblin_manual_Actions takes nothing returns nothing
    call statst( GetManipulatingUnit(), 1, 1, 1, 0, true )
    call DestroyEffect( AddSpecialEffectTarget("Abilities\\Spells\\Orc\\MirrorImage\\MirrorImageDeathCaster.mdl", GetManipulatingUnit(), "origin" ) )
    if SetCount_GetPieces(GetManipulatingUnit(), SET_MECH) > 0 then
        call NewUniques( GetManipulatingUnit(), 'A0XI' )
    endif
    call stazisst( GetManipulatingUnit(), GetManipulatedItem() )
endfunction

//===========================================================================
function InitTrig_Goblin_manual takes nothing returns nothing
    set gg_trg_Goblin_manual = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Goblin_manual, EVENT_PLAYER_UNIT_USE_ITEM )
    call TriggerAddCondition( gg_trg_Goblin_manual, Condition( function Trig_Goblin_manual_Conditions ) )
    call TriggerAddAction( gg_trg_Goblin_manual, function Trig_Goblin_manual_Actions )
endfunction

