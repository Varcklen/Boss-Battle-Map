function Trig_BloodL_Conditions takes nothing returns boolean
    if udg_logic[36] then
        return false
    endif
    if not( BloodLogic(GetManipulatedItem()) ) then
        return false
    endif
    return true
endfunction

function Trig_BloodL_Actions takes nothing returns nothing
    local unit n = GetManipulatingUnit()//udg_hero[GetPlayerId(GetOwningPlayer(GetManipulatingUnit())) + 1]
    local integer i = CorrectPlayer(n)//GetPlayerId(GetOwningPlayer(n)) + 1
    local boolean l = LoadBoolean( udg_hash, GetHandleId( n ), StringHash( "pkblt" ) )
    local boolean k = LoadBoolean( udg_hash, GetHandleId( n ), StringHash( "pkbl" ) )
    
    if l then
        set udg_logic[i + 14] = false
        call iconoff( i, "Кровь" )
    else
        set udg_Set_Blood_Number[i] = udg_Set_Blood_Number[i] - 1
        if udg_logic[i + 14] and udg_Set_Blood_Number[i] < 3 then
            if not( k ) then
                set udg_logic[i + 14] = false
                call UnitRemoveAbility( n, 'A03T' )
                call UnitRemoveAbility( n, 'B08U' )
            endif
            call DisplayTimedTextToPlayer( GetOwningPlayer(n), 0, 0, 5., "Set |cffb40431Blood|r is now disassembled!")
            call iconoff( i, "Кровь" )
        endif
    endif
    
    //call AllSetRing( n, 2, GetManipulatedItem() )
    
    set n = null
endfunction

//===========================================================================
function InitTrig_BloodL takes nothing returns nothing
    set gg_trg_BloodL = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_BloodL, EVENT_PLAYER_UNIT_DROP_ITEM )
    call TriggerAddCondition( gg_trg_BloodL, Condition( function Trig_BloodL_Conditions ) )
    call TriggerAddAction( gg_trg_BloodL, function Trig_BloodL_Actions )
endfunction

