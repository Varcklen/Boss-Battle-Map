function Trig_ShoggothRM_Conditions takes nothing returns boolean
    return GetUnitTypeId(GetEnteringUnit()) == 'z000'
endfunction

function ShoggothRMCast takes nothing returns nothing 
	local integer id = GetHandleId( GetExpiredTimer( ) )
    local unit caster = LoadUnitHandle( udg_hash, id, StringHash( "shgr" ) )

    if GetUnitState( caster, UNIT_STATE_LIFE) > 0.405 then
		call BlzSetUnitMaxHP( caster, BlzGetUnitMaxHP(caster)+10 )
		call BlzSetUnitBaseDamage( caster, BlzGetUnitBaseDamage(caster, 0)+1, 0 )
		call SetUnitState( caster, UNIT_STATE_LIFE, GetUnitState( caster, UNIT_STATE_LIFE) + 10 )
    else
        call FlushChildHashtable( udg_hash, id )
		call DestroyTimer( GetExpiredTimer() )
    endif

    set caster = null
endfunction 

function Trig_ShoggothRM_Actions takes nothing returns nothing
	local integer id = GetHandleId( GetEnteringUnit() )
	
	call SaveTimerHandle( udg_hash, id, StringHash( "shgr" ), CreateTimer( ) ) 
	set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "shgr" ) ) ) 
	call SaveUnitHandle( udg_hash, id, StringHash( "shgr" ), GetEnteringUnit() ) 
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( GetEnteringUnit() ), StringHash( "shgr" ) ), 0.5, true, function ShoggothRMCast ) 
endfunction 

//===========================================================================
function InitTrig_ShoggothRM takes nothing returns nothing
    set gg_trg_ShoggothRM = CreateTrigger(  )
    call TriggerRegisterEnterRectSimple( gg_trg_ShoggothRM, GetWorldBounds() )
    call TriggerAddCondition( gg_trg_ShoggothRM, Condition( function Trig_ShoggothRM_Conditions ) )
    call TriggerAddAction( gg_trg_ShoggothRM, function Trig_ShoggothRM_Actions )
endfunction