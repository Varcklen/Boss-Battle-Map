function Trig_Nehalenas_Eye_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A05E'
endfunction

function Trig_Nehalenas_Eye_Actions takes nothing returns nothing
    local integer k = GetPlayerId( GetOwningPlayer( GetSpellTargetUnit() ) )*3
    local item it = GetItemOfTypeFromUnitBJ( GetSpellAbilityUnit(), 'I0FD')
    local integer id = GetHandleId(it) 

    call SaveInteger( udg_hash, id, StringHash( "frg1" ), 0 )
    call SaveInteger( udg_hash, id, StringHash( "frg2" ), 0 )
    call SaveInteger( udg_hash, id, StringHash( "frg3" ), 0 )
    
    call forge( GetSpellAbilityUnit(), it, udg_LastReward[k+1], udg_LastReward[k+2], udg_LastReward[k+3], true )
    
    set it = null
endfunction

//===========================================================================
function InitTrig_Nehalenas_Eye takes nothing returns nothing
    set gg_trg_Nehalenas_Eye = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Nehalenas_Eye, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_Nehalenas_Eye, Condition( function Trig_Nehalenas_Eye_Conditions ) )
    call TriggerAddAction( gg_trg_Nehalenas_Eye, function Trig_Nehalenas_Eye_Actions )
endfunction

