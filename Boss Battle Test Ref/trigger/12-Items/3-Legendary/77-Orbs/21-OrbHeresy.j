function Trig_OrbHeresy_Conditions takes nothing returns boolean
    return GetUnitAbilityLevel( udg_DamageEventSource, 'A191') > 0 and not( udg_IsDamageSpell )
endfunction

function Trig_OrbHeresy_Actions takes nothing returns nothing
    local unit target = null
    local integer cyclA = 1
    local real heal = 15
    
    loop
        exitwhen cyclA > 4
        if inv(udg_hero[cyclA], 'I09N') == 0 and IsUnitAlly(udg_hero[cyclA], GetOwningPlayer(udg_DamageEventSource)) and GetUnitState(udg_hero[cyclA], UNIT_STATE_LIFE) > 0.405 and ( RMinBJ(GetUnitLifePercent(udg_hero[cyclA]), GetUnitLifePercent(udg_hero[cyclA - 3])) == GetUnitLifePercent(udg_hero[cyclA]) or GetUnitState(udg_hero[cyclA - 3], UNIT_STATE_LIFE) <= 0.405 ) and ( RMinBJ(GetUnitLifePercent(udg_hero[cyclA]), GetUnitLifePercent(udg_hero[cyclA - 1])) == GetUnitLifePercent(udg_hero[cyclA]) or GetUnitState(udg_hero[cyclA - 1], UNIT_STATE_LIFE) <= 0.405 ) and ( RMinBJ(GetUnitLifePercent(udg_hero[cyclA]), GetUnitLifePercent(udg_hero[cyclA - 2])) == GetUnitLifePercent(udg_hero[cyclA]) or GetUnitState(udg_hero[cyclA - 2], UNIT_STATE_LIFE) <= 0.405 ) then
            set target = udg_hero[cyclA]
        endif
        set cyclA = cyclA + 1
    endloop
    if target != null then
        call healst( udg_DamageEventSource, target, heal )
        set target = null
    endif
endfunction

//===========================================================================
function InitTrig_OrbHeresy takes nothing returns nothing
    set gg_trg_OrbHeresy = CreateTrigger(  )
    call TriggerRegisterVariableEvent( gg_trg_OrbHeresy, "udg_DamageModifierEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_OrbHeresy, Condition( function Trig_OrbHeresy_Conditions ) )
    call TriggerAddAction( gg_trg_OrbHeresy, function Trig_OrbHeresy_Actions )
endfunction

