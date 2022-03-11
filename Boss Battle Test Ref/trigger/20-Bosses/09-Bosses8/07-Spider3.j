function Trig_Spider3_Conditions takes nothing returns boolean
    return IsUnitInGroup(GetDyingUnit(), udg_heroinfo) and udg_combatlogic[GetPlayerId(GetOwningPlayer(GetDyingUnit())) + 1] and udg_fightmod[0]
endfunction

function Trig_Spider3_Actions takes nothing returns nothing
    local integer cyclA = 1
    
    if CountLivingPlayerUnitsOfTypeId('n01X', Player(10)) > 0 then
        loop
            exitwhen cyclA > 4
            if CountLivingPlayerUnitsOfTypeId('n01Y', Player(10)) <= 35 then
                set bj_lastCreatedUnit = CreateUnit( Player(10), 'n01Y', GetUnitX( GetDyingUnit() ) + GetRandomReal( -200, 200 ), GetUnitY( GetDyingUnit() ) + GetRandomReal( -200, 200 ), GetRandomReal( 0, 360 ) )
                call DestroyEffect( AddSpecialEffectTarget( "Abilities\\Spells\\Undead\\AnimateDead\\AnimateDeadTarget.mdl", bj_lastCreatedUnit, "origin") )
            endif
            set cyclA = cyclA + 1
        endloop
    endif
endfunction

//===========================================================================
function InitTrig_Spider3 takes nothing returns nothing
    set gg_trg_Spider3 = CreateTrigger(  )
    call DisableTrigger( gg_trg_Spider3 )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Spider3, EVENT_PLAYER_UNIT_DEATH )
    call TriggerAddCondition( gg_trg_Spider3, Condition( function Trig_Spider3_Conditions ) )
    call TriggerAddAction( gg_trg_Spider3, function Trig_Spider3_Actions )
endfunction

