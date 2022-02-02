function Trig_Electro3_Conditions takes nothing returns boolean
    return GetUnitTypeId( udg_DamageEventTarget ) == 'n00Z' and GetUnitLifePercent( udg_DamageEventTarget ) <= 25
endfunction

function Trig_Electro3_Actions takes nothing returns nothing
    local integer id = GetHandleId( udg_DamageEventTarget )

    call DisableTrigger( GetTriggeringTrigger() )
    
    if LoadTimerHandle( udg_hash, id, StringHash( "bsel1" ) ) == null then 
        call SaveTimerHandle( udg_hash, id, StringHash( "bsel1" ), CreateTimer() )
    endif
	set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "bsel1" ) ) ) 
    call SaveUnitHandle( udg_hash, id, StringHash( "bsel1" ), udg_DamageEventTarget )
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( udg_DamageEventTarget ), StringHash( "bsel1" ) ), 2, true, function ElectroCast1 )
endfunction

//===========================================================================
function InitTrig_Electro3 takes nothing returns nothing
    set gg_trg_Electro3 = CreateTrigger(  )
    call DisableTrigger( gg_trg_Electro3 )
    call TriggerRegisterVariableEvent( gg_trg_Electro3, "udg_AfterDamageEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_Electro3, Condition( function Trig_Electro3_Conditions ) )
    call TriggerAddAction( gg_trg_Electro3, function Trig_Electro3_Actions )
endfunction

