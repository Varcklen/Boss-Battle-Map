function Trig_MechL_Conditions takes nothing returns boolean
    if udg_logic[36] then
        return false
    endif
    if not( Mech_Logic(GetManipulatedItem()) ) then
        return false
    endif
    return true
endfunction

function Trig_MechL_Actions takes nothing returns nothing
    local unit n = GetManipulatingUnit()
    local integer i = GetUnitUserData(n)
    local integer m = -1

    if GetItemTypeId(GetManipulatedItem()) == 'I05I' or GetItemTypeId(GetManipulatedItem()) == 'I03I' then
        set m = m - 2
    endif
    call SetCount_AddPiece( n, SET_MECH, m )

    set n = null
endfunction

//===========================================================================
function InitTrig_MechL takes nothing returns nothing
    set gg_trg_MechL = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_MechL, EVENT_PLAYER_UNIT_DROP_ITEM )
    call TriggerAddCondition( gg_trg_MechL, Condition( function Trig_MechL_Conditions ) )
    call TriggerAddAction( gg_trg_MechL, function Trig_MechL_Actions )
endfunction

