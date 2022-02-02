function Trig_MechG_Conditions takes nothing returns boolean
    if udg_logic[36] then
        return false
    endif
    if not( Mech_Logic(GetManipulatedItem()) ) then
        return false
    endif
    return true
endfunction

function Trig_MechG_Actions takes nothing returns nothing
    local unit n = GetManipulatingUnit()
    local integer i = GetUnitUserData(n)
    local integer m = 1
    local boolean l = LoadBoolean( udg_hash, GetHandleId( n ), StringHash( "pkblt" ) ) 

    if GetItemTypeId(GetManipulatedItem()) == 'I05I' or l then
        set m = m + 2
    endif
    call SetCount_AddPiece( n, SET_MECH, m )

    set n = null
endfunction

//===========================================================================
function InitTrig_MechG takes nothing returns nothing
    set gg_trg_MechG = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_MechG, EVENT_PLAYER_UNIT_PICKUP_ITEM )
    call TriggerAddCondition( gg_trg_MechG, Condition( function Trig_MechG_Conditions ) )
    call TriggerAddAction( gg_trg_MechG, function Trig_MechG_Actions )
endfunction

