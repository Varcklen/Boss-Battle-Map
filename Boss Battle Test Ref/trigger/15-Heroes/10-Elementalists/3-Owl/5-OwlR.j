function Trig_OwlR_Conditions takes nothing returns boolean
    return GetSpellAbilityId( ) == 'A024'
endfunction

function OwlRMotion takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local unit target = LoadUnitHandle( udg_hash, id, StringHash( "owlrt" ) )
    local unit dummy = LoadUnitHandle( udg_hash, id, StringHash( "owlr" ) )
    local real dmg = LoadReal( udg_hash, id, StringHash( "owlr" ) )
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
        call UnitDamageTarget( dummy, target, dmg, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS )
        call RemoveUnit( dummy )
        call FlushChildHashtable( udg_hash, id )
        call DestroyTimer( GetExpiredTimer() )
    endif

    set dummy = null
    set target = null
endfunction

function Trig_OwlR_Actions takes nothing returns nothing
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
        call textst( udg_string[0] + GetObjectName('A024'), caster, 64, 90, 10, 1.5 )
        if target == null then
            set caster = null
            return
        endif
    else
        set caster = GetSpellAbilityUnit()
        set target = GetSpellTargetUnit()
        set lvl = GetUnitAbilityLevel(GetSpellAbilityUnit(), GetSpellAbilityId())
    endif
    set dmg = ( ( 0.5 * lvl ) + 1 ) * 100 * GetUnitSpellPower(caster)
    
    set dummy = CreateUnit( GetOwningPlayer( caster ), 'u000', GetUnitX( caster ), GetUnitY( caster ), AngleBetweenUnits( caster, target ) )
    call UnitAddAbility( dummy, 'A0L0' ) 
    call UnitAddAbility( dummy, 'A0N5' )
    set id = GetHandleId( dummy )
    
    call SaveTimerHandle( udg_hash, id, StringHash( "owlr" ), CreateTimer() )
	set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "owlr" ) ) ) 
	call SaveUnitHandle( udg_hash, id, StringHash( "owlr" ), dummy )
    call SaveUnitHandle( udg_hash, id, StringHash( "owlrt" ), target )
    call SaveReal( udg_hash, id, StringHash( "owlr" ), dmg )
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( dummy ), StringHash( "owlr" ) ), 0.04, true, function OwlRMotion )  

    set caster = null
    set target = null
    set dummy = null
endfunction

//===========================================================================
function InitTrig_OwlR takes nothing returns nothing
    set gg_trg_OwlR = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_OwlR, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_OwlR, Condition( function Trig_OwlR_Conditions ) )
    call TriggerAddAction( gg_trg_OwlR, function Trig_OwlR_Actions )
endfunction



