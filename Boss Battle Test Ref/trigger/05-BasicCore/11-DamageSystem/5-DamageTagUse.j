function Trig_DamageTagUse_Actions takes nothing returns nothing
     set udg_DamageEventAmount = GetEventDamage()
     set udg_DamageEventTarget = BlzGetEventDamageTarget()
     set udg_DamageEventSource = GetEventDamageSource()

    set udg_DamageEventAfterArmor = 0.00
	set udg_DamageEventAfterArmor = 1.00
	set udg_DamageEventAfterArmor = 0.00

    call BlzSetEventDamage( udg_DamageEventAmount )

	set udg_DamageEvent = 0.00
	set udg_DamageEvent = 1.00
	set udg_DamageEvent = 0.00
    
    set IsAttack = false

	set udg_DamageEventAmount = 0
	set udg_DamageEventTarget = null
	set udg_DamageEventSource = null
endfunction

//===========================================================================
function InitTrig_DamageTagUse takes nothing returns nothing
    set gg_trg_DamageTagUse = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_DamageTagUse, EVENT_PLAYER_UNIT_DAMAGED )
    //call TriggerRegisterAnyUnitEventBJ( gg_trg_DamageTagUse, EVENT_PLAYER_UNIT_DAMAGING )
    call TriggerAddAction( gg_trg_DamageTagUse, function Trig_DamageTagUse_Actions )
endfunction

