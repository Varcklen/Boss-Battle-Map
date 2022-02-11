function Trig_GBSummon_Conditions takes nothing returns boolean
    return GetUnitTypeId(GetEnteringUnit()) == 'o01C'
endfunction

function GBSummonCast takes nothing returns nothing 
	local integer id = GetHandleId( GetExpiredTimer( ) )
    local unit caster = LoadUnitHandle( udg_hash, id, StringHash( "gbstt" ) )

    if GetUnitState( caster, UNIT_STATE_LIFE) > 0.405 then
        set udg_RandomLogic = true
        set udg_Caster = caster
        set udg_Level = 1
        call TriggerExecute( gg_trg_KillEye )
    else
        call DestroyTimer( GetExpiredTimer( ) )
        call FlushChildHashtable( udg_hash, id )
	endif

    set caster = null
endfunction 

function Trig_GBSummon_Actions takes nothing returns nothing
	local integer id = GetHandleId( GetEnteringUnit() )
	
	call SaveTimerHandle( udg_hash, id, StringHash( "gbstt" ), CreateTimer( ) ) 
	set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "gbstt" ) ) ) 
	call SaveUnitHandle( udg_hash, id, StringHash( "gbstt" ), GetEnteringUnit() ) 
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( GetEnteringUnit() ), StringHash( "gbstt" ) ), 5, true, function GBSummonCast ) 
endfunction 

//===========================================================================
function InitTrig_GBSummon takes nothing returns nothing
    set gg_trg_GBSummon = CreateTrigger(  )
    call TriggerRegisterEnterRectSimple( gg_trg_GBSummon, GetWorldBounds() )
    call TriggerAddCondition( gg_trg_GBSummon, Condition( function Trig_GBSummon_Conditions ) )
    call TriggerAddAction( gg_trg_GBSummon, function Trig_GBSummon_Actions )
endfunction

