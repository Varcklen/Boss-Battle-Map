function Trig_Bob3_Conditions takes nothing returns boolean
    return GetUnitTypeId(udg_DamageEventTarget) == 'n00A' and GetUnitLifePercent(udg_DamageEventTarget) <= 50
endfunction

function Trig_Bob3_Actions takes nothing returns nothing
    local integer cyclA = 1
    local integer cyclB
    local real x
    local real y
    local unit u
    
    call DisableTrigger( GetTriggeringTrigger() )
    call TransmissionFromUnitWithNameBJ( bj_FORCE_ALL_PLAYERS, udg_DamageEventTarget, GetUnitName(udg_DamageEventTarget), null, "Bosses, help me!", bj_TIMETYPE_SET, 3, false )
    loop
        exitwhen cyclA > 4
        if GetUnitState( udg_hero[cyclA], UNIT_STATE_LIFE) > 0.405 then
        	set x = GetUnitX( udg_DamageEventTarget ) + 400 * Cos( ( 45 + ( 90 * cyclA ) ) * bj_DEGTORAD )
        	set y = GetUnitY( udg_DamageEventTarget ) + 400 * Sin( ( 45 + ( 90 * cyclA ) ) * bj_DEGTORAD )
            set u = CreateUnit( GetOwningPlayer( udg_DamageEventTarget ), DB_Boss_id[GetRandomInt(1,3)][cyclA], x, y, GetRandomReal( 0, 360 ) )
            call aggro( u )
        endif
        set cyclA = cyclA + 1
    endloop

	set u = null
endfunction

//===========================================================================
function InitTrig_Bob3 takes nothing returns nothing
    set gg_trg_Bob3 = CreateTrigger(  )
    call DisableTrigger( gg_trg_Bob3 )
    call TriggerRegisterVariableEvent( gg_trg_Bob3, "udg_AfterDamageEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_Bob3, Condition( function Trig_Bob3_Conditions ) )
    call TriggerAddAction( gg_trg_Bob3, function Trig_Bob3_Actions )
endfunction

