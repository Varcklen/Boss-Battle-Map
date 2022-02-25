function Trig_AlchemyL_Conditions takes nothing returns boolean
    if udg_logic[36] then
        return false
    endif
    if not( AlchemyLogic(GetManipulatedItem()) ) then
        return false
    endif
    return true
endfunction

function Trig_AlchemyL_Actions takes nothing returns nothing
    local unit n = GetManipulatingUnit()//udg_hero[GetPlayerId(GetOwningPlayer(GetManipulatingUnit())) + 1]
    local integer i = CorrectPlayer(n)//GetPlayerId(GetOwningPlayer(n)) + 1
    local integer cyclA = 0
    local boolean l = LoadBoolean( udg_hash, GetHandleId( n ), StringHash( "pkblt" ) )
    local boolean k = LoadBoolean( udg_hash, GetHandleId( n ), StringHash( "pkbl" ) )
    
    if l then
        set udg_logic[i + 10] = false
        call iconoff( i, "Алхимия" )
    else
        set udg_Set_Alchemy_Number[i] = udg_Set_Alchemy_Number[i] - 1
        if udg_logic[i + 10] and udg_Set_Alchemy_Number[i] < 3 then
            if not( k ) then
                set udg_logic[i + 10] = false
                call UnitRemoveAbility( n, 'A04F' )
                call UnitRemoveAbility( n, 'B08X' )
            endif
            call DisplayTimedTextToPlayer(GetOwningPlayer(n), 0, 0, 5., "Set |cfffe9a2eAlchemy|r is now disassembled!")
            call iconoff( i, "Алхимия" )
        endif
    endif
    
    //call AllSetRing( n, 6, GetManipulatedItem() )
    
    set n = null
endfunction

//===========================================================================
function InitTrig_AlchemyL takes nothing returns nothing
    set gg_trg_AlchemyL = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_AlchemyL, EVENT_PLAYER_UNIT_DROP_ITEM )
    call TriggerAddCondition( gg_trg_AlchemyL, Condition( function Trig_AlchemyL_Conditions ) )
    call TriggerAddAction( gg_trg_AlchemyL, function Trig_AlchemyL_Actions )
endfunction

