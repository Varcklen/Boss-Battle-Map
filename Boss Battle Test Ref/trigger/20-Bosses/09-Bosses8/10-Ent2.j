function Trig_Ent2_Conditions takes nothing returns boolean
    return GetUnitTypeId(udg_DamageEventTarget) == 'e006' and GetUnitLifePercent(udg_DamageEventTarget) <= 50
endfunction

function Trig_Ent2_Actions takes nothing returns nothing
    local group g = CreateGroup()
    local unit u
    local real r
    
    call DisableTrigger( GetTriggeringTrigger() )
    set bj_livingPlayerUnitsTypeId = 'o00O'
    call GroupEnumUnitsOfPlayer(g, GetOwningPlayer( udg_DamageEventTarget ), filterLivingPlayerUnitsOfTypeId)
    loop
        set u = FirstOfGroup(g)
        exitwhen u == null
        if GetUnitState( u, UNIT_STATE_LIFE) > 0.405 then
            set r = GetUnitLifePercent( u )
            call KillUnit( u )
            set bj_lastCreatedUnit = CreateUnit( GetOwningPlayer( u ), 'e007', GetUnitX( u ), GetUnitY( u ), GetRandomReal( 0, 360 ) )
            call SetUnitState(bj_lastCreatedUnit, UNIT_STATE_LIFE, GetUnitState(bj_lastCreatedUnit, UNIT_STATE_MAX_LIFE) * r * 0.01)
            call DestroyEffect( AddSpecialEffectTarget("Objects\\Spawnmodels\\NightElf\\EntBirthTarget\\EntBirthTarget.mdl", bj_lastCreatedUnit, "origin" ) )
        endif
        call GroupRemoveUnit(g,u)
        set u = FirstOfGroup(g)
    endloop
    
    call GroupClear( g )
    call DestroyGroup( g )
    set u = null
    set g = null
endfunction

//===========================================================================
function InitTrig_Ent2 takes nothing returns nothing
    set gg_trg_Ent2 = CreateTrigger(  )
    call DisableTrigger( gg_trg_Ent2 )
    call TriggerRegisterVariableEvent( gg_trg_Ent2, "udg_AfterDamageEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_Ent2, Condition( function Trig_Ent2_Conditions ) )
    call TriggerAddAction( gg_trg_Ent2, function Trig_Ent2_Actions )
endfunction

