function Trig_NomadR_Conditions takes nothing returns boolean
    return GetLearnedSkill() == 'A04U' and GetUnitAbilityLevel(GetLearningUnit(), 'A04U') == 1
endfunction

function Trig_NomadR_Actions takes nothing returns nothing
    	local integer id = GetHandleId( GetLearningUnit() )

	if GetLocalPlayer() == GetOwningPlayer(GetLearningUnit()) then
    		call BlzFrameSetVisible( shamanframe, true )
	endif
	call BallEnergy( GetLearningUnit(), -3 )

    	if LoadTimerHandle( udg_hash, id, StringHash( "nmdr" ) ) == null  then
        	call SaveTimerHandle( udg_hash, id, StringHash( "nmdr" ), CreateTimer() )
    	endif
	set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "nmdr" ) ) ) 
	call SaveUnitHandle( udg_hash, id, StringHash( "nmdr" ), GetLearningUnit() )
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( GetLearningUnit() ), StringHash( "nmdr" ) ), 3.5, true, function NomadRCast )
endfunction

//===========================================================================
function InitTrig_NomadR takes nothing returns nothing
    set gg_trg_NomadR = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_NomadR, EVENT_PLAYER_HERO_SKILL )
    call TriggerAddCondition( gg_trg_NomadR, Condition( function Trig_NomadR_Conditions ) )
    call TriggerAddAction( gg_trg_NomadR, function Trig_NomadR_Actions )
endfunction

