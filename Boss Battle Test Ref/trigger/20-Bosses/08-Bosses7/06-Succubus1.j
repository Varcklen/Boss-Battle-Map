function Trig_Succubus1_Conditions takes nothing returns boolean
    return GetUnitTypeId(udg_DamageEventTarget) == 'n01S'
endfunction

function SucRun takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer( ) )
    local unit boss = LoadUnitHandle( udg_hash, id, StringHash( "bssc1" ) )
    local unit target = LoadUnitHandle( udg_hash, id, StringHash( "bssc1t" ) )
    local integer counter = LoadInteger( udg_hash, id, StringHash( "bssc1" ) ) + 1
    local real x = GetUnitX( target )
    local real y = GetUnitY( target )
    local real angle = Atan2( y - GetUnitY( boss ), x - GetUnitX( boss ) )
    local real NewX = GetUnitX( boss ) + 30 * Cos( angle )
    local real NewY = GetUnitY( boss ) + 30 * Sin( angle )
    local group g = CreateGroup()
    local unit u
    local integer i = 0
    
    set bj_livingPlayerUnitsTypeId = 'n036'
    call GroupEnumUnitsOfPlayer(g, GetOwningPlayer( boss ), filterLivingPlayerUnitsOfTypeId)
    loop
        set u = FirstOfGroup(g)
        exitwhen u == null
        set i = i + 1
        call GroupRemoveUnit(g,u)
        set u = FirstOfGroup(g)
    endloop
    
    if counter == 10 then
        call SetUnitFlyHeight( boss, -100, 300 )
    endif

    if counter == 20 or GetUnitState( boss, UNIT_STATE_LIFE) <= 0.405 or not( udg_fightmod[0] ) then
        call SetUnitPathing( boss, true )
        call UnitRemoveAbility( boss, 'Amrf' )
        call pausest( boss, -1 )
        if GetUnitState( target, UNIT_STATE_LIFE) > 0.405 and GetOwningPlayer( boss ) == Player(10) then
            call SetUnitState( boss, UNIT_STATE_LIFE, GetUnitState( boss, UNIT_STATE_LIFE) + ( 75 * SpellPower_GetBossSpellPower() ) )
            call dummyspawn( boss, 1, 0, 0, 0 )
            call DestroyEffect( AddSpecialEffect( "Objects\\Spawnmodels\\Human\\HumanLargeDeathExplode\\HumanLargeDeathExplode.mdl", GetUnitX( target ), GetUnitY( target ) ) )
            call UnitDamageTarget( bj_lastCreatedUnit, target, 75, true, false, ATTACK_TYPE_HERO, DAMAGE_TYPE_NORMAL, WEAPON_TYPE_WHOKNOWS)
            if i <= 15 then
                set bj_lastCreatedUnit = CreateUnit( GetOwningPlayer( boss ), 'n036', GetUnitX( target ) + GetRandomReal(-400, 400), GetUnitY( target ) + GetRandomReal(-400, 400), GetRandomReal( 0, 360 ) )
                call DestroyEffect( AddSpecialEffectTarget( "Abilities\\Spells\\Other\\Doom\\DoomDeath.mdl", bj_lastCreatedUnit, "origin") )
                set udg_DamageEventTarget = bj_lastCreatedUnit
                call TriggerExecute( gg_trg_Succubus1 )
            endif
        endif
        call DestroyTimer( GetExpiredTimer() )
        call FlushChildHashtable( udg_hash, id ) 
    else 
        call SaveInteger( udg_hash, id, StringHash( "bssc1" ), counter )
        call SetUnitPosition( boss, NewX, NewY )
    endif
    
	call GroupClear( g )
    call DestroyGroup( g )
    set u = null
    set g = null
    set boss = null
    set target = null
endfunction

function SucCast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer( ) )
    local unit boss = LoadUnitHandle( udg_hash, id, StringHash( "bssc" ))
    local integer id1 = GetHandleId( boss )
    local unit target
    local real x
    local real y

    if GetUnitState( boss, UNIT_STATE_LIFE) <= 0.405 or not( udg_fightmod[0] ) then
        call DestroyTimer( GetExpiredTimer() )
        call FlushChildHashtable( udg_hash, id )
    else
        set target = randomtarget( boss, 600, "enemy", "", "", "", "" )
        if target != null then
            set x = GetUnitX( target )
            set y = GetUnitY( target )
            call SetUnitFacing( boss, bj_RADTODEG * Atan2(GetUnitY(target) - GetUnitY(boss), GetUnitX(target) - GetUnitX(boss) ) )
            call pausest( boss, 1 )
            call UnitAddAbility( boss, 'Amrf' )
            call SetUnitFlyHeight( boss, 100, 300 )
            call SetUnitPathing( boss, true )

            if LoadTimerHandle( udg_hash, id1, StringHash( "bssc1" ) ) == null  then
                call SaveTimerHandle( udg_hash, id1, StringHash( "bssc1" ), CreateTimer() )
            endif
            set id1 = GetHandleId( LoadTimerHandle( udg_hash, id1, StringHash( "bssc1" ) ) )
            call SaveUnitHandle( udg_hash, id1, StringHash( "bssc1" ), boss )
            call SaveUnitHandle( udg_hash, id1, StringHash( "bssc1t" ), target )
            call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( boss ), StringHash( "bssc1" ) ), 0.02, true, function SucRun ) 
        endif
    endif
    
    set boss = null
    set target = null
endfunction

function Trig_Succubus1_Actions takes nothing returns nothing
    local integer id = GetHandleId( udg_DamageEventTarget )

    call DisableTrigger( GetTriggeringTrigger() )
    
    if LoadTimerHandle( udg_hash, id, StringHash( "bssc" ) ) == null  then
        call SaveTimerHandle( udg_hash, id, StringHash( "bssc" ), CreateTimer() )
    endif
	set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "bssc" ) ) ) 
    call SaveUnitHandle( udg_hash, id, StringHash( "bssc" ), udg_DamageEventTarget )
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( udg_DamageEventTarget ), StringHash( "bssc" ) ), bosscast(8), true, function SucCast )
endfunction

//===========================================================================
function InitTrig_Succubus1 takes nothing returns nothing
    set gg_trg_Succubus1 = CreateTrigger(  )
    call DisableTrigger( gg_trg_Succubus1 )
    call TriggerRegisterVariableEvent( gg_trg_Succubus1, "udg_AfterDamageEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_Succubus1, Condition( function Trig_Succubus1_Conditions ) )
    call TriggerAddAction( gg_trg_Succubus1, function Trig_Succubus1_Actions )
endfunction

