function Trig_IncarnationW_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A0UH'
endfunction

function IncarnationWCast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local real r = LoadReal( udg_hash, id, StringHash( "incw" ) )
    local unit caster = LoadUnitHandle( udg_hash, id, StringHash( "incw" ) )
    local unit dummy = LoadUnitHandle( udg_hash, id, StringHash( "incwf" ) )
	local real dmg = LoadReal( udg_hash, id, StringHash( "incwd" ) )
	local integer c = LoadInteger( udg_hash, id, StringHash( "incwc" ) ) + 1
	local integer counter = LoadInteger( udg_hash, id, StringHash( "incw" ) ) - 1
    local real x
    local real y
	local group g = CreateGroup()
    local unit u
    
	if GetUnitState( dummy, UNIT_STATE_LIFE) > 0.405 and GetUnitState( caster, UNIT_STATE_LIFE) > 0.405 and counter > 0 then
		call SaveInteger( udg_hash, id, StringHash( "incw" ), counter )
		set x = GetUnitX( caster ) + 150 * Cos( r * bj_DEGTORAD)
		set y = GetUnitY( caster ) + 150 * Sin( r * bj_DEGTORAD)
		call SaveReal( udg_hash, id, StringHash( "incw" ), r + 5 )
		call SetUnitPosition( dummy, x, y )
		call SetUnitFacing( dummy, r )
		if c >= 8 then
			call SaveInteger( udg_hash, id, StringHash( "incwc" ), 0 )
			call GroupEnumUnitsInRange( g, x, y, 142, null )
			loop
				set u = FirstOfGroup(g)
				exitwhen u == null
				if unitst( u, caster, "enemy" ) then
					call UnitDamageTarget( dummy, u, dmg, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS )
				endif
				call GroupRemoveUnit(g,u)
			endloop
		else
			call SaveInteger( udg_hash, id, StringHash( "incwc" ), c )
		endif
	else
		call RemoveUnit( dummy )
        call DestroyTimer( GetExpiredTimer() )
        call FlushChildHashtable( udg_hash, id ) 
	endif
    
	call GroupClear( g )
    call DestroyGroup( g )
    set u = null
	set g = null
    set caster = null
    set dummy = null
endfunction

function Trig_IncarnationW_Actions takes nothing returns nothing
    local integer id 
    local unit caster
    local integer lvl
    local real dmg
    
    if CastLogic() then
        set caster = udg_Caster
        set lvl = udg_Level
    elseif RandomLogic() then
        set caster = udg_Caster
        set lvl = udg_Level
        call textst( udg_string[0] + GetObjectName('A0UH'), caster, 64, 90, 10, 1.5 )
    else
        set caster = GetSpellAbilityUnit()
        set lvl = GetUnitAbilityLevel(GetSpellAbilityUnit(), GetSpellAbilityId())
    endif

    set dmg = (( 10 + ( 5 * lvl ) ) * GetUnitSpellPower(caster)) / 4

    set bj_lastCreatedUnit = CreateUnit( GetOwningPlayer( caster ), 'u000', GetUnitX(caster), GetUnitY(caster) + 150, bj_UNIT_FACING )
    call UnitAddAbility( bj_lastCreatedUnit, 'A01R' )
    
    set id = GetHandleId( bj_lastCreatedUnit ) 
    if LoadTimerHandle( udg_hash, id, StringHash( "incw" ) ) == null then
        call SaveTimerHandle( udg_hash, id, StringHash( "incw" ), CreateTimer() )
    endif
	set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "incw" ) ) ) 
    call SaveUnitHandle( udg_hash, id, StringHash( "incw" ), caster )
    call SaveUnitHandle( udg_hash, id, StringHash( "incwf" ), bj_lastCreatedUnit )
	call SaveReal( udg_hash, id, StringHash( "incw" ), 90 )
	call SaveReal( udg_hash, id, StringHash( "incwd" ), dmg )
	call SaveInteger( udg_hash, id, StringHash( "incw" ), 33*20 )
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( bj_lastCreatedUnit ), StringHash( "incw" ) ), 0.03, true, function IncarnationWCast )
	
	set bj_lastCreatedUnit = CreateUnit( GetOwningPlayer( caster ), 'u000', GetUnitX(caster), GetUnitY(caster) - 150, bj_UNIT_FACING )
    call UnitAddAbility( bj_lastCreatedUnit, 'A01R' )
    set id = GetHandleId( bj_lastCreatedUnit ) 
    if LoadTimerHandle( udg_hash, id, StringHash( "incw" ) ) == null then
        call SaveTimerHandle( udg_hash, id, StringHash( "incw" ), CreateTimer() )
    endif
	set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "incw" ) ) ) 
    call SaveUnitHandle( udg_hash, id, StringHash( "incw" ), caster )
    call SaveUnitHandle( udg_hash, id, StringHash( "incwf" ), bj_lastCreatedUnit )
	call SaveReal( udg_hash, id, StringHash( "incw" ), 270 )
	call SaveReal( udg_hash, id, StringHash( "incwd" ), dmg )
	call SaveInteger( udg_hash, id, StringHash( "incw" ), 33*20 )
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( bj_lastCreatedUnit ), StringHash( "incw" ) ), 0.03, true, function IncarnationWCast )
    
    set caster = null
endfunction

//===========================================================================
function InitTrig_IncarnationW takes nothing returns nothing
    set gg_trg_IncarnationW = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_IncarnationW, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_IncarnationW, Condition( function Trig_IncarnationW_Conditions ) )
    call TriggerAddAction( gg_trg_IncarnationW, function Trig_IncarnationW_Actions )
endfunction













