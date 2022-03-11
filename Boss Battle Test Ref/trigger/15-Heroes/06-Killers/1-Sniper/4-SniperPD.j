function Trig_SniperPD_Conditions takes nothing returns boolean
    return IsUnitEnemy(udg_DamageEventSource, GetOwningPlayer(udg_DamageEventTarget)) and GetUnitAbilityLevel( udg_DamageEventTarget, 'A0LA') > 0 and udg_DamageEventAmount > 0
endfunction

function Trig_SniperPD_Actions takes nothing returns nothing
    local integer id = GetHandleId( udg_DamageEventTarget )
    
    call UnitRemoveAbility( udg_DamageEventTarget, 'A18P' )
    call UnitRemoveAbility( udg_DamageEventTarget, 'A18Q' ) 
    call UnitRemoveAbility( udg_DamageEventTarget, 'A18R' ) 
    call UnitRemoveAbility( udg_DamageEventTarget, 'B031' ) 
    
    //if LoadTimerHandle( udg_hash, id, StringHash( "snp" ) ) == null then
        //call SaveTimerHandle( udg_hash, id, StringHash( "snp" ), CreateTimer() )
    //endif
	//call SaveTimerHandle( udg_hash, id, StringHash( "snp" ), CreateTimer( ) ) 
	//set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "snp" ) ) ) 
	//call SaveUnitHandle( udg_hash, id, StringHash( "snp" ), udg_DamageEventTarget ) 
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( udg_DamageEventTarget ), StringHash( "snp" ) ), 4, false, function SniperPCast ) 
endfunction

//===========================================================================
function InitTrig_SniperPD takes nothing returns nothing
    set gg_trg_SniperPD = CreateTrigger(  )
    call TriggerRegisterVariableEvent( gg_trg_SniperPD, "udg_AfterDamageEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_SniperPD, Condition( function Trig_SniperPD_Conditions ) )
    call TriggerAddAction( gg_trg_SniperPD, function Trig_SniperPD_Actions )
endfunction

