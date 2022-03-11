function Trig_MagnataurP_Conditions takes nothing returns boolean
     return not( udg_IsDamageSpell ) and GetUnitAbilityLevel( udg_DamageEventSource, 'A098') > 0 and luckylogic( udg_DamageEventSource, ( 3 * GetUnitAbilityLevel( udg_DamageEventSource, 'A098') ) + 1, 1, 100 )
endfunction

function Trig_MagnataurP_Actions takes nothing returns nothing
    local integer rand = GetRandomInt( 1, 3 )

    set udg_RandomLogic = true
    set udg_Caster = udg_DamageEventSource
    set udg_Level = GetUnitAbilityLevel( udg_DamageEventSource, 'A098')
    if rand == 1 then
        call TriggerExecute( gg_trg_MagnataurQ )
    elseif rand == 2 then
        call TriggerExecute( gg_trg_MagnataurW )
    else
        call TriggerExecute( gg_trg_MagnataurR )
    endif
endfunction

//===========================================================================
function InitTrig_MagnataurP takes nothing returns nothing
    set gg_trg_MagnataurP = CreateTrigger(  )
    call TriggerRegisterVariableEvent( gg_trg_MagnataurP, "udg_DamageEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_MagnataurP, Condition( function Trig_MagnataurP_Conditions ) )
    call TriggerAddAction( gg_trg_MagnataurP, function Trig_MagnataurP_Actions )
endfunction

