function Trig_BarbarianP_Conditions takes nothing returns boolean
     return not( udg_IsDamageSpell ) and GetUnitAbilityLevel( udg_DamageEventSource, 'A08F') > 0 and IsUnitEnemy(udg_DamageEventSource, GetOwningPlayer(udg_DamageEventTarget)) and ( GetUnitManaPercent( udg_DamageEventSource ) < 100 or GetUnitLifePercent( udg_DamageEventSource ) < 100 )
endfunction

function Trig_BarbarianP_Actions takes nothing returns nothing
    local real r = GetUnitAbilityLevel( udg_DamageEventSource, 'A08F') * 0.01
    local real heal 
    
    if GetUnitManaPercent( udg_DamageEventSource ) == 100 then
        set heal = GetUnitState( udg_DamageEventSource, UNIT_STATE_MAX_LIFE) * r
        if heal < 1 then
            set heal = 1
        endif
        call healst( udg_DamageEventSource, null, heal )
        call spectimeunit( udg_DamageEventSource, "Abilities\\Spells\\Human\\Heal\\HealTarget.mdl", "origin", 2 )
    else
        set heal = GetUnitState( udg_DamageEventSource, UNIT_STATE_MAX_MANA) * r
        if heal < 1 then
            set heal = 1
        endif
        call manast( udg_DamageEventSource, null, heal )
        call spectimeunit( udg_DamageEventSource, "Abilities\\Spells\\Undead\\ReplenishMana\\ReplenishManaCaster.mdl", "origin", 2 )
    endif
    
    if heal < 1 then
        set heal = 1
    endif
endfunction

//===========================================================================
function InitTrig_BarbarianP takes nothing returns nothing
    set gg_trg_BarbarianP = CreateTrigger(  )
    call TriggerRegisterVariableEvent( gg_trg_BarbarianP, "udg_DamageModifierEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_BarbarianP, Condition( function Trig_BarbarianP_Conditions ) )
    call TriggerAddAction( gg_trg_BarbarianP, function Trig_BarbarianP_Actions )
endfunction

