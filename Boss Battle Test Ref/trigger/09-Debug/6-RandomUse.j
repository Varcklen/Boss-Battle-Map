function Trig_RandomUse_Actions takes nothing returns nothing
    set udg_RandomLogic = true
    set udg_Caster = udg_hero[1]
    set udg_Level = 5
endfunction

//===========================================================================
function InitTrig_RandomUse takes nothing returns nothing
    set gg_trg_RandomUse = CreateTrigger(  )
    call TriggerRegisterPlayerChatEvent( gg_trg_RandomUse, Player(0), "1", true )
    call TriggerAddAction( gg_trg_RandomUse, function Trig_RandomUse_Actions )
endfunction

