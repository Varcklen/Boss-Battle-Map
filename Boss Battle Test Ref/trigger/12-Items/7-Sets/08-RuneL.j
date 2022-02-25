function Trig_RuneL_Conditions takes nothing returns boolean
    if udg_logic[36] then
        return false
    endif
    if not( RuneLogic(GetManipulatedItem()) ) then
        return false
    endif
    return true
endfunction

function Trig_RuneL_Actions takes nothing returns nothing
    local unit n = GetManipulatingUnit()
    local integer i = CorrectPlayer(n)
    local boolean l = LoadBoolean( udg_hash, GetHandleId( n ), StringHash( "pkblt" ) )
    local boolean k = LoadBoolean( udg_hash, GetHandleId( n ), StringHash( "pkbl" ) )
    local boolean b = false
    
    if l then
        set udg_logic[i + 26] = false
        set b = true
        call iconoff( i, "Руна" )
    else
        set udg_Set_Rune_Number[i] = udg_Set_Rune_Number[i] - 1
        if udg_logic[i + 26] and udg_Set_Rune_Number[i] < 3 then
            if not( k ) then
                set udg_logic[i + 26] = false
                set b = true
            endif
            call DisplayTimedTextToPlayer( GetOwningPlayer(n), 0, 0, 5., "Set |cff848484Rune|r is now disassembled!")
            call iconoff( i, "Руна" )
        endif
    endif
    
    if b then
        set udg_Event_RuneSetRemove_Hero = n
        set udg_Event_RuneSetRemove_Item = GetManipulatedItem()
        
        set udg_Event_RuneSetRemove_Real = 0.00
        set udg_Event_RuneSetRemove_Real = 1.00
        set udg_Event_RuneSetRemove_Real = 0.00
        
        if inv(n, 'I00B') > 0 then
            call UnitAddAbility( n, 'A0Z8')
        endif
        if inv(n, 'I00C') > 0 then
            call UnitAddAbility( n, 'A0ZA')
        endif
        if inv(n, 'I02G') > 0 then
            call UnitAddAbility( n, 'A0YZ')
        endif
        if inv(n, 'I00O') > 0 then
            call UnitAddAbility( n, 'A0Z1')
        endif
        if inv(n, 'I00M') > 0 then
            call UnitAddAbility( n, 'A0CB')
        endif
        if inv(n, 'I06N') > 0 then
            call UnitAddAbility( n, 'A0OU')
        endif
        if inv(n, 'I078') > 0 then
            call UnitAddAbility( n, 'A0L9')
        endif
        if inv(n, 'I0BL') > 0 then
            call UnitAddAbility( n, 'A0M9')
        endif
    endif
    
    set n = null
endfunction

//===========================================================================
function InitTrig_RuneL takes nothing returns nothing
    set gg_trg_RuneL = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_RuneL, EVENT_PLAYER_UNIT_DROP_ITEM )
    call TriggerAddCondition( gg_trg_RuneL, Condition( function Trig_RuneL_Conditions ) )
    call TriggerAddAction( gg_trg_RuneL, function Trig_RuneL_Actions )
endfunction

