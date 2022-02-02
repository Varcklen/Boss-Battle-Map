function Trig_MoonPriest3_Conditions takes nothing returns boolean
    return GetUnitTypeId( udg_DamageEventTarget ) == 'e005' and GetUnitLifePercent(udg_DamageEventTarget) <= 40
endfunction

function Trig_MoonPriest3_Actions takes nothing returns nothing
    local group g = CreateGroup()
    local unit u
    
    call DisableTrigger( GetTriggeringTrigger() )
    call UnitAddAbility( udg_DamageEventTarget, 'A021')
    call DestroyEffect( AddSpecialEffectTarget("Abilities\\Spells\\Human\\ControlMagic\\ControlMagicTarget.mdl", udg_DamageEventTarget, "overhead") )
    
    set bj_livingPlayerUnitsTypeId = 'e00I'
    call GroupEnumUnitsOfPlayer(g, GetOwningPlayer( udg_DamageEventTarget ), filterLivingPlayerUnitsOfTypeId)
    loop
        set u = FirstOfGroup(g)
        exitwhen u == null
        if GetUnitState( u, UNIT_STATE_LIFE) > 0.405 then
            call UnitAddAbility( u, 'A021')
            call DestroyEffect( AddSpecialEffectTarget("Abilities\\Spells\\Human\\ControlMagic\\ControlMagicTarget.mdl", u, "overhead") )
        endif
        call GroupRemoveUnit(g,u)
    endloop
    
    call GroupClear( g )
    call DestroyGroup( g )
    set g = null
    set u = null
endfunction

//===========================================================================
function InitTrig_MoonPriest3 takes nothing returns nothing
    set gg_trg_MoonPriest3 = CreateTrigger(  )
    call DisableTrigger( gg_trg_MoonPriest3 )
    call TriggerRegisterVariableEvent( gg_trg_MoonPriest3, "udg_AfterDamageEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_MoonPriest3, Condition( function Trig_MoonPriest3_Conditions ) )
    call TriggerAddAction( gg_trg_MoonPriest3, function Trig_MoonPriest3_Actions )
endfunction

