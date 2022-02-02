function Trig_OutcastE_Conditions takes nothing returns boolean
    return GetLearnedSkill() == 'A082'
endfunction

function Trig_OutcastE_Actions takes nothing returns nothing
    	local integer id = GetHandleId( GetLearningUnit() )
	local integer t = 55 - (5*GetUnitAbilityLevel(GetLearningUnit(), GetLearnedSkill()))

	if GetLocalPlayer() == GetOwningPlayer(GetLearningUnit()) then
    		call BlzFrameSetVisible( outcastframe, true )
    		call BlzFrameSetVisible( outballframe[1], false )
    		call BlzFrameSetVisible( outballframe[2], false )
    		call BlzFrameSetVisible( outballframe[3], false )
	endif

		set udg_outcast[1] = false
		set udg_outcast[2] = false
		set udg_outcast[3] = false

    	if LoadTimerHandle( udg_hash, id, StringHash( "outeq" ) ) == null  then
        	call SaveTimerHandle( udg_hash, id, StringHash( "outeq" ), CreateTimer() )
    	endif
	set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "outeq" ) ) ) 
	call SaveUnitHandle( udg_hash, id, StringHash( "outeq" ), GetLearningUnit() )
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( GetLearningUnit() ), StringHash( "outeq" ) ), t, true, function OutcastEQEnd )

	set id = GetHandleId( GetLearningUnit() )
    	if LoadTimerHandle( udg_hash, id, StringHash( "outew" ) ) == null  then
        	call SaveTimerHandle( udg_hash, id, StringHash( "outew" ), CreateTimer() )
    	endif
	set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "outew" ) ) ) 
	call SaveUnitHandle( udg_hash, id, StringHash( "outew" ), GetLearningUnit() )
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( GetLearningUnit() ), StringHash( "outew" ) ), t, true, function OutcastEWEnd )

	set id = GetHandleId( GetLearningUnit() )
    	if LoadTimerHandle( udg_hash, id, StringHash( "outer" ) ) == null  then
        	call SaveTimerHandle( udg_hash, id, StringHash( "outer" ), CreateTimer() )
    	endif
	set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "outer" ) ) ) 
	call SaveUnitHandle( udg_hash, id, StringHash( "outer" ), GetLearningUnit() )
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( GetLearningUnit() ), StringHash( "outer" ) ), t, true, function OutcastEREnd )
endfunction

//===========================================================================
function InitTrig_OutcastE takes nothing returns nothing
    set gg_trg_OutcastE = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_OutcastE, EVENT_PLAYER_HERO_SKILL )
    call TriggerAddCondition( gg_trg_OutcastE, Condition( function Trig_OutcastE_Conditions ) )
    call TriggerAddAction( gg_trg_OutcastE, function Trig_OutcastE_Actions )
endfunction

