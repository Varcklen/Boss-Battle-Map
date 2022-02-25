//TESH.scrollpos=0
//TESH.alwaysfold=0
function Trig_Illusionist3_Conditions takes nothing returns boolean
    return GetUnitTypeId(udg_DamageEventTarget) == 'h020' and GetUnitLifePercent(udg_DamageEventTarget) <= 66
endfunction

function Trig_Illusionist3_Actions takes nothing returns nothing
    
    call DisableTrigger( GetTriggeringTrigger() )
    call SaveBoolean( udg_hash, GetHandleId( udg_DamageEventTarget ), StringHash( "bsilb" ), true )
    call DestroyEffect( AddSpecialEffectTarget( "Abilities\\Spells\\Undead\\DarkRitual\\DarkRitualTarget.mdl", udg_DamageEventTarget, "origin") )
endfunction

//===========================================================================
function InitTrig_Illusionist3 takes nothing returns nothing
    set gg_trg_Illusionist3 = CreateTrigger(  )
    call DisableTrigger( gg_trg_Illusionist3 )
    call TriggerRegisterVariableEvent( gg_trg_Illusionist3, "udg_AfterDamageEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_Illusionist3, Condition( function Trig_Illusionist3_Conditions ) )
    call TriggerAddAction( gg_trg_Illusionist3, function Trig_Illusionist3_Actions )
endfunction

