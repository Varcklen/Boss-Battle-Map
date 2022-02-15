function Trig_PowerupT_Actions takes nothing returns nothing
        call DisplayTimedTextToForce( GetPlayersAll(), 5.00, "Enemies have become stronger +5" + udg_perc + "!" )
    	set udg_BossHP = udg_BossHP + 0.05
    	set udg_BossAT = udg_BossAT + 0.05
        call SpellPower_AddBossSpellPower(0.05)
endfunction

//===========================================================================
function InitTrig_PowerupT takes nothing returns nothing
    set gg_trg_PowerupT = CreateTrigger(  )
    call TriggerRegisterTimerExpireEvent( gg_trg_PowerupT, udg_timer[4] )
    call TriggerAddAction( gg_trg_PowerupT, function Trig_PowerupT_Actions )
endfunction

