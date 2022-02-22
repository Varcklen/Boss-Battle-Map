function Trig_Norepinephrine_Conditions takes nothing returns boolean
    return not( udg_IsDamageSpell ) and inv( udg_DamageEventSource, 'I0DS') > 0 and GetUnitState( udg_DamageEventSource, UNIT_STATE_LIFE) > 0.405 and not(LoadBoolean( udg_hash, GetHandleId( udg_DamageEventSource ), StringHash( "nrad" ) ) )
endfunction

function NorepinephrineCast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer( ) )
    local unit u = LoadUnitHandle( udg_hash, id, StringHash( "nrad" ) )
    local item it = LoadItemHandle( udg_hash, id, StringHash( "nrad" ) )
    
	call SaveBoolean( udg_hash, GetHandleId( u ), StringHash( "nrad" ), false )
	//call BlzItemRemoveAbilityBJ( it, 'A0F0' )
    call FlushChildHashtable( udg_hash, id )

    set u = null
    set it = null
endfunction

function Trig_Norepinephrine_Actions takes nothing returns nothing
    local unit caster = udg_DamageEventSource
    local item it = GetItemOfTypeFromUnitBJ( caster, 'I0DS')
    local integer id = GetHandleId( caster )

	call SaveBoolean( udg_hash, GetHandleId( caster ), StringHash( "nrad" ), true ) 

	//call BlzItemAddAbilityBJ( it, 'A0F0' )

    call bufst( caster, caster, 'A0EA', 'B07S', "nradb", 0.5 )

    //call BlzStartUnitAbilityCooldown( caster, 'A0F0', 1.2 )

    if LoadTimerHandle( udg_hash, id, StringHash( "nrad" ) ) == null then
        call SaveTimerHandle( udg_hash, id, StringHash( "nrad" ), CreateTimer() )
    endif
	call SaveTimerHandle( udg_hash, id, StringHash( "nrad" ), CreateTimer( ) ) 
	set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "nrad" ) ) ) 
	call SaveUnitHandle( udg_hash, id, StringHash( "nrad" ), caster ) 
	call SaveItemHandle( udg_hash, id, StringHash( "nradt" ), it )
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( caster ), StringHash( "nrad" ) ), 1.2, false, function NorepinephrineCast ) 

	set it = null
	set caster = null
endfunction

//===========================================================================
function InitTrig_Norepinephrine takes nothing returns nothing
    set gg_trg_Norepinephrine = CreateTrigger(  )
    call TriggerRegisterVariableEvent( gg_trg_Norepinephrine, "udg_AfterDamageEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_Norepinephrine, Condition( function Trig_Norepinephrine_Conditions ) )
    call TriggerAddAction( gg_trg_Norepinephrine, function Trig_Norepinephrine_Actions )
endfunction

