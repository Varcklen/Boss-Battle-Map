function Trig_Item_Conditions takes nothing returns boolean
    return SubString(GetEventPlayerChatString(), 0, 5) == "-item" 
endfunction

function Trig_Item_Actions takes nothing returns nothing
    local integer g = GetPlayerId(GetTriggerPlayer()) + 1
    local string i = SubString(GetEventPlayerChatString(), 6, 7)
    local string p = SubString(GetEventPlayerChatString(), 8, 9)
    local integer a = S2I(i)-1
    local integer b = S2I(p)-1
    local item it
    local item ir
    
    set udg_logic[36] = true
    if S2I(i) > 0 and S2I(i) <= 6 and S2I(p) > 0 and S2I(p) <= 6 and GetUnitState(udg_hero[g], UNIT_STATE_LIFE) > 0.405 then
        set it = UnitItemInSlot(udg_hero[g], a )
        set ir = UnitItemInSlot(udg_hero[g], b )
        call UnitRemoveItem(udg_hero[g], it)
        call UnitRemoveItem(udg_hero[g], ir)
        call UnitAddItem(udg_hero[g], it)
        if UnitItemInSlot( udg_hero[g], b ) != it then
            call UnitDropItemSlot(udg_hero[g], it, b)
        endif
        call UnitAddItem(udg_hero[g], ir)
        if UnitItemInSlot( udg_hero[g], a ) != ir then
            call UnitDropItemSlot(udg_hero[g], ir, a)
        endif
    endif
    set udg_logic[36] = false
    set it = null
    set ir = null
endfunction

//===========================================================================
function InitTrig_Item takes nothing returns nothing
    local integer cyclA = 0
    set gg_trg_Item = CreateTrigger()
    loop
        exitwhen cyclA > 3
        call TriggerRegisterPlayerChatEvent( gg_trg_Item, Player(cyclA), "-item ", false )
        set cyclA = cyclA + 1
    endloop
    call TriggerAddCondition( gg_trg_Item, Condition( function Trig_Item_Conditions ) )
    call TriggerAddAction( gg_trg_Item, function Trig_Item_Actions )
endfunction

