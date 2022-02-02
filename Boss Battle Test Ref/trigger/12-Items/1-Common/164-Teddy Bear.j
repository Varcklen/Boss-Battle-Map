function Trig_Teddy_Bear_Conditions takes nothing returns boolean
    return GetUnitState( udg_Event_PlayerMinionSummon_Hero, UNIT_STATE_LIFE) > 0.405 and inv( udg_Event_PlayerMinionSummon_Hero, 'I08V' ) > 0
endfunction

function Trig_Teddy_Bear_Actions takes nothing returns nothing
    local unit myUnit = udg_Event_PlayerMinionSummon_Unit
	local real hp = BlzGetUnitMaxHP(myUnit)
    
    call BlzSetUnitBaseDamage( myUnit, BlzGetUnitBaseDamage(myUnit, 0) + 5, 0 )
    call DestroyEffect( AddSpecialEffectTarget("Abilities\\Spells\\Human\\Slow\\SlowCaster.mdl", myUnit, "overhead" ) )
    if GetUnitTypeId(myUnit) == ID_SHEEP then
    	call BlzSetUnitMaxHP( myUnit, R2I(BlzGetUnitMaxHP(myUnit) + hp ) )
        call SetUnitLifeBJ( myUnit, GetUnitState(myUnit, UNIT_STATE_LIFE) + R2I(hp) )
    	call BlzSetUnitBaseDamage( myUnit, R2I(BlzGetUnitBaseDamage(myUnit, 0) * 2), 0 )
    endif
    
    set myUnit = null
endfunction

//===========================================================================
function InitTrig_Teddy_Bear takes nothing returns nothing
    set gg_trg_Teddy_Bear = CreateTrigger(  )
    call TriggerRegisterVariableEvent( gg_trg_Teddy_Bear, "udg_Event_PlayerMinionSummon_Real", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_Teddy_Bear, Condition( function Trig_Teddy_Bear_Conditions ) )
    call TriggerAddAction( gg_trg_Teddy_Bear, function Trig_Teddy_Bear_Actions )
endfunction

