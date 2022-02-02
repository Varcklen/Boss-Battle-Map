function Trig_PA_End_Conditions takes nothing returns boolean
    return GetUnitAbilityLevel(GetDyingUnit(), 'A05X') == 0 and ( GetDyingUnit() == udg_unit[57] or GetDyingUnit() == udg_unit[58] ) and not( IsUnitInGroup(GetDyingUnit(), udg_Return) )
endfunction

function Trig_PA_End_Actions takes nothing returns nothing 
    local integer i = GetPlayerId(GetOwningPlayer(udg_unit[57])) + 1
    local integer p = GetPlayerId(GetOwningPlayer(udg_unit[58])) + 1
    
    call DisableTrigger( GetTriggeringTrigger() )
     if not( udg_logic[62] ) then
        if GetDyingUnit() == udg_unit[57] then
            call DisplayTimedTextToForce( bj_FORCE_ALL_PLAYERS, 2, "Winner: " + udg_Player_Color[p] + GetPlayerName(GetOwningPlayer(udg_unit[58])) )
        else
            call DisplayTimedTextToForce( bj_FORCE_ALL_PLAYERS, 2, "Winner: " + udg_Player_Color[i] + GetPlayerName(GetOwningPlayer(udg_unit[57])) )
        endif
    endif
    call Between( "end_PA" )
endfunction

//===========================================================================
function InitTrig_PA_End takes nothing returns nothing
    set gg_trg_PA_End = CreateTrigger()
    call DisableTrigger( gg_trg_PA_End )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_PA_End, EVENT_PLAYER_UNIT_DEATH )
    call TriggerAddCondition( gg_trg_PA_End, Condition( function Trig_PA_End_Conditions ) )
    call TriggerAddAction( gg_trg_PA_End, function Trig_PA_End_Actions )
endfunction

