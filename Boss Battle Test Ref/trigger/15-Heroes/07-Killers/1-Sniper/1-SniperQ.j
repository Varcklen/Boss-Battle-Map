function Trig_SniperQ_Conditions takes nothing returns boolean
    return GetSpellAbilityId( ) == 'A07K'
endfunction

function SniperQMotion takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local unit target = LoadUnitHandle( udg_hash, id, StringHash( "snpqt" ) )
    local unit dummy = LoadUnitHandle( udg_hash, id, StringHash( "snpq" ) )
    local real dmg = LoadReal( udg_hash, id, StringHash( "snpq" ) )
    local real x = GetUnitX( target )
    local real y = GetUnitY( target )
    local real angle = Atan2( y - GetUnitY( dummy ), x - GetUnitX( dummy ) )
    local real NewX = GetUnitX( dummy ) + 120 * Cos( angle )
    local real NewY = GetUnitY( dummy ) + 120 * Sin( angle )
    local real IfX = ( ( x - GetUnitX( dummy ) ) * ( x - GetUnitX( dummy ) ) )
    local real IfY = ( ( y - GetUnitY( dummy ) ) * ( y - GetUnitY( dummy ) ) )
    
    if SquareRoot( IfX + IfY ) > 100 and GetUnitState( target, UNIT_STATE_LIFE) > 0.405 then
        call SetUnitPosition( dummy, NewX, NewY )
        call GetUnitLoc( target )
    else
        call spectimeunit( target, "Objects\\Spawnmodels\\Human\\FragmentationShards\\FragBoomSpawn.mdl", "origin", 2 )
        call UnitDamageTarget( dummy, target, dmg, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS )
        call RemoveUnit( dummy )
        call DestroyTimer( GetExpiredTimer() )
        call FlushChildHashtable( udg_hash, id )
    endif

    set dummy = null
    set target = null
endfunction   

function Trig_SniperQ_Actions takes nothing returns nothing
    local integer id 
    local real dmg 
    local unit caster
    local unit target
    local integer lvl

    if CastLogic() then
        set caster = udg_Caster
        set target = udg_Target
        set lvl = udg_Level
    elseif RandomLogic() then
        set caster = udg_Caster
        set target = randomtarget( caster, 900, "enemy", "", "", "", "" )
        set lvl = udg_Level
        call textst( udg_string[0] + GetObjectName('A07K'), caster, 64, 90, 10, 1.5 )
        if target == null then
            set caster = null
            return
        endif
    else
        set caster = GetSpellAbilityUnit()
        set target = GetSpellTargetUnit()
        set lvl = GetUnitAbilityLevel(GetSpellAbilityUnit(), GetSpellAbilityId())
    endif
    
    set dmg = ( ( 0.012 + ( 0.012 * lvl ) ) * GetUnitState( target, UNIT_STATE_MAX_LIFE ) ) * GetUnitSpellPower(caster)
    
    call dummyspawn( caster, 0, 'A10A', 'A0N5', 0 )
    call SetUnitFacing( bj_lastCreatedUnit, AngleBetweenUnits( caster, target ) )

    set id = GetHandleId( bj_lastCreatedUnit )
    
    call SaveTimerHandle( udg_hash, id, StringHash( "snpq" ), CreateTimer() )
	set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "snpq" ) ) ) 
	call SaveUnitHandle( udg_hash, id, StringHash( "snpq" ), bj_lastCreatedUnit )
    call SaveUnitHandle( udg_hash, id, StringHash( "snpqt" ), target )
    call SaveReal( udg_hash, id, StringHash( "snpq" ), dmg )
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( bj_lastCreatedUnit ), StringHash( "snpq" ) ), 0.04, true, function SniperQMotion )
    
    set caster = null
    set target = null
endfunction

//===========================================================================
function InitTrig_SniperQ takes nothing returns nothing
    set gg_trg_SniperQ = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_SniperQ, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_SniperQ, Condition( function Trig_SniperQ_Conditions ) )
    call TriggerAddAction( gg_trg_SniperQ, function Trig_SniperQ_Actions )
endfunction




