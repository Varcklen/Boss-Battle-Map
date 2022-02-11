function Trig_ChaosTotem_Conditions takes nothing returns boolean
    return GetUnitTypeId(GetEnteringUnit()) == 'o00W'
endfunction

function ChaosTotemCast takes nothing returns nothing 
	local integer id = GetHandleId( GetExpiredTimer( ) )
    local unit caster = LoadUnitHandle( udg_hash, id, StringHash( "chstt" ) )
    local integer rand = GetRandomInt( 1, 3 )

	if GetUnitState( caster, UNIT_STATE_LIFE) > 0.405 then
        set udg_RandomLogic = true
        set udg_Caster = caster
        set udg_Level = 1
        if rand == 1 then
            call TriggerExecute( udg_DB_Trigger_One[GetRandomInt( 1, udg_Database_NumberItems[14])] )
        elseif rand == 2 then
            call TriggerExecute( udg_DB_Trigger_Two[GetRandomInt( 1, udg_Database_NumberItems[15])] )
        else
            call TriggerExecute( udg_DB_Trigger_Three[GetRandomInt( 1, udg_Database_NumberItems[16])] )
        endif
    else
        call DestroyTimer( GetExpiredTimer( ) )
        call FlushChildHashtable( udg_hash, id )
	endif

    set caster = null
endfunction 

function Trig_ChaosTotem_Actions takes nothing returns nothing
	local integer id = GetHandleId( GetEnteringUnit() )
	
	call SaveTimerHandle( udg_hash, id, StringHash( "chstt" ), CreateTimer( ) ) 
	set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "chstt" ) ) ) 
	call SaveUnitHandle( udg_hash, id, StringHash( "chstt" ), GetEnteringUnit() ) 
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( GetEnteringUnit() ), StringHash( "chstt" ) ), 4, true, function ChaosTotemCast ) 
endfunction 

//===========================================================================
function InitTrig_ChaosTotem takes nothing returns nothing
    set gg_trg_ChaosTotem = CreateTrigger(  )
    call TriggerRegisterEnterRectSimple( gg_trg_ChaosTotem, GetWorldBounds() )
    call TriggerAddCondition( gg_trg_ChaosTotem, Condition( function Trig_ChaosTotem_Conditions ) )
    call TriggerAddAction( gg_trg_ChaosTotem, function Trig_ChaosTotem_Actions )
endfunction

