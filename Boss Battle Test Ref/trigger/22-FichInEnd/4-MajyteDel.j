function Trig_MajyteDel_Conditions takes nothing returns boolean
    return GetUnitAbilityLevel(GetSpellAbilityUnit(), 'A0YC') > 0 and GetSpellAbilityId() != 'A0YA'
endfunction

function Trig_MajyteDel_Actions takes nothing returns nothing
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( GetSpellAbilityUnit() ), StringHash( "majt" ) ), 0, false, function MajyteCast )
endfunction

//===========================================================================
function InitTrig_MajyteDel takes nothing returns nothing
    set gg_trg_MajyteDel = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_MajyteDel, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_MajyteDel, Condition( function Trig_MajyteDel_Conditions ) )
    call TriggerAddAction( gg_trg_MajyteDel, function Trig_MajyteDel_Actions )
endfunction

