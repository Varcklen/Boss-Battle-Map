function Trig_LegBook_Conditions takes nothing returns boolean
    return GetItemTypeId(GetManipulatedItem()) == 'I09S'
endfunction

function Trig_LegBook_Actions takes nothing returns nothing                
	set udg_logic[76] = true
    call IconFrame( "LegBook", udg_DB_BonusFrame_Icon[4], udg_DB_BonusFrame_Name[4], udg_DB_BonusFrame_Tooltip[4] )
    call StartSound(gg_snd_QuestLog)
    call DestroyEffect( AddSpecialEffectTarget( "Abilities\\Spells\\Human\\Resurrect\\ResurrectTarget.mdl", GetManipulatingUnit(), "origin") )
    call statst( GetManipulatingUnit(), 1, 1, 1, 0, true )
    call stazisst( GetManipulatingUnit(), GetManipulatedItem() )
endfunction

//===========================================================================
function InitTrig_LegBook takes nothing returns nothing
    set gg_trg_LegBook = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_LegBook, EVENT_PLAYER_UNIT_USE_ITEM )
    call TriggerAddCondition( gg_trg_LegBook, Condition( function Trig_LegBook_Conditions ) )
    call TriggerAddAction( gg_trg_LegBook, function Trig_LegBook_Actions )
endfunction