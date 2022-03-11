function Trig_FallenOneIdol_Conditions takes nothing returns boolean
    return GetUnitTypeId(GetEnteringUnit()) == 'o01K'
endfunction

function FallenOneIdolEnd takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer( ) )
    local unit caster = LoadUnitHandle( udg_hash, id, StringHash( "flne1" ) )
    
    call UnitRemoveAbility( caster, 'A0BS' )
    call UnitRemoveAbility( caster, 'A0BT' )
    call UnitRemoveAbility( caster, 'B08I' )
    call FlushChildHashtable( udg_hash, id )
    
    set caster = null
endfunction

function FallenOneIdolCast takes nothing returns nothing 
	local integer id = GetHandleId( GetExpiredTimer( ) )
    local unit caster = LoadUnitHandle( udg_hash, id, StringHash( "flne" ) )
    local real dmg = LoadReal( udg_hash, GetHandleId( caster ), StringHash( "flned" ) )
    local integer lvl = LoadInteger( udg_hash, GetHandleId( caster ), StringHash( "flnelvl" ) )
    local group g = CreateGroup()
    local unit u
    local real coef
    local integer id1

    if GetUnitState( caster, UNIT_STATE_LIFE) > 0.405 then
        call dummyspawn( caster, 1, 0, 0, 0 )
        call spectimeunit( caster, "Abilities\\Spells\\NightElf\\Starfall\\StarfallCaster.mdl", "origin", 2 )
    	call GroupEnumUnitsInRange( g, GetUnitX( caster ), GetUnitY( caster ), 600, null )
    	loop
        	set u = FirstOfGroup(g)
        	exitwhen u == null
        	if unitst( u, caster, "enemy" ) then
                set coef = RMaxBJ(0,(600-DistanceBetweenUnits(caster, u))/300)
                call UnitDamageTarget( bj_lastCreatedUnit, u, dmg*coef, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS )

                if GetUnitState( u, UNIT_STATE_LIFE) > 0.405 then
                    set id1 = GetHandleId( u )
                    call UnitAddAbility( u, 'A0BS' )
                    call UnitAddAbility( u, 'A0BT' )
                    call SetUnitAbilityLevel( u, 'A0BT', lvl )
                    if LoadTimerHandle( udg_hash, id1, StringHash( "flne1" ) ) == null  then
                        call SaveTimerHandle( udg_hash, id1, StringHash( "flne1" ), CreateTimer() )
                    endif
                    set id1 = GetHandleId( LoadTimerHandle(udg_hash, id1, StringHash( "flne1" ) ) )
                    call SaveUnitHandle( udg_hash, id1, StringHash( "flne1" ), u )
                    call SaveReal( udg_hash, GetHandleId( u ), StringHash( "flne1m" ), 0.04+(0.04*lvl) )
                    call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( u ), StringHash( "flne1" ) ), 10, false, function FallenOneIdolEnd )

                    call debuffst( caster, u, null, lvl, 10 )
                endif
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

function Trig_FallenOneIdol_Actions takes nothing returns nothing
	local integer id = GetHandleId( GetEnteringUnit() )
    local integer lvlbasis = 3
	
    if LoadInteger( udg_hash, GetHandleId( GetEnteringUnit() ), StringHash( "flnelvl" )) == 0 then
        call SaveReal( udg_hash, GetHandleId( GetEnteringUnit() ), StringHash( "flned" ), 80 + (lvlbasis*20) )
        call SaveInteger( udg_hash, GetHandleId( GetEnteringUnit() ), StringHash( "flnelvl" ), lvlbasis )
    endif
    
	call SaveTimerHandle( udg_hash, id, StringHash( "flne" ), CreateTimer( ) ) 
	set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "flne" ) ) ) 
	call SaveUnitHandle( udg_hash, id, StringHash( "flne" ), GetEnteringUnit() ) 
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( GetEnteringUnit() ), StringHash( "flne" ) ), 3, true, function FallenOneIdolCast ) 
endfunction 

//===========================================================================
function InitTrig_FallenOneIdol takes nothing returns nothing
    set gg_trg_FallenOneIdol = CreateTrigger(  )
    call TriggerRegisterEnterRectSimple( gg_trg_FallenOneIdol, GetWorldBounds() )
    call TriggerAddCondition( gg_trg_FallenOneIdol, Condition( function Trig_FallenOneIdol_Conditions ) )
    call TriggerAddAction( gg_trg_FallenOneIdol, function Trig_FallenOneIdol_Actions )
endfunction

