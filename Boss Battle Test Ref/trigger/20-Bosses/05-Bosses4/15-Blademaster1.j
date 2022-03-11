function Trig_Blademaster1_Conditions takes nothing returns boolean
    return GetUnitTypeId(udg_DamageEventTarget) == 'e001'
endfunction

function BlademasterMove takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local unit boss = LoadUnitHandle( udg_hash, id, StringHash( "bsbmb" ) )
    local unit dummy = LoadUnitHandle( udg_hash, id, StringHash( "bsbm" ) )
    local unit target = LoadUnitHandle( udg_hash, id, StringHash( "bsbmh" ) )       
    
    if not( udg_fightmod[0] ) or GetUnitState( boss, UNIT_STATE_LIFE) <= 0.405 or GetUnitState( dummy, UNIT_STATE_LIFE) <= 0.405 then
        call RemoveUnit( dummy )
        call DestroyTimer( GetExpiredTimer() )
        call FlushChildHashtable( udg_hash, id )
    else
        call IssuePointOrder( dummy, "move", GetUnitX( target ), GetUnitY( target ) )
    endif
    
    set dummy = null
    set target = null
    set boss = null
endfunction   
    
function Trig_Blademaster1_Actions takes nothing returns nothing
    local integer id
	local integer cyclA = 1

    call DisableTrigger( GetTriggeringTrigger() )

    loop
        exitwhen cyclA > 4
        if udg_hero[cyclA] != null then 
            set bj_lastCreatedUnit = CreateUnit( GetOwningPlayer( udg_DamageEventTarget ), 'u000', GetUnitX( udg_hero[cyclA] ) + GetRandomReal(-400,400), GetUnitY( udg_hero[cyclA] ) + GetRandomReal(-400,400), 270 )
            call UnitAddAbility( bj_lastCreatedUnit, 'A06N')
            call UnitAddAbility( bj_lastCreatedUnit, 'A05U')
            call IssuePointOrder( bj_lastCreatedUnit, "move", GetUnitX( udg_hero[cyclA] ), GetUnitY( udg_hero[cyclA] ) )
    
            set id = GetHandleId( bj_lastCreatedUnit )
            if LoadTimerHandle( udg_hash, id, StringHash( "bsbm" ) ) == null  then
                call SaveTimerHandle( udg_hash, id, StringHash( "bsbm" ), CreateTimer() )
            endif
	        set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "bsbm" ) ) ) 
            call SaveUnitHandle( udg_hash, id, StringHash( "bsbm" ), bj_lastCreatedUnit )
            call SaveUnitHandle( udg_hash, id, StringHash( "bsbmb" ), udg_DamageEventTarget )
            call SaveUnitHandle( udg_hash, id, StringHash( "bsbmh" ), udg_hero[cyclA] )
	        call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( bj_lastCreatedUnit ), StringHash( "bsbm" ) ), bosscast(10), true, function BlademasterMove )
	    endif
	    set cyclA = cyclA + 1
    endloop  

endfunction

//===========================================================================
function InitTrig_Blademaster1 takes nothing returns nothing
    set gg_trg_Blademaster1 = CreateTrigger(  )
    call DisableTrigger( gg_trg_Blademaster1 )
    call TriggerRegisterVariableEvent( gg_trg_Blademaster1, "udg_AfterDamageEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_Blademaster1, Condition( function Trig_Blademaster1_Conditions ) )
    call TriggerAddAction( gg_trg_Blademaster1, function Trig_Blademaster1_Actions )
endfunction

