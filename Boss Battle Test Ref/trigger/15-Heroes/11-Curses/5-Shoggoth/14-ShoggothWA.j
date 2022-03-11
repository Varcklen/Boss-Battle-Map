function Trig_ShoggothWA_Conditions takes nothing returns boolean
    return GetUnitAbilityLevel(udg_DamageEventSource, 'A124') > 0 and IsUnitEnemy(udg_DamageEventSource, GetOwningPlayer(udg_DamageEventTarget))
endfunction

function ShoggothWACast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    call UnitRemoveAbility( LoadUnitHandle( udg_hash, id, StringHash( "shgw1" ) ), 'A12Y' )
    call UnitRemoveAbility( LoadUnitHandle( udg_hash, id, StringHash( "shgw1" ) ), 'B06U' )
    call FlushChildHashtable( udg_hash, id )
endfunction

function Trig_ShoggothWA_Actions takes nothing returns nothing
    local integer lvl = LoadInteger( udg_hash, GetHandleId( udg_DamageEventSource ), StringHash( "shgw" ) )
    local integer id

	call UnitAddAbility( udg_DamageEventTarget, 'A12Y' )
	call SetUnitAbilityLevel( udg_DamageEventTarget, 'A12E', lvl )
	
	set id = GetHandleId( udg_DamageEventTarget )
	if LoadTimerHandle( udg_hash, id, StringHash( "shgw1" ) ) == null  then
		call SaveTimerHandle( udg_hash, id, StringHash( "shgw1" ), CreateTimer() )
	endif
	set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "shgw1" ) ) ) 
	call SaveUnitHandle( udg_hash, id, StringHash( "shgw1" ), udg_DamageEventTarget )
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( udg_DamageEventTarget ), StringHash( "shgw1" ) ), 10, false, function ShoggothWACast )

	if BuffLogic() then
		call debuffst( udg_DamageEventSource, udg_DamageEventTarget, null, 1, 10 )
	endif
endfunction

//===========================================================================
function InitTrig_ShoggothWA takes nothing returns nothing
    set gg_trg_ShoggothWA = CreateTrigger(  )
    call TriggerRegisterVariableEvent( gg_trg_ShoggothWA, "udg_DamageModifierEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_ShoggothWA, Condition( function Trig_ShoggothWA_Conditions ) )
    call TriggerAddAction( gg_trg_ShoggothWA, function Trig_ShoggothWA_Actions )
endfunction