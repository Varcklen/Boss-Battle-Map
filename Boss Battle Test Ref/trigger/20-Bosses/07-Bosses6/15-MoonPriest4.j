function Trig_MoonPriest4_Conditions takes nothing returns boolean
    return GetUnitTypeId( udg_DamageEventTarget ) == 'e005' and GetUnitLifePercent(udg_DamageEventTarget) <= 20
endfunction

function Trig_MoonPriest4_Actions takes nothing returns nothing
    local integer id = GetHandleId( udg_DamageEventTarget )
    local group g = CreateGroup()
    local unit u

    call DisableTrigger( GetTriggeringTrigger() )
    
    if LoadTimerHandle( udg_hash, id, StringHash( "bsmp" ) ) == null  then
        call SaveTimerHandle( udg_hash, id, StringHash( "bsmp" ), CreateTimer() )
    endif
	set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "bsmp" ) ) ) 
    call SaveUnitHandle( udg_hash, id, StringHash( "bsmp" ), udg_DamageEventTarget )
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( udg_DamageEventTarget ), StringHash( "bsmp" ) ), bosscast(3.5), true, function MoonPriestCast )
    
    call GroupClear( g )
    call DestroyGroup( g )
    set g = null
    set u = null
endfunction

//===========================================================================
function InitTrig_MoonPriest4 takes nothing returns nothing
    set gg_trg_MoonPriest4 = CreateTrigger(  )
    call DisableTrigger( gg_trg_MoonPriest4 )
    call TriggerRegisterVariableEvent( gg_trg_MoonPriest4, "udg_AfterDamageEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_MoonPriest4, Condition( function Trig_MoonPriest4_Conditions ) )
    call TriggerAddAction( gg_trg_MoonPriest4, function Trig_MoonPriest4_Actions )
endfunction

