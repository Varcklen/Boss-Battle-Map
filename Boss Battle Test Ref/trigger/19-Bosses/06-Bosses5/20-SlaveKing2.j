function Trig_SlaveKing2_Conditions takes nothing returns boolean
    return GetUnitTypeId( udg_DamageEventTarget ) == 'o00F' and GetUnitLifePercent(udg_DamageEventTarget) <= 60
endfunction

function Trig_SlaveKing2_Actions takes nothing returns nothing
    local integer id = GetHandleId( udg_DamageEventTarget )
    
    call DisableTrigger( GetTriggeringTrigger() )
    
    if LoadTimerHandle( udg_hash, id, StringHash( "bssk" ) ) == null  then
        call SaveTimerHandle( udg_hash, id, StringHash( "bssk" ), CreateTimer() )
    endif
    set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "bssk" ) ) ) 
    call SaveUnitHandle( udg_hash, id, StringHash( "bssk" ), udg_DamageEventTarget )
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( udg_DamageEventTarget ), StringHash( "bssk" ) ), bosscast(2), true, function SlaveKingCast )
endfunction

//===========================================================================
function InitTrig_SlaveKing2 takes nothing returns nothing
    set gg_trg_SlaveKing2 = CreateTrigger(  )
    call DisableTrigger( gg_trg_SlaveKing2 )
    call TriggerRegisterVariableEvent( gg_trg_SlaveKing2, "udg_AfterDamageEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_SlaveKing2, Condition( function Trig_SlaveKing2_Conditions ) )
    call TriggerAddAction( gg_trg_SlaveKing2, function Trig_SlaveKing2_Actions )
endfunction

