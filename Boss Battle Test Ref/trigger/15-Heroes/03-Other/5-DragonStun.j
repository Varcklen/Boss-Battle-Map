function Trig_DragonStun_Conditions takes nothing returns boolean
    return GetUnitTypeId(GetEnteringUnit()) == 'n00D'
endfunction

function DragonStunCast takes nothing returns nothing 
	local integer id = GetHandleId( GetExpiredTimer( ) )
    local unit caster = LoadUnitHandle( udg_hash, id, StringHash( "drst" ) )
    local group g = CreateGroup()
    local unit u
    
	if GetUnitState( caster, UNIT_STATE_LIFE) > 0.405 then
        call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\Other\\HowlOfTerror\\HowlCaster.mdl", GetUnitX( caster ), GetUnitY( caster ) ) )
        call GroupEnumUnitsInRange( g, GetUnitX( caster ), GetUnitY( caster ), 400, null )
        loop
            set u = FirstOfGroup(g)
            exitwhen u == null
            if unitst( u, caster, "enemy" ) then
                call UnitStun(caster, u, 2 )
            endif
            call GroupRemoveUnit(g,u)
            set u = FirstOfGroup(g)
        endloop
    else
        call DestroyTimer( GetExpiredTimer( ) )
        call FlushChildHashtable( udg_hash, id )
	endif
    
    call GroupClear( g )
    call DestroyGroup( g )
    set u = null
    set caster = null
endfunction 

function Trig_DragonStun_Actions takes nothing returns nothing
	local integer id = GetHandleId( GetEnteringUnit() )
	
	call SaveTimerHandle( udg_hash, id, StringHash( "drst" ), CreateTimer( ) ) 
	set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "drst" ) ) ) 
	call SaveUnitHandle( udg_hash, id, StringHash( "drst" ), GetEnteringUnit() ) 
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( GetEnteringUnit() ), StringHash( "drst" ) ), 8, true, function DragonStunCast ) 
endfunction 

//===========================================================================
function InitTrig_DragonStun takes nothing returns nothing
    set gg_trg_DragonStun = CreateTrigger(  )
    call TriggerRegisterEnterRectSimple( gg_trg_DragonStun, GetWorldBounds() )
    call TriggerAddCondition( gg_trg_DragonStun, Condition( function Trig_DragonStun_Conditions ) )
    call TriggerAddAction( gg_trg_DragonStun, function Trig_DragonStun_Actions )
endfunction