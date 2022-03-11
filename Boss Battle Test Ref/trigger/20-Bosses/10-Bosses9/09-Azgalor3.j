function Trig_Azgalor3_Conditions takes nothing returns boolean
    return GetUnitTypeId(udg_DamageEventTarget) == 'h011' and GetUnitLifePercent(udg_DamageEventTarget) <= 50
endfunction

function Trig_Azgalor3_Actions takes nothing returns nothing
    local integer id 
    local integer cyclA = 1

    call DisableTrigger( GetTriggeringTrigger() )
    loop
        exitwhen cyclA > 2
        set bj_lastCreatedUnit = CreateUnit( GetOwningPlayer( udg_DamageEventTarget ), 'h00O', GetUnitX( udg_DamageEventTarget ) + GetRandomReal(-400, 400), GetUnitY( udg_DamageEventTarget ) + GetRandomReal(-400, 400), GetRandomReal( 0, 360 ) )
        call DestroyEffect( AddSpecialEffectTarget( "Abilities\\Spells\\Other\\Doom\\DoomDeath.mdl", bj_lastCreatedUnit, "origin") )
        call UnitAddAbility( bj_lastCreatedUnit, 'A0K1')
        
        set id = GetHandleId( bj_lastCreatedUnit )
        if LoadTimerHandle( udg_hash, id, StringHash( "bszg" ) ) == null  then
            call SaveTimerHandle( udg_hash, id, StringHash( "bszg" ), CreateTimer() )
        endif
        set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "bszg" ) ) ) 
        call SaveUnitHandle( udg_hash, id, StringHash( "bszg" ), bj_lastCreatedUnit )
        call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( bj_lastCreatedUnit ), StringHash( "bszg" ) ), bosscast(1), true, function AzgCast )
        
        set id = GetHandleId( bj_lastCreatedUnit )
        if LoadTimerHandle( udg_hash, id, StringHash( "bszg1" ) ) == null  then
            call SaveTimerHandle( udg_hash, id, StringHash( "bszg1" ), CreateTimer() )
        endif
        set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "bszg1" ) ) ) 
        call SaveUnitHandle( udg_hash, id, StringHash( "bszg1" ), bj_lastCreatedUnit )
        call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( bj_lastCreatedUnit ), StringHash( "bszg1" ) ), bosscast(12), true, function Azg2Cast )
        set cyclA = cyclA + 1
    endloop
endfunction

//===========================================================================
function InitTrig_Azgalor3 takes nothing returns nothing
    set gg_trg_Azgalor3 = CreateTrigger(  )
    call DisableTrigger( gg_trg_Azgalor3 )
    call TriggerRegisterVariableEvent( gg_trg_Azgalor3, "udg_AfterDamageEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_Azgalor3, Condition( function Trig_Azgalor3_Conditions ) )
    call TriggerAddAction( gg_trg_Azgalor3, function Trig_Azgalor3_Actions )
endfunction

