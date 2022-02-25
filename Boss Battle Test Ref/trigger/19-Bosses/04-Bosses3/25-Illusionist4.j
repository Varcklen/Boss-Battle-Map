//TESH.scrollpos=0
//TESH.alwaysfold=0
function Trig_Illusionist4_Conditions takes nothing returns boolean
    return GetUnitTypeId(udg_DamageEventTarget) == 'h020' and GetUnitLifePercent(udg_DamageEventTarget) <= 25
endfunction

function Trig_Illusionist4_Actions takes nothing returns nothing
    local integer rand = GetRandomInt( 1, 2 )
    
    call DisableTrigger( GetTriggeringTrigger() )
    if rand == 1 then
    	call SaveBoolean( udg_hash, GetHandleId( udg_DamageEventTarget ), StringHash( "bsilb" ), false )
    endif
    call DestroyEffect( AddSpecialEffectTarget( "Abilities\\Spells\\Undead\\DarkRitual\\DarkRitualTarget.mdl", udg_DamageEventTarget, "origin") )
endfunction

//===========================================================================
function InitTrig_Illusionist4 takes nothing returns nothing
    set gg_trg_Illusionist4 = CreateTrigger(  )
    call DisableTrigger( gg_trg_Illusionist4 )
    call TriggerRegisterVariableEvent( gg_trg_Illusionist4, "udg_AfterDamageEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_Illusionist4, Condition( function Trig_Illusionist4_Conditions ) )
    call TriggerAddAction( gg_trg_Illusionist4, function Trig_Illusionist4_Actions )
endfunction

