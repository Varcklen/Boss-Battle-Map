function Trig_Thief2_Conditions takes nothing returns boolean
    return GetUnitTypeId(udg_DamageEventTarget) == 'h015' and GetUnitLifePercent(udg_DamageEventTarget) <= 50 and GetOwningPlayer(udg_DamageEventTarget) == Player(10)
endfunction

function Thief2End takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )

    call UnitRemoveAbility( LoadUnitHandle( udg_hash, id, StringHash( "bsthtrg" ) ), 'A0XU' )
    call UnitRemoveAbility( LoadUnitHandle( udg_hash, id, StringHash( "bsthtrg" ) ), 'B03T' )
    call FlushChildHashtable( udg_hash, id )
endfunction

function Thief2Cast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local integer id1
    local integer cyclA = 1
    local unit boss = LoadUnitHandle( udg_hash, id, StringHash( "bsth2" ) )
    
    if GetUnitState( boss, UNIT_STATE_LIFE) <= 0.405 or not( udg_fightmod[0] ) then
        call DestroyTimer( GetExpiredTimer() )
        call FlushChildHashtable( udg_hash, id )
    else
        loop
            exitwhen cyclA > 4
            if GetUnitState( udg_hero[cyclA], UNIT_STATE_LIFE) > 0.405 then
                call DestroyEffect( AddSpecialEffectTarget( "Abilities\\Spells\\Undead\\AnimateDead\\AnimateDeadTarget.mdl", udg_hero[cyclA], "origin") )
                call UnitAddAbility( udg_hero[cyclA], 'A0XU')
                
                set id1 = GetHandleId( udg_hero[cyclA] )
                if LoadTimerHandle( udg_hash, id1, StringHash( "bsthtrg" ) ) == null  then
                    call SaveTimerHandle( udg_hash, id1, StringHash( "bsthtrg" ), CreateTimer() )
                endif
                set id1 = GetHandleId( LoadTimerHandle( udg_hash, id1, StringHash( "bsthtrg" ) ) ) 
                call SaveUnitHandle( udg_hash, id1, StringHash( "bsthtrg" ), udg_hero[cyclA] )
                call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( udg_hero[cyclA] ), StringHash( "bsthtrg" ) ), 2.5, false, function Thief2End )
            endif
            set cyclA = cyclA + 1
        endloop
    endif
    
    set boss = null
endfunction

function Trig_Thief2_Actions takes nothing returns nothing
    local integer id = GetHandleId( udg_DamageEventTarget )

    call DisableTrigger( GetTriggeringTrigger() )

    if LoadTimerHandle( udg_hash, id, StringHash( "bsth2" ) ) == null  then
        call SaveTimerHandle( udg_hash, id, StringHash( "bsth2" ), CreateTimer() )
    endif
	set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "bsth2" ) ) ) 
    call SaveUnitHandle( udg_hash, id, StringHash( "bsth2" ), udg_DamageEventTarget )
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( udg_DamageEventTarget ), StringHash( "bsth2" ) ), bosscast(5), true, function Thief2Cast )
endfunction

//===========================================================================
function InitTrig_Thief2 takes nothing returns nothing
    set gg_trg_Thief2 = CreateTrigger(  )
    call DisableTrigger( gg_trg_Thief2 )
    call TriggerRegisterVariableEvent( gg_trg_Thief2, "udg_AfterDamageEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_Thief2, Condition( function Trig_Thief2_Conditions ) )
    call TriggerAddAction( gg_trg_Thief2, function Trig_Thief2_Actions )
endfunction

