function Trig_Knight3_Conditions takes nothing returns boolean
    return GetUnitTypeId(udg_DamageEventTarget) == 'h000' and GetUnitLifePercent(udg_DamageEventTarget) <= 50
endfunction

function Trig_Knight3_Actions takes nothing returns nothing
    local integer i = GetRandomInt(1, 4)
    local real x = GetRectCenterX( udg_Boss_Rect ) + 2000 * Cos( ( 45 + ( 90 * i ) ) * bj_DEGTORAD )
    local real y = GetRectCenterY( udg_Boss_Rect ) + 2000 * Sin( ( 45 + ( 90 * i ) ) * bj_DEGTORAD )

    call DisableTrigger( GetTriggeringTrigger() )
    call SetUnitAbilityLevel(udg_DamageEventTarget, 'A03D', 3)
    call SetUnitAbilityLevel(udg_DamageEventTarget, 'A01E', 3)
    call SetUnitAnimation( udg_DamageEventTarget, "stand victory" )
    call DestroyEffect(AddSpecialEffectTarget( "Abilities\\Spells\\Human\\Thunderclap\\ThunderClapCaster.mdl", udg_DamageEventTarget, "origin") )
    set bj_lastCreatedUnit = CreateUnit( GetOwningPlayer( udg_DamageEventTarget ), 'h01E', x, y, GetUnitFacing( udg_DamageEventTarget ) )
    call aggro( bj_lastCreatedUnit )
    call TransmissionFromUnitWithNameBJ( bj_FORCE_ALL_PLAYERS, bj_lastCreatedUnit, "Methodius", gg_snd_FootmanWarcry1, "Sir! I will help you in battle!", bj_TIMETYPE_SET, 3, false )
endfunction

//===========================================================================
function InitTrig_Knight3 takes nothing returns nothing
    set gg_trg_Knight3 = CreateTrigger()
    call DisableTrigger( gg_trg_Knight3 )
    call TriggerRegisterVariableEvent( gg_trg_Knight3, "udg_AfterDamageEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_Knight3, Condition( function Trig_Knight3_Conditions ) )
    call TriggerAddAction( gg_trg_Knight3, function Trig_Knight3_Actions )
endfunction

