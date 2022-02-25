function Trig_MoonL_Conditions takes nothing returns boolean
    if udg_logic[36] then
        return false
    endif
    if not( MoonLogic(GetManipulatedItem()) ) then
        return false
    endif
    return true
endfunction

function Trig_MoonL_Actions takes nothing returns nothing
    local unit n = GetManipulatingUnit()//udg_hero[GetPlayerId(GetOwningPlayer(GetManipulatingUnit())) + 1]
    local integer i = CorrectPlayer(n)//GetPlayerId(GetOwningPlayer(n)) + 1
    local integer cyclA = 0
    local boolean l = LoadBoolean( udg_hash, GetHandleId( n ), StringHash( "pkblt" ) )
    local boolean k = LoadBoolean( udg_hash, GetHandleId( n ), StringHash( "pkbl" ) )
    
    if l then
        set udg_logic[i + 18] = false
        call iconoff( i, "Луна" )
    else
        set udg_Set_Moon_Number[i] = udg_Set_Moon_Number[i] - 1
        if udg_logic[i + 18] and udg_Set_Moon_Number[i] < 3 then
            if not( k ) then
                set udg_logic[i + 18] = false
                call UnitRemoveAbility( n, 'A04C' )
                call UnitRemoveAbility( n, 'B08W' )
            endif
            call DisplayTimedTextToPlayer(GetOwningPlayer(n), 0, 0, 5., "Set |cff5858faMoon|r is now disassembled!" )
            call iconoff( i, "Луна" )
        endif
    endif
    
    //call AllSetRing( n, 4, GetManipulatedItem() )
    
    set n = null
endfunction

//===========================================================================
function InitTrig_MoonL takes nothing returns nothing
    set gg_trg_MoonL = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_MoonL, EVENT_PLAYER_UNIT_DROP_ITEM )
    call TriggerAddCondition( gg_trg_MoonL, Condition( function Trig_MoonL_Conditions ) )
    call TriggerAddAction( gg_trg_MoonL, function Trig_MoonL_Actions )
endfunction

