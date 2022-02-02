function Trig_Thirst_Actions takes nothing returns nothing
    if IsUnitInGroup(GetSpellAbilityUnit(), udg_heroinfo) then
        call healst( GetSpellAbilityUnit(), null, 20 )
    endif
endfunction

//===========================================================================
function InitTrig_Thirst takes nothing returns nothing
    set gg_trg_Thirst = CreateTrigger(  )
    call DisableTrigger( gg_trg_Thirst )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Thirst, EVENT_PLAYER_UNIT_SPELL_FINISH )
    call TriggerAddAction( gg_trg_Thirst, function Trig_Thirst_Actions )
endfunction

