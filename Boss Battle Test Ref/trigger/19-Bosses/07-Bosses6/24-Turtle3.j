function Trig_Turtle3_Conditions takes nothing returns boolean
    return GetUnitTypeId( udg_DamageEventTarget ) == 'h01R' and GetUnitLifePercent(udg_DamageEventTarget) <= 70
endfunction

globals
    constant real TURTLE3_AOE_DAMAGE = 250
    constant real TURTLE3_AOE_RANGE = 300
endglobals

function Turtle3End takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local unit boss = LoadUnitHandle( udg_hash, id, StringHash( "bstt3u" ) )
    local unit dummy = LoadUnitHandle( udg_hash, id, StringHash( "bstt3d" ) )
    
    call DestroyEffect( AddSpecialEffect( "Objects\\Spawnmodels\\Naga\\NagaDeath\\NagaDeath.mdl", GetUnitX( dummy ), GetUnitY( dummy ) + 100 ) )
    call DestroyEffect( AddSpecialEffect( "Objects\\Spawnmodels\\Naga\\NagaDeath\\NagaDeath.mdl", GetUnitX( dummy ) + 140, GetUnitY( dummy ) - 140 ) )
    call DestroyEffect( AddSpecialEffect( "Objects\\Spawnmodels\\Naga\\NagaDeath\\NagaDeath.mdl", GetUnitX( dummy ) - 140, GetUnitY( dummy ) - 140 ) )
    
    call GroupAoE(boss, dummy, GetUnitX( dummy ), GetUnitY( dummy ), TURTLE3_AOE_DAMAGE, TURTLE3_AOE_RANGE, TARGET_ENEMY, null, null)
    
    call RemoveUnit( dummy )
    
    call FlushChildHashtable( udg_hash, id )

    set boss = null
    set dummy = null
endfunction 

function Turtle3Cast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local integer id1
    local unit boss = LoadUnitHandle( udg_hash, id, StringHash( "bstt3" ) )

    if GetUnitState( boss, UNIT_STATE_LIFE) <= 0.405 or not( udg_fightmod[0] ) then
        call DestroyTimer( GetExpiredTimer() )
        call FlushChildHashtable( udg_hash, id )
    else
        set bj_lastCreatedUnit = CreateUnit( GetOwningPlayer( boss ), 'u000', GetUnitX( boss ) + GetRandomReal(-500, 500), GetUnitY( boss ) + GetRandomReal(-500, 500), 270 )
        call SetUnitScale(bj_lastCreatedUnit, 3, 3, 3 )
        call UnitAddAbility( bj_lastCreatedUnit, 'A136')
        
        set id1 = GetHandleId( bj_lastCreatedUnit )
        if LoadTimerHandle( udg_hash, id1, StringHash( "bstt3d" ) ) == null  then
            call SaveTimerHandle( udg_hash, id1, StringHash( "bstt3d" ), CreateTimer() )
        endif
        set id1 = GetHandleId( LoadTimerHandle( udg_hash, id1, StringHash( "bstt3d" ) ) ) 
        call SaveUnitHandle( udg_hash, id1, StringHash( "bstt3d" ), bj_lastCreatedUnit )
        call SaveUnitHandle( udg_hash, id1, StringHash( "bstt3u" ), boss )
        call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( bj_lastCreatedUnit ), StringHash( "bstt3d" ) ), bosscast(3), false, function Turtle3End )
    endif
    
    set boss = null
endfunction

function Trig_Turtle3_Actions takes nothing returns nothing
    local integer id = GetHandleId( udg_DamageEventTarget )

    call DisableTrigger( GetTriggeringTrigger() )

    if LoadTimerHandle( udg_hash, id, StringHash( "bstt3" ) ) == null then 
        call SaveTimerHandle( udg_hash, id, StringHash( "bstt3" ), CreateTimer() )
    endif
	set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "bstt3" ) ) ) 
    call SaveUnitHandle( udg_hash, id, StringHash( "bstt3" ), udg_DamageEventTarget )
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( udg_DamageEventTarget ), StringHash( "bstt3" ) ), bosscast(3), true, function Turtle3Cast )
endfunction

//===========================================================================
function InitTrig_Turtle3 takes nothing returns nothing
    set gg_trg_Turtle3 = CreateTrigger(  )
    call DisableTrigger( gg_trg_Turtle3 )
    call TriggerRegisterVariableEvent( gg_trg_Turtle3, "udg_AfterDamageEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_Turtle3, Condition( function Trig_Turtle3_Conditions ) )
    call TriggerAddAction( gg_trg_Turtle3, function Trig_Turtle3_Actions )
endfunction

