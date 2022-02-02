function Trig_Sheep_cannon_Conditions takes nothing returns boolean
    return GetSpellAbilityId( ) == 'A1BY'
endfunction

function Sheep_cannonMotion takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local unit target = LoadUnitHandle( udg_hash, id, StringHash( "shcnt" ) )
    local unit dummy = LoadUnitHandle( udg_hash, id, StringHash( "shcn" ) )
    local real dmg = LoadReal( udg_hash, id, StringHash( "shcn" ) )
    local real x = GetUnitX( target )
    local real y = GetUnitY( target )
    local real angle = Atan2( y - GetUnitY( dummy ), x - GetUnitX( dummy ) )
    local real NewX = GetUnitX( dummy ) + 80 * Cos( angle )
    local real NewY = GetUnitY( dummy ) + 80 * Sin( angle )
    local real IfX = ( ( x - GetUnitX( dummy ) ) * ( x - GetUnitX( dummy ) ) )
    local real IfY = ( ( y - GetUnitY( dummy ) ) * ( y - GetUnitY( dummy ) ) )
    
    if SquareRoot( IfX + IfY ) > 100 and GetUnitState( target, UNIT_STATE_LIFE) > 0.405 then
        call SetUnitPosition( dummy, NewX, NewY )
        call GetUnitLoc( target )
    else
        call spectimeunit( target, "Objects\\Spawnmodels\\Human\\FragmentationShards\\FragBoomSpawn.mdl", "origin", 2 )
        set bj_lastCreatedUnit = CreateUnit( GetOwningPlayer( dummy ), ID_SHEEP, GetUnitX( target ) + GetRandomReal( -200, 200 ), GetUnitY( target ) + GetRandomReal( -200, 200 ),  GetRandomReal( 0, 360 ))
        call UnitApplyTimedLife( bj_lastCreatedUnit, 'BTLF', 60 )
        call UnitDamageTarget( dummy, target, dmg, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS )
        call RemoveUnit( dummy )
        call DestroyTimer( GetExpiredTimer() )
        call FlushChildHashtable( udg_hash, id )
    endif

    set dummy = null
    set target = null
endfunction   

function Trig_Sheep_cannon_Actions takes nothing returns nothing
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
        call textst( udg_string[0] + GetObjectName('A1BY'), caster, 64, 90, 10, 1.5 )
        if target == null then
            set caster = null
            return
        endif
    else
        set caster = GetSpellAbilityUnit()
        set target = GetSpellTargetUnit()
        set lvl = GetUnitAbilityLevel(GetSpellAbilityUnit(), GetSpellAbilityId())
    endif
    
    set dmg = 100 * udg_SpellDamage[GetPlayerId(GetOwningPlayer( caster ) ) + 1]
    
    call dummyspawn( caster, 0, 'A1BZ', 'A0N5', 0 )
    call SetUnitFacing( bj_lastCreatedUnit, AngleBetweenUnits( caster, target ) )

    set id = GetHandleId( bj_lastCreatedUnit )
    
    call SaveTimerHandle( udg_hash, id, StringHash( "shcn" ), CreateTimer() )
	set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "shcn" ) ) ) 
	call SaveUnitHandle( udg_hash, id, StringHash( "shcn" ), bj_lastCreatedUnit )
    call SaveUnitHandle( udg_hash, id, StringHash( "shcnt" ), target )
    call SaveReal( udg_hash, id, StringHash( "shcn" ), dmg )
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( bj_lastCreatedUnit ), StringHash( "shcn" ) ), 0.04, true, function Sheep_cannonMotion )
    
    set caster = null
    set target = null
endfunction

//===========================================================================
function InitTrig_Sheep_cannon takes nothing returns nothing
    set gg_trg_Sheep_cannon = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Sheep_cannon, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_Sheep_cannon, Condition( function Trig_Sheep_cannon_Conditions ) )
    call TriggerAddAction( gg_trg_Sheep_cannon, function Trig_Sheep_cannon_Actions )
endfunction




