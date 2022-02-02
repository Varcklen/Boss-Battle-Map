function Trig_MountGiant2_Conditions takes nothing returns boolean
    return GetUnitTypeId( udg_DamageEventTarget ) == 'e000' and GetUnitLifePercent(udg_DamageEventTarget) <= 90
endfunction

function MountGiant2End takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local integer counter = LoadInteger( udg_hash, id, StringHash( "bsmg4" ) ) + 1
    local unit boss = LoadUnitHandle( udg_hash, id, StringHash( "bsmg4" ) )
    local integer id1
    local group g = CreateGroup()
    local unit u
    local real x
    local real y
    
    if counter >= 2 then
        if GetUnitState( boss, UNIT_STATE_LIFE) > 0.405 and ( udg_fightmod[0] ) then
            call pausest( boss, -1 )

            call UnitRemoveAbility( boss, 'A06Z')
            call UnitRemoveAbility( boss, 'B019')

            set x = GetUnitX( boss ) + 175 * Cos( 0.017 * GetUnitFacing( boss ) )
            set y = GetUnitY( boss ) + 175 * Sin( 0.017 * GetUnitFacing( boss ) )
            call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\Human\\ThunderClap\\ThunderClapCaster.mdl", x, y ) )
            call dummyspawn( boss, 1, 0, 0, 0 )
            call GroupEnumUnitsInRange( g, x, y, 142, null )
            loop
                set u = FirstOfGroup(g)
                exitwhen u == null
                if unitst( u, boss, "enemy" ) then
                    call UnitDamageTarget( bj_lastCreatedUnit, u, 1000, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS )
                endif
                call GroupRemoveUnit(g,u)
                set u = FirstOfGroup(g)
            endloop
            call IssueImmediateOrder( boss, "stop" )
            call SetUnitAnimation( boss, "attack slam" )
            if GetUnitCurrentOrder(boss) == OrderId("stand") then
                call aggro( boss )
            endif
        endif
        call DestroyTimer( GetExpiredTimer() )
        call FlushChildHashtable( udg_hash, id )
    else
        call SaveInteger( udg_hash, id, StringHash( "bsmg4" ), counter )
        if GetUnitState( boss, UNIT_STATE_LIFE) > 0.405 then
            call SetUnitAnimation( boss, "spell" )
        endif
    endif
    
    call GroupClear( g )
    call DestroyGroup( g )
    set g = null
    set u = null
    set boss = null
endfunction

function MountGiant2Cast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local unit boss = LoadUnitHandle( udg_hash, id, StringHash( "bsmg3" ) )
    local integer id1 = GetHandleId( boss )
    
    if GetUnitState( boss, UNIT_STATE_LIFE) <= 0.405 or not( udg_fightmod[0] ) then
        call DestroyTimer( GetExpiredTimer() )
        call FlushChildHashtable( udg_hash, id )
    else
        call pausest( boss, 1 )
        call SetUnitAnimation( boss, "spell" )
        call UnitAddAbility( boss, 'A06Z' )
        
        if LoadTimerHandle( udg_hash, id1, StringHash( "bsmg4" ) ) == null  then
            call SaveTimerHandle( udg_hash, id1, StringHash( "bsmg4" ), CreateTimer() )
        endif
        set id1 = GetHandleId( LoadTimerHandle( udg_hash, id1, StringHash( "bsmg4" ) ) ) 
        call SaveUnitHandle( udg_hash, id1, StringHash( "bsmg4" ), boss )
        call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( boss ), StringHash( "bsmg4" ) ), 1, true, function MountGiant2End )
    endif
    
    set boss = null
endfunction

function Trig_MountGiant2_Actions takes nothing returns nothing
    local integer id = GetHandleId( udg_DamageEventTarget )
    
    call DisableTrigger( GetTriggeringTrigger() )

    if LoadTimerHandle( udg_hash, id, StringHash( "bsmg3" ) ) == null  then
        call SaveTimerHandle( udg_hash, id, StringHash( "bsmg3" ), CreateTimer() )
    endif
	set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "bsmg3" ) ) ) 
    call SaveUnitHandle( udg_hash, id, StringHash( "bsmg3" ), udg_DamageEventTarget )
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( udg_DamageEventTarget ), StringHash( "bsmg3" ) ), bosscast(12), true, function MountGiant2Cast )
endfunction

//===========================================================================
function InitTrig_MountGiant2 takes nothing returns nothing
    set gg_trg_MountGiant2 = CreateTrigger()
    call DisableTrigger( gg_trg_MountGiant2 )
    call TriggerRegisterVariableEvent( gg_trg_MountGiant2, "udg_AfterDamageEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_MountGiant2, Condition( function Trig_MountGiant2_Conditions ) )
    call TriggerAddAction( gg_trg_MountGiant2, function Trig_MountGiant2_Actions )
endfunction

