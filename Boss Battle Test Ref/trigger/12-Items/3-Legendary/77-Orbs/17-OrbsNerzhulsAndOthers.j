function Trig_OrbsNerzhulsAndOthers_Conditions takes nothing returns boolean
    return GetUnitState( udg_Event_PlayerMinionSummon_Hero, UNIT_STATE_LIFE) > 0.405
endfunction

function Trig_OrbsNerzhulsAndOthers_Actions takes nothing returns nothing
    if inv( udg_Event_PlayerMinionSummon_Hero, 'I0FV') > 0 then
        if not(udg_DoubleSummon) then
            set udg_DoubleSummon = true
            set bj_lastCreatedUnit = CreateUnit( GetOwningPlayer( udg_Event_PlayerMinionSummon_Unit ), GetUnitTypeId(udg_Event_PlayerMinionSummon_Unit), GetUnitX(udg_Event_PlayerMinionSummon_Unit), GetUnitY(udg_Event_PlayerMinionSummon_Unit), GetUnitFacing( udg_Event_PlayerMinionSummon_Unit ) )
            call UnitApplyTimedLife( bj_lastCreatedUnit, 'BTLF', 30 )
        else
            set udg_DoubleSummon = false
        endif
    endif
    if inv( udg_Event_PlayerMinionSummon_Hero, 'I0FW') > 0 then
        call UnitAddAbility(udg_Event_PlayerMinionSummon_Unit, 'A18Y')
        call UnitAddAbility(udg_Event_PlayerMinionSummon_Unit, 'A18X')
    endif
    if inv( udg_Event_PlayerMinionSummon_Hero, 'I0FY') > 0 then
        call UnitAddAbility(udg_Event_PlayerMinionSummon_Unit, 'A18Z')
    endif
    if inv( udg_Event_PlayerMinionSummon_Hero, 'I0G0') > 0 then
        call UnitAddAbility(udg_Event_PlayerMinionSummon_Unit, 'A191')
    endif
endfunction

//===========================================================================
function InitTrig_OrbsNerzhulsAndOthers takes nothing returns nothing
    set gg_trg_OrbsNerzhulsAndOthers = CreateTrigger(  )
    //call TriggerRegisterEnterRectSimple( gg_trg_OrbsNerzhulsAndOthers, GetWorldBounds() )
    call TriggerRegisterVariableEvent( gg_trg_OrbsNerzhulsAndOthers, "udg_Event_PlayerMinionSummon_Real", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_OrbsNerzhulsAndOthers, Condition( function Trig_OrbsNerzhulsAndOthers_Conditions ) )
    call TriggerAddAction( gg_trg_OrbsNerzhulsAndOthers, function Trig_OrbsNerzhulsAndOthers_Actions )
endfunction