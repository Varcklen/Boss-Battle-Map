function Trig_Sheep2_Conditions takes nothing returns boolean
    return GetUnitTypeId(udg_DamageEventTarget) == 'n007' and GetUnitLifePercent(udg_DamageEventTarget) <= 75.
endfunction

function Trig_Sheep2_Actions takes nothing returns nothing
    local integer cyclA = 1
    local integer cyclB

    call DisableTrigger( GetTriggeringTrigger() )
    loop
        exitwhen cyclA > 4
        if GetUnitState( udg_hero[cyclA], UNIT_STATE_LIFE) > 0.405 then
            call IssueImmediateOrder( udg_hero[cyclA], "stop" )
        endif
        set cyclA = cyclA + 1
    endloop
    call DestroyEffect(AddSpecialEffectTarget( "Abilities\\Spells\\Other\\Silence\\SilenceAreaBirth.mdl", udg_DamageEventTarget, "origin") )
    set cyclA = 1
    loop
        exitwhen cyclA > 4
        set cyclB = 1
        loop
            exitwhen cyclB > 3
            set bj_lastCreatedUnit = CreateUnit( GetOwningPlayer( udg_DamageEventTarget ), 'n00E', GetUnitX( udg_DamageEventTarget ) + GetRandomReal( -500, 500 ), GetUnitY( udg_DamageEventTarget ) + GetRandomReal( -500, 500 ), GetRandomReal( 0, 360 ) )
            call SetUnitState(bj_lastCreatedUnit, UNIT_STATE_LIFE, GetUnitState(bj_lastCreatedUnit, UNIT_STATE_MAX_LIFE) * 0.75)
            call UnitAddAbility( bj_lastCreatedUnit, 'A0D8')
            if not( RectContainsUnit( udg_Boss_Rect, bj_lastCreatedUnit) ) then
                call SetUnitPositionLoc( bj_lastCreatedUnit, GetRectCenter( udg_Boss_Rect ) )
            endif
            set cyclB = cyclB + 1
        endloop
        set cyclA = cyclA + 1
    endloop
    call SetUnitPosition( udg_DamageEventTarget, GetUnitX( udg_DamageEventTarget ) + GetRandomReal( -200, 200 ), GetUnitY( udg_DamageEventTarget ) + GetRandomReal( -200, 200 ) )
    if not( RectContainsUnit( udg_Boss_Rect, udg_DamageEventTarget) ) then
        call SetUnitPositionLoc( udg_DamageEventTarget, GetRectCenter( udg_Boss_Rect ) )
    endif
endfunction

//===========================================================================
function InitTrig_Sheep2 takes nothing returns nothing
    set gg_trg_Sheep2 = CreateTrigger()
    call DisableTrigger( gg_trg_Sheep2 )
    call TriggerRegisterVariableEvent( gg_trg_Sheep2, "udg_AfterDamageEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_Sheep2, Condition( function Trig_Sheep2_Conditions ) )
    call TriggerAddAction( gg_trg_Sheep2, function Trig_Sheep2_Actions )
endfunction