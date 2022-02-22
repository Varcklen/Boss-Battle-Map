function Trig_Totem_Power_Conditions takes nothing returns boolean
    return GetUnitTypeId(GetEnteringUnit()) == 'o00R'
endfunction

function Totem_PowerCast takes nothing returns nothing 
	local integer id = GetHandleId( GetExpiredTimer( ) )
    local unit caster = LoadUnitHandle( udg_hash, id, StringHash( "pwrtt" ) )
    local group g = CreateGroup()
    local unit u

    if GetUnitState( caster, UNIT_STATE_LIFE) > 0.405 then
	call dummyspawn( caster, 1, 0, 0, 0 )
    	call DestroyEffect( AddSpecialEffect( "war3mapImported\\ArcaneExplosion.mdx", GetUnitX( caster ), GetUnitY( caster ) ) )
    	call GroupEnumUnitsInRange( g, GetUnitX( caster ), GetUnitY( caster ), 400, null )
    	loop
        	set u = FirstOfGroup(g)
        	exitwhen u == null
        	if unitst( u, caster, "enemy" ) then
                call UnitDamageTarget( bj_lastCreatedUnit, u, 100, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS )
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

function Trig_Totem_Power_Actions takes nothing returns nothing
	local integer id = GetHandleId( GetEnteringUnit() )
	
	call SaveTimerHandle( udg_hash, id, StringHash( "pwrtt" ), CreateTimer( ) ) 
	set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "pwrtt" ) ) ) 
	call SaveUnitHandle( udg_hash, id, StringHash( "pwrtt" ), GetEnteringUnit() ) 
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( GetEnteringUnit() ), StringHash( "pwrtt" ) ), 3, true, function Totem_PowerCast ) 
endfunction 

//===========================================================================
function InitTrig_Totem_Power takes nothing returns nothing
    set gg_trg_Totem_Power = CreateTrigger(  )
    call TriggerRegisterEnterRectSimple( gg_trg_Totem_Power, GetWorldBounds() )
    call TriggerAddCondition( gg_trg_Totem_Power, Condition( function Trig_Totem_Power_Conditions ) )
    call TriggerAddAction( gg_trg_Totem_Power, function Trig_Totem_Power_Actions )
endfunction

