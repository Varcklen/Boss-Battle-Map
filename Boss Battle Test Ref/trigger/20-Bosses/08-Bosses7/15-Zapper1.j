function Trig_Zapper1_Conditions takes nothing returns boolean
    return GetUnitTypeId(udg_DamageEventTarget) == 'n00Q'
endfunction

function Zapper1Cast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local real r = LoadReal( udg_hash, id, StringHash( "bszp1" ) )
    local unit boss = LoadUnitHandle( udg_hash, id, StringHash( "bszp1" ) )
    local unit dummy = LoadUnitHandle( udg_hash, id, StringHash( "bszp1d" ) )
    local real xc = LoadReal( udg_hash, id, StringHash( "bszp1x" ) )
    local real yc = LoadReal( udg_hash, id, StringHash( "bszp1y" ) )
    local real x
    local real y
    
    if GetUnitState( boss, UNIT_STATE_LIFE) <= 0.405 or not( udg_fightmod[0] ) then
        call RemoveUnit( dummy )
        call DestroyTimer( GetExpiredTimer() )
        call FlushChildHashtable( udg_hash, id )
    else
        set x = xc + 1000 * Cos( r * bj_DEGTORAD)
        set y = yc + 1000 * Sin( r * bj_DEGTORAD)
        call SaveReal( udg_hash, id, StringHash( "bszp1" ), r + 1 )
        call SetUnitPosition( dummy, x, y )
        call SetUnitFacing( dummy, 90 + r )
    endif
    
    set boss = null
    set dummy = null
endfunction

function Zapper2Fire takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer( ) )
    local unit dummy = LoadUnitHandle( udg_hash, id, StringHash( "bszpfire" ) )
    local unit un = LoadUnitHandle( udg_hash, id, StringHash( "bszpfireu" ) )
    local unit t = LoadUnitHandle( udg_hash, id, StringHash( "bszpfiret" ) )
    local real x = LoadReal( udg_hash, id, StringHash( "bszpfirex" ) )
    local real y = LoadReal( udg_hash, id, StringHash( "bszpfirey" ) )
    local real r = LoadReal( udg_hash, id, StringHash( "bszpfire" ) )
    local real angle = Atan2( y - GetUnitY( dummy ), x - GetUnitX( dummy ) )
    local real NewX = GetUnitX( dummy ) + 0.04 * r * Cos( angle )
    local real NewY = GetUnitY( dummy ) + 0.04 * r * Sin( angle )
    local real IfX = ( ( x - GetUnitX( dummy ) ) * ( x - GetUnitX( dummy ) ) )
    local real IfY = ( ( y - GetUnitY( dummy ) ) * ( y - GetUnitY( dummy ) ) )
    local group g = CreateGroup()
    local unit u
    
    if GetUnitState( un, UNIT_STATE_LIFE) <= 0.405 or not( udg_fightmod[0] ) or SquareRoot( IfX + IfY ) <= 25 then
        if GetUnitState( un, UNIT_STATE_LIFE) > 0.405 then
            call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\Other\\Incinerate\\FireLordDeathExplode.mdl", NewX, NewY ) )
            call GroupEnumUnitsInRange( g, NewX, NewY, 200, null )
            loop
                set u = FirstOfGroup(g)
                exitwhen u == null
                if unitst( u, un, "enemy" ) then
                    call UnitDamageTarget( dummy, u, 100, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_FIRE, WEAPON_TYPE_WHOKNOWS )
                endif
                call GroupRemoveUnit(g,u)
                set u = FirstOfGroup(g)
            endloop
        endif
        call RemoveUnit( t )
        call RemoveUnit( dummy )
        call DestroyTimer( GetExpiredTimer() )
        call FlushChildHashtable( udg_hash, id ) 
    else 
        call SetUnitPosition( dummy, NewX, NewY )
    endif
    
    call GroupClear( g )
    call DestroyGroup( g )
    set u = null
    set g = null
    set un = null
    set t = null
    set dummy = null
endfunction

function Zapper2Cast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local unit u = LoadUnitHandle( udg_hash, id, StringHash( "bszp" ) )
    local unit t
    local real r
    local real x
    local real y
    local integer id1
    
    if GetUnitState( u, UNIT_STATE_LIFE) <= 0.405 or not( udg_fightmod[0] ) then
        call DestroyTimer( GetExpiredTimer() )
        call FlushChildHashtable( udg_hash, id )
    else
        set t = CreateUnit( GetOwningPlayer( u ), 'u000', GetUnitX( u ) + GetRandomReal( -900, 900 ), GetUnitY( u ) + GetRandomReal( -900, 900 ), 270 )
        call UnitAddAbility( t, 'A136')
        call dummyspawn( u, 0, 'A07D', 0, 0 )
        set x = GetUnitX(bj_lastCreatedUnit) - GetUnitX(t)
        set y = GetUnitY(bj_lastCreatedUnit) - GetUnitY(t)
        set r = SquareRoot(x * x + y * y)
        call SetUnitFlyHeight( bj_lastCreatedUnit, 500, -r / ( r * 0.04 ) )
        set id1 = GetHandleId( bj_lastCreatedUnit )
        if LoadTimerHandle( udg_hash, id1, StringHash( "bszpfire" ) ) == null  then
            call SaveTimerHandle( udg_hash, id1, StringHash( "bszpfire" ), CreateTimer() )
        endif
        set id1 = GetHandleId( LoadTimerHandle( udg_hash, id1, StringHash( "bszpfire" ) ) ) 
        call SaveReal( udg_hash, id1, StringHash( "bszpfirex" ), GetUnitX( t ) ) 
        call SaveReal( udg_hash, id1, StringHash( "bszpfirey" ), GetUnitY( t ) )
        call SaveReal( udg_hash, id1, StringHash( "bszpfire" ), r ) 
        call SaveUnitHandle( udg_hash, id1, StringHash( "bszpfire" ), bj_lastCreatedUnit )
        call SaveUnitHandle( udg_hash, id1, StringHash( "bszpfiret" ), t )
        call SaveUnitHandle( udg_hash, id1, StringHash( "bszpfireu" ), u )
        call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( bj_lastCreatedUnit ), StringHash( "bszpfire" ) ), 0.04, true, function Zapper2Fire )
    endif
    
    set t = null
endfunction

function Trig_Zapper1_Actions takes nothing returns nothing
    local integer id 
    local real x = GetRectCenterX(udg_Boss_Rect)
    local real y = GetRectCenterY(udg_Boss_Rect) + 300

    call DisableTrigger( GetTriggeringTrigger() )
    set bj_lastCreatedUnit = CreateUnit( GetOwningPlayer( udg_DamageEventTarget ), 'u005', x, y, GetUnitFacing(udg_DamageEventTarget) )
    
    set id = GetHandleId( bj_lastCreatedUnit )
    if LoadTimerHandle( udg_hash, id, StringHash( "bszp" ) ) == null  then
        call SaveTimerHandle( udg_hash, id, StringHash( "bszp" ), CreateTimer() )
    endif
	set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "bszp" ) ) ) 
    call SaveUnitHandle( udg_hash, id, StringHash( "bszp" ), bj_lastCreatedUnit )
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( bj_lastCreatedUnit ), StringHash( "bszp" ) ), 0.5, true, function Zapper2Cast )
    
    set id = GetHandleId( udg_DamageEventTarget )
    if LoadTimerHandle( udg_hash, id, StringHash( "bszp1" ) ) == null  then
        call SaveTimerHandle( udg_hash, id, StringHash( "bszp1" ), CreateTimer() )
    endif
	set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "bszp1" ) ) ) 
    call SaveUnitHandle( udg_hash, id, StringHash( "bszp1" ), udg_DamageEventTarget )
    call SaveUnitHandle( udg_hash, id, StringHash( "bszp1d" ), bj_lastCreatedUnit )
    call SaveReal( udg_hash, id, StringHash( "bszp1x" ), x )
    call SaveReal( udg_hash, id, StringHash( "bszp1y" ), y )
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( udg_DamageEventTarget ), StringHash( "bszp1" ) ), 0.02, true, function Zapper1Cast )
endfunction

//===========================================================================
function InitTrig_Zapper1 takes nothing returns nothing
    set gg_trg_Zapper1 = CreateTrigger(  )
    call DisableTrigger( gg_trg_Zapper1 )
    call TriggerRegisterVariableEvent( gg_trg_Zapper1, "udg_AfterDamageEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_Zapper1, Condition( function Trig_Zapper1_Conditions ) )
    call TriggerAddAction( gg_trg_Zapper1, function Trig_Zapper1_Actions )
endfunction

