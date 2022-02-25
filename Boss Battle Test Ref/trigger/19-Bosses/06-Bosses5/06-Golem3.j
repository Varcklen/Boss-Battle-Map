function Trig_Golem3_Conditions takes nothing returns boolean
    return GetUnitTypeId(udg_DamageEventTarget) == 'n00R' and GetUnitLifePercent(udg_DamageEventTarget) <= 25.
endfunction

function Trig_Golem3_Actions takes nothing returns nothing
    local integer id
    local integer cyclA = 1
    local real x
    local real y
    local lightning l

    call DisableTrigger( GetTriggeringTrigger() )
    call UnitAddAbility( udg_DamageEventTarget, 'A06O' )
    call UnitAddAbility( udg_DamageEventTarget, 'A06Q' )
    call SetUnitAbilityLevel( udg_DamageEventTarget, 'A0B0', 2)
    call DestroyEffect(AddSpecialEffectTarget( "Abilities\\Spells\\Orc\\WarStomp\\WarStompCaster.mdl", udg_DamageEventTarget, "origin") )
    call SaveUnitHandle( udg_hash, GetHandleId( udg_DamageEventTarget ), StringHash( "bsgk2" ), udg_DamageEventTarget )
    loop
        exitwhen cyclA > 8
        set x = GetUnitX(udg_DamageEventTarget) + 700 * Cos(45 * cyclA * bj_DEGTORAD)
        set y = GetUnitY(udg_DamageEventTarget) + 700 * Sin(45 * cyclA * bj_DEGTORAD)
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
    set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "bsig2" ) ) ) 
    call SaveUnitHandle( udg_hash, id, StringHash( "bsig2" ), udg_DamageEventTarget )
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( udg_DamageEventTarget ), StringHash( "bsig2" ) ), 0.5, true, function GolemLose )
    
    set l = null
endfunction

//===========================================================================
function InitTrig_Golem3 takes nothing returns nothing
    set gg_trg_Golem3 = CreateTrigger(  )
    call DisableTrigger( gg_trg_Golem3 )
    call TriggerRegisterVariableEvent( gg_trg_Golem3, "udg_AfterDamageEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_Golem3, Condition( function Trig_Golem3_Conditions ) )
    call TriggerAddAction( gg_trg_Golem3, function Trig_Golem3_Actions )
endfunction

