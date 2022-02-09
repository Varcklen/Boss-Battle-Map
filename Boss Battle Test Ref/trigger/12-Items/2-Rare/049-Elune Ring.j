function Trig_Elune_Ring_Conditions takes nothing returns boolean
    return not( udg_IsDamageSpell ) and inv( udg_DamageEventSource, 'I0FR') > 0
endfunction

function Trig_Elune_Ring_Actions takes nothing returns nothing
    local unit u = udg_DamageEventSource
    local integer id = GetHandleId( u )
    local integer s = LoadInteger( udg_hash, id, StringHash( "cgnt" ) ) + 1
    
    if s >= 7 then
        call MoonTrigger(u)
        call SaveInteger( udg_hash, id, StringHash( "cgnt" ), 0 )
    else
        call SaveInteger( udg_hash, id, StringHash( "cgnt" ), s )
    endif
    
    set u = null
endfunction

//===========================================================================
function InitTrig_Elune_Ring takes nothing returns nothing
    set gg_trg_Elune_Ring = CreateTrigger(  )
    call TriggerRegisterVariableEvent( gg_trg_Elune_Ring, "udg_AfterDamageEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_Elune_Ring, Condition( function Trig_Elune_Ring_Conditions ) )
    call TriggerAddAction( gg_trg_Elune_Ring, function Trig_Elune_Ring_Actions )
endfunction

