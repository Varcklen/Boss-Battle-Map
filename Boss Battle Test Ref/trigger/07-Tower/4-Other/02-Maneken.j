function Target_Conditions takes nothing returns boolean
    return GetUnitTypeId(GetDyingUnit()) == 'h01F' and (RectContainsUnit(gg_rct_TargetRegion01, GetDyingUnit()) or RectContainsUnit(gg_rct_TargetRegion02, GetDyingUnit()))
endfunction

function Trig_Maneken_Conditions takes nothing returns boolean
    return GetUnitTypeId(GetDyingUnit()) == 'h009' or Target_Conditions()
endfunction

function ManekenCast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer( ) )
    local unit u = LoadUnitHandle( udg_hash, id, StringHash( "mnkn" ) )
    
    if GetUnitState( u, UNIT_STATE_LIFE) > 0.405 then
        call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\Orc\\MirrorImage\\MirrorImageDeathCaster.mdl", GetUnitX( u ), GetUnitY( u ) ) )
        call ShowUnit(u, true)
        call UnitRemoveAbility( u, 'Avul' )
    endif
    call FlushChildHashtable( udg_hash, id )
    
    set u = null
endfunction

function Trig_Maneken_Actions takes nothing returns nothing
    set bj_lastCreatedUnit = CreateUnit( Player(PLAYER_NEUTRAL_AGGRESSIVE), GetUnitTypeId( GetDyingUnit() ), GetUnitX( GetDyingUnit() ), GetUnitY( GetDyingUnit() ), GetUnitFacing( GetDyingUnit() ) )
    call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\Orc\\MirrorImage\\MirrorImageDeathCaster.mdl", GetUnitX( bj_lastCreatedUnit ), GetUnitY( bj_lastCreatedUnit ) ) )
    if GetUnitTypeId(GetDyingUnit()) == 'h009' then
    	call SetUnitAnimation( bj_lastCreatedUnit, "sleep" )
    endif
    call RemoveUnit(GetDyingUnit())
    call ShowUnit(bj_lastCreatedUnit, false)
    call UnitAddAbility( bj_lastCreatedUnit, 'Avul' )

    call InvokeTimerWithUnit(bj_lastCreatedUnit, "mnkn", 2, false, function ManekenCast)
endfunction

//===========================================================================
function InitTrig_Maneken takes nothing returns nothing
    set gg_trg_Maneken = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Maneken, EVENT_PLAYER_UNIT_DEATH )
    call TriggerAddCondition( gg_trg_Maneken, Condition( function Trig_Maneken_Conditions ) )
    call TriggerAddAction( gg_trg_Maneken, function Trig_Maneken_Actions )
endfunction

