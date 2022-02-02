function Trig_SeaGiant1_Conditions takes nothing returns boolean
    return GetUnitTypeId( udg_DamageEventTarget ) == 'n00W'
endfunction

function SeaGiantWave takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local integer counter = LoadInteger( udg_hash, id, StringHash( "bssg2" ) ) + 1
    local unit dummy = LoadUnitHandle( udg_hash, id, StringHash( "bssg2" ) )
    local unit caster = LoadUnitHandle( udg_hash, id, StringHash( "bssg2cs" ) )
    local unit u
    local real NewX = GetUnitX( dummy ) + 10 * Cos( 0.017 * GetUnitFacing( dummy ) )
    local real NewY = GetUnitY( dummy ) + 10 * Sin( 0.017 * GetUnitFacing( dummy ) )
    local group nodmg = LoadGroupHandle( udg_hash, id, StringHash( "bssg2g" ) )
    local group g = CreateGroup()
    local boolean l = false

    if counter >= 400 or GetUnitState( dummy, UNIT_STATE_LIFE) <= 0.405 then
        call RemoveUnit( dummy )
        call GroupClear( nodmg )
        call DestroyGroup( nodmg )
        call FlushChildHashtable( udg_hash, id )
        call DestroyTimer( GetExpiredTimer() )
    else
        call SetUnitPosition( dummy, NewX, NewY )
        call SaveInteger( udg_hash, id, StringHash( "bssg2" ), counter )
        call GroupEnumUnitsInRange( g, GetUnitX( dummy ), GetUnitY( dummy ), 128, null )
        loop
            set u = FirstOfGroup(g)
            exitwhen u == null
            if unitst( u, caster, "enemy" ) and not( IsUnitInGroup( u, nodmg ) ) then
                call UnitDamageTarget( dummy, u, 150, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS )
                call GroupAddUnit( nodmg, u )
                set l = true
            endif
            call GroupRemoveUnit(g,u)
            set u = FirstOfGroup(g)
        endloop
        if l then
            call DestroyEffect( AddSpecialEffect( "Objects\\Spawnmodels\\Naga\\NagaDeath\\NagaDeath.mdl", GetUnitX( dummy ), GetUnitY( dummy ) ) )
            call RemoveUnit( dummy )
        endif
    endif
    
    call GroupClear( g )
    call DestroyGroup( g )
    set u = null
    set g = null
    set nodmg = null
    set dummy = null
    set caster = null
endfunction

function SeaGiantCast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer( ) )
    local integer id1
    local integer i = GetRandomInt( 1, 4 )
    local unit u = GroupPickRandomUnit(udg_otryad)
    local unit boss = LoadUnitHandle( udg_hash, id, StringHash( "bssg" ) )
    local real x = GetRectCenterX( udg_Boss_Rect ) + 2000 * Cos( ( 45 + ( 90 * i ) ) * bj_DEGTORAD )
    local real y = GetRectCenterY( udg_Boss_Rect ) + 2000 * Sin( ( 45 + ( 90 * i ) ) * bj_DEGTORAD )
    
    if GetUnitState( boss, UNIT_STATE_LIFE) <= 0.405 or not( udg_fightmod[0] ) then
        call FlushChildHashtable( udg_hash, id )
        call DestroyTimer( GetExpiredTimer() )
    else
        set bj_lastCreatedUnit = CreateUnit( GetOwningPlayer( boss ), 'u000', x, y, bj_RADTODEG * Atan2( GetUnitY( u ) - y, GetUnitX( u ) - x ) )
        call UnitAddAbility( bj_lastCreatedUnit, 'A0DI')
        call UnitAddAbility( bj_lastCreatedUnit, 'A0N5')
        
        call SaveTimerHandle( udg_hash, GetHandleId( bj_lastCreatedUnit ), StringHash( "bssg2" ), CreateTimer() )
        set id1 = GetHandleId( LoadTimerHandle( udg_hash, GetHandleId( bj_lastCreatedUnit ), StringHash( "bssg2" ) ) ) 
        call SaveUnitHandle( udg_hash, id1, StringHash( "bssg2" ), bj_lastCreatedUnit )
        call SaveUnitHandle( udg_hash, id1, StringHash( "bssg2cs" ), boss )
        call SaveGroupHandle( udg_hash, id1, StringHash( "bssg2g" ), CreateGroup() )
        call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( bj_lastCreatedUnit ), StringHash( "bssg2" ) ), 0.04, true, function SeaGiantWave )
    endif
    
    set u = null
    set boss = null
endfunction

function Trig_SeaGiant1_Actions takes nothing returns nothing
    local integer id = GetHandleId( udg_DamageEventTarget )

    call DisableTrigger( GetTriggeringTrigger() )
    
    if LoadTimerHandle( udg_hash, id, StringHash( "bssg" ) ) == null then
        call SaveTimerHandle( udg_hash, id, StringHash( "bssg" ), CreateTimer() )
    endif
	set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "bssg" ) ) ) 
    call SaveUnitHandle( udg_hash, id, StringHash( "bssg" ), udg_DamageEventTarget )
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( udg_DamageEventTarget ), StringHash( "bssg" ) ), bosscast(1), true, function SeaGiantCast )
endfunction

//===========================================================================
function InitTrig_SeaGiant1 takes nothing returns nothing
    set gg_trg_SeaGiant1 = CreateTrigger(  )
    call DisableTrigger( gg_trg_SeaGiant1 )
    call TriggerRegisterVariableEvent( gg_trg_SeaGiant1, "udg_AfterDamageEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_SeaGiant1, Condition( function Trig_SeaGiant1_Conditions ) )
    call TriggerAddAction( gg_trg_SeaGiant1, function Trig_SeaGiant1_Actions )
endfunction

