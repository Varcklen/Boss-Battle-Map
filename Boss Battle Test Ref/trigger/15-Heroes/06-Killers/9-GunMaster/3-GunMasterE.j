function Trig_GunMasterE_Conditions takes nothing returns boolean
     return udg_DamageEventAmount > 0 and combat( udg_DamageEventSource, false, 0 ) and luckylogic( udg_DamageEventSource, 2*GetUnitAbilityLevel( udg_hero[GetPlayerId( GetOwningPlayer(udg_DamageEventSource) ) + 1], 'A19J'), 1, 100 ) and GetUnitAbilityLevel(udg_hero[GetPlayerId( GetOwningPlayer(udg_DamageEventSource) ) + 1], 'A19J') > 0 and ( GetUnitTypeId(udg_DamageEventSource) == 'u000' or udg_DamageEventSource == udg_hero[GetPlayerId( GetOwningPlayer(udg_DamageEventSource) ) + 1] ) and not(IsUnitType( udg_DamageEventTarget, UNIT_TYPE_HERO))
endfunction

function Trig_GunMasterE_Actions takes nothing returns nothing
    local unit target = udg_DamageEventTarget
    
    if GetUnitState( target, UNIT_STATE_LIFE) > 0.405 then
        call BlzSetUnitArmor( target, BlzGetUnitArmor(target) - 1 )
        call DestroyEffect( AddSpecialEffect( "Abilities\\Weapons\\GyroCopter\\GyroCopterMissile.mdl", GetUnitX( target ), GetUnitY( target ) ) )
    endif

    set target = null
endfunction

//===========================================================================
function InitTrig_GunMasterE takes nothing returns nothing
    set gg_trg_GunMasterE = CreateTrigger(  )
    call TriggerRegisterVariableEvent( gg_trg_GunMasterE, "udg_DamageModifierEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_GunMasterE, Condition( function Trig_GunMasterE_Conditions ) )
    call TriggerAddAction( gg_trg_GunMasterE, function Trig_GunMasterE_Actions )
endfunction

