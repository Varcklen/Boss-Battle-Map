function Trig_Pyromant3_Conditions takes nothing returns boolean
    return GetUnitTypeId(udg_DamageEventTarget) == 'h00Z' and GetUnitLifePercent(udg_DamageEventTarget) <= 25
endfunction

function Pyro3End takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local unit boss = LoadUnitHandle( udg_hash, id, StringHash( "bspr4" ) )
    local unit dummy = LoadUnitHandle( udg_hash, id, StringHash( "bspr4d" ) )
    local integer i = LoadInteger( udg_hash, id, StringHash( "bspr4" ) ) + 1
    local group g = CreateGroup()
    local unit u

    if GetUnitState( dummy, UNIT_STATE_LIFE) <= 0.405 or not(udg_fightmod[0]) or i > 15 then
        call DestroyTimer( GetExpiredTimer() )
        call FlushChildHashtable( udg_hash, id )
    else
        call SaveInteger( udg_hash, id, StringHash( "bspr4" ), i )
        call GroupEnumUnitsInRange( g, GetRectCenterX(udg_Boss_Rect), GetRectCenterY(udg_Boss_Rect), 2000, null )
        loop
            set u = FirstOfGroup(g)
            exitwhen u == null
            if unitst( u, boss, "enemy" ) then
                call UnitDamageTarget( dummy, u, 200, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS )
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

function Pyro3Cast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local unit boss = LoadUnitHandle( udg_hash, id, StringHash( "bspr2" ) )
    local integer id1

    if GetUnitState( boss, UNIT_STATE_LIFE) > 0.405 and ( udg_fightmod[0] ) then
        call pausest( boss, -1 )
        call SetUnitAnimation( boss, "stand")
        call dummyspawn( boss, 15, 'A0KW', 0, 0 )
        call IssuePointOrder( bj_lastCreatedUnit, "flamestrike", GetUnitX( boss ), GetUnitY( boss ) )
        
        set id1 = GetHandleId( bj_lastCreatedUnit )
        if LoadTimerHandle( udg_hash, id1, StringHash( "bspr4" ) ) == null  then
            call SaveTimerHandle( udg_hash, id1, StringHash( "bspr4" ), CreateTimer() )
        endif
        set id1 = GetHandleId( LoadTimerHandle( udg_hash, id1, StringHash( "bspr4" ) ) ) 
        call SaveUnitHandle( udg_hash, id1, StringHash( "bspr4" ), boss )
        call SaveUnitHandle( udg_hash, id1, StringHash( "bspr4d" ), bj_lastCreatedUnit )
        call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( bj_lastCreatedUnit ), StringHash( "bspr4" ) ), 1, true, function Pyro3End )
    endif
    call FlushChildHashtable( udg_hash, id )
    
    set boss = null
endfunction

function Trig_Pyromant3_Actions takes nothing returns nothing
    local integer id = GetHandleId( udg_DamageEventTarget )

    call DisableTrigger( GetTriggeringTrigger() )
    call SetUnitPosition( udg_DamageEventTarget, GetRectCenterX(udg_Boss_Rect), GetRectCenterY(udg_Boss_Rect) + 600 )
    call SetUnitFacing(udg_DamageEventTarget, 270 )
    call DestroyEffect( AddSpecialEffectTarget( "Abilities\\Spells\\Human\\MassTeleport\\MassTeleportCaster.mdl", udg_DamageEventTarget, "origin") )
    
    call pausest( udg_DamageEventTarget, 1 )
    call SetUnitAnimationWithRarity( udg_DamageEventTarget, "spell channel", RARITY_FREQUENT )
    
    if LoadTimerHandle( udg_hash, id, StringHash( "bspr2" ) ) == null  then
        call SaveTimerHandle( udg_hash, id, StringHash( "bspr2" ), CreateTimer() )
    endif
	set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "bspr2" ) ) ) 
    call SaveUnitHandle( udg_hash, id, StringHash( "bspr2" ), udg_DamageEventTarget )
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( udg_DamageEventTarget ), StringHash( "bspr2" ) ), bosscast(12), false, function Pyro3Cast )
endfunction

//===========================================================================
function InitTrig_Pyromant3 takes nothing returns nothing
    set gg_trg_Pyromant3 = CreateTrigger(  )
    call DisableTrigger( gg_trg_Pyromant3 )
    call TriggerRegisterVariableEvent( gg_trg_Pyromant3, "udg_AfterDamageEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_Pyromant3, Condition( function Trig_Pyromant3_Conditions ) )
    call TriggerAddAction( gg_trg_Pyromant3, function Trig_Pyromant3_Actions )
endfunction

