function Trig_MonkW_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A093'
endfunction

function MonkWEnd takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local unit caster = LoadUnitHandle( udg_hash, id, StringHash( "mnkw1" ) )
    local real dmg = LoadReal( udg_hash, id, StringHash( "mnkw1d" ) )
    local real heal = LoadReal( udg_hash, id, StringHash( "mnkw1h" ) )
    local real h = LoadReal( udg_hash, id, StringHash( "mnkw1hh" ) )
    local real healsum = 0
    local group g = CreateGroup()
    local unit u
    
    call dummyspawn( caster, 1, 0, 'A0N5', 0 )
    call GroupEnumUnitsInRange( g, GetUnitX( caster ), GetUnitY( caster ), 300, null )
    loop
        set u = FirstOfGroup(g)
        exitwhen u == null
        if unitst( u, caster, "enemy" ) then
            call UnitDamageTarget(bj_lastCreatedUnit, u, dmg, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS)
            set healsum = healsum + heal
        endif
        call GroupRemoveUnit(g,u)
    endloop

    if healsum > 0 then
    	call healst( caster, null, healsum )
        call spectimeunit( caster, "Abilities\\Spells\\Human\\Heal\\HealTarget.mdl", "origin", 2 )
    endif
    
    call SetUnitFlyHeight( caster, h, 0 )
    call DestroyEffect( AddSpecialEffectTarget( "Abilities\\Spells\\Human\\Thunderclap\\ThunderClapCaster.mdl", caster, "origin" ) )
    call PauseUnit( caster, false)
    call UnitRemoveAbility(caster, 'Amrf')
    call SetUnitPathing( caster, true )
    
    call FlushChildHashtable( udg_hash, id )
    call GroupClear( g )
    call DestroyGroup( g )
    set caster = null
    set u = null
endfunction

function MonkWMotion takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local unit u = LoadUnitHandle( udg_hash, id, StringHash( "mnkw" ) )
    local integer id1 = GetHandleId( u )
    local real h = LoadReal( udg_hash, id, StringHash( "mnkwhh" ) )
    
    call SetUnitFlyHeight( u, -600., 1000.)
    
    call SaveTimerHandle( udg_hash, id1, StringHash( "mnkw1" ), CreateTimer() )
	set id1 = GetHandleId( LoadTimerHandle( udg_hash, id1, StringHash( "mnkw1" ) ) ) 
	call SaveUnitHandle( udg_hash, id1, StringHash( "mnkw1" ), u )
    call SaveReal( udg_hash, id1, StringHash( "mnkw1d" ), LoadReal( udg_hash, id, StringHash( "mnkwd" ) ) )
    call SaveReal( udg_hash, id1, StringHash( "mnkw1h" ), LoadReal( udg_hash, id, StringHash( "mnkwh" ) ) )
    call SaveReal( udg_hash, id1, StringHash( "mnkw1hh" ), h)
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( u ), StringHash( "mnkw1" ) ), 0.2, false, function MonkWEnd )

    call FlushChildHashtable( udg_hash, id )
    set u = null
endfunction

function Trig_MonkW_Actions takes nothing returns nothing
    local integer id
    local integer lvl
    local unit caster
    local real dmg
    local real heal
    local real h
    
    if CastLogic() then
        set caster = udg_Caster
        set lvl = udg_Level
    elseif RandomLogic() then
        set caster = udg_Caster
        set lvl = udg_Level
        call textst( udg_string[0] + GetObjectName('A093'), caster, 64, 90, 10, 1.5 )
    else
        set caster = GetSpellAbilityUnit()
        set lvl = GetUnitAbilityLevel(GetSpellAbilityUnit(), GetSpellAbilityId())
    endif
    set id = GetHandleId( caster )
    set dmg = ( 60. + ( 40. * lvl ) ) * GetUnitSpellPower(caster)
    set heal = 12. + ( 8. * lvl )
    set h = GetUnitDefaultFlyHeight(caster)
    
    call PauseUnit( caster, true)
    call UnitAddAbility( caster, 'Amrf')
    call SetUnitFlyHeight( caster, 600., 1000.)
    call SetUnitPathing( caster, false )

    call SaveTimerHandle( udg_hash, id, StringHash( "mnkw" ), CreateTimer() )
	set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "mnkw" ) ) ) 
	call SaveUnitHandle( udg_hash, id, StringHash( "mnkw" ), caster )
    call SaveReal( udg_hash, id, StringHash( "mnkwd" ), dmg )
    call SaveReal( udg_hash, id, StringHash( "mnkwh" ), heal )
    call SaveReal( udg_hash, id, StringHash( "mnkwhh" ), h)
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( caster ), StringHash( "mnkw" ) ), 0.2, false, function MonkWMotion )
    
    set caster = null
endfunction

//===========================================================================
function InitTrig_MonkW takes nothing returns nothing
    set gg_trg_MonkW = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_MonkW, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_MonkW, Condition( function Trig_MonkW_Conditions ) )
    call TriggerAddAction( gg_trg_MonkW, function Trig_MonkW_Actions )
endfunction

