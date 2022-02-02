function Trig_Chief2_Conditions takes nothing returns boolean
    return IsUnitInGroup(GetDyingUnit(), udg_heroinfo) and udg_combatlogic[GetPlayerId(GetOwningPlayer(GetDyingUnit())) + 1] and udg_fightmod[0] and CountLivingPlayerUnitsOfTypeId('h01X', Player(10)) > 0
endfunction

function Trig_Chief2_Actions takes nothing returns nothing
    local group g = CreateGroup()
    local unit n

        set bj_livingPlayerUnitsTypeId = 'h01X'
        call GroupEnumUnitsOfPlayer(g, Player(10), filterLivingPlayerUnitsOfTypeId)
        loop
            set n = FirstOfGroup(g)
            exitwhen n == null
            call SetUnitState( n, UNIT_STATE_LIFE, GetUnitState( n, UNIT_STATE_LIFE) + ( GetUnitState( n, UNIT_STATE_MAX_LIFE)*0.1*udg_SpellDamage[0] ) )
            call DestroyEffect( AddSpecialEffect("Abilities\\Spells\\Undead\\AnimateDead\\AnimateDeadTarget.mdl", GetUnitX( n ), GetUnitY( n ) ) )
            call GroupRemoveUnit(g,n)
            set n = FirstOfGroup(g)
        endloop

    call GroupClear( g )
    call DestroyGroup( g )
    set n = null
    set g = null
endfunction

//===========================================================================
function InitTrig_Chief2 takes nothing returns nothing
    set gg_trg_Chief2 = CreateTrigger(  )
    call DisableTrigger( gg_trg_Chief2 )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Chief2, EVENT_PLAYER_UNIT_DEATH )
    call TriggerAddCondition( gg_trg_Chief2, Condition( function Trig_Chief2_Conditions ) )
    call TriggerAddAction( gg_trg_Chief2, function Trig_Chief2_Actions )
endfunction

