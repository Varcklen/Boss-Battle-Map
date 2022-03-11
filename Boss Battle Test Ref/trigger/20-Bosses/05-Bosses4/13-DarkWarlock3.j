function Trig_DarkWarlock3_Conditions takes nothing returns boolean
    return GetUnitTypeId(udg_DamageEventTarget) == 'e00D' and GetUnitLifePercent(udg_DamageEventTarget) <= 30.
endfunction

function Trig_DarkWarlock3_Actions takes nothing returns nothing
    local integer cyclA = 1 
    local real x
    local real y
    local integer id
    
    call DisableTrigger( GetTriggeringTrigger() )
    call DestroyEffect( AddSpecialEffectTarget( "Abilities\\Spells\\Other\\HowlOfTerror\\HowlCaster.mdl", udg_DamageEventTarget, "origin") )
    
    loop
        exitwhen cyclA > 30
        set x = GetRandomReal(GetRectMinX(udg_Boss_Rect), GetRectMaxX(udg_Boss_Rect))
        set y = GetRandomReal(GetRectMinY(udg_Boss_Rect), GetRectMaxY(udg_Boss_Rect))
        set bj_lastCreatedUnit = CreateUnit( GetOwningPlayer( udg_DamageEventTarget ), 'u000', x, y, 270 )
        call UnitAddAbility( bj_lastCreatedUnit, 'A07O' )
        
        set id = GetHandleId( bj_lastCreatedUnit )
        if LoadTimerHandle( udg_hash, id, StringHash( "bsdwd" ) ) == null  then
            call SaveTimerHandle( udg_hash, id, StringHash( "bsdwd" ), CreateTimer() )
        endif
        set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "bsdwd" ) ) ) 
        call SaveUnitHandle( udg_hash, id, StringHash( "bsdwd" ), bj_lastCreatedUnit )
        call SaveUnitHandle( udg_hash, id, StringHash( "bsdwdb" ), udg_DamageEventTarget )
        call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( bj_lastCreatedUnit ), StringHash( "bsdwd" ) ), 1, true, function DarkWarDamage ) 
        set cyclA = cyclA + 1
    endloop
endfunction

//===========================================================================
function InitTrig_DarkWarlock3 takes nothing returns nothing
    set gg_trg_DarkWarlock3 = CreateTrigger(  )
    call DisableTrigger( gg_trg_DarkWarlock3 )
    call TriggerRegisterVariableEvent( gg_trg_DarkWarlock3, "udg_AfterDamageEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_DarkWarlock3, Condition( function Trig_DarkWarlock3_Conditions ) )
    call TriggerAddAction( gg_trg_DarkWarlock3, function Trig_DarkWarlock3_Actions )
endfunction

