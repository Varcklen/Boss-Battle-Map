function Trig_NerubP_Conditions takes nothing returns boolean
    return GetUnitAbilityLevel( udg_DamageEventTarget, 'A0D6') > 0 and IsUnitEnemy(udg_DamageEventSource, GetOwningPlayer(udg_DamageEventTarget)) and luckylogic( udg_DamageEventTarget, 15, 1, 100 ) and not( udg_fightmod[3] )
endfunction
    
function Trig_NerubP_Actions takes nothing returns nothing
	local integer i = GetUnitAbilityLevel( udg_DamageEventTarget, 'A0D6')
    call BlzSetUnitMaxHP( udg_DamageEventTarget, ( BlzGetUnitMaxHP(udg_DamageEventTarget) + i ) )
    set udg_Data[GetPlayerId(GetOwningPlayer(udg_DamageEventTarget)) + 1 + 100] = udg_Data[GetPlayerId(GetOwningPlayer(udg_DamageEventTarget)) + 1 + 100] + i
endfunction

//===========================================================================
function InitTrig_NerubP takes nothing returns nothing
    set gg_trg_NerubP = CreateTrigger(  )
    call TriggerRegisterVariableEvent( gg_trg_NerubP, "udg_DamageModifierEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_NerubP, Condition( function Trig_NerubP_Conditions ) )
    call TriggerAddAction( gg_trg_NerubP, function Trig_NerubP_Actions )
endfunction