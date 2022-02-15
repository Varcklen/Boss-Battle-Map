//TESH.scrollpos=0
//TESH.alwaysfold=0
function Trig_SlaveKing4_Conditions takes nothing returns boolean
    return GetUnitTypeId( udg_DamageEventTarget ) == 'o00F' and GetUnitLifePercent(udg_DamageEventTarget) <= 20
endfunction

function Trig_SlaveKing4_Actions takes nothing returns nothing
    local integer id = GetHandleId( udg_DamageEventTarget )
    
    call DisableTrigger( GetTriggeringTrigger() )
    
    if LoadTimerHandle( udg_hash, id, StringHash( "bssk" ) ) == null  then
        call SaveTimerHandle( udg_hash, id, StringHash( "bssk" ), CreateTimer() )
    endif
    set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "bssk" ) ) ) 
    call SaveUnitHandle( udg_hash, id, StringHash( "bssk" ), udg_DamageEventTarget )
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( udg_DamageEventTarget ), StringHash( "bssk" ) ), bosscast(1), true, function SlaveKingCast )
endfunction

//===========================================================================
function InitTrig_SlaveKing4 takes nothing returns nothing
    set gg_trg_SlaveKing4 = CreateTrigger(  )
    call DisableTrigger( gg_trg_SlaveKing4 )
    call TriggerRegisterVariableEvent( gg_trg_SlaveKing4, "udg_AfterDamageEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_SlaveKing4, Condition( function Trig_SlaveKing4_Conditions ) )
    call TriggerAddAction( gg_trg_SlaveKing4, function Trig_SlaveKing4_Actions )
endfunction

