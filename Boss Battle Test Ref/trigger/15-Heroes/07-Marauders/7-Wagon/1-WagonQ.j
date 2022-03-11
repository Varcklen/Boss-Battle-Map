function Trig_WagonQ_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A01G'
endfunction

function WagonQCast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer( ) )
    local unit dummy = LoadUnitHandle( udg_hash, id, StringHash( "mwgq" ) )
    local real dmg = LoadReal( udg_hash, id, StringHash( "mwgqdmg" ) )
    local real x = LoadReal( udg_hash, id, StringHash( "mwgqx" ) )
    local real y = LoadReal( udg_hash, id, StringHash( "mwgqy" ) )
    local real xc = GetUnitX( dummy )
    local real yc = GetUnitY( dummy )
    local integer counter = LoadInteger( udg_hash, id, StringHash( "mwgq" ) ) + 1
    local integer c = LoadInteger( udg_hash, id, StringHash( "mwgqc" ) ) + 1
    local real angle = Atan2( y - yc, x - xc )
    local real NewX = xc + 20 * Cos( angle )
    local real NewY = yc + 20 * Sin( angle )
    local group g = CreateGroup()
    local unit u
    local real dist = LoadReal( udg_hash, id, StringHash( "mwgqd" ) )
    local real IfX = ( x - xc ) * ( x - xc )
    local real IfY = ( y - yc ) * ( y - yc )
    local real IfS = SquareRoot( IfX + IfY )
    local real perc = (IfS * 100)/dist
    local boolean l = LoadBoolean( udg_hash, id, StringHash( "mwgq" ))

    if perc <= 50 and not(l) then
        call SetUnitFlyHeight( dummy, -400, 1000 )
        call SaveBoolean( udg_hash, id, StringHash( "mwgq" ), true )
    endif
    
    if c >= 10 then
        call SaveInteger( udg_hash, id, StringHash( "mwgqc" ), 0 )
        if not(udg_fightmod[3]) and combat( dummy, false, 0 ) then
            call CreateItem( 'I02U', xc, yc )
            call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\Orc\\MirrorImage\\MirrorImageDeathCaster.mdl", xc, yc ) )
        endif
    else
        call SaveInteger( udg_hash, id, StringHash( "mwgqc" ), c )
    endif

    if IfS < 100 or GetUnitState( dummy, UNIT_STATE_LIFE) <= 0.405 then
        if GetUnitState( dummy, UNIT_STATE_LIFE) > 0.405 then
            call DestroyEffect( AddSpecialEffect( "Abilities\\Weapons\\MeatwagonMissile\\MeatwagonMissile.mdl", x, y ) )
            call GroupEnumUnitsInRange( g, x, y, 300, null )
            loop
                set u = FirstOfGroup(g)
                exitwhen u == null
                if unitst( u, dummy, "enemy" ) then
                    call UnitDamageTarget(dummy, u, dmg, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS)
                endif
                call GroupRemoveUnit(g,u)
                set u = FirstOfGroup(g) 
            endloop
        endif
        call RemoveUnit(dummy)
        call FlushChildHashtable( udg_hash, id ) 
        call DestroyTimer( GetExpiredTimer() )
    else
        call SaveInteger( udg_hash, id, StringHash( "mwgq" ), counter )
        call SetUnitPosition( dummy, NewX, NewY )
    endif
    
    call GroupClear( g )
    call DestroyGroup( g )
    set u = null
    set g = null
    set dummy = null
endfunction

function Trig_WagonQ_Actions takes nothing returns nothing
    local integer id 
    local integer lvl
    local unit caster
    local unit target
    local real dmg
    local real x
    local real y
    local real dist
    local real dx
    local real dy

    if CastLogic() then
        set caster = udg_Caster
        set target = udg_Target
        set lvl = udg_Level
    elseif RandomLogic() then
        set caster = udg_Caster
        set target = randomtarget( caster, 900, "enemy", "", "", "", "" )
        set lvl = udg_Level
        call textst( udg_string[0] + GetObjectName('A01G'), caster, 64, 90, 10, 1.5 )
        if target == null then
            set caster = null
            return
        endif
    else
        set caster = GetSpellAbilityUnit()
        set target = GetSpellTargetUnit()
        set lvl = GetUnitAbilityLevel(GetSpellAbilityUnit(), GetSpellAbilityId())
    endif
    
    call dummyspawn( caster, 0, 'A027', 0, 0 )
    call UnitAddAbility(bj_lastCreatedUnit, 'Amrf')
    
    set dmg = 80 + (50*lvl)
	set x = GetUnitX(target)
    set y = GetUnitY(target)
    set dx = x - GetUnitX(bj_lastCreatedUnit)
    set dy = y - GetUnitY(bj_lastCreatedUnit)
    set dist = SquareRoot(dx * dx + dy * dy)
    call SetUnitFlyHeight( bj_lastCreatedUnit, 400, 1000 )
    
    set id = GetHandleId( bj_lastCreatedUnit )
    if LoadTimerHandle( udg_hash, id, StringHash( "mwgq" ) ) == null then
        call SaveTimerHandle( udg_hash, id, StringHash( "mwgq" ), CreateTimer() )
    endif
    set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "mwgq" ) ) )
    call SaveUnitHandle( udg_hash, id, StringHash( "mwgq" ), bj_lastCreatedUnit)
    call SaveReal( udg_hash, id, StringHash( "mwgqx" ), x )
    call SaveReal( udg_hash, id, StringHash( "mwgqy" ), y )
    call SaveReal( udg_hash, id, StringHash( "mwgqd" ), dist)
    call SaveReal( udg_hash, id, StringHash( "mwgqdmg" ), dmg)
    call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( bj_lastCreatedUnit ), StringHash( "mwgq" ) ), 0.02, true, function WagonQCast ) 

    set caster = null
    set target = null
endfunction

//===========================================================================
function InitTrig_WagonQ takes nothing returns nothing
    set gg_trg_WagonQ = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_WagonQ, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_WagonQ, Condition( function Trig_WagonQ_Conditions ) )
    call TriggerAddAction( gg_trg_WagonQ, function Trig_WagonQ_Actions )
endfunction