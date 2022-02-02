function Trig_Stroke_Conditions takes nothing returns boolean
    return GetUnitTypeId(GetSoldUnit()) == 'n03E'
endfunction

function StrokeCast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    call UnitRemoveAbility( LoadUnitHandle( udg_hash, id, StringHash( "strk" ) ), 'A0F6' )
    call UnitRemoveAbility( LoadUnitHandle( udg_hash, id, StringHash( "strk" ) ), 'B02D' )
    call FlushChildHashtable( udg_hash, id )
endfunction

function Trig_Stroke_Actions takes nothing returns nothing
    local integer id = GetHandleId( GetBuyingUnit() )

    call RemoveUnit( GetSoldUnit() )
    call UnitAddAbility( GetBuyingUnit(), 'A0F6' )
    call DestroyEffect( AddSpecialEffectTarget("Abilities\\Spells\\Human\\Resurrect\\ResurrectTarget.mdl", GetBuyingUnit(), "origin" ) )
    
    if LoadTimerHandle( udg_hash, id, StringHash( "strk" ) ) == null then 
        call SaveTimerHandle( udg_hash, id, StringHash( "strk" ), CreateTimer() )
    endif
	set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "strk" ) ) ) 
	call SaveUnitHandle( udg_hash, id, StringHash( "strk" ), GetBuyingUnit() )
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( GetBuyingUnit() ), StringHash( "strk" ) ), 30, false, function StrokeCast )
endfunction

//===========================================================================
function InitTrig_Stroke takes nothing returns nothing
    set gg_trg_Stroke = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Stroke, EVENT_PLAYER_UNIT_SELL )
    call TriggerAddCondition( gg_trg_Stroke, Condition( function Trig_Stroke_Conditions ) )
    call TriggerAddAction( gg_trg_Stroke, function Trig_Stroke_Actions )
endfunction

