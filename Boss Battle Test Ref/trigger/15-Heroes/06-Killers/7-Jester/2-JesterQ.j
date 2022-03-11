function Trig_JesterQ_Conditions takes nothing returns boolean
    return GetSpellAbilityId( ) == 'A0IC'
endfunction

function JesterQEnd takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer( ) )
    local unit caster = LoadUnitHandle( udg_hash, id, StringHash( "jesq1" ) )
    
    call jesterst( caster, -100, 1 )
    call FlushChildHashtable( udg_hash, id )
    
    set caster = null
endfunction

function JesterQMotion takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local unit target = LoadUnitHandle( udg_hash, id, StringHash( "jesqt" ) )
    local unit caster = LoadUnitHandle( udg_hash, id, StringHash( "jesqc" ) )
    local unit dummy = LoadUnitHandle( udg_hash, id, StringHash( "jesq" ) )
    local real dmg = LoadReal( udg_hash, id, StringHash( "jesq" ) )
    local real x = GetUnitX( target )
    local real y = GetUnitY( target )
    local real xd = GetUnitX( dummy )
    local real yd = GetUnitY( dummy )
    local real angle = Atan2( y - yd, x - xd )
    local real NewX = xd + 50 * Cos( angle )
    local real NewY = yd + 50 * Sin( angle )
    local real IfX = ( ( x - xd ) * ( x - xd ) )
    local real IfY = ( ( y - yd ) * ( y - yd ) )
    local integer lvl = LoadInteger( udg_hash, id, StringHash( "jesqlvl" ) )
    local integer id1
    
    if SquareRoot( IfX + IfY ) > 100 and GetUnitState( target, UNIT_STATE_LIFE) > 0.405 then
        call SetUnitPosition( dummy, NewX, NewY )
        call GetUnitLoc( target )
    else
        call UnitDamageTarget( dummy, target, dmg, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS )
        if GetUnitState( caster, UNIT_STATE_LIFE) > 0.405 then
            call jesterst( caster, 1, lvl )
            set id1 = GetHandleId( caster )
            if LoadTimerHandle( udg_hash, id1, StringHash( "jesq1" ) ) == null  then
                call SaveTimerHandle( udg_hash, id1, StringHash( "jesq1" ), CreateTimer() )
            endif
            set id1 = GetHandleId( LoadTimerHandle(udg_hash, id1, StringHash( "jesq1" ) ) )
            call SaveUnitHandle( udg_hash, id1, StringHash( "jesq1" ), caster )
            call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( caster ), StringHash( "jesq1" ) ), 15, false, function JesterQEnd )
            
            call effst( caster, caster, null, 1, 15 )
        endif
        call RemoveUnit( dummy )
        call FlushChildHashtable( udg_hash, id )
        call DestroyTimer( GetExpiredTimer() )
    endif

    set dummy = null
    set target = null
    set caster = null
endfunction

function Trig_JesterQ_Actions takes nothing returns nothing
    local unit caster
    local unit target
    local unit dummy
    local integer lvl
    local integer id
    local real dmg
    
    if CastLogic() then
        set caster = udg_Caster
        set target = udg_Target
        set lvl = udg_Level
    elseif RandomLogic() then
        set caster = udg_Caster
        set target = randomtarget( caster, 900, "enemy", "", "", "", "" )
        set lvl = udg_Level
        call textst( udg_string[0] + GetObjectName('A0IC'), caster, 64, 90, 10, 1.5 )
        if target == null then
            set caster = null
            return
        endif
    else
        set caster = GetSpellAbilityUnit()
        set target = GetSpellTargetUnit()
        set lvl = GetUnitAbilityLevel(GetSpellAbilityUnit(), GetSpellAbilityId())
    endif
    set dmg = (40+(10*lvl)) * GetUnitSpellPower(caster)
    
    set dummy = CreateUnit( GetOwningPlayer( caster ), 'u000', GetUnitX( caster ), GetUnitY( caster ), AngleBetweenUnits( caster, target ) )
    call UnitAddAbility( dummy, 'A0IF' ) 
    call UnitAddAbility( dummy, 'A0N5' )
    
    set id = GetHandleId( dummy )
    
    call SaveTimerHandle( udg_hash, id, StringHash( "jesq" ), CreateTimer() )
	set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "jesq" ) ) ) 
	call SaveUnitHandle( udg_hash, id, StringHash( "jesq" ), dummy )
    call SaveUnitHandle( udg_hash, id, StringHash( "jesqc" ), caster )
    call SaveUnitHandle( udg_hash, id, StringHash( "jesqt" ), target )
    call SaveReal( udg_hash, id, StringHash( "jesq" ), dmg )
    call SaveInteger( udg_hash, id, StringHash( "jesqlvl" ), lvl )
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( dummy ), StringHash( "jesq" ) ), 0.04, true, function JesterQMotion )  

    set caster = null
    set target = null
    set dummy = null
endfunction

//===========================================================================
function InitTrig_JesterQ takes nothing returns nothing
    set gg_trg_JesterQ = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_JesterQ, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_JesterQ, Condition( function Trig_JesterQ_Conditions ) )
    call TriggerAddAction( gg_trg_JesterQ, function Trig_JesterQ_Actions )
endfunction



