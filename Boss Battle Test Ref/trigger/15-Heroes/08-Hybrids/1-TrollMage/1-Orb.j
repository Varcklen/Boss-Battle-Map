function Trig_Orb_Conditions takes nothing returns boolean
    return GetUnitTypeId(GetEnteringUnit()) == 'u000' and GetUnitAbilityLevel(GetEnteringUnit(), 'A04J') > 0
endfunction

function OrbCast takes nothing returns nothing 
	local integer id = GetHandleId( GetExpiredTimer( ) )
    local unit caster = LoadUnitHandle( udg_hash, id, StringHash( "orbc" ) )
    local unit un = LoadUnitHandle( udg_hash, id, StringHash( "orb" ) )
    local real dmg = LoadReal( udg_hash, id, StringHash( "orbd" ) )
    local real heal = LoadReal( udg_hash, id, StringHash( "orbh" ) )
    local group g = CreateGroup()
    local unit u

    if GetUnitState( un, UNIT_STATE_LIFE) > 0.405 then
    	call GroupEnumUnitsInRange( g, GetUnitX( un ), GetUnitY( un ), 182, null )
    	loop
        	set u = FirstOfGroup(g)
        	exitwhen u == null
        	if unitst( u, un, "enemy" ) then
        	    call UnitDamageTarget( un, u, dmg, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS )
            elseif unitst( u, un, "ally" ) then
                call healst(caster, u, heal)
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
    set un = null
    set g = null
    set caster = null
endfunction 

function Trig_Orb_Actions takes nothing returns nothing
    local integer i = GetPlayerId(GetOwningPlayer(GetEnteringUnit())) + 1
	local integer id = GetHandleId( GetEnteringUnit() )
    
	call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\Human\\Invisibility\\InvisibilityTarget.mdl", GetUnitX(GetEnteringUnit()), GetUnitY(GetEnteringUnit()) ) )
    
    call UnitApplyTimedLife( GetEnteringUnit(), 'BTLF', 30 )
    
	call SaveTimerHandle( udg_hash, id, StringHash( "orb" ), CreateTimer( ) ) 
	set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "orb" ) ) ) 
	call SaveUnitHandle( udg_hash, id, StringHash( "orb" ), GetEnteringUnit() ) 
    call SaveReal( udg_hash, id, StringHash( "orbd" ), 5*udg_SpellDamageSpec[i] ) 
    call SaveReal( udg_hash, id, StringHash( "orbh" ), 5*udg_SpellDamageSpec[i] )
	call SaveUnitHandle( udg_hash, id, StringHash( "orbc" ), udg_hero[i] ) 
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( GetEnteringUnit() ), StringHash( "orb" ) ), 1, true, function OrbCast ) 
endfunction 

//===========================================================================
function InitTrig_Orb takes nothing returns nothing
    set gg_trg_Orb = CreateTrigger(  )
    call TriggerRegisterEnterRectSimple( gg_trg_Orb, GetWorldBounds() )
    call TriggerAddCondition( gg_trg_Orb, Condition( function Trig_Orb_Conditions ) )
    call TriggerAddAction( gg_trg_Orb, function Trig_Orb_Actions )
endfunction

