function Trig_ShadowArcherR_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A0J1'
endfunction

function ShadowArcherRMotion takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local unit target = LoadUnitHandle( udg_hash, id, StringHash( "sdar" ) )
    local unit dummy = LoadUnitHandle( udg_hash, id, StringHash( "sdar1" ) )
    local real dmg = LoadReal( udg_hash, id, StringHash( "sdar" ) )
    local real x = GetUnitX( target )
    local real y = GetUnitY( target )
    local real angle = Atan2( y - GetUnitY( dummy ), x - GetUnitX( dummy ) )
    local real NewX = GetUnitX( dummy ) + 60 * Cos( angle )
    local real NewY = GetUnitY( dummy ) + 60 * Sin( angle )
    local real IfX = ( ( x - GetUnitX( dummy ) ) * ( x - GetUnitX( dummy ) ) )
    local real IfY = ( ( y - GetUnitY( dummy ) ) * ( y - GetUnitY( dummy ) ) )
    local group g = CreateGroup()
    local unit u
    
    if SquareRoot( IfX + IfY ) > 100 and GetUnitState( target, UNIT_STATE_LIFE ) > 0.405 then
        call SetUnitPosition( dummy, NewX, NewY )
        call GetUnitLoc( target )
    else
        if LoadBoolean( udg_hash, id, StringHash( "sdar" ) ) then
            call DestroyEffect(AddSpecialEffect( "Abilities\\Spells\\Other\\HowlOfTerror\\HowlCaster.mdl", GetUnitX( target ), GetUnitY( target ) ) )
            call GroupEnumUnitsInRange( g, GetUnitX( target ), GetUnitY( target ), 300, null )
            loop
                set u = FirstOfGroup(g)
                exitwhen u == null
                if unitst( u, dummy, "enemy" ) then
                    call UnitDamageTarget( dummy, u, dmg, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS )
                endif
                call GroupRemoveUnit(g,u)
            endloop
        else
            call UnitDamageTarget( dummy, target, dmg, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS )
        endif
        call RemoveUnit( dummy )
        call PauseTimer( GetExpiredTimer() )
        call DestroyTimer( GetExpiredTimer() )
        call FlushChildHashtable( udg_hash, id )
    endif
    
    call GroupClear( g )
    call DestroyGroup( g )
    set u = null
    set g = null
    set dummy = null
    set target = null
endfunction 

function Trig_ShadowArcherR_Actions takes nothing returns nothing
    local integer id
    local unit caster
    local unit target
    local integer lvl
    local real dmg 
    local real attackBonus
    
    if CastLogic() then
        set caster = udg_Caster
        set target = udg_Target
        set lvl = udg_Level
    elseif RandomLogic() then
        set caster = udg_Caster
        set target = randomtarget( caster, 900, "enemy", "", "", "", "" )
        set lvl = udg_Level
        call textst( udg_string[0] + GetObjectName('A0J1'), caster, 64, 90, 10, 1.5 )
        if target == null then
            set caster = null
            return
        endif
    else
        set caster = GetSpellAbilityUnit()
        set target = GetSpellTargetUnit()
        set lvl = GetUnitAbilityLevel(GetSpellAbilityUnit(), GetSpellAbilityId())
    endif
    
    set attackBonus = BlzGetUnitBaseDamage(caster, 0) * (0.5+(0.25*lvl))
    set dmg = (attackBonus + 80 + ( 20 * lvl ) ) * GetUnitSpellPower(caster)
    call dummyspawn( caster, 0, 0, 'A0J3', 'A0N5' )
    call SetUnitFacing( bj_lastCreatedUnit, bj_RADTODEG * Atan2(GetUnitY(target) - GetUnitY(caster), GetUnitX(target) - GetUnitX(caster) ) )

    call SaveTimerHandle( udg_hash, GetHandleId( bj_lastCreatedUnit ), StringHash( "sdar" ), CreateTimer() )
	set id = GetHandleId( LoadTimerHandle( udg_hash, GetHandleId( bj_lastCreatedUnit ), StringHash( "sdar" ) ) )
    call SaveUnitHandle( udg_hash, id, StringHash( "sdar" ), target )
    call SaveUnitHandle( udg_hash, id, StringHash( "sdar1" ), bj_lastCreatedUnit )
    call SaveReal( udg_hash, id, StringHash( "sdar" ), dmg )
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( bj_lastCreatedUnit ), StringHash( "sdar" ) ), 0.04, true, function ShadowArcherRMotion )

    set caster = null
    set target = null
endfunction

//===========================================================================
function InitTrig_ShadowArcherR takes nothing returns nothing
    set gg_trg_ShadowArcherR = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_ShadowArcherR, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_ShadowArcherR, Condition( function Trig_ShadowArcherR_Conditions ) )
    call TriggerAddAction( gg_trg_ShadowArcherR, function Trig_ShadowArcherR_Actions )
endfunction