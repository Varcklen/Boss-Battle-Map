function Trig_MountGiant3_Conditions takes nothing returns boolean
    return GetUnitTypeId( udg_DamageEventTarget ) == 'e000' and GetUnitLifePercent(udg_DamageEventTarget) <= 70
endfunction

function Trig_MountGiant3_Actions takes nothing returns nothing
    local unit u = GroupPickRandomUnit(udg_otryad)

    call DisableTrigger( GetTriggeringTrigger() )
    
	if u != null then
        call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\Human\\ThunderClap\\ThunderClapCaster.mdl", GetUnitX(u), GetUnitY(u) ) ) 
        call UnitStun(udg_DamageEventTarget, u, 10 )
	endif
    
	set u = null
endfunction

//===========================================================================
function InitTrig_MountGiant3 takes nothing returns nothing
    set gg_trg_MountGiant3 = CreateTrigger(  )
    call DisableTrigger( gg_trg_MountGiant3 )
    call TriggerRegisterVariableEvent( gg_trg_MountGiant3, "udg_AfterDamageEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_MountGiant3, Condition( function Trig_MountGiant3_Conditions ) )
    call TriggerAddAction( gg_trg_MountGiant3, function Trig_MountGiant3_Actions )
endfunction

