function Serrated_blade_Condition takes unit hero returns boolean
    local boolean work = true
    local integer i = 0
    local integer index = GetUnitUserData(hero)
    
    if inv( hero, 'I0DX') == 0 then
        set i = i + 1
    endif
    if inv( hero, 'I030') == 0 or udg_Set_Weapon_Logic[index + 36] == false then
        set i = i + 1
    endif
    
    if i > 1 then
        set work = false
    elseif IsUnitEnemy( hero, GetOwningPlayer( hero ) ) then
        set work = false
    elseif udg_IsDamageSpell then
        set work = false
    elseif GetUnitTypeId(hero) == 'u000' then
        set work = false
    endif
    
    set hero = null
    return work
endfunction

function Trig_Serrated_blade_Conditions takes nothing returns boolean
    return Serrated_blade_Condition(udg_DamageEventSource)
endfunction

globals
    constant real SERRATED_BLADE_DURATION = 5
    constant real SERRATED_BLADE_DAMAGE_TICK = 1
    constant real SERRATED_BLADE_PERCENT_HEALTH_TO_DAMAGE = 0.016
endglobals

function Serrated_bladeCast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer( ) )
    local real dmg = LoadReal( udg_hash, id, StringHash( "srbl" ) )
    local unit target = LoadUnitHandle( udg_hash, id, StringHash( "srbl" ) )
    local unit dummy = LoadUnitHandle( udg_hash, id, StringHash( "srbld" ) )
    
    if GetUnitState( target, UNIT_STATE_LIFE) > 0.405 and GetUnitState( dummy, UNIT_STATE_LIFE) > 0.405 and GetUnitAbilityLevel( target, 'A0O4') > 0 then
        call UnitDamageTarget( dummy, target, dmg, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS )
    else
        call RemoveUnit( dummy )
        call FlushChildHashtable( udg_hash, id )
        call DestroyTimer( GetExpiredTimer() )
    endif
    
    set dummy = null
    set target = null
endfunction

function Trig_Serrated_blade_Actions takes nothing returns nothing
    local integer id 
    local unit target
    local unit caster
    local real t
    local real dmg
    
    if CastLogic() then
        set caster = udg_Caster
        set target = udg_Target
        set t = udg_Time
    else
        set caster = udg_DamageEventSource
        set target = udg_DamageEventTarget
        set t = SERRATED_BLADE_DURATION
    endif
    set t = timebonus( caster, t )
    set id = GetHandleId( target )

    set dmg = GetUnitState( caster, UNIT_STATE_MAX_LIFE) * SERRATED_BLADE_PERCENT_HEALTH_TO_DAMAGE * udg_SpellDamage[GetPlayerId(GetOwningPlayer( caster ) ) + 1]

    if GetUnitAbilityLevel( target, 'A0O4') == 0 then 
        call dummyspawn( caster, 0, 'A0N5', 0, 0 )
       
        if LoadTimerHandle( udg_hash, id, StringHash( "srbl" ) ) == null then
            call SaveTimerHandle( udg_hash, id, StringHash( "srbl" ), CreateTimer() )
        endif
        set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "srbl" ) ) ) 
        call SaveUnitHandle( udg_hash, id, StringHash( "srbl" ), target )
        call SaveUnitHandle( udg_hash, id, StringHash( "srbld" ), bj_lastCreatedUnit )
        call SaveReal( udg_hash, id, StringHash( "srbl" ), dmg )
        call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( target ), StringHash( "srbl" ) ), SERRATED_BLADE_DAMAGE_TICK, true, function Serrated_bladeCast )
    endif

    call bufst( caster, target, 'A0O4', 'B07V', "srbl1", t ) 
    
    call debuffst( caster, target, null, 1, t )
    
    set caster = null
    set target = null
endfunction

//===========================================================================
function InitTrig_Serrated_blade takes nothing returns nothing
    set gg_trg_Serrated_blade = CreateTrigger(  )
    call TriggerRegisterVariableEvent( gg_trg_Serrated_blade, "udg_AfterDamageEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_Serrated_blade, Condition( function Trig_Serrated_blade_Conditions ) )
    call TriggerAddAction( gg_trg_Serrated_blade, function Trig_Serrated_blade_Actions )
endfunction