function Trig_DryadEA_Conditions takes nothing returns boolean
    return IsUnitEnemy( udg_DamageEventSource, GetOwningPlayer( udg_DamageEventTarget ) ) and not( udg_fightmod[3] ) and GetUnitTypeId(udg_DamageEventSource) != 'u000' and luckylogic( udg_DamageEventSource, 1+GetUnitAbilityLevel( udg_DamageEventSource, 'A0I9'), 1, 100 ) and GetUnitAbilityLevel( udg_DamageEventSource, 'A0I9') > 0 and combat( udg_DamageEventSource, false, 0 )
endfunction

function Trig_DryadEA_Actions takes nothing returns nothing
    call DestroyEffect( AddSpecialEffectTarget( "Abilities\\Spells\\Items\\AIem\\AIemTarget.mdl", udg_DamageEventSource, "origin") )
    call statst( udg_DamageEventSource, 0, 1, 0, 204, true )
    call textst( "|c0020FF20 +1 agility", udg_DamageEventSource, 64, 90, 10, 1 )
endfunction

//===========================================================================
function InitTrig_DryadEA takes nothing returns nothing
    set gg_trg_DryadEA = CreateTrigger(  )
    call TriggerRegisterVariableEvent( gg_trg_DryadEA, "udg_AfterDamageEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_DryadEA, Condition( function Trig_DryadEA_Conditions ) )
    call TriggerAddAction( gg_trg_DryadEA, function Trig_DryadEA_Actions )
endfunction

