function Trig_Metal_MageQPas_Conditions takes nothing returns boolean
    return GetLearnedSkill() == 'A0KM'
endfunction

function Metal_MageQPasCast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer( ) )
    local unit caster = LoadUnitHandle( udg_hash, id, StringHash( "mtmqp" ) )
    local real arm = LoadReal( udg_hash, id, StringHash( "mtmqp" ) )
    local real spd = (BlzGetUnitArmor(caster) - arm) * LoadInteger( udg_hash, id, StringHash( "mtmqp" ) )
    local real spdnow = LoadReal( udg_hash, GetHandleId( caster ), StringHash( "mtmqpn" ) )
    
	if GetUnitAbilityLevel(caster, 'A0KM') == 0 then
        call spdst( caster, -spdnow )
        call SaveReal( udg_hash, GetHandleId( caster ), StringHash( "mtmqpn" ), 0 )
        call FlushChildHashtable( udg_hash, id )
        call DestroyTimer( GetExpiredTimer() )
    elseif arm != BlzGetUnitArmor(caster) then
        call spdst( caster, spd )
		call SaveReal( udg_hash, GetHandleId( caster ), StringHash( "mtmqpn" ), spdnow + spd ) 
        call SaveReal( udg_hash, id, StringHash( "mtmqp" ), BlzGetUnitArmor(caster) ) 
    endif

    set caster = null
endfunction

function Trig_Metal_MageQPas_Actions takes nothing returns nothing
    local integer id

    call spdst( GetLearningUnit(), -1*LoadReal( udg_hash, GetHandleId( GetLearningUnit() ), StringHash( "mtmqpn" ) ) )
    call SaveReal( udg_hash, GetHandleId( GetLearningUnit() ), StringHash( "mtmqpn" ), 0 )

    set id = GetHandleId( GetLearningUnit() )
    
    if LoadTimerHandle( udg_hash, id, StringHash( "mtmqp" ) ) == null  then
        call SaveTimerHandle( udg_hash, id, StringHash( "mtmqp" ), CreateTimer() )
    endif
    set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "mtmqp" ) ) )
    call SaveUnitHandle ( udg_hash, id, StringHash( "mtmqp" ), GetLearningUnit() )
    call SaveInteger( udg_hash, id, StringHash( "mtmqp" ), GetUnitAbilityLevel(GetLearningUnit(), 'A0KM') + 1 ) 
    call SaveReal( udg_hash, id, StringHash( "mtmqp" ), 0 )
    call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( GetLearningUnit() ), StringHash( "mtmqp" ) ), 1, true, function Metal_MageQPasCast )
endfunction

//===========================================================================
function InitTrig_Metal_MageQPas takes nothing returns nothing
    set gg_trg_Metal_MageQPas = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Metal_MageQPas, EVENT_PLAYER_HERO_SKILL )
    call TriggerAddCondition( gg_trg_Metal_MageQPas, Condition( function Trig_Metal_MageQPas_Conditions ) )
    call TriggerAddAction( gg_trg_Metal_MageQPas, function Trig_Metal_MageQPas_Actions )
endfunction

