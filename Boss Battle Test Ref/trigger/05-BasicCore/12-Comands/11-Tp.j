function Trig_Tp_Conditions takes nothing returns boolean
    return not( udg_fightmod[0] )
endfunction

function Trig_Tp_Actions takes nothing returns nothing
    local integer i = GetPlayerId(GetTriggerPlayer()) + 1
    local unit u = udg_hero[i]

    if u != null then
        call SetUnitPosition( u, GetLocationX(udg_point[i + 21]), GetLocationY(udg_point[i + 21]) )
        call SetUnitFacing( u, 90 )
        call PanCameraToTimedLocForPlayer( GetOwningPlayer(u), udg_point[i + 21], 0.00 )
        call DestroyEffect( AddSpecialEffect("Void Teleport Caster.mdx", GetLocationX(udg_point[i + 21]), GetLocationY(udg_point[i + 21]) ) )
    endif
    
    set u = null
endfunction

//===========================================================================
function InitTrig_Tp takes nothing returns nothing
    local integer cyclA = 0
    set gg_trg_Tp = CreateTrigger()
    loop
        exitwhen cyclA > 3
        call TriggerRegisterPlayerChatEvent( gg_trg_Tp, Player(cyclA), "-tp", true )
        set cyclA = cyclA + 1
    endloop
    call TriggerAddCondition( gg_trg_Tp, Condition( function Trig_Tp_Conditions ) )
    call TriggerAddAction( gg_trg_Tp, function Trig_Tp_Actions )
endfunction