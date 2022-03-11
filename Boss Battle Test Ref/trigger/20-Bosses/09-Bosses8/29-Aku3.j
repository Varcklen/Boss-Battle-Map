function Trig_Aku3_Conditions takes nothing returns boolean
    return GetUnitTypeId(udg_DamageEventTarget) == 'n04O'
endfunction

function Aku3Cast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local unit boss = LoadUnitHandle( udg_hash, id, StringHash( "bsdl3" ) )

    if GetUnitState( boss, UNIT_STATE_LIFE) <= 0.405 or not( udg_fightmod[0] ) then
        call DestroyTimer( GetExpiredTimer() )
        call FlushChildHashtable( udg_hash, id )
    else
        set bj_lastCreatedUnit = CreateUnit( GetOwningPlayer( boss ), 'n04P', GetUnitX( boss ) + GetRandomReal( -120, 120 ), GetUnitY( boss ) + GetRandomReal( -120, 120 ), GetRandomReal(0, 360) )
        call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Orc\\MirrorImage\\MirrorImageCaster.mdl", bj_lastCreatedUnit, "origin") )
        call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Orc\\MirrorImage\\MirrorImageCaster.mdl", boss, "origin") )
        call UnitApplyTimedLife( bj_lastCreatedUnit , 'BTLF', 10 )
        call SetUnitState(bj_lastCreatedUnit, UNIT_STATE_LIFE, GetUnitState(boss, UNIT_STATE_LIFE))
    endif
    
    set boss = null
endfunction

function Trig_Aku3_Actions takes nothing returns nothing
    local integer id = GetHandleId( udg_DamageEventTarget )
    
    call DisableTrigger( GetTriggeringTrigger() )
    
    if LoadTimerHandle( udg_hash, id, StringHash( "bsdl3" ) ) == null  then
        call SaveTimerHandle( udg_hash, id, StringHash( "bsdl3" ), CreateTimer() )
    endif
	set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "bsdl3" ) ) ) 
    call SaveUnitHandle( udg_hash, id, StringHash( "bsdl3" ), udg_DamageEventTarget )
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( udg_DamageEventTarget ), StringHash( "bsdl3" ) ), bosscast(15), true, function Aku3Cast )
endfunction

//===========================================================================
function InitTrig_Aku3 takes nothing returns nothing
    set gg_trg_Aku3 = CreateTrigger()
    call DisableTrigger( gg_trg_Aku3 )
    call TriggerRegisterVariableEvent( gg_trg_Aku3, "udg_AfterDamageEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_Aku3, Condition( function Trig_Aku3_Conditions ) )
    call TriggerAddAction( gg_trg_Aku3, function Trig_Aku3_Actions )
endfunction

