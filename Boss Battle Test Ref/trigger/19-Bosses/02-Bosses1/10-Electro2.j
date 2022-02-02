function Trig_Electro2_Conditions takes nothing returns boolean
    return GetUnitTypeId( udg_DamageEventTarget ) == 'n00Z' and GetUnitLifePercent( udg_DamageEventTarget ) <= 50
endfunction

function Trig_Electro2_Actions takes nothing returns nothing
    local integer id
    local integer cyclA = 1
    local real x
    local real y

    call DisableTrigger( GetTriggeringTrigger() )
    
    loop
        exitwhen cyclA > 8
        set x = GetUnitX(udg_DamageEventTarget) + 400 * Cos(45. * cyclA * bj_DEGTORAD)
        set y = GetUnitY(udg_DamageEventTarget) + 400 * Sin(45. * cyclA * bj_DEGTORAD)
        set bj_lastCreatedUnit = CreateUnit( GetOwningPlayer( udg_DamageEventTarget ), 'u000', x, y, 270 )
        call UnitAddAbility( bj_lastCreatedUnit, 'A072')
        call UnitApplyTimedLife( bj_lastCreatedUnit, 'BTLF', 20)
        call DestroyEffect( AddSpecialEffectTarget( "Abilities\\Spells\\Other\\Monsoon\\MonsoonBoltTarget.mdl", bj_lastCreatedUnit, "origin") )
        set id = GetHandleId( bj_lastCreatedUnit )
        
        call SaveTimerHandle( udg_hash, id, StringHash( "bsel2" ), CreateTimer() )
        set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "bsel2" ) ) ) 
        call SaveUnitHandle( udg_hash, id, StringHash( "bsel2" ), bj_lastCreatedUnit )
        call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( bj_lastCreatedUnit ), StringHash( "bsel2" ) ), 1, true, function Electro1Cast ) 
        set cyclA = cyclA + 1
    endloop
endfunction

//===========================================================================
function InitTrig_Electro2 takes nothing returns nothing
    set gg_trg_Electro2 = CreateTrigger(  )
    call DisableTrigger( gg_trg_Electro2 )
    call TriggerRegisterVariableEvent( gg_trg_Electro2, "udg_AfterDamageEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_Electro2, Condition( function Trig_Electro2_Conditions ) )
    call TriggerAddAction( gg_trg_Electro2, function Trig_Electro2_Actions )
endfunction

