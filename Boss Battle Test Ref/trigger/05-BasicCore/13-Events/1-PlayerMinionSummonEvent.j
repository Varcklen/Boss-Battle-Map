function Trig_PlayerMinionSummonEvent_Conditions takes nothing returns boolean
    return udg_hero[GetPlayerId(GetOwningPlayer(GetEnteringUnit())) + 1] != null
endfunction

function SummonEventCondition takes integer own returns boolean

    if IsUnitType(GetEnteringUnit(), UNIT_TYPE_ANCIENT ) then
        return true
    elseif IsUnitType(GetEnteringUnit(), UNIT_TYPE_HERO ) then
        return true
    elseif not(IsUnitInGroup(udg_hero[own], udg_heroinfo)) then
        return true
    elseif GetUnitTypeId(GetEnteringUnit()) == 'u00X' then 
        return true
    elseif GetUnitTypeId(GetEnteringUnit()) == 'u000' then
        return true
    endif
        
    return false
endfunction

function Trig_PlayerMinionSummonEvent_Actions takes nothing returns nothing
    local integer own = GetPlayerId(GetOwningPlayer(GetEnteringUnit())) + 1
    
    if SummonEventCondition(own) then
        return
    endif
    set udg_Event_PlayerMinionSummon_Hero = udg_hero[own]
    set udg_Event_PlayerMinionSummon_Unit = GetEnteringUnit()
    
    set udg_Event_PlayerMinionSummon_Real = 0
    set udg_Event_PlayerMinionSummon_Real = 1
    set udg_Event_PlayerMinionSummon_Real = 0
endfunction

//===========================================================================
function InitTrig_PlayerMinionSummonEvent takes nothing returns nothing
    set gg_trg_PlayerMinionSummonEvent = CreateTrigger(  )
    call TriggerRegisterEnterRectSimple( gg_trg_PlayerMinionSummonEvent, bj_mapInitialPlayableArea )
    //call TriggerRegisterEnterRectSimple( gg_trg_PlayerMinionSummonEvent, GetWorldBounds() )
    call TriggerAddCondition( gg_trg_PlayerMinionSummonEvent, Condition( function Trig_PlayerMinionSummonEvent_Conditions ) )
    call TriggerAddAction( gg_trg_PlayerMinionSummonEvent, function Trig_PlayerMinionSummonEvent_Actions )
endfunction

