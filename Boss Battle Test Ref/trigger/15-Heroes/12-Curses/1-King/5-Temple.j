function Trig_Temple_Conditions takes nothing returns boolean
    return GetUnitTypeId(GetEnteringUnit()) == 'h01O'
endfunction

function TempleCast takes nothing returns nothing 
	local integer id = GetHandleId( GetExpiredTimer( ) )
    local unit caster = LoadUnitHandle( udg_hash, id, StringHash( "temple" ) )
    local integer lvl = LoadInteger( udg_hash, GetHandleId(caster), StringHash( "temple" ) )
    local real r = 1

	if GetUnitState( caster, UNIT_STATE_LIFE) > 0.405 then
        if luckylogic( caster, 15, 1, 100 ) then
            set r = r + (0.75*lvl)
        endif
        set bj_lastCreatedUnit = CreateUnit( GetOwningPlayer( caster ), 'u01K', GetUnitX( caster ) + GetRandomReal( 0, 200 ), GetUnitY( caster ) + GetRandomReal( 0, 200 ), GetRandomReal( 0, 360 ) )
        call UnitApplyTimedLife( bj_lastCreatedUnit , 'BTLF', 15 )
        if r > 1 then
            call BlzSetUnitBaseDamage( bj_lastCreatedUnit, R2I(BlzGetUnitBaseDamage(bj_lastCreatedUnit, 0) * r), 0 )
            call BlzSetUnitMaxHP( bj_lastCreatedUnit, R2I(BlzGetUnitMaxHP(bj_lastCreatedUnit) * r) )
            call SetUnitState(bj_lastCreatedUnit, UNIT_STATE_LIFE, GetUnitState(bj_lastCreatedUnit, UNIT_STATE_MAX_LIFE))
            call SetUnitScale( bj_lastCreatedUnit, 1.5, 1.5, 1.5 )
        endif
        call DestroyEffect(AddSpecialEffectTarget("war3mapImported\\SoulRitual.mdx", bj_lastCreatedUnit, "origin"))
    else
        call FlushChildHashtable( udg_hash, id )
        call DestroyTimer( GetExpiredTimer( ) )
	endif

    set caster = null
endfunction 

function Trig_Temple_Actions takes nothing returns nothing
	local integer id = GetHandleId( GetEnteringUnit() )
    
	call SaveTimerHandle( udg_hash, id, StringHash( "temple" ), CreateTimer( ) ) 
	set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "temple" ) ) ) 
	call SaveUnitHandle( udg_hash, id, StringHash( "temple" ), GetEnteringUnit() ) 
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( GetEnteringUnit() ), StringHash( "temple" ) ), 5, true, function TempleCast ) 
endfunction 

//===========================================================================
function InitTrig_Temple takes nothing returns nothing
    set gg_trg_Temple = CreateTrigger(  )
    call TriggerRegisterEnterRectSimple( gg_trg_Temple, GetWorldBounds() )
    call TriggerAddCondition( gg_trg_Temple, Condition( function Trig_Temple_Conditions ) )
    call TriggerAddAction( gg_trg_Temple, function Trig_Temple_Actions )
endfunction

