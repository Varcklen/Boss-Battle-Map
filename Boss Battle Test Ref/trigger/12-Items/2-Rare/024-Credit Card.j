function Trig_Credit_Card_Conditions takes nothing returns boolean
    return GetItemTypeId(GetManipulatedItem()) == 'I0CQ'
endfunction

function Trig_Credit_Card_Actions takes nothing returns nothing 

	call moneyst( GetManipulatingUnit(), 350 )               
	call IconFrame( "Credit Card", udg_DB_BonusFrame_Icon[1], udg_DB_BonusFrame_Name[1], udg_DB_BonusFrame_Tooltip[1] )
	set udg_logic[4] = true
	set udg_logic[5] = true

    call StartSound(gg_snd_QuestLog)
    call DestroyEffect( AddSpecialEffectTarget( "Abilities\\Spells\\Human\\Resurrect\\ResurrectTarget.mdl", GetManipulatingUnit(), "origin") )
    call stazisst( GetManipulatingUnit(), GetManipulatedItem() )
endfunction

//===========================================================================
function InitTrig_Credit_Card takes nothing returns nothing
    set gg_trg_Credit_Card = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Credit_Card, EVENT_PLAYER_UNIT_USE_ITEM )
    call TriggerAddCondition( gg_trg_Credit_Card, Condition( function Trig_Credit_Card_Conditions ) )
    call TriggerAddAction( gg_trg_Credit_Card, function Trig_Credit_Card_Actions )
endfunction

