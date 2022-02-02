function Trig_AnyHero_Actions takes nothing returns nothing
    //Если активно, можно выбрать героя даже если он  уже выбран
    set udg_logic[35] = true
endfunction

//===========================================================================
function InitTrig_AnyHero takes nothing returns nothing
    set gg_trg_AnyHero = CreateTrigger(  )
    call TriggerAddAction( gg_trg_AnyHero, function Trig_AnyHero_Actions )
endfunction

