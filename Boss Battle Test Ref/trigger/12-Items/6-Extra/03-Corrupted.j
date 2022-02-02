function CorruptLogic takes item t returns boolean
    local integer cyclA = 1
    local integer cyclAEnd = udg_Database_NumberItems[29]
    local boolean l = false
    
    loop
        exitwhen cyclA > cyclAEnd
        if GetItemTypeId(t) == udg_DB_Item_Destroyed[cyclA] then
            set l = true
            set cyclA = cyclAEnd
        endif
        set cyclA = cyclA + 1
    endloop

    set t = null
    return l
endfunction

function Trig_Corrupted_Conditions takes nothing returns boolean
    if udg_logic[GetPlayerId(GetOwningPlayer(GetManipulatingUnit())) + 1 + 90] then
        return false
    endif
    if not( CorruptLogic(GetManipulatedItem()) ) then
        return false
    endif
    return true
endfunction

function Trig_Corrupted_Actions takes nothing returns nothing
    set udg_logic[GetPlayerId(GetOwningPlayer(GetManipulatingUnit())) + 1 + 90] = true
    call DisplayTimedTextToPlayer( GetOwningPlayer(GetManipulatingUnit()), 0, 0, 20, "|cffcc0000Corrupted|r - the item is disposable and destroyed after use.")
    if GetLocalPlayer() == GetOwningPlayer(GetManipulatingUnit()) then
        call StartSound(gg_snd_QuestLog)
    endif
endfunction

//===========================================================================
function InitTrig_Corrupted takes nothing returns nothing
    set gg_trg_Corrupted = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Corrupted, EVENT_PLAYER_UNIT_PICKUP_ITEM )
    call TriggerAddCondition( gg_trg_Corrupted, Condition( function Trig_Corrupted_Conditions ) )
    call TriggerAddAction( gg_trg_Corrupted, function Trig_Corrupted_Actions )
endfunction

