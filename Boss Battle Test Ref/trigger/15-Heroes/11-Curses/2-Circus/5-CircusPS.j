function Trig_CircusPS_Conditions takes nothing returns boolean
    return GetUnitAbilityLevel( GetSpellAbilityUnit(), 'A0S7') > 0 and luckylogic( GetSpellAbilityUnit(), 10 + ( 5 * GetUnitAbilityLevel(GetSpellAbilityUnit(), 'A0S7') ), 1, 100 )
endfunction

function Trig_CircusPS_Actions takes nothing returns nothing
    local unit u = randomtarget( GetSpellAbilityUnit(), 900, "enemy", "", "", "", "" )
    
    if u != null then
        call DemomanCurse( GetSpellAbilityUnit(), u )
    endif
    set u = null
endfunction

//===========================================================================
function InitTrig_CircusPS takes nothing returns nothing
    set gg_trg_CircusPS = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_CircusPS, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_CircusPS, Condition( function Trig_CircusPS_Conditions ) )
    call TriggerAddAction( gg_trg_CircusPS, function Trig_CircusPS_Actions )
endfunction

