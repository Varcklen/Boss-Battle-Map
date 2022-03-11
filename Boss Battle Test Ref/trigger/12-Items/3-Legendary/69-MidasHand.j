function Trig_MidasHand_Conditions takes nothing returns boolean
    return GetItemTypeId(GetManipulatedItem()) == 'I08S'
endfunction

function Trig_MidasHand_Actions takes nothing returns nothing
    local integer cyclA = 1
    
    loop
        exitwhen cyclA > 4
        if udg_hero[cyclA] != null then
        call moneyst( udg_hero[cyclA], 1000 )
        endif
        set cyclA = cyclA + 1
    endloop
    call stazisst( GetManipulatingUnit(), GetManipulatedItem() )
endfunction

//===========================================================================
function InitTrig_MidasHand takes nothing returns nothing
    set gg_trg_MidasHand = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_MidasHand, EVENT_PLAYER_UNIT_USE_ITEM )
    call TriggerAddCondition( gg_trg_MidasHand, Condition( function Trig_MidasHand_Conditions ) )
    call TriggerAddAction( gg_trg_MidasHand, function Trig_MidasHand_Actions )
endfunction

