function Trig_Equality_Conditions takes nothing returns boolean
    return GetUnitLifePercent(udg_DamageEventTarget) <= 50 and IsUnitInGroup( udg_DamageEventTarget, udg_Bosses )
endfunction

function Trig_Equality_Actions takes nothing returns nothing
    local integer cyclA = 1

    call DisableTrigger( GetTriggeringTrigger() )
    loop
        exitwhen cyclA > 4
        if GetPlayerSlotState( Player( cyclA - 1 ) ) == PLAYER_SLOT_STATE_PLAYING and GetUnitState( udg_hero[cyclA], UNIT_STATE_LIFE) > 0.405 then
            call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\Undead\\DeathCoil\\DeathCoilSpecialArt.mdl", GetUnitX(udg_hero[cyclA]), GetUnitY(udg_hero[cyclA])) )
            call SetUnitState( udg_hero[cyclA], UNIT_STATE_LIFE, GetUnitState( udg_hero[cyclA], UNIT_STATE_LIFE) - (GetUnitState( udg_hero[cyclA], UNIT_STATE_MAX_LIFE) * 0.2) )
        endif
        set cyclA = cyclA + 1
    endloop
endfunction

//===========================================================================
function InitTrig_Equality takes nothing returns nothing
    set gg_trg_Equality = CreateTrigger(  )
    call DisableTrigger( gg_trg_Equality )
    call TriggerRegisterVariableEvent( gg_trg_Equality, "udg_AfterDamageEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_Equality, Condition( function Trig_Equality_Conditions ) )
    call TriggerAddAction( gg_trg_Equality, function Trig_Equality_Actions )
endfunction

