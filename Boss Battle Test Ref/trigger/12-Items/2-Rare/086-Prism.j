function Trig_Prism_Conditions takes nothing returns boolean
    local integer cyclA = 0
    local boolean l = false

    loop
        exitwhen cyclA > 4
        if GetItemTypeId(GetManipulatedItem()) == 'I031' + cyclA then
            set l = true
            set cyclA = 4
        endif
        set cyclA = cyclA + 1
    endloop
    return l
endfunction

function Trig_Prism_Actions takes nothing returns nothing
    local integer cyclA = 0

    loop
        exitwhen cyclA > 3
        if GetOwningPlayer(GetManipulatingUnit()) == Player(cyclA) and GetItemTypeId(GetManipulatedItem()) != 'I032' + cyclA then
            call RemoveItem( GetManipulatedItem() )
            set bj_lastCreatedItem = CreateItem( 'I032' + cyclA, GetUnitX(GetManipulatingUnit()), GetUnitY(GetManipulatingUnit()))
            call UnitAddItem( GetManipulatingUnit(), bj_lastCreatedItem)
            set cyclA = 3
        endif
        set cyclA = cyclA + 1
    endloop
endfunction

//===========================================================================
function InitTrig_Prism takes nothing returns nothing
    set gg_trg_Prism = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Prism, EVENT_PLAYER_UNIT_PICKUP_ITEM )
    call TriggerAddCondition( gg_trg_Prism, Condition( function Trig_Prism_Conditions ) )
    call TriggerAddAction( gg_trg_Prism, function Trig_Prism_Actions )
endfunction

