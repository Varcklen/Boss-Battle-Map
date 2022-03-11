function Trig_MoonPriest5_Conditions takes nothing returns boolean
    return GetUnitTypeId( udg_DamageEventTarget ) == 'e005' and GetUnitLifePercent(udg_DamageEventTarget) <= 30
endfunction

function Trig_MoonPriest5_Actions takes nothing returns nothing
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
    if LoadTimerHandle( udg_hash, id, StringHash( "bsmp1" ) ) == null  then
        call SaveTimerHandle( udg_hash, id, StringHash( "bsmp1" ), CreateTimer() )
    endif
    set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "bsmp1" ) ) ) 
    call SaveUnitHandle( udg_hash, id, StringHash( "bsmp1" ), udg_DamageEventTarget )
    call SaveEffectHandle( udg_hash, id, StringHash( "bsmp1e" ), bj_lastCreatedEffect )
    call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( udg_DamageEventTarget ), StringHash( "bsmp1" ) ), 1, true, function MoonPriestIf )
endfunction

//===========================================================================
function InitTrig_MoonPriest5 takes nothing returns nothing
    set gg_trg_MoonPriest5 = CreateTrigger(  )
    call DisableTrigger( gg_trg_MoonPriest5 )
    call TriggerRegisterVariableEvent( gg_trg_MoonPriest5, "udg_AfterDamageEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_MoonPriest5, Condition( function Trig_MoonPriest5_Conditions ) )
    call TriggerAddAction( gg_trg_MoonPriest5, function Trig_MoonPriest5_Actions )
endfunction

