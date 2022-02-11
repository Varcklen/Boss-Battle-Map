function Trig_SPIG_Conditions takes nothing returns boolean
    return inv( GetDyingUnit(), 'I097' ) > 0 and combat( GetDyingUnit(), false, 0 ) and not( udg_fightmod[3] )
endfunction

function Trig_SPIG_Actions takes nothing returns nothing
    local integer i = GetUnitUserData(GetDyingUnit())
    local integer id = GetHandleId( GetDyingUnit() )
    local integer s = LoadInteger( udg_hash, id, StringHash( udg_QuestItemCode[5] ) ) + 1
    local item it = GetItemOfTypeFromUnitBJ(GetDyingUnit(), 'I097')
    
    call SaveInteger( udg_hash, id, StringHash( udg_QuestItemCode[5] ), s )

    if s == udg_QuestNum[5] then
        call BlzSetItemIconPath( it, words( GetDyingUnit(), BlzGetItemDescription(it), "|cFF959697(", ")|r", "Complete!" ) )
    elseif s < udg_QuestNum[5] then
        call QuestDiscription( GetDyingUnit(), 'I097', s, udg_QuestNum[5] )
    endif
    
    set it = null
endfunction

//===========================================================================
function InitTrig_SPIG takes nothing returns nothing
    set gg_trg_SPIG = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_SPIG, EVENT_PLAYER_UNIT_DEATH )
    call TriggerAddCondition( gg_trg_SPIG, Condition( function Trig_SPIG_Conditions ) )
    call TriggerAddAction( gg_trg_SPIG, function Trig_SPIG_Actions )
endfunction

