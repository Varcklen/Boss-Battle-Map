function Trig_Pyromant4_Conditions takes nothing returns boolean
    return GetUnitTypeId(udg_DamageEventTarget) == 'h00Z'
endfunction

function Pyromant4Cast1 takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer( ) )
    local unit boss = LoadUnitHandle( udg_hash, id, StringHash( "bspr6" ) )
    local unit dummy = LoadUnitHandle( udg_hash, id, StringHash( "bspr6d" ) )
    local integer counter = LoadInteger( udg_hash, id, StringHash( "bspr6" ) ) + 1
    local group g = CreateGroup()
    local unit u
    local real x = LoadReal( udg_hash, id, StringHash( "bspr6x" ) )
    local real y = LoadReal( udg_hash, id, StringHash( "bspr6y" ) )
    
    if counter >= 20 or not(udg_fightmod[0]) then
        call RemoveUnit( dummy )
        call DestroyTimer( GetExpiredTimer() )
        call FlushChildHashtable( udg_hash, id )
    else
        call SaveInteger( udg_hash, id, StringHash( "bspr6" ), counter )
        call GroupEnumUnitsInRange( g, x, y, 400, null )
        loop
            set u = FirstOfGroup(g)
            exitwhen u == null
            if unitst( u, boss, "enemy" ) then
                call UnitDamageTarget( dummy, u, 37, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS )
            endif
            call GroupRemoveUnit(g,u)
        endloop
    endif
    
    call GroupClear( g )
    call DestroyGroup( g )
    set u = null
    set g = null
    set dummy = null
    set boss = null
endfunction
    
function Pyromant4Cast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer( ) )
    local unit boss = LoadUnitHandle( udg_hash, id, StringHash( "bspr5" ))
    local integer id1
    local real x
    local real y
    
    if GetUnitState( boss, UNIT_STATE_LIFE) <= 0.405 or not( udg_fightmod[0] ) then
        call DestroyTimer( GetExpiredTimer() )
        call FlushChildHashtable( udg_hash, id )
    else
        set x = GetUnitX(boss) + GetRandomReal( -700, 700 )
        set y = GetUnitY(boss) + GetRandomReal( -700, 700 )
        //call dummyspawn( boss, 0, 'A0XE', 'A136', 0 )
        set bj_lastCreatedUnit = CreateUnit( GetOwningPlayer(boss), 'u000', x, y , 270 )
        call UnitAddAbility( bj_lastCreatedUnit, 'A0XE' )
        call UnitAddAbility( bj_lastCreatedUnit, 'A136' )
        call SetUnitScale(bj_lastCreatedUnit, 4, 4, 4 )
        call IssuePointOrder( bj_lastCreatedUnit, "flamestrike", x, y-1 )
        call spectime( "Abilities\\Spells\\Human\\FlameStrike\\FlameStrike1.mdl", x, y, 8 )
        
        set id1 = GetHandleId( bj_lastCreatedUnit )
        if LoadTimerHandle( udg_hash, id1, StringHash( "bspr6" ) ) == null  then
            call SaveTimerHandle( udg_hash, id1, StringHash( "bspr6" ), CreateTimer() )
        endif
        set id1 = GetHandleId( LoadTimerHandle( udg_hash, id1, StringHash( "bspr6" ) ) ) 
        call SaveUnitHandle( udg_hash, id1, StringHash( "bspr6" ), boss )
        call SaveUnitHandle( udg_hash, id1, StringHash( "bspr6d" ), bj_lastCreatedUnit )
        call SaveReal( udg_hash, id1, StringHash( "bspr6x" ), x )
        call SaveReal( udg_hash, id1, StringHash( "bspr6y" ), y )
        call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( bj_lastCreatedUnit ), StringHash( "bspr6" ) ), 0.5, true, function Pyromant4Cast1 )
    endif
    
    set boss = null
endfunction

function Trig_Pyromant4_Actions takes nothing returns nothing
    local integer id = GetHandleId( udg_DamageEventTarget )

    call DisableTrigger( GetTriggeringTrigger() )
    
    if LoadTimerHandle( udg_hash, id, StringHash( "bspr5" ) ) == null  then
        call SaveTimerHandle( udg_hash, id, StringHash( "bspr5" ), CreateTimer() )
    endif
	set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "bspr5" ) ) ) 
    call SaveUnitHandle( udg_hash, id, StringHash( "bspr5" ), udg_DamageEventTarget )
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( udg_DamageEventTarget ), StringHash( "bspr5" ) ), bosscast(12), true, function Pyromant4Cast )
endfunction

//===========================================================================
function InitTrig_Pyromant4 takes nothing returns nothing
    set gg_trg_Pyromant4 = CreateTrigger()
    call DisableTrigger( gg_trg_Pyromant4 )
    call TriggerRegisterVariableEvent( gg_trg_Pyromant4, "udg_DamageEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_Pyromant4, Condition( function Trig_Pyromant4_Conditions ) )
    call TriggerAddAction( gg_trg_Pyromant4, function Trig_Pyromant4_Actions )
endfunction

