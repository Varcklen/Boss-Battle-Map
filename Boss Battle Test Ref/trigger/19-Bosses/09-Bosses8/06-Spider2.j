function Trig_Spider2_Conditions takes nothing returns boolean
    return GetUnitTypeId(udg_DamageEventTarget) == 'n01X' and GetUnitLifePercent(udg_DamageEventTarget) <= 45
endfunction

function Trig_Spider2_Actions takes nothing returns nothing
    local integer i
    local integer cyclA = 1
    local group g = CreateGroup()
    local unit u
    local integer n = 0
    
    call DisableTrigger( GetTriggeringTrigger() )
    if GetUnitAbilityLevel( udg_DamageEventTarget, 'A01X') == 0 then
        call UnitAddAbility( udg_DamageEventTarget, 'A01X')
    endif
    call spectime("Abilities\\Spells\\NightElf\\FanOfKnives\\FanOfKnivesCaster.mdl", GetUnitX( udg_DamageEventTarget ), GetUnitY( udg_DamageEventTarget ), 1.6 )
    loop
        exitwhen cyclA > 2
        if cyclA == 1 then
            set i = 1
        else
            set i = -1
        endif
        set bj_lastCreatedUnit = CreateUnit( GetOwningPlayer( udg_DamageEventTarget ), 'h00N', GetRectCenterX( gg_rct_ArenaBoss ) + ( i * 1200 ), GetRectCenterY( gg_rct_ArenaBoss ) + 800, 270 )
        call spectime("Abilities\\Spells\\NightElf\\FanOfKnives\\FanOfKnivesCaster.mdl", GetUnitX( bj_lastCreatedUnit ), GetUnitY( bj_lastCreatedUnit ), 1.6 )
        set cyclA = cyclA + 1
    endloop
    
    set bj_livingPlayerUnitsTypeId = 'h00N'
    call GroupEnumUnitsOfPlayer(g, GetOwningPlayer( udg_DamageEventTarget ), filterLivingPlayerUnitsOfTypeId)
    loop
        set u = FirstOfGroup(g)
        exitwhen u == null
        set n = n + 1
        call GroupRemoveUnit(g,u)
        set u = FirstOfGroup(g)
    endloop
    
    call SetUnitAbilityLevel(udg_DamageEventTarget, 'A0DT', n )
    call SetUnitAbilityLevel(udg_DamageEventTarget, 'A0E8', n )

    call GroupClear( g )
    call DestroyGroup( g )
    set u = null
    set g = null
endfunction

//===========================================================================
function InitTrig_Spider2 takes nothing returns nothing
    set gg_trg_Spider2 = CreateTrigger(  )
    call DisableTrigger( gg_trg_Spider2 )
    call TriggerRegisterVariableEvent( gg_trg_Spider2, "udg_AfterDamageEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_Spider2, Condition( function Trig_Spider2_Conditions ) )
    call TriggerAddAction( gg_trg_Spider2, function Trig_Spider2_Actions )
endfunction

