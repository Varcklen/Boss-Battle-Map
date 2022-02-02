function Trig_Totem3_Conditions takes nothing returns boolean
    return GetUnitTypeId( udg_DamageEventTarget ) == 'o007' and GetUnitLifePercent( udg_DamageEventTarget ) <= 50
endfunction

function Trig_Totem3_Actions takes nothing returns nothing
    call DisableTrigger( GetTriggeringTrigger() )
    
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( udg_DamageEventTarget ), StringHash( "bstm1" ) ), bosscast(3), true, function TotemCast )
endfunction

//===========================================================================
function InitTrig_Totem3 takes nothing returns nothing
    set gg_trg_Totem3 = CreateTrigger(  )
    call DisableTrigger( gg_trg_Totem3 )
    call TriggerRegisterVariableEvent( gg_trg_Totem3, "udg_DamageEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_Totem3, Condition( function Trig_Totem3_Conditions ) )
    call TriggerAddAction( gg_trg_Totem3, function Trig_Totem3_Actions )
endfunction

