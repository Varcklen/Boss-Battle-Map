function ColorOwner takes unit u returns boolean
    local boolean l = false
    local integer i = 0
    
    loop
        exitwhen i > 3
        if GetOwningPlayer(u) == Player(i) then
            set i = 3
            set l = true
        endif
        set i = i + 1
    endloop
    
    set u = null
    return l
endfunction

function Trig_ReviveColor_Actions takes nothing returns nothing
    if ColorOwner(GetRevivingUnit()) then
        call SetUnitColor(GetRevivingUnit(), ConvertPlayerColor(udg_Player_Color_Int[GetPlayerId(GetOwningPlayer(GetRevivingUnit()))+1]-1))
    endif
endfunction

//===========================================================================
function InitTrig_ReviveColor takes nothing returns nothing
    set gg_trg_ReviveColor = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_ReviveColor, EVENT_PLAYER_HERO_REVIVE_FINISH )
    call TriggerAddAction( gg_trg_ReviveColor, function Trig_ReviveColor_Actions )
endfunction

