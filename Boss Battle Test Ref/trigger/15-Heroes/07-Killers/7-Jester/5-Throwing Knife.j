function Trig_Throwing_Knife_Conditions takes nothing returns boolean
    return GetSpellAbilityId( ) == 'A0KL'
endfunction

function Throwing_KnifeMotion takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local unit target = LoadUnitHandle( udg_hash, id, StringHash( "trknt" ) )
    local unit caster = LoadUnitHandle( udg_hash, id, StringHash( "trknc" ) )
    local unit dummy = LoadUnitHandle( udg_hash, id, StringHash( "trkn" ) )
    local real dmg = LoadReal( udg_hash, id, StringHash( "trkn" ) )
    local real x = GetUnitX( target )
    local real y = GetUnitY( target )
    local real xd = GetUnitX( dummy )
    local real yd = GetUnitY( dummy )
    local real angle = Atan2( y - yd, x - xd )
    local real NewX = xd + 50 * Cos( angle )
    local real NewY = yd + 50 * Sin( angle )
    local real IfX = ( ( x - xd ) * ( x - xd ) )
    local real IfY = ( ( y - yd ) * ( y - yd ) )
    
    if SquareRoot( IfX + IfY ) > 100 and GetUnitState( target, UNIT_STATE_LIFE) > 0.405 then
        call SetUnitPosition( dummy, NewX, NewY )
        call GetUnitLoc( target )
    else
        call hpoisonst( caster, target, 1 )
        call UnitDamageTarget( dummy, target, dmg, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS )
        call RemoveUnit( dummy )
        call FlushChildHashtable( udg_hash, id )
        call DestroyTimer( GetExpiredTimer() )
    endif

    set dummy = null
    set target = null
    set caster = null
endfunction

function Trig_Throwing_Knife_Actions takes nothing returns nothing
    local unit caster
    local unit target
    local unit dummy
    local integer id
    local real dmg
    local integer cyclA
    
    if CastLogic() then
        set caster = udg_Caster
    elseif RandomLogic() then
        set caster = udg_Caster
        call textst( udg_string[0] + GetObjectName('A0KL'), caster, 64, 90, 10, 1.5 )
    else
        set caster = GetSpellAbilityUnit()
    endif
    set dmg = 10 * GetUnitSpellPower(caster)
    
    set cyclA = 1
    loop
        exitwhen cyclA > 2
        set target = randomtarget( caster, 600, "enemy", "", "", "", "" )
        if target != null then
            set dummy = CreateUnit( GetOwningPlayer( caster ), 'u000', GetUnitX( caster ), GetUnitY( caster ), AngleBetweenUnits( caster, target ) )
            call UnitAddAbility( dummy, 'A0IF' ) 
            call UnitAddAbility( dummy, 'A0N5' )
            
            set id = GetHandleId( dummy )
            
            call SaveTimerHandle( udg_hash, id, StringHash( "trkn" ), CreateTimer() )
            set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "trkn" ) ) ) 
            call SaveUnitHandle( udg_hash, id, StringHash( "trkn" ), dummy )
            call SaveUnitHandle( udg_hash, id, StringHash( "trknc" ), caster )
            call SaveUnitHandle( udg_hash, id, StringHash( "trknt" ), target )
            call SaveReal( udg_hash, id, StringHash( "trkn" ), dmg )
            call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( dummy ), StringHash( "trkn" ) ), 0.04, true, function Throwing_KnifeMotion )
        endif
        set cyclA = cyclA + 1
    endloop
    call manast( caster, null, 10 )

    set caster = null
    set target = null
    set dummy = null
endfunction

//===========================================================================
function InitTrig_Throwing_Knife takes nothing returns nothing
    set gg_trg_Throwing_Knife = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Throwing_Knife, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_Throwing_Knife, Condition( function Trig_Throwing_Knife_Conditions ) )
    call TriggerAddAction( gg_trg_Throwing_Knife, function Trig_Throwing_Knife_Actions )
endfunction



