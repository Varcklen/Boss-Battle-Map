function Trig_Metal_MageQA_Conditions takes nothing returns boolean
    return GetUnitAbilityLevel( udg_DamageEventSource, 'B06H') > 0 and not( udg_IsDamageSpell )
endfunction

function Trig_Metal_MageQA_Actions takes nothing returns nothing
    local integer id = GetHandleId( LoadTimerHandle( udg_hash, GetHandleId( udg_DamageEventSource ), StringHash( "mtmq" ) ) ) 
    local integer i = LoadInteger( udg_hash, id, StringHash( "mtmq" ) ) - 1
    
    call SaveInteger( udg_hash, id, StringHash( "mtmq" ), i )

    if i <= 0 then
        call UnitRemoveAbility( udg_DamageEventSource, 'A0KP' )
        call UnitRemoveAbility( udg_DamageEventSource, 'B06H' )
        call DestroyTimer( LoadTimerHandle( udg_hash, id, StringHash( "mtmq" ) ) )
        call FlushChildHashtable( udg_hash, id )
    endif
endfunction

//===========================================================================
function InitTrig_Metal_MageQA takes nothing returns nothing
    set gg_trg_Metal_MageQA = CreateTrigger(  )
    call TriggerRegisterVariableEvent( gg_trg_Metal_MageQA, "udg_DamageModifierEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_Metal_MageQA, Condition( function Trig_Metal_MageQA_Conditions ) )
    call TriggerAddAction( gg_trg_Metal_MageQA, function Trig_Metal_MageQA_Actions )
endfunction

