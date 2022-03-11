function Trig_Crab2_Conditions takes nothing returns boolean
    return GetUnitTypeId( udg_DamageEventTarget ) == 'n009' and GetUnitLifePercent(udg_DamageEventTarget) <= 90
endfunction

function Crab2Cast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local unit boss = LoadUnitHandle( udg_hash, id, StringHash( "bscr" ) )
    local integer cyclA = 1
    local integer cyclAEnd = LoadInteger( udg_hash, id, StringHash( "bscr" ) )

    if GetUnitState( boss, UNIT_STATE_LIFE) <= 0.405 or not( udg_fightmod[0] ) then
        call DestroyTimer( GetExpiredTimer() )
        call FlushChildHashtable( udg_hash, id )
    else
        loop
            exitwhen cyclA > cyclAEnd
            set bj_lastCreatedUnit = CreateUnit( GetOwningPlayer( boss ), 'u000', GetUnitX( boss ) + GetRandomReal(-600, 600), GetUnitY( boss ) + GetRandomReal(-600, 600), GetRandomReal( 0, 360 ) )
            call UnitApplyTimedLife( bj_lastCreatedUnit, 'BTLF', 1)
            call UnitAddAbility( bj_lastCreatedUnit, 'A0E5' )
            call IssuePointOrder( bj_lastCreatedUnit, "carrionswarm", GetUnitX( bj_lastCreatedUnit ), GetUnitY( bj_lastCreatedUnit ) )
            call DestroyEffect( AddSpecialEffectTarget( "Abilities\\Spells\\Undead\\FrostNova\\FrostNovaTarget.mdl", bj_lastCreatedUnit, "origin" ) )
            set cyclA = cyclA + 1
        endloop
    endif
    
    set boss = null
endfunction

function Trig_Crab2_Actions takes nothing returns nothing
    local integer id = GetHandleId( udg_DamageEventTarget )
    
    call DisableTrigger( GetTriggeringTrigger() )
    call DestroyEffect( AddSpecialEffectTarget( "Abilities\\Spells\\Undead\\FrostNova\\FrostNovaTarget.mdl", udg_DamageEventTarget, "origin" ) )
    call UnitAddAbility(udg_DamageEventTarget,  'A01Y' )
    
    if LoadTimerHandle( udg_hash, id, StringHash( "bscr" ) ) == null  then
        call SaveTimerHandle( udg_hash, id, StringHash( "bscr" ), CreateTimer() )
    endif
    set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "bscr" ) ) ) 
    call SaveUnitHandle( udg_hash, id, StringHash( "bscr" ), udg_DamageEventTarget )
    call SaveInteger( udg_hash, id, StringHash( "bscr" ), 5 )
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( udg_DamageEventTarget ), StringHash( "bscr" ) ), bosscast(7), true, function Crab2Cast )
endfunction

//===========================================================================
function InitTrig_Crab2 takes nothing returns nothing
    set gg_trg_Crab2 = CreateTrigger(  )
    call DisableTrigger( gg_trg_Crab2 )
    call TriggerRegisterVariableEvent( gg_trg_Crab2, "udg_AfterDamageEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_Crab2, Condition( function Trig_Crab2_Conditions ) )
    call TriggerAddAction( gg_trg_Crab2, function Trig_Crab2_Actions )
endfunction

