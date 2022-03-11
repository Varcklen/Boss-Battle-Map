function Trig_Soulfiend2_Conditions takes nothing returns boolean
    return GetUnitTypeId( udg_DamageEventTarget ) == 'n04F' and GetUnitLifePercent(udg_DamageEventTarget) <= 70
endfunction

function Soulfiend2End takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer( ) )
    local unit u = LoadUnitHandle( udg_hash, id, StringHash( "bssf3" ) )
    local real hp = GetUnitLifePercent(u)
    
	if GetUnitAbilityLevel(u, 'B07G') > 0 then
        call DestroyEffect( AddSpecialEffect( "CallOfAggression.mdx", GetUnitX( u ), GetUnitY( u ) ) )
		if hp < 50 then
			call KillUnit( u )
		else
        call SetUnitState( u, UNIT_STATE_LIFE, GetUnitState( u, UNIT_STATE_MAX_LIFE)*0.4 )
		endif
	endif

    call UnitRemoveAbility( u, 'A172' )
    call UnitRemoveAbility( u, 'B07G' )
    call FlushChildHashtable( udg_hash, id )

    set u = null
endfunction

function Soulfiend2_CastCurse takes nothing returns nothing
    local integer cyclA = 1
    loop
		exitwhen cyclA > 4
		if GetUnitState( udg_hero[cyclA], UNIT_STATE_LIFE) > 0.405 then
			call PingMinimapLocForForceEx( bj_FORCE_ALL_PLAYERS, GetUnitLoc( udg_hero[cyclA] ), 2., bj_MINIMAPPINGSTYLE_ATTACK, 0, 0, 0 )
            call UnitAddAbility( udg_hero[cyclA], 'A172')
            call InvokeTimerWithUnit( udg_hero[cyclA], "bssf3", bosscast(8), false, function Soulfiend2End )
		endif
		set cyclA = cyclA + 1
	endloop
endfunction

function Trig_Soulfiend2_Actions takes nothing returns nothing
    call DisableTrigger( GetTriggeringTrigger() )
    call Soulfiend2_CastCurse()
endfunction

//===========================================================================
function InitTrig_Soulfiend2 takes nothing returns nothing
    set gg_trg_Soulfiend2 = CreateTrigger(  )
    call DisableTrigger( gg_trg_Soulfiend2 )
    call TriggerRegisterVariableEvent( gg_trg_Soulfiend2, "udg_AfterDamageEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_Soulfiend2, Condition( function Trig_Soulfiend2_Conditions ) )
    call TriggerAddAction( gg_trg_Soulfiend2, function Trig_Soulfiend2_Actions )
endfunction

