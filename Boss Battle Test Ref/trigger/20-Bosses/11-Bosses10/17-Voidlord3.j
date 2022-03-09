function Trig_Voidlord3_Conditions takes nothing returns boolean
    return GetUnitTypeId(udg_DamageEventTarget) == 'n00C' and GetUnitLifePercent(udg_DamageEventTarget) <= 50.
endfunction

function Trig_Voidlord3_Actions takes nothing returns nothing
    local integer cyclA = 1
    local integer cyclB
	local real x
	local real y
	local integer rand = GetRandomInt( 1, 4 )

    call DisableTrigger( GetTriggeringTrigger() )
    loop
        exitwhen cyclA > 4
        if GetUnitState( udg_hero[cyclA], UNIT_STATE_LIFE) > 0.405 then
            call IssueImmediateOrder( udg_hero[cyclA], "stop" )
        endif
        set cyclA = cyclA + 1
    endloop
    call TransmissionFromUnitWithNameBJ( bj_FORCE_ALL_PLAYERS, udg_DamageEventTarget, GetUnitName(udg_DamageEventTarget), null, "Shadow will consume you all!", bj_TIMETYPE_SET, 3, false )
    call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\Human\\MassTeleport\\MassTeleportCaster.mdl", GetUnitX(udg_DamageEventTarget), GetUnitY(udg_DamageEventTarget) ) )
    set cyclA = 1
    loop
        exitwhen cyclA > 4
	set x = GetRectCenterX( udg_Boss_Rect ) + 2500 * Cos( ( 135 + ( 90 * cyclA ) ) * bj_DEGTORAD )
        set y = GetRectCenterY( udg_Boss_Rect ) + 2500 * Sin( ( 135 + ( 90 * cyclA ) ) * bj_DEGTORAD )
        set cyclB = 1
        loop
            exitwhen cyclB > 5
            set bj_lastCreatedUnit = CreateUnit( GetOwningPlayer( udg_DamageEventTarget ), 'u008', x, y, GetRandomReal( 0, 360 ) )
            call SetUnitState(bj_lastCreatedUnit, UNIT_STATE_LIFE, GetUnitState(bj_lastCreatedUnit, UNIT_STATE_MAX_LIFE) * 0.5)
            set cyclB = cyclB + 1
        endloop
        set cyclA = cyclA + 1
    endloop
    set x = GetRectCenterX( udg_Boss_Rect ) + 2500 * Cos( ( 135 + ( 90 * rand ) ) * bj_DEGTORAD )
    set y = GetRectCenterY( udg_Boss_Rect ) + 2500 * Sin( ( 135 + ( 90 * rand ) ) * bj_DEGTORAD )
    call SetUnitPosition( udg_DamageEventTarget, x, y )
    call aggro( udg_DamageEventTarget )
endfunction

//===========================================================================
function InitTrig_Voidlord3 takes nothing returns nothing
    set gg_trg_Voidlord3 = CreateTrigger()
    call DisableTrigger( gg_trg_Voidlord3 )
    call TriggerRegisterVariableEvent( gg_trg_Voidlord3, "udg_AfterDamageEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_Voidlord3, Condition( function Trig_Voidlord3_Conditions ) )
    call TriggerAddAction( gg_trg_Voidlord3, function Trig_Voidlord3_Actions )
endfunction

