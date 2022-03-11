globals
    real Event_OnDamageChange_StaticDamage
    real Event_OnDamageChange_Real
    
    boolean IsDisableSpellPower = false
    boolean IsAttack = false
endglobals

function Trig_DamageSystem_Actions takes nothing returns nothing
    set udg_DamageEventAmount = GetEventDamage()
    set udg_DamageEventTarget = BlzGetEventDamageTarget()
    set udg_DamageEventSource = GetEventDamageSource()
    
	if BlzGetEventAttackType() == ATTACK_TYPE_MAGIC or BlzGetEventAttackType() == ATTACK_TYPE_NORMAL then
		set udg_IsDamageSpell = true
	else
		set udg_IsDamageSpell = false
	endif
    set IsAttack = true
	set udg_DamageHealLoop = false
	set udg_DamageEventType = 0
    
    //Событие, чтобы изменить udg_DamageEventAmount
    set Event_OnDamageChange_StaticDamage = udg_DamageEventAmount
    set Event_OnDamageChange_Real = 0.00
    set Event_OnDamageChange_Real = 1.00
    set Event_OnDamageChange_Real = 0.00
    
    // Obsolete. Do not use
    set udg_DamageModifierEvent = 0.00
	set udg_DamageModifierEvent = 1.00
	set udg_DamageModifierEvent = 0.00

    //Событие, чтобы добавить модификаторы, не меняющие udg_DamageEventAmount (например вампиризм или запуск волны)
	if udg_DamageEventAmount > 0 then
        set udg_AfterDamageEvent = 0.00
        set udg_AfterDamageEvent = 1.00
        set udg_AfterDamageEvent = 0.00
    endif

	call BlzSetEventDamage( udg_DamageEventAmount )
    
    set IsDisableSpellPower = false

	set udg_DamageEventAmount = 0
	set udg_DamageEventTarget = null
	set udg_DamageEventSource = null
endfunction

//===========================================================================
function InitTrig_DamageSystem takes nothing returns nothing
    set gg_trg_DamageSystem = CreateTrigger(  )
    //call TriggerRegisterAnyUnitEventBJ( gg_trg_DamageSystem, EVENT_PLAYER_UNIT_DAMAGED )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_DamageSystem, EVENT_PLAYER_UNIT_DAMAGING )
    call TriggerAddAction( gg_trg_DamageSystem, function Trig_DamageSystem_Actions )
endfunction