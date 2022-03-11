//TESH.scrollpos=0
//TESH.alwaysfold=0
function Trig_DoctorRUse_Conditions takes nothing returns boolean
    return not( IsUnitInGroup(GetDyingUnit(), udg_Return) ) and GetPlayerSlotState(GetOwningPlayer(GetDyingUnit())) == PLAYER_SLOT_STATE_PLAYING and IsUnitInGroup(GetDyingUnit(), udg_heroinfo) and GetUnitAbilityLevel(GetDyingUnit(), 'A05X') > 0
endfunction

function DoctorRUseCast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local unit u = LoadUnitHandle( udg_hash, id, StringHash( "dctres" ) )
    local real r = LoadReal( udg_hash, id, StringHash( "dctres" ) )

    if udg_fightmod[0] then
        call ReviveHeroLoc( u, GetUnitLoc( u ), true )
        call GroupAddUnit( udg_otryad, u )
        call PauseUnit( u, false )
        call SetUnitState( u, UNIT_STATE_LIFE, GetUnitState( u, UNIT_STATE_MAX_LIFE) * r)
	call SetUnitState( u, UNIT_STATE_MANA, GetUnitState( u, UNIT_STATE_MAX_MANA) * r)
	call UnitRemoveAbility( u, 'A05X' )
    	call UnitRemoveAbility( u, 'B047' )
    endif
    
    call FlushChildHashtable( udg_hash, id )
    set u = null
endfunction

function Trig_DoctorRUse_Actions takes nothing returns nothing
    local integer id = GetHandleId( GetDyingUnit() )
    local real r = LoadReal( udg_hash, GetHandleId( GetDyingUnit() ), StringHash( "dctr" ) )
    
    set bj_lastCreatedUnit = CreateUnit( Player( PLAYER_NEUTRAL_PASSIVE ), 'u000', GetUnitX( GetDyingUnit() ), GetUnitY( GetDyingUnit() ), 270 )
    call UnitApplyTimedLife( bj_lastCreatedUnit, 'BTLF', 3 )
    call DestroyEffect( AddSpecialEffectTarget( "Abilities\\Spells\\Human\\Resurrect\\ResurrectCaster.mdl",  bj_lastCreatedUnit, "origin" ) )
    
    call SaveTimerHandle( udg_hash, id, StringHash( "dctres" ), CreateTimer() )
	set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "dctres" ) ) ) 
	call SaveUnitHandle( udg_hash, id, StringHash( "dctres" ), GetDyingUnit() )
	call SaveReal( udg_hash, id, StringHash( "dctres" ), r )
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( GetDyingUnit() ), StringHash( "dctres" ) ), 3, false, function DoctorRUseCast )
endfunction

//===========================================================================
function InitTrig_DoctorRUse takes nothing returns nothing
    set gg_trg_DoctorRUse = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_DoctorRUse, EVENT_PLAYER_UNIT_DEATH )
    call TriggerAddCondition( gg_trg_DoctorRUse, Condition( function Trig_DoctorRUse_Conditions ) )
    call TriggerAddAction( gg_trg_DoctorRUse, function Trig_DoctorRUse_Actions )
endfunction

