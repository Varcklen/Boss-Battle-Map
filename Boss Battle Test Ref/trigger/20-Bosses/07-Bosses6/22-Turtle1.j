function Trig_Turtle1_Conditions takes nothing returns boolean
    return GetUnitTypeId( udg_DamageEventTarget ) == 'h01R'
endfunction

function Turtle1End takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local unit u = LoadUnitHandle( udg_hash, id, StringHash( "bstt1" ) )
    
    call UnitRemoveAbility( u, 'A13B' )
    call UnitRemoveAbility( u, 'B05X' )
    call FlushChildHashtable( udg_hash, id )
    
    set u = null
endfunction

function Turtle1Cast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local integer id1
    local unit boss = LoadUnitHandle( udg_hash, id, StringHash( "bstt" ) )
    local group g = CreateGroup()
    local unit u
    local boolean l = false

    if GetUnitState( boss, UNIT_STATE_LIFE) <= 0.405 or not( udg_fightmod[0] ) then
        call DestroyTimer( GetExpiredTimer() )
        call FlushChildHashtable( udg_hash, id )
    else
        call GroupEnumUnitsInRange( g, GetUnitX( boss ), GetUnitY( boss ), 700, null )
        loop
            set u = FirstOfGroup(g)
            exitwhen u == null
            if IsUnitType( u, UNIT_TYPE_HERO) then
                set l = true
            endif
            call GroupRemoveUnit(g,u)
        endloop
        if not( l ) then
            set id1 = GetHandleId( boss )
            call UnitAddAbility( boss, 'A13B' )
            
            if LoadTimerHandle( udg_hash, id1, StringHash( "bstt1" ) ) == null  then
                call SaveTimerHandle( udg_hash, id1, StringHash( "bstt1" ), CreateTimer() )
                call DestroyEffect( AddSpecialEffectTarget("Abilities\\Spells\\NightElf\\BattleRoar\\RoarCaster.mdl", boss, "origin" ) )
            endif
            set id1 = GetHandleId( LoadTimerHandle( udg_hash, id1, StringHash( "bstt1" ) ) ) 
            call SaveUnitHandle( udg_hash, id1, StringHash( "bstt1" ), boss )
            call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( boss ), StringHash( "bstt1" ) ), 15, false, function Turtle1End )
        endif
    endif
    
    call GroupClear( g )
    call DestroyGroup( g )
    set u = null
    set g = null
    set boss = null
endfunction

function Trig_Turtle1_Actions takes nothing returns nothing
    local integer id = GetHandleId( udg_DamageEventTarget )

    call DisableTrigger( GetTriggeringTrigger() )

    if LoadTimerHandle( udg_hash, id, StringHash( "bstt" ) ) == null  then
        call SaveTimerHandle( udg_hash, id, StringHash( "bstt" ), CreateTimer() )
    endif
	set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "bstt" ) ) ) 
    call SaveUnitHandle( udg_hash, id, StringHash( "bstt" ), udg_DamageEventTarget )
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( udg_DamageEventTarget ), StringHash( "bstt" ) ), 1, true, function Turtle1Cast )
endfunction

//===========================================================================
function InitTrig_Turtle1 takes nothing returns nothing
    set gg_trg_Turtle1 = CreateTrigger(  )
    call DisableTrigger( gg_trg_Turtle1 )
    call TriggerRegisterVariableEvent( gg_trg_Turtle1, "udg_AfterDamageEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_Turtle1, Condition( function Trig_Turtle1_Conditions ) )
    call TriggerAddAction( gg_trg_Turtle1, function Trig_Turtle1_Actions )
endfunction

