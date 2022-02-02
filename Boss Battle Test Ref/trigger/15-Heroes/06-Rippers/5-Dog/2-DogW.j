function Trig_DogW_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A155' and combat( GetSpellAbilityUnit(), true, GetSpellAbilityId() )
endfunction

function DogWCast takes nothing returns nothing 
	local integer id = GetHandleId( GetExpiredTimer( ) )
    local unit caster = LoadUnitHandle( udg_hash, id, StringHash( "dogw1" ) )
	local real dmg = LoadReal( udg_hash, id, StringHash( "dogw1" ))
    local group g = CreateGroup()
    local unit u

    if GetUnitState( caster, UNIT_STATE_LIFE) > 0.405 then
    	call GroupEnumUnitsInRange( g, GetUnitX( caster ), GetUnitY( caster ), 225, null )
    	loop
        	set u = FirstOfGroup(g)
        	exitwhen u == null
        	if unitst( u, caster, "enemy" ) then
                call UnitDamageTarget( caster, u, dmg, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS )
        	endif
        	call GroupRemoveUnit(g,u)
        	set u = FirstOfGroup(g)
    	endloop
    else
        call FlushChildHashtable( udg_hash, id )
        call DestroyTimer( GetExpiredTimer() )
    endif

    call GroupClear( g )
    call DestroyGroup( g )
    set u = null
    set g = null
    set caster = null
endfunction 

function DogWRun takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer( ) )
    local unit caster = LoadUnitHandle( udg_hash, id, StringHash( "dogw" ) )
    local unit target = LoadUnitHandle( udg_hash, id, StringHash( "dogwtrg" ) )
    local integer counter = LoadInteger( udg_hash, id, StringHash( "dogw" ) ) + 1
    local real x = GetUnitX( target )
    local real y = GetUnitY( target )
    local real angle = Atan2( y - GetUnitY( caster ), x - GetUnitX( caster ) )
    local real NewX = GetUnitX( caster ) + 30 * Cos( angle )
    local real NewY = GetUnitY( caster ) + 30 * Sin( angle )
    local group g = CreateGroup()
    local unit u
	local integer id1
	local real dmg = LoadReal( udg_hash, id, StringHash( "dogw" ))
	local real dmgac = LoadReal( udg_hash, id, StringHash( "dogwac" ))
    local real h = LoadReal( udg_hash, id, StringHash( "dogwh" ) )
    local real flyHeight = LoadReal ( udg_hash, id, StringHash( "dogwf" ) )

    if counter == 10 then
        call SetUnitFlyHeight( caster, -600, 1500 )
    endif

    if counter == 20 or GetUnitState( caster, UNIT_STATE_LIFE) <= 0.405 then
		call SetUnitPathing( caster, true )
        call SetUnitFlyHeight( caster, h, flyHeight )
		call UnitRemoveAbility( caster, 'Amrf' )
		call PauseUnit( caster, false)
		call UnitRemoveAbility( caster, 'A00L' )
        if GetUnitState( caster, UNIT_STATE_LIFE) > 0.405 then
            call GroupEnumUnitsInRange( g, GetUnitX( caster ), GetUnitY( caster ), 300, null )
            loop
                set u = FirstOfGroup(g)
                exitwhen u == null
                if unitst( u, caster, "enemy" ) then
                    call dummyspawn( caster, 1, 'A0N5', 0, 0 )
                    call UnitStun(caster, u, 1.5 )
                    call UnitDamageTarget( bj_lastCreatedUnit, u, dmg, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS)
                endif
                call GroupRemoveUnit(g,u) 
            endloop
            call dummyspawn( caster, 10.5, 'A157', 'A0N5', 0 )
            call SetUnitScale( bj_lastCreatedUnit, 1.5, 1.5, 1.5 )
            
            set id1 = GetHandleId( bj_lastCreatedUnit )
            if LoadTimerHandle( udg_hash, id1, StringHash( "dogw1" ) ) == null  then
                call SaveTimerHandle( udg_hash, id1, StringHash( "dogw1" ), CreateTimer() )
            endif
            set id1 = GetHandleId( LoadTimerHandle( udg_hash, id1, StringHash( "dogw1" ) ) )
            call SaveUnitHandle( udg_hash, id1, StringHash( "dogw1" ), bj_lastCreatedUnit)
            call SaveReal( udg_hash, id1, StringHash( "dogw1" ), dmgac)
            call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( bj_lastCreatedUnit ), StringHash( "dogw1" ) ), 1, true, function DogWCast )
        endif
        call FlushChildHashtable( udg_hash, id ) 
        call DestroyTimer( GetExpiredTimer() )
    else 
        call SaveInteger( udg_hash, id, StringHash( "dogw" ), counter )
        call SetUnitPosition( caster, NewX, NewY )
    endif
    
    call GroupClear( g )
    call DestroyGroup( g )
    set u = null
    set g = null
    set caster = null
    set target = null
endfunction

function Trig_DogW_Actions takes nothing returns nothing
    local integer id 
    local integer lvl
    local unit caster
    local unit target
    local real dmg
	local real dmgac
    local real x
    local real y
    local real h
    
    if CastLogic() then
        set caster = udg_Caster
        set target = udg_Target
        set lvl = udg_Level
    elseif RandomLogic() then
        set caster = udg_Caster
        set target = randomtarget( caster, 900, "enemy", "", "", "", "" )
        set lvl = udg_Level
        call textst( udg_string[0] + GetObjectName('A155'), caster, 64, 90, 10, 1.5 )
        if target == null then
            set caster = null
            return
        endif
    else
        set caster = GetSpellAbilityUnit()
        set target = GetSpellTargetUnit()
        set lvl = GetUnitAbilityLevel(GetSpellAbilityUnit(), GetSpellAbilityId())
    endif
    
    set id = GetHandleId( caster )
    set dmg = (75 + ( 25 * lvl )) * udg_SpellDamage[GetPlayerId(GetOwningPlayer(caster)) + 1] 
	set dmgac = (10 + ( 5 * lvl )) * udg_SpellDamage[GetPlayerId(GetOwningPlayer(caster)) + 1] 
    set h = GetUnitDefaultFlyHeight(caster)

	set x = GetUnitX( target )
	set y = GetUnitY( target )
	call PauseUnit( caster, true )
	call UnitAddAbility( caster, 'A00L' )
	call UnitAddAbility( caster, 'Amrf' )
	call SetUnitFlyHeight( caster, 600, 1500 )
	call SetUnitPathing( caster, false )
	
	if LoadTimerHandle( udg_hash, id, StringHash( "dogw" ) ) == null  then
		call SaveTimerHandle( udg_hash, id, StringHash( "dogw" ), CreateTimer() )
	endif
	set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "dogw" ) ) )
	call SaveUnitHandle( udg_hash, id, StringHash( "dogw" ), caster)
	call SaveUnitHandle( udg_hash, id, StringHash( "dogwtrg" ), target )
	call SaveReal( udg_hash, id, StringHash( "dogw" ), dmg)
	call SaveReal( udg_hash, id, StringHash( "dogwac" ), dmgac)
    call SaveReal( udg_hash, id, StringHash( "dogwh" ), h)
    call SaveReal ( udg_hash, id, StringHash( "dogwf" ), GetUnitFlyHeight(caster))
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( caster ), StringHash( "dogw" ) ), 0.02, true, function DogWRun ) 

    set caster = null
    set target = null
endfunction

//===========================================================================
function InitTrig_DogW takes nothing returns nothing
    set gg_trg_DogW = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_DogW, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_DogW, Condition( function Trig_DogW_Conditions ) )
    call TriggerAddAction( gg_trg_DogW, function Trig_DogW_Actions )
endfunction

