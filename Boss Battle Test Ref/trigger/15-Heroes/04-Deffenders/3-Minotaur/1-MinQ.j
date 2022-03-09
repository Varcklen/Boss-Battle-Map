function Trig_MinQ_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A0DU' and combat( GetSpellAbilityUnit(), true, GetSpellAbilityId() )
endfunction
  
function MinQCast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local integer counter = LoadInteger( udg_hash, id, StringHash( "minq" ) )
    local real dmg = LoadReal( udg_hash, id, StringHash( "minq" ) )
    local unit caster = LoadUnitHandle( udg_hash, id, StringHash( "minq" ) )
    local unit target = LoadUnitHandle( udg_hash, id, StringHash( "minqt" ) )
    local real x = GetUnitX( target )
    local real y = GetUnitY( target )
    local real xc = GetUnitX( caster )
    local real yc = GetUnitY( caster )
    local real angle = Atan2( y - yc, x - xc )
    local real NewX = xc + 20 * Cos( angle )
    local real NewY = yc + 20 * Sin( angle )
    local real IfX = ( x - xc ) * ( x - xc )
    local real IfY = ( y - yc ) * ( y - yc )
    
    if RectContainsCoords(udg_Boss_Rect, x, y) and SquareRoot( IfX + IfY ) > 128 and counter < 200 and GetUnitState( target, UNIT_STATE_LIFE) > 0.405 and GetUnitState( caster, UNIT_STATE_LIFE) > 0.405 and combat( caster, false, 0 ) then
        call SetUnitPosition( caster, NewX, NewY )
        call SaveInteger( udg_hash, id, StringHash( "minq" ), counter + 1 )
    else
        if GetUnitState( caster, UNIT_STATE_LIFE) > 0.405 and GetUnitState( target, UNIT_STATE_LIFE) > 0.405 and counter < 200 and combat( caster, false, 0 ) then
            call DestroyEffect( AddSpecialEffect("Abilities\\Spells\\Human\\Thunderclap\\ThunderClapCaster.mdl", GetUnitX( target ), GetUnitY( target ) ) )
            call UnitStun(caster, target, 2 )
            call dummyspawn( caster, 1, 0, 'A0N5', 0 )
            call UnitDamageTarget( bj_lastCreatedUnit, target, dmg, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS )
        endif
        call SetUnitPathing( caster, true )
    	call pausest( caster, -1 )
        call UnitRemoveAbility( caster, 'A0DV' )
        call FlushChildHashtable( udg_hash, id )
        call DestroyTimer( GetExpiredTimer() )
    endif
    
    set caster = null
    set target = null
endfunction

function Trig_MinQ_Actions takes nothing returns nothing
    local integer id 
    local integer lvl
    local unit caster
    local unit target
    local real dmg
    local real x
    local real y
    
    if CastLogic() then
        set caster = udg_Caster
        set target = udg_Target
        set lvl = udg_Level
    elseif RandomLogic() then
        set caster = udg_Caster
        set target = randomtarget( caster, 900, "enemy", "", "", "", "" )
        set lvl = udg_Level
        call textst( udg_string[0] + GetObjectName('A0DU'), caster, 64, 90, 10, 1.5 )
        if target == null then
            set caster = null
            return
        endif
    else
        set caster = GetSpellAbilityUnit()
        set target = GetSpellTargetUnit()
        set lvl = GetUnitAbilityLevel(GetSpellAbilityUnit(), GetSpellAbilityId())
    endif
    
    if udg_fightmod[3] and not( RectContainsUnit(udg_Boss_Rect, target) ) then
        set caster = null
        set target = null
        return
    endif
    
    if target != null and GetUnitAbilityLevel( caster, 'A0DV' ) == 0 then
        set x = GetUnitX( target )
        set y = GetUnitY( target )
        
        set id = GetHandleId( caster )
        set dmg = (70 + ( 30 * lvl )) * GetUnitSpellPower(caster)
        
        if GetUnitAbilityLevel( caster, 'A0DV' ) == 0 then
            call pausest( caster, 1 )
        endif
        call UnitAddAbility( caster, 'A0DV' )
        
        call SetUnitPathing( caster, false )
        call SetUnitFacing( caster, bj_RADTODEG * Atan2(GetUnitY(target) - GetUnitY(caster), GetUnitX(target) - GetUnitX(caster) ) )

        if LoadTimerHandle( udg_hash, id, StringHash( "minq" ) ) == null  then
            call SaveTimerHandle( udg_hash, id, StringHash( "minq" ), CreateTimer() )
        endif
        set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "minq" ) ) ) 
        call SaveUnitHandle( udg_hash, id, StringHash( "minq" ), caster )
        call SaveUnitHandle( udg_hash, id, StringHash( "minqt" ), target )
        call SaveReal( udg_hash, id, StringHash( "minq" ), dmg )
        call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( caster ), StringHash( "minq" ) ), 0.02, true, function MinQCast )
    endif
    set caster = null
    set target = null
endfunction

//===========================================================================
function InitTrig_MinQ takes nothing returns nothing
    set gg_trg_MinQ = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_MinQ, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_MinQ, Condition( function Trig_MinQ_Conditions ) )
    call TriggerAddAction( gg_trg_MinQ, function Trig_MinQ_Actions )
endfunction

