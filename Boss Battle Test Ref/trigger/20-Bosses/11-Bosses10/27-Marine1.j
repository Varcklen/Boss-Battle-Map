function Trig_Marine1_Conditions takes nothing returns boolean
    return GetUnitTypeId(GetEnteringUnit()) == 'n04N'
endfunction

function Marine1End takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer( ) )
    local unit boss = LoadUnitHandle( udg_hash, id, StringHash( "bsmr2" ) )
    local group g = CreateGroup()
    local unit u

    if GetUnitState( boss, UNIT_STATE_LIFE) > 0.405 and udg_fightmod[0] then
        call PauseUnit( boss, false )
        call UnitRemoveAbility( boss, 'Amrf')
        call DestroyEffect( AddSpecialEffect("Abilities\\Spells\\Human\\Thunderclap\\ThunderClapCaster.mdl", GetUnitX( boss ), GetUnitY( boss ) ) )
        call GroupEnumUnitsInRange( g, GetUnitX( boss ), GetUnitY( boss ), 400, null )
        loop
            set u = FirstOfGroup(g)
            exitwhen u == null
            if unitst( u, boss, "enemy" ) then
                call UnitStun(boss, u, 3 )
            endif
            call GroupRemoveUnit(g,u)
        endloop
    endif
    call FlushChildHashtable( udg_hash, id )
    
    call GroupClear( g )
    call DestroyGroup( g )
    set u = null
    set g = null
    set boss = null
endfunction

function Marine1Cast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer( ) )
    local unit boss = LoadUnitHandle( udg_hash, id, StringHash( "bsmr1" ))
    local integer id1
    local unit c = GroupPickRandomUnit(udg_otryad)
    local real x
    local real y
    
    if c != null then
        set x = GetUnitX(c)
        set y = GetUnitY(c)
    else
        set x = GetUnitX(boss)
        set y = GetUnitY(boss)
    endif

    if GetUnitState( boss, UNIT_STATE_LIFE) > 0.405 and udg_fightmod[0] then
        call TransmissionFromUnitWithNameBJ( bj_FORCE_ALL_PLAYERS, boss, GetUnitName(boss), null, "Surprise!", bj_TIMETYPE_SET, 3, false )
        call SetUnitPosition( boss, x, y )
        call ShowUnit( boss, true )
        call SetUnitFlyHeight( boss, -600, 3000 )
        
        set id1 = GetHandleId( boss )
        call SaveTimerHandle( udg_hash, id1, StringHash( "bsmr2" ), CreateTimer() )
        set id1 = GetHandleId( LoadTimerHandle( udg_hash, id1, StringHash( "bsmr2" ) ) ) 
        call SaveUnitHandle( udg_hash, id1, StringHash( "bsmr2" ), boss )
        call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( boss ), StringHash( "bsmr2" ) ), 1.1, false, function Marine1End )
    endif

    call FlushChildHashtable( udg_hash, id )
    
    set boss = null
    set c = null
endfunction

function Trig_Marine1_Actions takes nothing returns nothing
    local integer id = GetHandleId( GetEnteringUnit() )
    
    call ShowUnit( GetEnteringUnit(), false)
    call PauseUnit( GetEnteringUnit(), true )
    call UnitAddAbility( GetEnteringUnit(), 'Amrf')
    call SetUnitFlyHeight( GetEnteringUnit(), 3000, 3000 )
    call TransmissionFromUnitWithNameBJ( bj_FORCE_ALL_PLAYERS, GetEnteringUnit(), GetUnitName(GetEnteringUnit()), null, "Do you want to find me? Hehe...", bj_TIMETYPE_SET, 3, false )
    
    if LoadTimerHandle( udg_hash, id, StringHash( "bsmr1" ) ) == null  then
        call SaveTimerHandle( udg_hash, id, StringHash( "bsmr1" ), CreateTimer() )
    endif
    set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "bsmr1" ) ) ) 
    call SaveUnitHandle( udg_hash, id, StringHash( "bsmr1" ), GetEnteringUnit() )
    call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( GetEnteringUnit() ), StringHash( "bsmr1" ) ), 10, false, function Marine1Cast )
endfunction

//===========================================================================
function InitTrig_Marine1 takes nothing returns nothing
    set gg_trg_Marine1 = CreateTrigger(  )
    call TriggerRegisterEnterRectSimple( gg_trg_Marine1, GetWorldBounds() )
    call TriggerAddCondition( gg_trg_Marine1, Condition( function Trig_Marine1_Conditions ) )
    call TriggerAddAction( gg_trg_Marine1, function Trig_Marine1_Actions )
endfunction

