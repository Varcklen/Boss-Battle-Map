function Trig_KeeperW_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A09Y'
endfunction

function KeeperWEnd takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer( ) )
    local real dmg = LoadReal( udg_hash, id, StringHash( "kepw" ) )
    local real x = LoadReal( udg_hash, id, StringHash( "kepwx" ) )
    local real y = LoadReal( udg_hash, id, StringHash( "kepwy" ) )
    local unit dummy = LoadUnitHandle( udg_hash, id, StringHash( "kepw" ) )
    local unit caster = LoadUnitHandle( udg_hash, id, StringHash( "kepwc" ) )
    local real t = LoadReal( udg_hash, id, StringHash( "kepwt" ) )
    local group g = CreateGroup()
    local unit u
    local effect fx

    set fx = AddSpecialEffect("Flamestrike Mystic I.mdx", x, y )
    call BlzSetSpecialEffectScale( fx, 1.5 )
    call DestroyEffect( fx )

    call GroupEnumUnitsInRange( g, x, y, 350, null )
    loop
        set u = FirstOfGroup(g)
        exitwhen u == null
        if unitst( u, dummy, "enemy" ) then
            call UnitDamageTarget( bj_lastCreatedUnit, u, dmg, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS )
            call bufst( caster, u, 'A09Z', 'B09B', "kepw1", t )
            call debuffst( caster, u, null, 1, t )
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
    set fx = null
    set dummy = null
    set caster = null
endfunction

function Trig_KeeperW_Actions takes nothing returns nothing
    local unit caster
    local real x
    local real y
    local integer lvl
    local integer id
    local real dmg
    local real t
    
    if CastLogic() then
        set caster = udg_Caster
        set lvl = udg_Level
        set t = udg_Time
    elseif RandomLogic() then
        set caster = udg_Caster
        set lvl = udg_Level
        call textst( udg_string[0] + GetObjectName('A09Y'), caster, 64, 90, 10, 1.5 )
        set t = 3
    else
        set caster = GetSpellAbilityUnit()
        set lvl = GetUnitAbilityLevel(GetSpellAbilityUnit(), GetSpellAbilityId())
        set t = 3
    endif
    set t = timebonus( caster, t )
    
    set dmg = (100+(50 * lvl)) * udg_SpellDamage[GetPlayerId(GetOwningPlayer( caster ) ) + 1]
    
    set x = GetUnitX( caster )
    set y = GetUnitY( caster )
    
    call dummyspawn( caster, 0, 'A0N5', 0, 0 )

    call spectime( "Abilities\\Spells\\NightElf\\Starfall\\StarfallCaster.mdl", x, y, 2 )
    
    set id = GetHandleId( bj_lastCreatedUnit )
    if LoadTimerHandle( udg_hash, id, StringHash( "kepw" ) ) == null then
        call SaveTimerHandle( udg_hash, id, StringHash( "kepw" ), CreateTimer() )
    endif
    set id = GetHandleId( LoadTimerHandle(udg_hash, id, StringHash( "kepw" ) ) )
    call SaveUnitHandle( udg_hash, id, StringHash( "kepw" ), bj_lastCreatedUnit )
    call SaveUnitHandle( udg_hash, id, StringHash( "kepwc" ), caster )
    call SaveReal( udg_hash, id, StringHash( "kepw" ), dmg )
    call SaveReal( udg_hash, id, StringHash( "kepwx" ), x )
    call SaveReal( udg_hash, id, StringHash( "kepwy" ), y )
    call SaveReal( udg_hash, id, StringHash( "kepwt" ), t )
    call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( bj_lastCreatedUnit ), StringHash( "kepw" ) ), 2, false, function KeeperWEnd )
    
    set caster = null
endfunction

//===========================================================================
function InitTrig_KeeperW takes nothing returns nothing
    set gg_trg_KeeperW = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_KeeperW, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_KeeperW, Condition( function Trig_KeeperW_Conditions ) )
    call TriggerAddAction( gg_trg_KeeperW, function Trig_KeeperW_Actions )
endfunction

