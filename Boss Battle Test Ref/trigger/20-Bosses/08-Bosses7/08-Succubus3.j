//TESH.scrollpos=0
//TESH.alwaysfold=0
function Trig_Succubus3_Conditions takes nothing returns boolean
    return GetUnitTypeId( udg_DamageEventTarget ) == 'n01S' and GetUnitLifePercent(udg_DamageEventTarget) <= 25
endfunction

function Trig_Succubus3_Actions takes nothing returns nothing
    local integer id 
    local unit u 
    local integer i = 0
    local integer cyclA = 1
    
    call DisableTrigger( GetTriggeringTrigger() )
    loop
        exitwhen cyclA > 4
        if GetUnitState(udg_hero[cyclA], UNIT_STATE_LIFE) > 0.405 then
            set i = i + 2
        endif
        set cyclA = cyclA + 1
    endloop
    set cyclA = 1
    loop
        exitwhen cyclA > i
        set u = GroupPickRandomUnit(udg_otryad)
        set bj_lastCreatedUnit = CreateUnit( GetOwningPlayer( udg_DamageEventTarget ), 'n036', GetUnitX( u ) + GetRandomReal(-400, 400), GetUnitY( u ) + GetRandomReal(-400, 400), GetRandomReal( 0, 360 ) )
        call DestroyEffect( AddSpecialEffectTarget( "Objects\\Spawnmodels\\Human\\HumanLargeDeathExplode\\HumanLargeDeathExplode.mdl", bj_lastCreatedUnit, "origin") )
        
        set id = GetHandleId( bj_lastCreatedUnit )
        if LoadTimerHandle( udg_hash, id, StringHash( "bssc" ) ) == null  then
            call SaveTimerHandle( udg_hash, id, StringHash( "bssc" ), CreateTimer() )
        endif
        call SaveUnitHandle( udg_hash, GetHandleId( bj_lastCreatedUnit ), StringHash( "bssc" ), bj_lastCreatedUnit )
        call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( bj_lastCreatedUnit ), StringHash( "bssc" ) ), bosscast(8), true, function SucCast )
        set cyclA = cyclA + 1
    endloop
    set u = null
endfunction

//===========================================================================
function InitTrig_Succubus3 takes nothing returns nothing
    set gg_trg_Succubus3 = CreateTrigger(  )
    call DisableTrigger( gg_trg_Succubus3 )
    call TriggerRegisterVariableEvent( gg_trg_Succubus3, "udg_AfterDamageEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_Succubus3, Condition( function Trig_Succubus3_Conditions ) )
    call TriggerAddAction( gg_trg_Succubus3, function Trig_Succubus3_Actions )
endfunction

