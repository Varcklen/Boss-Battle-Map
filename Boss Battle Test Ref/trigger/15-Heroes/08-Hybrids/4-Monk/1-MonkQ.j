function Trig_MonkQ_Conditions takes nothing returns boolean
    return GetSpellAbilityId( ) == 'A0U3'
endfunction

function MonkQCast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    call UnitRemoveAbility( LoadUnitHandle( udg_hash, id, StringHash( "mnkq1" ) ), 'A0UA' )
    call UnitRemoveAbility( LoadUnitHandle( udg_hash, id, StringHash( "mnkq1" ) ), 'B01N' )
    call FlushChildHashtable( udg_hash, id )
endfunction

function MonkQMotion takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local unit target = LoadUnitHandle( udg_hash, id, StringHash( "mnkqt" ) )
    local unit caster = LoadUnitHandle( udg_hash, id, StringHash( "mnkqc" ) )
    local unit dummy = LoadUnitHandle( udg_hash, id, StringHash( "mnkq" ) )
    local integer id1 = GetHandleId( target )
    local real dmg = LoadReal( udg_hash, id, StringHash( "mnkq" ) )
    local real x = GetUnitX( target )
    local real y = GetUnitY( target )
    local real angle = Atan2( y - GetUnitY( dummy ), x - GetUnitX( dummy ) )
    local real NewX = GetUnitX( dummy ) + 60 * Cos( angle )
    local real NewY = GetUnitY( dummy ) + 60 * Sin( angle )
    local real IfX = ( x - GetUnitX( dummy ) ) * ( x - GetUnitX( dummy ) )
    local real IfY = ( y - GetUnitY( dummy ) ) * ( y - GetUnitY( dummy ) )
    local real t = LoadReal( udg_hash, id, StringHash( "mnkqt" ) )
    local boolean l = LoadBoolean( udg_hash, id, StringHash( "mnkq" ) )
    local integer lvl = LoadInteger( udg_hash, id, StringHash( "mnkq" ) )

    if SquareRoot( IfX + IfY ) > 100 and GetUnitState( target, UNIT_STATE_LIFE) > 0.405 then
        call SetUnitPosition( dummy, NewX, NewY )
        call GetUnitLoc( target )
    else
    	set t = timebonus(caster, t)
        call DestroyEffect( AddSpecialEffectTarget( "Abilities\\Spells\\Other\\StrongDrink\\BrewmasterMissile.mdl", target, "origin" ) )
        call UnitAddAbility( target, 'A0UA' )
        
        if LoadTimerHandle( udg_hash, id1, StringHash( "mnkq1" ) ) == null then
            call SaveTimerHandle( udg_hash, id1, StringHash( "mnkq1" ), CreateTimer() )
        endif
        set id1 = GetHandleId( LoadTimerHandle( udg_hash, id1, StringHash( "mnkq1" ) ) ) 
        call SaveUnitHandle( udg_hash, id1, StringHash( "mnkq1" ), target )
        call SaveUnitHandle( udg_hash, id1, StringHash( "mnkq1c" ), caster )
        call SaveInteger( udg_hash, id1, StringHash( "mnkq1" ), 20 + ( 10 * lvl ) ) 
        call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( target ), StringHash( "mnkq1" ) ), t, false, function MonkQCast )

        if l then
            call debuffst( caster, target, "Trig_MonkQ_Actions", lvl, t )
        endif
        
        call RemoveUnit( dummy )
        call FlushChildHashtable( udg_hash, id )
        call DestroyTimer( GetExpiredTimer() )
    endif

    set dummy = null
    set target = null
    set caster = null
endfunction   

function Trig_MonkQ_Actions takes nothing returns nothing
    local integer id 
    local unit caster
    local unit target
    local integer lvl
    local real t
    
    if CastLogic() then
        set caster = udg_Caster
        set target = udg_Target
        set lvl = udg_Level
        set t = udg_Time 
    elseif RandomLogic() then
        set caster = udg_Caster
        set target = randomtarget( caster, 900, "enemy", "", "", "", "" )
        set lvl = udg_Level
        call textst( udg_string[0] + GetObjectName('A0U3'), caster, 64, 90, 10, 1.5 )
        set t = 14
        if target == null then
            set caster = null
            return
        endif
    else
        set caster = GetSpellAbilityUnit()
        set target = GetSpellTargetUnit()
        set lvl = GetUnitAbilityLevel(GetSpellAbilityUnit(), GetSpellAbilityId())
        set t = 14
    endif

    call dummyspawn( caster, 1, 'A0UB', 0, 0 )
    set id = GetHandleId( bj_lastCreatedUnit )
    
    call SaveTimerHandle( udg_hash, id, StringHash( "mnkq" ), CreateTimer() )
	set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "mnkq" ) ) ) 
	call SaveUnitHandle( udg_hash, id, StringHash( "mnkq" ), bj_lastCreatedUnit )
    call SaveUnitHandle( udg_hash, id, StringHash( "mnkqt" ), target )
    call SaveUnitHandle( udg_hash, id, StringHash( "mnkqc" ), caster )
    call SaveInteger( udg_hash, id, StringHash( "mnkq" ), lvl ) 
    call SaveReal( udg_hash, id, StringHash( "mnkqt" ), t )
    if BuffLogic() then
        call SaveBoolean( udg_hash, id, StringHash( "mnkq" ), true )
    endif
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( bj_lastCreatedUnit ), StringHash( "mnkq" ) ), 0.04, true, function MonkQMotion )
    
    set caster = null
    set target = null
endfunction

//===========================================================================
function InitTrig_MonkQ takes nothing returns nothing
    set gg_trg_MonkQ = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_MonkQ, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_MonkQ, Condition( function Trig_MonkQ_Conditions ) )
    call TriggerAddAction( gg_trg_MonkQ, function Trig_MonkQ_Actions )
endfunction




