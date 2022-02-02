function Trig_RingL_Conditions takes nothing returns boolean
    if udg_logic[36] then
        return false
    endif
    if not( Ring_Logic(GetManipulatedItem()) ) then
        return false
    endif
    return true
endfunction

function Trig_RingL_Actions takes nothing returns nothing
    local unit u = GetManipulatingUnit()//udg_hero[GetPlayerId(GetOwningPlayer(GetManipulatingUnit())) + 1]
    local integer i = CorrectPlayer(u)//GetPlayerId(GetOwningPlayer(n)) + 1
    local boolean l = LoadBoolean( udg_hash, GetHandleId( u ), StringHash( "pkblt" ) )
    local boolean k = LoadBoolean( udg_hash, GetHandleId( u ), StringHash( "pkbl" ) )
    
    if l then
        set udg_logic[i + 62] = false
        call skillst( i, -1 )
        call iconoff( i, "Кольцо" )
    else
        set udg_Set_Ring_Number[i] = udg_Set_Ring_Number[i] - 1
        if udg_logic[i + 62] and udg_Set_Ring_Number[i] < 3 then
            if not( k ) then
                set udg_logic[i + 62] = false
                
            	call skillst( i, -1 )
            endif
            call DisplayTimedTextToPlayer( GetOwningPlayer( u ), 0, 0, 5, "Set |cff9001fdRing|r is now disassembled!" )
            call iconoff( i, "Кольцо" )
        endif
    endif
    
    //call AllSetRing( GetManipulatingUnit(), 8, GetManipulatedItem() )
    
    set u = null
endfunction

//===========================================================================
function InitTrig_RingL takes nothing returns nothing
    set gg_trg_RingL = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_RingL, EVENT_PLAYER_UNIT_DROP_ITEM )
    call TriggerAddCondition( gg_trg_RingL, Condition( function Trig_RingL_Conditions ) )
    call TriggerAddAction( gg_trg_RingL, function Trig_RingL_Actions )
endfunction

