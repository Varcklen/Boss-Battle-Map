function Trig_VampP_Conditions takes nothing returns boolean
    return not( udg_IsDamageSpell ) and GetUnitAbilityLevel( udg_DamageEventSource, 'A0FC') > 0 and luckylogic( udg_DamageEventSource, 20, 1, 100 )
endfunction

function VampPCast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local unit target = LoadUnitHandle( udg_hash, id, StringHash( "vapp" ) )
    local unit caster = LoadUnitHandle( udg_hash, id, StringHash( "vappc" ) )
    local real dmg = LoadReal( udg_hash, id, StringHash( "vapp" ) )
    local group g = CreateGroup()
    local unit u
    local real heal = 0

    call dummyspawn( caster, 1, 0, 0, 0 )
    call GroupEnumUnitsInRange( g, GetUnitX( target ), GetUnitY( target ), 300, null )
    loop
        set u = FirstOfGroup(g)
        exitwhen u == null
        if unitst( u, caster, "enemy" ) then
            set heal = heal + dmg
            call UnitDamageTarget( bj_lastCreatedUnit, u, dmg, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS )
            call DestroyEffect( AddSpecialEffectTarget("Abilities\\Spells\\Human\\Heal\\HealTarget.mdl", u, "chest" ) )
        endif
        call GroupRemoveUnit(g,u)
    endloop
    
    call healst( caster, null, heal )
    call spectimeunit( caster, "Abilities\\Spells\\Human\\Heal\\HealTarget.mdl", "origin", 2 )
    
    call GroupClear( g )
    call DestroyGroup( g )
    set u = null
    set g = null
    set caster = null
    set target = null
endfunction

function Trig_VampP_Actions takes nothing returns nothing
    local integer id = GetHandleId( udg_DamageEventTarget )
    local real dmg = 10 + ( 5 * GetUnitAbilityLevel(udg_DamageEventSource, 'A0FC') )
    
    if LoadTimerHandle( udg_hash, id, StringHash( "vapp" ) ) == null then
        call SaveTimerHandle( udg_hash, id, StringHash( "vapp" ), CreateTimer() )
    endif
    set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "vapp" ) ) ) 
    call SaveUnitHandle( udg_hash, id, StringHash( "vapp" ), udg_DamageEventTarget )
    call SaveUnitHandle( udg_hash, id, StringHash( "vappc" ), udg_DamageEventSource )
    call SaveReal( udg_hash, id, StringHash( "vapp" ), dmg )
    call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( udg_DamageEventTarget ), StringHash( "vapp" ) ), 0.01, false, function VampPCast )
endfunction

//===========================================================================
function InitTrig_VampP takes nothing returns nothing
    set gg_trg_VampP = CreateTrigger(  )
    call TriggerRegisterVariableEvent( gg_trg_VampP, "udg_AfterDamageEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_VampP, Condition( function Trig_VampP_Conditions ) )
    call TriggerAddAction( gg_trg_VampP, function Trig_VampP_Actions )
endfunction

