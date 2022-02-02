function Trig_HardModActive_Conditions takes nothing returns boolean
    return GetOwningPlayer(GetEnteringUnit()) == Player(10) or GetOwningPlayer(GetEnteringUnit()) == Player(11)
endfunction

function Trig_HardModActive_Actions takes nothing returns nothing
    local integer cyclA = 1
    call UnitAddAbility( GetEnteringUnit(), 'A073' )
    loop
        exitwhen cyclA > 4
        call UnitAddAbility( GetEnteringUnit(), udg_HardModBonus[cyclA] )
        call SetUnitAbilityLevel( GetEnteringUnit(), udg_HardModBonus[cyclA], udg_HardNum)
        set cyclA = cyclA + 1
    endloop
endfunction

//===========================================================================
function InitTrig_HardModActive takes nothing returns nothing
    set gg_trg_HardModActive = CreateTrigger(  )
    call DisableTrigger( gg_trg_HardModActive )
    call TriggerRegisterEnterRectSimple( gg_trg_HardModActive, GetWorldBounds() )
    call TriggerAddCondition( gg_trg_HardModActive, Condition( function Trig_HardModActive_Conditions ) )
    call TriggerAddAction( gg_trg_HardModActive, function Trig_HardModActive_Actions )
endfunction

