function Trig_Rarity_Conditions takes nothing returns boolean
    return GetItemTypeId(GetManipulatedItem()) == 'I0EK'
endfunction

function Trig_Rarity_Actions takes nothing returns nothing
    local integer i = GetPlayerId(GetOwningPlayer(GetManipulatingUnit())) + 1
    
    call IconFrame( "Rarity", udg_DB_BonusFrame_Icon[5], udg_DB_BonusFrame_Name[5], udg_DB_BonusFrame_Tooltip[5] )
    set udg_logic[98] = true
    call StartSound(gg_snd_QuestLog)
    call DestroyEffect( AddSpecialEffectTarget( "Abilities\\Spells\\Human\\Resurrect\\ResurrectTarget.mdl", GetManipulatingUnit(), "origin") )
    call statst( GetManipulatingUnit(), 1, 1, 1, 0, true )

    call stazisst( GetManipulatingUnit(), GetItemOfTypeFromUnitBJ( GetManipulatingUnit(), 'I0EK') )
endfunction

//===========================================================================
function InitTrig_Rarity takes nothing returns nothing
    set gg_trg_Rarity = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Rarity, EVENT_PLAYER_UNIT_USE_ITEM )
    call TriggerAddCondition( gg_trg_Rarity, Condition( function Trig_Rarity_Conditions ) )
    call TriggerAddAction( gg_trg_Rarity, function Trig_Rarity_Actions )
endfunction

