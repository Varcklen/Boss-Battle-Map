function Trig_Barnakle_blood_Actions takes nothing returns nothing
    if inv(GetSpellAbilityUnit(), 'I0B4') > 0  then
        call healst( GetSpellAbilityUnit(), null, 50 )
    endif
endfunction

//===========================================================================
function InitTrig_Barnakle_blood takes nothing returns nothing
    set gg_trg_Barnakle_blood = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Barnakle_blood, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddAction( gg_trg_Barnakle_blood, function Trig_Barnakle_blood_Actions )
endfunction