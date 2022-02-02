//TESH.scrollpos=0
//TESH.alwaysfold=0
function Trig_Ent1_Conditions takes nothing returns boolean
    return GetUnitTypeId(udg_DamageEventTarget) == 'e006' and GetUnitLifePercent(udg_DamageEventTarget) <= 75
endfunction

function Trig_Ent1_Actions takes nothing returns nothing
    local integer cyclA = 1

    call DisableTrigger( GetTriggeringTrigger() )
    loop
        exitwhen cyclA > 20
        set bj_lastCreatedUnit = CreateUnit( GetOwningPlayer( udg_DamageEventTarget ), 'o00O', GetRectCenterX( udg_Boss_Rect ) + GetRandomReal( -1750, 1750 ), GetRectCenterY( udg_Boss_Rect ) + GetRandomReal( -1750, 1750 ), GetRandomReal( 0, 360 ) )
        call DestroyEffect( AddSpecialEffect("Objects\\Spawnmodels\\NightElf\\EntBirthTarget\\EntBirthTarget.mdl", GetUnitX( bj_lastCreatedUnit ), GetUnitY( bj_lastCreatedUnit ) ) )
        set cyclA = cyclA + 1
    endloop
endfunction

//===========================================================================
function InitTrig_Ent1 takes nothing returns nothing
    set gg_trg_Ent1 = CreateTrigger(  )
    call DisableTrigger( gg_trg_Ent1 )
    call TriggerRegisterVariableEvent( gg_trg_Ent1, "udg_AfterDamageEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_Ent1, Condition( function Trig_Ent1_Conditions ) )
    call TriggerAddAction( gg_trg_Ent1, function Trig_Ent1_Actions )
endfunction

