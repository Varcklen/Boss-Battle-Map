function Trig_Voidlord1_Conditions takes nothing returns boolean
    return GetUnitTypeId(udg_DamageEventTarget) == 'n00C'
endfunction

function Voidlord1Cast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer( ) )
    local unit boss = LoadUnitHandle( udg_hash, id, StringHash( "bbvd" ))
    local unit target 
    local integer cyclA = 1
    local integer i = 0

    if GetUnitState( boss, UNIT_STATE_LIFE) <= 0.405 or not( udg_fightmod[0] ) then
        call DestroyTimer( GetExpiredTimer() )
        call FlushChildHashtable( udg_hash, id )
    else
        loop
            exitwhen cyclA > 4
            if IsUnitHiddenBJ(udg_hero[cyclA]) then
                set cyclA = 4
                set i = 0
            elseif GetUnitState( udg_hero[cyclA], UNIT_STATE_LIFE) > 0.405 then
                set i = i + 1
            endif
            set cyclA = cyclA + 1
        endloop
        if i > 1 then
            set target = GroupPickRandomUnit(udg_otryad)
            if target != null then
                call PauseUnit( target, true )
                call ShowUnitHide( target )
                set bj_lastCreatedUnit = CreateUnit( Player(PLAYER_NEUTRAL_AGGRESSIVE), 'h008', GetUnitX( target ), GetUnitY( target ), 270 )
                call SaveUnitHandle( udg_hash, GetHandleId( bj_lastCreatedUnit ), StringHash( "egg" ), target )	
                call DestroyEffect( AddSpecialEffect("CallOfAggression.mdx", GetUnitX(bj_lastCreatedUnit), GetUnitY(bj_lastCreatedUnit) ) )
            endif
        endif
    endif
    
    set boss = null
    set target = null
endfunction

function Trig_Voidlord1_Actions takes nothing returns nothing
    local integer id = GetHandleId( udg_DamageEventTarget )

    call DisableTrigger( GetTriggeringTrigger() )    

    if LoadTimerHandle( udg_hash, id, StringHash( "bbvd" ) ) == null  then
        call SaveTimerHandle( udg_hash, id, StringHash( "bbvd" ), CreateTimer() )
    endif
	set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "bbvd" ) ) ) 
    call SaveUnitHandle( udg_hash, id, StringHash( "bbvd" ), udg_DamageEventTarget )
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( udg_DamageEventTarget ), StringHash( "bbvd" ) ), bosscast(15), true, function Voidlord1Cast )
endfunction

//===========================================================================
function InitTrig_Voidlord1 takes nothing returns nothing
    set gg_trg_Voidlord1 = CreateTrigger(  )
    call DisableTrigger( gg_trg_Voidlord1 )
    call TriggerRegisterVariableEvent( gg_trg_Voidlord1, "udg_AfterDamageEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_Voidlord1, Condition( function Trig_Voidlord1_Conditions ) )
    call TriggerAddAction( gg_trg_Voidlord1, function Trig_Voidlord1_Actions )
endfunction

