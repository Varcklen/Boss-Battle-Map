function ArrowMoveCast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local integer c = LoadInteger( udg_hash, id, StringHash( "arrmv" ) )
    local real y = LoadReal( udg_hash, id, StringHash( "arrmvm" ) ) + (c*0.005)

	if udg_fightmod[0] then
		call BlzFrameSetVisible( arrowframe, false )
        call FlushChildHashtable( udg_hash, id )
        call DestroyTimer( GetExpiredTimer() )
	else
        call BlzFrameSetAbsPoint(arrowframe, FRAMEPOINT_CENTER, 0.4, y)
		call SaveReal( udg_hash, id, StringHash( "arrmvm" ), y )
		if y > 0.24 or y < 0.2 then
			if c == 1 then
				call SaveInteger( udg_hash, id, StringHash( "arrmv" ), -1 )
			else
				call SaveInteger( udg_hash, id, StringHash( "arrmv" ), 1 )
			endif
		endif
	endif
endfunction

function Trig_ArrowMove_Actions takes nothing returns nothing
    local integer id = GetHandleId(gg_unit_h00A_0034)

    if LoadTimerHandle( udg_hash, id, StringHash( "arrmv" ) ) == null  then
        call SaveTimerHandle( udg_hash, id, StringHash( "arrmv" ), CreateTimer() )
    endif
	set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "arrmv" ) ) ) 
	call SaveInteger( udg_hash, id, StringHash( "arrmv" ), 1 )
	call SaveReal( udg_hash, id, StringHash( "arrmvm" ), 0.2 )
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId(gg_unit_h00A_0034), StringHash( "arrmv" ) ), 0.04, true, function ArrowMoveCast )
endfunction

//===========================================================================
function InitTrig_ArrowMove takes nothing returns nothing
    set gg_trg_ArrowMove = CreateTrigger(  )
    call TriggerRegisterTimerEventSingle( gg_trg_ArrowMove, 1.00 )
    call TriggerAddAction( gg_trg_ArrowMove, function Trig_ArrowMove_Actions )
endfunction

