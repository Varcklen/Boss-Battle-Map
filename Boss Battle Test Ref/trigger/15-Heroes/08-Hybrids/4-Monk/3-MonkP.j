function Trig_MonkP_Conditions takes nothing returns boolean
    return IsUnitHasAbility( udg_DamageEventSource, 'A08W') and udg_IsDamageSpell == false
endfunction

function Trig_MonkP_Actions takes nothing returns nothing
    local unit target = null
    local integer lvl = GetUnitAbilityLevel(udg_DamageEventSource, 'A08W')
    local real heal = 5. + I2R( ( lvl + 6 ) * lvl )

    set target = HeroLessHP(udg_DamageEventSource)
    if target != null then
        call healst( udg_DamageEventSource, target, heal )
        set target = null
    endif
endfunction

//===========================================================================
function InitTrig_MonkP takes nothing returns nothing
    //По какой-то причине при udg_AfterDamageEvent другие модификаторы переставали работать?udg_DamageEventAfterArmor
    call CreateEventTrigger( "udg_AfterDamageEvent", function Trig_MonkP_Actions, function Trig_MonkP_Conditions )
endfunction

