function Trig_PiratePM_Conditions takes nothing returns boolean
    return IsUnitInGroup(GetSpellTargetUnit(), udg_BlackMark) and GetSpellAbilityId() != 'A01F' and GetUnitName(GetSpellAbilityUnit()) != "dummy" and combat( GetSpellAbilityUnit(), false, 0 ) and not( udg_fightmod[3] )
endfunction

function Trig_PiratePM_Actions takes nothing returns nothing
    local integer k = GetPlayerId(GetOwningPlayer(GetSpellAbilityUnit())) + 1
    local integer i = GetHandleId( LoadTimerHandle( udg_hash, GetHandleId( GetSpellTargetUnit() ), StringHash( "pmt" ) ) )
    local integer g = LoadInteger( udg_hash, i, StringHash( "pmt" ) )
    
    call moneyst( GetSpellAbilityUnit(), g )
    set udg_Data[k + 136] = udg_Data[k + 136] + g
endfunction

//===========================================================================
function InitTrig_PiratePM takes nothing returns nothing
    set gg_trg_PiratePM = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_PiratePM, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_PiratePM, Condition( function Trig_PiratePM_Conditions ) )
    call TriggerAddAction( gg_trg_PiratePM, function Trig_PiratePM_Actions )
endfunction

