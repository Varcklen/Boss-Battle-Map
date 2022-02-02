function Trig_Rock2_Conditions takes nothing returns boolean
    return GetUnitTypeId(udg_DamageEventTarget) == 'n03J' and GetUnitLifePercent(udg_DamageEventTarget) <= 75
endfunction

function Rock2Cast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer( ) )
    local unit boss = LoadUnitHandle( udg_hash, id, StringHash( "bsrk2" ) )
    local item it
    local integer cyclA = 1
    local integer i = 0
    local group g = CreateGroup()
    local unit u
    local integer rand 

    if GetUnitState( boss, UNIT_STATE_LIFE) <= 0.405 or not( udg_fightmod[0] ) then
        call DestroyTimer( GetExpiredTimer() )
        call FlushChildHashtable( udg_hash, id )
    else
        call dummyspawn( boss, 1, 0, 0, 0 )
        call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\Human\\Thunderclap\\ThunderClapCaster.mdl", GetUnitX(boss), GetUnitY(boss) ) )
        call GroupEnumUnitsInRange( g, GetUnitX(boss), GetUnitY(boss), 400, null )
        loop
            set u = FirstOfGroup(g)
            exitwhen u == null
            if unitst( u, boss, "enemy" )  then
                call UnitDamageTarget( bj_lastCreatedUnit, u, 70, true, false, ATTACK_TYPE_HERO, DAMAGE_TYPE_NORMAL, WEAPON_TYPE_WHOKNOWS )
            endif
            call GroupRemoveUnit(g,u)
            set u = FirstOfGroup(g)
        endloop
        loop
            exitwhen cyclA > 1
            if i < 30 then
                set rand = GetRandomInt( 0, 2 )
                set it = CreateItem( 'III1' + rand, GetUnitX( boss ) + GetRandomReal( -400, 400 ), GetUnitY( boss ) + GetRandomReal( -400, 400 ) )
                if RectContainsItem( it, udg_Boss_Rect ) then
                    call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\Human\\Thunderclap\\ThunderClapCaster.mdl", GetItemX( it ), GetItemY( it ) ) )
                else
                    call RemoveItem( it )
                    set cyclA = cyclA - 1
                endif
            endif
            set i = i + 1
            set cyclA = cyclA + 1
        endloop
    endif
    
    call GroupClear( g )
    call DestroyGroup( g )
    set g = null
    set u = null
    set boss = null
    set it = null
endfunction

function Trig_Rock2_Actions takes nothing returns nothing
    local integer id = GetHandleId( udg_DamageEventTarget )

    call DisableTrigger( GetTriggeringTrigger() )

    if LoadTimerHandle( udg_hash, id, StringHash( "bsrk2" ) ) == null  then
        call SaveTimerHandle( udg_hash, id, StringHash( "bsrk2" ), CreateTimer() )
    endif
	set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "bsrk2" ) ) ) 
    call SaveUnitHandle( udg_hash, id, StringHash( "bsrk2" ), udg_DamageEventTarget )
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( udg_DamageEventTarget ), StringHash( "bsrk2" ) ), bosscast(7), true, function Rock2Cast )
endfunction

//===========================================================================
function InitTrig_Rock2 takes nothing returns nothing
    set gg_trg_Rock2 = CreateTrigger(  )
    call DisableTrigger( gg_trg_Rock2 )
    call TriggerRegisterVariableEvent( gg_trg_Rock2, "udg_AfterDamageEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_Rock2, Condition( function Trig_Rock2_Conditions ) )
    call TriggerAddAction( gg_trg_Rock2, function Trig_Rock2_Actions )
endfunction

