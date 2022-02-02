function Trig_FallenOneR_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A085'
endfunction

function FallenOneREnd takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer( ) )
    local real dmg = LoadReal( udg_hash, id, StringHash( "flnr" ) )
    local real coef = LoadReal( udg_hash, id, StringHash( "flnrc" ) )
    local real x = LoadReal( udg_hash, id, StringHash( "flnrx" ) )
    local real y = LoadReal( udg_hash, id, StringHash( "flnry" ) )
    local unit dummy = LoadUnitHandle( udg_hash, id, StringHash( "flnr" ) )
    local group g = CreateGroup()
    local unit u
    local effect fx
    local real c

    set fx = AddSpecialEffect( "Desecrate.mdx", x, y )
    call BlzSetSpecialEffectScale( fx, 2 )
    call DestroyEffect( fx )
    call GroupEnumUnitsInRange( g, x, y, 400, null )
    loop
        set u = FirstOfGroup(g)
        exitwhen u == null
        if unitst( u, dummy, "enemy" ) then
            set c = GetUnitState( u, UNIT_STATE_MAX_LIFE)*coef
            call UnitDamageTarget( bj_lastCreatedUnit, u, dmg+c, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS )
        endif
        call GroupRemoveUnit(g,u)
        set u = FirstOfGroup(g)
    endloop
    
    call RemoveUnit( dummy )
    call FlushChildHashtable( udg_hash, id )
    call DestroyTimer( GetExpiredTimer() )
    
    call GroupClear( g )
    call DestroyGroup( g )
    set g = null
    set u = null
    set dummy = null
    set fx = null
endfunction

function Trig_FallenOneR_Actions takes nothing returns nothing
    local unit caster
    local real x
    local real y
    local integer lvl
    local integer id
    local real dmg
    local real coef
    
    if CastLogic() then
        set caster = udg_Caster
        set x = GetLocationX( GetSpellTargetLoc() )
        set y = GetLocationY( GetSpellTargetLoc() )
        set lvl = udg_Level
    elseif RandomLogic() then
        set caster = udg_Caster
        set lvl = udg_Level
        set x = GetUnitX( caster ) + GetRandomReal( -650, 650 )
        set y = GetUnitY( caster ) + GetRandomReal( -650, 650 )
        call textst( udg_string[0] + GetObjectName('A085'), caster, 64, 90, 10, 1.5 )
    else
        set caster = GetSpellAbilityUnit()
        set x = GetLocationX( GetSpellTargetLoc() )
        set y = GetLocationY( GetSpellTargetLoc() )
        set lvl = GetUnitAbilityLevel(GetSpellAbilityUnit(), GetSpellAbilityId())
    endif
    if lvl > 4 then
        set lvl = 4
    endif
    set dmg = (100+(100 * lvl)) * udg_SpellDamage[GetPlayerId(GetOwningPlayer( caster ) ) + 1]
    set coef = 0.01+(lvl*0.01)
    
    call dummyspawn( caster, 0, 'A0N5', 0, 0 )
    call DestroyEffect( AddSpecialEffect( "war3mapImported\\MagicCircle_Devil.mdx", x, y ) )
    
    set id = GetHandleId( bj_lastCreatedUnit )
    if LoadTimerHandle( udg_hash, id, StringHash( "flnr" ) ) == null  then
        call SaveTimerHandle( udg_hash, id, StringHash( "flnr" ), CreateTimer() )
    endif
    set id = GetHandleId( LoadTimerHandle(udg_hash, id, StringHash( "flnr" ) ) )
    call SaveUnitHandle( udg_hash, id, StringHash( "flnr" ), bj_lastCreatedUnit )
    call SaveReal( udg_hash, id, StringHash( "flnr" ), dmg )
    call SaveReal( udg_hash, id, StringHash( "flnrc" ), coef )
    call SaveReal( udg_hash, id, StringHash( "flnrx" ), x )
    call SaveReal( udg_hash, id, StringHash( "flnry" ), y )
    call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( bj_lastCreatedUnit ), StringHash( "flnr" ) ), 2, false, function FallenOneREnd )
    
    set caster = null
endfunction

//===========================================================================
function InitTrig_FallenOneR takes nothing returns nothing
    set gg_trg_FallenOneR = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_FallenOneR, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_FallenOneR, Condition( function Trig_FallenOneR_Conditions ) )
    call TriggerAddAction( gg_trg_FallenOneR, function Trig_FallenOneR_Actions )
endfunction

