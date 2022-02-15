function Trig_KnightW_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A05T' or GetSpellAbilityId() == 'A05V'
endfunction

function KnightWMotion takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local unit target = LoadUnitHandle( udg_hash, id, StringHash( "kngw" ) )
    local unit dummy = LoadUnitHandle( udg_hash, id, StringHash( "kngw1" ) )
    local real dmg = LoadReal( udg_hash, id, StringHash( "kngw" ) )
    local real x = GetUnitX( target )
    local real y = GetUnitY( target )
    local real angle = Atan2( y - GetUnitY( dummy ), x - GetUnitX( dummy ) )
    local real NewX = GetUnitX( dummy ) + 60 * Cos( angle )
    local real NewY = GetUnitY( dummy ) + 60 * Sin( angle )
    local real IfX = ( ( x - GetUnitX( dummy ) ) * ( x - GetUnitX( dummy ) ) )
    local real IfY = ( ( y - GetUnitY( dummy ) ) * ( y - GetUnitY( dummy ) ) )
    
    if SquareRoot( IfX + IfY ) > 100 and GetUnitState( target, UNIT_STATE_LIFE ) > 0.405 then
        call SetUnitPosition( dummy, NewX, NewY )
        call GetUnitLoc( target )
    else
        call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\Undead\\DeathCoil\\DeathCoilSpecialArt.mdl", GetUnitX( target ), GetUnitY( target ) ) )
        call UnitDamageTarget( dummy, target, dmg, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS )
        call RemoveUnit( dummy )
        call PauseTimer( GetExpiredTimer() )
        call DestroyTimer( GetExpiredTimer() )
        call FlushChildHashtable( udg_hash, id )
    endif
    
    set dummy = null
    set target = null
endfunction 

function Trig_KnightW_Actions takes nothing returns nothing
    local unit caster
    local integer lvl
    local integer id
    local real dmg
    local group g = CreateGroup()
    local unit u
    
    if CastLogic() then
        set caster = udg_Caster
        set lvl = udg_Level
    elseif RandomLogic() then
        set caster = udg_Caster
        set lvl = udg_Level
        call textst( udg_string[0] + GetObjectName('A05T'), caster, 64, 90, 10, 1.5 )
    elseif GetSpellAbilityId() == 'A05V' then
        set caster = GetSpellAbilityUnit()
        set lvl = LoadInteger( udg_hash, GetHandleId( GetSpellAbilityUnit() ), StringHash( "kngew" ) )
    else
        set caster = GetSpellAbilityUnit()
        set lvl = GetUnitAbilityLevel(GetSpellAbilityUnit(), GetSpellAbilityId())
    endif
    set dmg = (15 + ( 15 * lvl )) * GetUnitSpellPower(caster)
    
    call GroupEnumUnitsInRange( g, GetUnitX( caster ), GetUnitY( caster ), 900, null )
    loop
        set u = FirstOfGroup(g)
        exitwhen u == null
        if GetUnitState( u, UNIT_STATE_LIFE) > 0.405 and unitst( u, caster, "enemy" ) then
            call dummyspawn( caster, 0, 0, 'A130', 'A0N5' )
            
            call SetUnitFacing( bj_lastCreatedUnit, bj_RADTODEG * Atan2(GetUnitY(u) - GetUnitY(caster), GetUnitX(u) - GetUnitX(caster) ) )
            set id = GetHandleId( bj_lastCreatedUnit )
            
            call SaveTimerHandle( udg_hash, id, StringHash( "kngw" ), CreateTimer() )
            set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "kngw" ) ) )
            call SaveUnitHandle( udg_hash, id, StringHash( "kngw" ), u )
            call SaveUnitHandle( udg_hash, id, StringHash( "kngw1" ), bj_lastCreatedUnit )
            call SaveReal( udg_hash, id, StringHash( "kngw" ), dmg )
            call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( bj_lastCreatedUnit ), StringHash( "kngw" ) ), 0.04, true, function KnightWMotion )
        endif
        call GroupRemoveUnit(g,u)
        set u = FirstOfGroup(g)
    endloop
    
    call GroupClear( g )
    call DestroyGroup( g )
    set u = null
    set caster = null
endfunction

//===========================================================================
function InitTrig_KnightW takes nothing returns nothing
    set gg_trg_KnightW = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_KnightW, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_KnightW, Condition( function Trig_KnightW_Conditions ) )
    call TriggerAddAction( gg_trg_KnightW, function Trig_KnightW_Actions )
endfunction

