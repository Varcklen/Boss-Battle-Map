function Trig_Arah2_Conditions takes nothing returns boolean
    return GetUnitTypeId(udg_DamageEventTarget) == 'h00K' and GetUnitLifePercent(udg_DamageEventTarget) <= 35
endfunction

function Trig_Arah2_Actions takes nothing returns nothing
    local integer cyclA = 1
    local integer cyclB
    local real x
    local real y
    
    call DisableTrigger( GetTriggeringTrigger() )
    call DestroyEffect( AddSpecialEffectTarget( "Abilities\\Spells\\NightElf\\BattleRoar\\RoarCaster.mdl", udg_DamageEventTarget, "origin") )
    loop
        exitwhen cyclA > 4
        set x = GetRectCenterX( udg_Boss_Rect ) + 2000 * Cos( ( 45 + ( 90 * cyclA ) ) * bj_DEGTORAD )
        set y = GetRectCenterY( udg_Boss_Rect ) + 2000 * Sin( ( 45 + ( 90 * cyclA ) ) * bj_DEGTORAD )
        set cyclB = 1
        loop
            exitwhen cyclB > 8
            set bj_lastCreatedUnit = CreateUnit( GetOwningPlayer( udg_DamageEventTarget ), 'h00L', x, y, GetRandomReal( 0, 360 ) )
            if udg_fightmod[4] then
                call UnitApplyTimedLife( bj_lastCreatedUnit, 'BTLF', 60)
            endif
            set cyclB = cyclB + 1
        endloop
        set cyclA = cyclA + 1
    endloop
endfunction

//===========================================================================
function InitTrig_Arah2 takes nothing returns nothing
    set gg_trg_Arah2 = CreateTrigger(  )
    call DisableTrigger( gg_trg_Arah2 )
    call TriggerRegisterVariableEvent( gg_trg_Arah2, "udg_AfterDamageEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_Arah2, Condition( function Trig_Arah2_Conditions ) )
    call TriggerAddAction( gg_trg_Arah2, function Trig_Arah2_Actions )
endfunction

