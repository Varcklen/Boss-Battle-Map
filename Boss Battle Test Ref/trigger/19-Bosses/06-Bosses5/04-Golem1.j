function Trig_Golem1_Conditions takes nothing returns boolean
    return GetUnitTypeId(udg_DamageEventTarget) == 'n00R' and GetUnitLifePercent(udg_DamageEventTarget) <= 75
endfunction

function GolemElectro1Cast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local unit dummy = LoadUnitHandle( udg_hash, id, StringHash( "bsigE2" ))
    local group g = CreateGroup()
    local unit u
    
    if GetUnitState( dummy, UNIT_STATE_LIFE) <= 0.405 or not( udg_fightmod[0] ) then
        call DestroyTimer( GetExpiredTimer() )
        call FlushChildHashtable( udg_hash, id )
    else
        call GroupEnumUnitsInRange( g, GetUnitX( dummy ), GetUnitY( dummy ), 200, null )
        loop
            set u = FirstOfGroup(g)
            exitwhen u == null
            if unitst( u, dummy, "enemy" ) then
                call UnitDamageTarget( dummy, u, 20, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS )
            endif
            call GroupRemoveUnit(g,u)
            set u = FirstOfGroup(g)
        endloop
    endif
    
    call GroupClear( g )
    call DestroyGroup( g )
    set u = null
    set g = null
    set dummy = null
endfunction

function GolemElectroCast1 takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer( ) )
    local unit boss = LoadUnitHandle( udg_hash, id, StringHash( "bsigE" ))
    local integer id1

    if GetUnitState( boss, UNIT_STATE_LIFE) <= 0.405 or not( udg_fightmod[0] ) then
        call DestroyTimer( GetExpiredTimer() )
        call FlushChildHashtable( udg_hash, id )
    else
        set bj_lastCreatedUnit = CreateUnit( GetOwningPlayer( boss ), 'u000', GetUnitX( boss ) + GetRandomReal(-400, 400), GetUnitY( boss ) + GetRandomReal(-400, 400), 270 )
        call UnitAddAbility( bj_lastCreatedUnit, 'A072')
        call SetUnitScale(bj_lastCreatedUnit, 2, 2, 2 )
        call UnitApplyTimedLife( bj_lastCreatedUnit, 'BTLF', 20)
        call DestroyEffect( AddSpecialEffectTarget( "Abilities\\Spells\\Other\\Monsoon\\MonsoonBoltTarget.mdl", bj_lastCreatedUnit, "origin") )
        set id1 = GetHandleId( bj_lastCreatedUnit )
        
        call SaveTimerHandle( udg_hash, id1, StringHash( "bsigE2" ), CreateTimer() )
        set id1 = GetHandleId( LoadTimerHandle( udg_hash, id1, StringHash( "bsigE2" ) ) ) 
        call SaveUnitHandle( udg_hash, id1, StringHash( "bsigE2" ), bj_lastCreatedUnit )
        call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( bj_lastCreatedUnit ), StringHash( "bsigE2" ) ), 1, true, function GolemElectro1Cast ) 
    endif
    
    set boss = null
endfunction

function GolemLose takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local unit boss = LoadUnitHandle( udg_hash, id, StringHash( "bsig2" ) )
    local group g = CreateGroup()
    local unit u
    local integer i = 0
    
    set bj_livingPlayerUnitsTypeId = 'n00S'
    call GroupEnumUnitsOfPlayer(g, GetOwningPlayer(boss), filterLivingPlayerUnitsOfTypeId)
    loop
        set u = FirstOfGroup(g)
        exitwhen u == null
        set i = i + 1
        call GroupRemoveUnit(g,u)
        set u = FirstOfGroup(g)
    endloop
    
    if i == 0 then
        call UnitRemoveAbility( boss, 'A06O' )
        call UnitRemoveAbility( boss, 'A06Q' )
        call FlushChildHashtable( udg_hash, id )
        call DestroyTimer( GetExpiredTimer() )
    endif
    
    call GroupClear( g )
    call DestroyGroup( g )
    set u = null
    set g = null
    set boss = null
endfunction

function Golem1Move takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local unit caster = LoadUnitHandle( udg_hash, id, StringHash( "bsigl" ) )
    local unit target = LoadUnitHandle( udg_hash, id, StringHash( "bsiglt" ) )
    local lightning l = LoadLightningHandle( udg_hash, id, StringHash( "bsigll" ) )
    
    if caster != target and GetUnitState( caster, UNIT_STATE_LIFE) > 0.405 and GetUnitState( target, UNIT_STATE_LIFE) > 0.405 then
        call MoveLightningUnits( l, caster, target )
    else
    	call DestroyLightning( l )
        call FlushChildHashtable( udg_hash, id )
        call DestroyTimer( GetExpiredTimer() )
    endif
    
    set caster = null
    set target = null
endfunction

function Trig_Golem1_Actions takes nothing returns nothing
    local integer id
    local integer cyclA = 1
    local real x
    local real y
    local lightning l

    call DisableTrigger( GetTriggeringTrigger() )
    call UnitAddAbility( udg_DamageEventTarget, 'A06O' )
    call UnitAddAbility( udg_DamageEventTarget, 'A06Q' )
    call UnitAddAbility( udg_DamageEventTarget, 'A0B0' )
    call DestroyEffect(AddSpecialEffectTarget( "Abilities\\Spells\\Orc\\WarStomp\\WarStompCaster.mdl", udg_DamageEventTarget, "origin") )
    call SaveUnitHandle( udg_hash, GetHandleId( udg_DamageEventTarget ), StringHash( "bsgk2" ), udg_DamageEventTarget )
    loop
        exitwhen cyclA > 4
        set x = GetUnitX(udg_DamageEventTarget) + 700 * Cos((45 + ( 90 * cyclA )) * bj_DEGTORAD)
        set y = GetUnitY(udg_DamageEventTarget) + 700 * Sin((45 + ( 90 * cyclA )) * bj_DEGTORAD)
        set bj_lastCreatedUnit = CreateUnit( GetOwningPlayer(udg_DamageEventTarget), 'n00S', x, y, 270 )
        call PingMinimapLocForForceEx( bj_FORCE_ALL_PLAYERS, GetUnitLoc(bj_lastCreatedUnit), 5.00, bj_MINIMAPPINGSTYLE_ATTACK, 100, 50.00, 50.00 )
        
        set l = AddLightningEx("DRAM", true, GetUnitX(bj_lastCreatedUnit), GetUnitY(bj_lastCreatedUnit), GetUnitFlyHeight(bj_lastCreatedUnit) , GetUnitX(udg_DamageEventTarget), GetUnitY(udg_DamageEventTarget), GetUnitFlyHeight(udg_DamageEventTarget))

        set id = GetHandleId( bj_lastCreatedUnit )
        if LoadTimerHandle( udg_hash, id, StringHash( "bsigl" ) ) == null  then
            call SaveTimerHandle( udg_hash, id, StringHash( "bsigl" ), CreateTimer() )
        endif
        set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "bsigl" ) ) ) 
        call SaveUnitHandle( udg_hash, id, StringHash( "bsigl" ), bj_lastCreatedUnit )
        call SaveUnitHandle( udg_hash, id, StringHash( "bsiglt" ), udg_DamageEventTarget )
        call SaveLightningHandle( udg_hash, id, StringHash( "bsigll" ), l )
        call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( bj_lastCreatedUnit ), StringHash( "bsigl" ) ), 0.02, true, function Golem1Move )
        set cyclA = cyclA + 1
    endloop
    
    set id = GetHandleId( udg_DamageEventTarget )
    if LoadTimerHandle( udg_hash, id, StringHash( "bsig2" ) ) == null then 
        call SaveTimerHandle( udg_hash, id, StringHash( "bsig2" ), CreateTimer() )
    endif
    set id = GetHandleId( LoadTimerHandle( udg_hash, GetHandleId( udg_DamageEventTarget ), StringHash( "bsig2" ) ) ) 
    call SaveUnitHandle( udg_hash, id, StringHash( "bsig2" ), udg_DamageEventTarget )
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( udg_DamageEventTarget ), StringHash( "bsig2" ) ), 0.5, true, function GolemLose )
    
    set id = GetHandleId( udg_DamageEventTarget )
    if LoadTimerHandle( udg_hash, id, StringHash( "bsigE" ) ) == null  then
        call SaveTimerHandle( udg_hash, id, StringHash( "bsigE" ), CreateTimer() )
    endif
	set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "bsigE" ) ) ) 
    call SaveUnitHandle( udg_hash, id, StringHash( "bsigE" ), udg_DamageEventTarget )
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( udg_DamageEventTarget ), StringHash( "bsigE" ) ), bosscast(6), true, function GolemElectroCast1 )
    
    set l = null
endfunction

//===========================================================================
function InitTrig_Golem1 takes nothing returns nothing
    set gg_trg_Golem1 = CreateTrigger(  )
    call DisableTrigger( gg_trg_Golem1 )
    call TriggerRegisterVariableEvent( gg_trg_Golem1, "udg_AfterDamageEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_Golem1, Condition( function Trig_Golem1_Conditions ) )
    call TriggerAddAction( gg_trg_Golem1, function Trig_Golem1_Actions )
endfunction

