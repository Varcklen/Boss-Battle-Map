function Trig_Alphabet_Conditions takes nothing returns boolean
    return GetItemTypeId(GetManipulatedItem()) == 'I0CE'
endfunction

function Trig_Alphabet_Actions takes nothing returns nothing
    call stazisst( GetManipulatingUnit(), GetManipulatedItem() )
    call SetHeroLevel( GetManipulatingUnit(), GetHeroLevel(GetManipulatingUnit()) + 3, true)
    call ModifyHeroSkillPoints( GetManipulatingUnit(), bj_MODIFYMETHOD_SUB, 3 )
endfunction

//===========================================================================
function InitTrig_Alphabet takes nothing returns nothing
    set gg_trg_Alphabet = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Alphabet, EVENT_PLAYER_UNIT_USE_ITEM )
    call TriggerAddCondition( gg_trg_Alphabet, Condition( function Trig_Alphabet_Conditions ) )
    call TriggerAddAction( gg_trg_Alphabet, function Trig_Alphabet_Actions )
endfunction

