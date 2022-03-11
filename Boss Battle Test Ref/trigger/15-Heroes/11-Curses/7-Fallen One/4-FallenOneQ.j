function Trig_FallenOneQ_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A02T'
endfunction

function FallenOneQEnd takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer( ) )
    local real dmg = LoadReal( udg_hash, id, StringHash( "flnq1" ) )
    local unit target = LoadUnitHandle( udg_hash, id, StringHash( "flnq1" ) )
    local unit dummy = LoadUnitHandle( udg_hash, id, StringHash( "flnq1d" ) )

    if GetUnitState( target, UNIT_STATE_LIFE) > 0.405 and GetUnitState( dummy, UNIT_STATE_LIFE) > 0.405 and GetUnitAbilityLevel( target, 'A09C') > 0 then
        call UnitDamageTarget( dummy, target, dmg, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS )
    else
        call RemoveUnit( dummy )
        call FlushChildHashtable( udg_hash, id )
        call DestroyTimer( GetExpiredTimer() )
    endif
    
    set dummy = null
    set target = null
endfunction

function Trig_FallenOneQ_Actions takes nothing returns nothing
    local real x 
    local real y
    local real dmg 
    local group g = CreateGroup()
    local unit u
    local integer id 
    local integer lvl
    local unit caster
    local real heal
    local real t
    
    if CastLogic() then
        set caster = udg_Caster
        set lvl = udg_Level
        set t = udg_Time
    elseif RandomLogic() then
        set caster = udg_Caster
        set lvl = udg_Level
        call textst( udg_string[0] + GetObjectName('A02T'), caster, 64, 90, 10, 1.5 )
        set t = 5
    else
        set caster = GetSpellAbilityUnit()
        set lvl = GetUnitAbilityLevel(GetSpellAbilityUnit(), GetSpellAbilityId() )
        set t = 5
    endif
    
    if lvl > 4 then
        set lvl = 4
    endif
    set t = timebonus(caster, t)
    set x = GetUnitX( caster ) + 250 * Cos( 0.017 * GetUnitFacing( caster ) )
    set y = GetUnitY( caster ) + 250 * Sin( 0.017 * GetUnitFacing( caster ) )
    set dmg = (30 + ( 10 * lvl )) * GetUnitSpellPower(caster)
    set heal = 0.03 + (0.02*lvl)
    
	call DestroyEffect( AddSpecialEffect( "war3mapImported\\BlackChakraExplosion.mdx", x, y ) )
    call GroupEnumUnitsInRange( g, x, y, 300, null )
    loop
        set u = FirstOfGroup(g)
        exitwhen u == null
        if unitst( u, caster, "enemy" ) then
            if GetUnitAbilityLevel( u, 'A09C') == 0 then
                call dummyspawn( caster, 0, 'A0N5', 0, 0 )
                
                set id = GetHandleId( u )
                if LoadTimerHandle( udg_hash, id, StringHash( "flnq1" ) ) == null then
                    call SaveTimerHandle( udg_hash, id, StringHash( "flnq1" ), CreateTimer() )
                endif
                set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "flnq1" ) ) ) 
                call SaveUnitHandle( udg_hash, id, StringHash( "flnq1" ), u )
                call SaveUnitHandle( udg_hash, id, StringHash( "flnq1d" ), bj_lastCreatedUnit )
                call SaveReal( udg_hash, id, StringHash( "flnq1" ), dmg )
                call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( u ), StringHash( "flnq1" ) ), 1, true, function FallenOneQEnd ) 
            endif
            call bufst( caster, u, 'A09C', 'B08H', "flnq", t )
            call debuffst( caster, u, null, lvl, t )
        elseif unitst( u, caster, "ally" ) and u != caster then
            call healst( caster, u, GetUnitState( u, UNIT_STATE_MAX_LIFE) * heal )
        endif
        call GroupRemoveUnit(g,u)
        set u = FirstOfGroup(g)
    endloop
    
    call GroupClear( g )
    call DestroyGroup( g )
    set g = null
    set u = null
    set caster = null
endfunction

//===========================================================================
function InitTrig_FallenOneQ takes nothing returns nothing
    set gg_trg_FallenOneQ = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_FallenOneQ, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_FallenOneQ, Condition( function Trig_FallenOneQ_Conditions ) )
    call TriggerAddAction( gg_trg_FallenOneQ, function Trig_FallenOneQ_Actions )
endfunction

