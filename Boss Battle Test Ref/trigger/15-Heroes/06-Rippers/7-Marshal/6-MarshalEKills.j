function Trig_MarshalEKills_Conditions takes nothing returns boolean
    return GetUnitAbilityLevel( Event_Hero_Kill_Unit, 'A0F7') > 0 and GetUnitAbilityLevel( Event_Hero_Kill_Unit, 'A0G0') > 0
endfunction

function Trig_MarshalEKills_Actions takes nothing returns nothing
    call UnitRemoveAbility(Event_Hero_Kill_Unit, 'A0G0')
    call UnitRemoveAbility(Event_Hero_Kill_Unit, 'B06B')
endfunction

//===========================================================================
function InitTrig_MarshalEKills takes nothing returns nothing
    set gg_trg_MarshalEKills = CreateTrigger(  )
     call TriggerRegisterVariableEvent( gg_trg_MarshalEKills, "Event_Hero_Kill_Real", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_MarshalEKills, Condition( function Trig_MarshalEKills_Conditions ) )
    call TriggerAddAction( gg_trg_MarshalEKills, function Trig_MarshalEKills_Actions )
endfunction