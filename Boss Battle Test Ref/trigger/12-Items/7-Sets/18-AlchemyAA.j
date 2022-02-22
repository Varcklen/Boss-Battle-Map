function Trig_AlchemyAA_Conditions takes nothing returns boolean
    return not( udg_IsDamageSpell ) and GetUnitAbilityLevel(udg_DamageEventSource, 'B08X') > 0 and luckylogic( udg_DamageEventSource, 8, 1, 100 )
endfunction

function AlchemyAACast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer( ) )
    local unit u = LoadUnitHandle( udg_hash, id, StringHash( "alch" ) ) 
    
    set udg_Caster = u
    set udg_RandomLogic = true
    call TriggerExecute( udg_DB_Trigger_Pot[GetRandomInt(1, 10)] )
    call FlushChildHashtable( udg_hash, id )
    
    set u = null
endfunction

function Trig_AlchemyAA_Actions takes nothing returns nothing
    local integer id = GetHandleId( udg_DamageEventSource )

    call SaveTimerHandle( udg_hash, id, StringHash( "alch" ), CreateTimer() )
    set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "alch" ) ) ) 
    call SaveUnitHandle( udg_hash, id, StringHash( "alch" ), udg_DamageEventSource )
    call SaveBoolean( udg_hash, GetHandleId( udg_DamageEventSource ), StringHash( "alch" ), true )
    call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( udg_DamageEventSource ), StringHash( "alch" ) ), 0.01, false, function AlchemyAACast )
endfunction

//===========================================================================
function InitTrig_AlchemyAA takes nothing returns nothing
    set gg_trg_AlchemyAA = CreateTrigger(  )
    call TriggerRegisterVariableEvent( gg_trg_AlchemyAA, "udg_DamageModifierEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_AlchemyAA, Condition( function Trig_AlchemyAA_Conditions ) )
    call TriggerAddAction( gg_trg_AlchemyAA, function Trig_AlchemyAA_Actions )
endfunction