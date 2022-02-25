function Trig_Manipulator1_Conditions takes nothing returns boolean
    return GetUnitTypeId(udg_DamageEventTarget) == 'n02W'
endfunction

function Manipulator1Cast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local unit boss = LoadUnitHandle( udg_hash, id, StringHash( "bsmn2" ) )
    local integer c = LoadInteger( udg_hash, id, StringHash( "bsmn2" ) ) - 1

    if GetUnitState( boss, UNIT_STATE_LIFE) <= 0.405 or not( udg_fightmod[0] ) then
        call FlushChildHashtable( udg_hash, id )
        call DestroyTimer( GetExpiredTimer() )
    else
        call SaveInteger( udg_hash, id, StringHash( "bsmn2" ), c )
        if c <= 0 then
            call heroswap()
            call FlushChildHashtable( udg_hash, id )
            call DestroyTimer( GetExpiredTimer() )
        else
            call DisplayTimedTextToForce( bj_FORCE_ALL_PLAYERS, 5, I2S(c) + "..." )
        endif
    endif
    
    set boss = null
endfunction

function Trig_Manipulator1_Actions takes nothing returns nothing
    local integer id = GetHandleId( udg_DamageEventTarget )
    
    call DisableTrigger( GetTriggeringTrigger() )
    call StartSound(gg_snd_Warning)
    call DisplayTimedTextToForce( bj_FORCE_ALL_PLAYERS, 5, "|cffff0000Warning!|r The souls of the heroes will swap in..." )
    
    if LoadTimerHandle( udg_hash, id, StringHash( "bsmn2" ) ) == null  then
        call SaveTimerHandle( udg_hash, id, StringHash( "bsmn2" ), CreateTimer() )
    endif
    set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "bsmn2" ) ) ) 
    call SaveUnitHandle( udg_hash, id, StringHash( "bsmn2" ), udg_DamageEventTarget )
    call SaveInteger( udg_hash, id, StringHash( "bsmn2" ), 4 )
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( udg_DamageEventTarget ), StringHash( "bsmn2" ) ), 1, true, function Manipulator1Cast )
endfunction

//===========================================================================
function InitTrig_Manipulator1 takes nothing returns nothing
    set gg_trg_Manipulator1 = CreateTrigger(  )
    call DisableTrigger( gg_trg_Manipulator1 )
    call TriggerRegisterVariableEvent( gg_trg_Manipulator1, "udg_AfterDamageEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_Manipulator1, Condition( function Trig_Manipulator1_Conditions ) )
    call TriggerAddAction( gg_trg_Manipulator1, function Trig_Manipulator1_Actions )
endfunction

