globals
    real Event_RemoveNature_Real
    unit Event_RemoveNature_Hero
endglobals

function Trig_NatureL_Conditions takes nothing returns boolean
    if udg_logic[36] then
        return false
    endif
    if not( NatureLogic(GetManipulatedItem()) ) then
        return false
    endif
    return true
endfunction

function Trig_NatureL_Actions takes nothing returns nothing
    local unit n = GetManipulatingUnit()//udg_hero[GetPlayerId(GetOwningPlayer(GetManipulatingUnit())) + 1]
    local integer i = CorrectPlayer(n)//GetPlayerId(GetOwningPlayer(n)) + 1
    local boolean l = LoadBoolean( udg_hash, GetHandleId( n ), StringHash( "pkblt" ) )
    local boolean k = LoadBoolean( udg_hash, GetHandleId( n ), StringHash( "pkbl" ) )
    local boolean b = false

    if l then
        set udg_logic[i + 22] = false
        set b = true
        call iconoff( i, "Природа" )
    else
        set udg_Set_Nature_Number[i] = udg_Set_Nature_Number[i] - 1
        if udg_logic[i + 22] and udg_Set_Nature_Number[i] < 3 then
            if not( k ) then
                set udg_logic[i + 22] = false
                set b = true
            endif
            call DisplayTimedTextToPlayer(GetOwningPlayer(n), 0, 0, 5., "Set |cff7cfc00Nature|r is now disassembled!")
            call iconoff( i, "Природа" )
        endif
    endif
    
    if b then
        call RessurectionPoints( -2, true )
    endif
    
    set Event_RemoveNature_Hero = n
    set Event_RemoveNature_Real = 0.00
    set Event_RemoveNature_Real = 1.00
    set Event_RemoveNature_Real = 0.00
    
    //call AllSetRing( n, 5, GetManipulatedItem() )
    
    set n = null
endfunction

//===========================================================================
function InitTrig_NatureL takes nothing returns nothing
    set gg_trg_NatureL = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_NatureL, EVENT_PLAYER_UNIT_DROP_ITEM )
    call TriggerAddCondition( gg_trg_NatureL, Condition( function Trig_NatureL_Conditions ) )
    call TriggerAddAction( gg_trg_NatureL, function Trig_NatureL_Actions )
endfunction

