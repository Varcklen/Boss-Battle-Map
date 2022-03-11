function Trig_EnergyballA_Conditions takes nothing returns boolean
    return GetUnitTypeId(udg_DamageEventSource) == 'N039'
endfunction

function EnergyballACast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    call DestroyLightning( LoadLightningHandle( udg_hash, id, StringHash( "enba" ) ) )
    call FlushChildHashtable( udg_hash, id )
endfunction

function Trig_EnergyballA_Actions takes nothing returns nothing
    local lightning l = AddLightningEx("CLPB", true, GetUnitX(udg_DamageEventSource), GetUnitY(udg_DamageEventSource), GetUnitFlyHeight(udg_DamageEventSource) + 50, GetUnitX(udg_DamageEventTarget), GetUnitY(udg_DamageEventTarget), GetUnitFlyHeight(udg_DamageEventTarget) + 50 )
    local integer id = GetHandleId( l )

    call SaveTimerHandle( udg_hash, id, StringHash( "enba" ), CreateTimer() )
	set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "enba" ) ) ) 
	call SaveLightningHandle( udg_hash, id, StringHash( "enba" ), l )
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( l ), StringHash( "enba" ) ), 0.5, false, function EnergyballACast )
    
    set l = null
endfunction

//===========================================================================
function InitTrig_EnergyballA takes nothing returns nothing
    set gg_trg_EnergyballA = CreateTrigger(  )
    call TriggerRegisterVariableEvent( gg_trg_EnergyballA, "udg_DamageModifierEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_EnergyballA, Condition( function Trig_EnergyballA_Conditions ) )
    call TriggerAddAction( gg_trg_EnergyballA, function Trig_EnergyballA_Actions )
endfunction

