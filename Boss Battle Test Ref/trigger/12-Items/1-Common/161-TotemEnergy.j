function Trig_TotemEnergy_Conditions takes nothing returns boolean
    return GetUnitTypeId(GetEnteringUnit()) == 'o00Y'
endfunction

function TotemEnergyCast takes nothing returns nothing 
	local integer id = GetHandleId( GetExpiredTimer( ) )
    local unit caster = LoadUnitHandle( udg_hash, id, StringHash( "enrgy" ) )
    local group g = CreateGroup()
    local unit u

	if GetUnitState( caster, UNIT_STATE_LIFE) > 0.405 then
        call GroupEnumUnitsInRange( g, GetUnitX( caster ), GetUnitY( caster ), 600, null )
        loop
            set u = FirstOfGroup(g)
            exitwhen u == null
            if unitst( u, caster, "ally" ) and IsUnitType( u, UNIT_TYPE_HERO) then
                call manast( caster, u, GetRandomInt( 1, 2 ) )
                call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\Undead\\ReplenishMana\\SpiritTouchTarget.mdl", GetUnitX( u ), GetUnitY( u ) ) )
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
    set g = null
    set caster = null
endfunction 

function Trig_TotemEnergy_Actions takes nothing returns nothing
	local integer id = GetHandleId( GetEnteringUnit() )
	
	call SaveTimerHandle( udg_hash, id, StringHash( "enrgy" ), CreateTimer( ) ) 
	set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "enrgy" ) ) ) 
	call SaveUnitHandle( udg_hash, id, StringHash( "enrgy" ), GetEnteringUnit() ) 
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( GetEnteringUnit() ), StringHash( "enrgy" ) ), 1, true, function TotemEnergyCast ) 
endfunction 

//===========================================================================
function InitTrig_TotemEnergy takes nothing returns nothing
    set gg_trg_TotemEnergy = CreateTrigger(  )
    call TriggerRegisterEnterRectSimple( gg_trg_TotemEnergy, GetWorldBounds() )
    call TriggerAddCondition( gg_trg_TotemEnergy, Condition( function Trig_TotemEnergy_Conditions ) )
    call TriggerAddAction( gg_trg_TotemEnergy, function Trig_TotemEnergy_Actions )
endfunction

