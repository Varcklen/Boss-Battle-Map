function Trig_CristallL_Conditions takes nothing returns boolean
    if udg_logic[36] then
        return false
    endif
    if not( CristallLogic(GetManipulatedItem()) ) then
        return false
    endif
    return true
endfunction

function Trig_CristallL_Actions takes nothing returns nothing
    local unit n = GetManipulatingUnit()//udg_hero[GetPlayerId(GetOwningPlayer(GetManipulatingUnit())) + 1]
    local integer i = CorrectPlayer(n)//GetPlayerId(GetOwningPlayer(n)) + 1
    local boolean l = LoadBoolean( udg_hash, GetHandleId( n ), StringHash( "pkblt" ) )
    local boolean k = LoadBoolean( udg_hash, GetHandleId( n ), StringHash( "pkbl" ) )
    
    if l then
        set udg_logic[i + 80] = false
        call iconoff( i, "Кристалл" )
    else
        set udg_Set_Cristall_Number[i] = udg_Set_Cristall_Number[i] - 1
        if udg_logic[i + 80] and udg_Set_Cristall_Number[i] < 3 then
            if not( k ) then
                set udg_logic[i + 80] = false
                call UnitRemoveAbility( n, 'A03Y' )
                call UnitRemoveAbility( n, 'B08V' )
            endif
            call DisplayTimedTextToPlayer( GetOwningPlayer(n), 0, 0, 5., "Set |cff00cceeCrystal|r is now disassembled!")
            call iconoff( i, "Кристалл" )
        endif
    endif
    
    //call AllSetRing( n, 9, GetManipulatedItem() )
    
    set n = null
endfunction

//===========================================================================
function InitTrig_CristallL takes nothing returns nothing
    set gg_trg_CristallL = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_CristallL, EVENT_PLAYER_UNIT_DROP_ITEM )
    call TriggerAddCondition( gg_trg_CristallL, Condition( function Trig_CristallL_Conditions ) )
    call TriggerAddAction( gg_trg_CristallL, function Trig_CristallL_Actions )
endfunction

