function Trig_MoonPriest2_Conditions takes nothing returns boolean
    return GetUnitTypeId( udg_DamageEventTarget ) == 'e005' and GetUnitLifePercent(udg_DamageEventTarget) <= 60
endfunction
    
function MoonPriestIf takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local unit boss = LoadUnitHandle( udg_hash, id, StringHash( "bsmp1" ) )
    local effect fx = LoadEffectHandle( udg_hash, id, StringHash( "bsmp1e" ) )
    local group g = CreateGroup()
    local unit u

    if CountLivingPlayerUnitsOfTypeId('e00I', Player(10)) == 0 or GetUnitState( boss, UNIT_STATE_LIFE) <= 0.405 or not( udg_fightmod[0] ) then
        call DestroyEffect( fx )
        call UnitRemoveAbility( boss, 'A06O' )
        call UnitRemoveAbility( boss, 'A06Q' )
        call DestroyTimer( GetExpiredTimer() )
        call FlushChildHashtable( udg_hash, id )
    else
        call dummyspawn( boss, 1, 0, 0, 0 )
        call GroupEnumUnitsInRange( g, GetUnitX( boss ), GetUnitY( boss ), 3000, null )
        loop
            set u = FirstOfGroup(g)
            exitwhen u == null
            if unitst( u, boss, "enemy" ) then
                call DestroyEffect( AddSpecialEffectTarget( "Abilities\\Spells\\NightElf\\Starfall\\StarfallTarget.mdl", u, "origin") )
                call UnitDamageTarget(bj_lastCreatedUnit, u, 50, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS)
            endif
            call GroupRemoveUnit(g,u)
        endloop
    endif
    
    call GroupClear( g )
    call DestroyGroup( g )
    set u = null
    set g = null
    set boss = null
    set fx = null
endfunction

function Trig_MoonPriest2_Actions takes nothing returns nothing
    local integer id 
    local integer cyclA = 1

    call DisableTrigger( GetTriggeringTrigger() )
    call UnitAddAbility( udg_DamageEventTarget, 'A06O' )
    call UnitAddAbility( udg_DamageEventTarget, 'A06Q' )
    
    loop
        exitwhen cyclA > 4
        call CreateUnit( GetOwningPlayer( udg_DamageEventTarget ), 'e00I', GetUnitX( udg_DamageEventTarget ) + GetRandomReal(-400, 400), GetUnitY( udg_DamageEventTarget ) + GetRandomReal(-400, 400), GetRandomReal( 0, 360 ) )
        set cyclA = cyclA + 1
    endloop
    
    set bj_lastCreatedEffect = AddSpecialEffectTarget("Abilities\\Spells\\NightElf\\Starfall\\StarfallCaster.mdl", udg_DamageEventTarget, "origin")
    
    set id = GetHandleId( udg_DamageEventTarget )
    if LoadTimerHandle( udg_hash, id, StringHash( "bsmp1" ) ) == null then
        call SaveTimerHandle( udg_hash, id, StringHash( "bsmp1" ), CreateTimer() )
    endif
    set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "bsmp1" ) ) ) 
    call SaveUnitHandle( udg_hash, id, StringHash( "bsmp1" ), udg_DamageEventTarget )
    call SaveEffectHandle( udg_hash, id, StringHash( "bsmp1e" ), bj_lastCreatedEffect )
    call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( udg_DamageEventTarget ), StringHash( "bsmp1" ) ), 1.5, true, function MoonPriestIf )
endfunction

//===========================================================================
function InitTrig_MoonPriest2 takes nothing returns nothing
    set gg_trg_MoonPriest2 = CreateTrigger(  )
    call DisableTrigger( gg_trg_MoonPriest2 )
    call TriggerRegisterVariableEvent( gg_trg_MoonPriest2, "udg_AfterDamageEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_MoonPriest2, Condition( function Trig_MoonPriest2_Conditions ) )
    call TriggerAddAction( gg_trg_MoonPriest2, function Trig_MoonPriest2_Actions )
endfunction

