//TESH.scrollpos=0
//TESH.alwaysfold=0
function Trig_DrunkMan2_Conditions takes nothing returns boolean
    return GetUnitTypeId(udg_DamageEventTarget) == 'n02U' and GetUnitLifePercent(udg_DamageEventTarget) <= 50
endfunction

function DrunkMan1Cast2 takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local integer cyclA = 1
    local unit boss = LoadUnitHandle( udg_hash, id, StringHash( "bsdm1" ))   
    local unit u

    if GetUnitState( boss, UNIT_STATE_LIFE) <= 0.405 or not( udg_fightmod[0] ) then
        call DestroyTimer( GetExpiredTimer() )
        call FlushChildHashtable( udg_hash, id )
    else
        loop
            exitwhen cyclA > 4
            set u = randomtarget( boss, 900, "enemy", "", "", "", "" )
            if u != null then
                call SetUnitAnimation( boss, "attack" )    
                call dummyspawn( boss, 1, 'A0XQ', 0, 0 )
                call IssueTargetOrder( bj_lastCreatedUnit, "drunkenhaze", u )
            endif
            set cyclA = cyclA + 1
        endloop
    endif

    set boss = null
    set u = null
endfunction

function Trig_DrunkMan2_Actions takes nothing returns nothing
    local integer id = GetHandleId( udg_DamageEventTarget )
    
    call DisableTrigger( GetTriggeringTrigger() )
    call DestroyEffect( AddSpecialEffectTarget( "Abilities\\Spells\\Human\\Thunderclap\\ThunderClapCaster.mdl", udg_DamageEventTarget, "origin") )
    
    if LoadTimerHandle( udg_hash, id, StringHash( "bsdm1" ) ) == null  then
        call SaveTimerHandle( udg_hash, id, StringHash( "bsdm1" ), CreateTimer() )
    endif
	set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "bsdm1" ) ) ) 
    call SaveUnitHandle( udg_hash, id, StringHash( "bsdm1" ), udg_DamageEventTarget )
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( udg_DamageEventTarget ), StringHash( "bsdm1" ) ), bosscast(8), true, function DrunkMan1Cast2 )
endfunction

//===========================================================================
function InitTrig_DrunkMan2 takes nothing returns nothing
    set gg_trg_DrunkMan2 = CreateTrigger(  )
    call DisableTrigger( gg_trg_DrunkMan2 )
    call TriggerRegisterVariableEvent( gg_trg_DrunkMan2, "udg_AfterDamageEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_DrunkMan2, Condition( function Trig_DrunkMan2_Conditions ) )
    call TriggerAddAction( gg_trg_DrunkMan2, function Trig_DrunkMan2_Actions )
endfunction

