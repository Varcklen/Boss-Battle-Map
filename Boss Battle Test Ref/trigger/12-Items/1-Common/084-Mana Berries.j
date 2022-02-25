function Trig_Mana_Berries_Conditions takes nothing returns boolean
    return not( udg_IsDamageSpell ) and inv(udg_DamageEventSource, 'I01W') > 0 and GetUnitTypeId(udg_DamageEventSource) != 'u000'
endfunction

function Trig_Mana_Berries_Actions takes nothing returns nothing
    local integer id = GetHandleId( udg_DamageEventSource )
    local integer i
    
    call SaveInteger( udg_hash, id, StringHash( "mnbb" ), LoadInteger( udg_hash, id, StringHash( "mnbb" ) ) + 1 )
    set i = LoadInteger( udg_hash, id, StringHash( "mnbb" ) )
    if i >= 3 then
        call SaveInteger( udg_hash, id, StringHash( "mnbb" ), 0 )
        call manast( udg_DamageEventSource, null, 12 )
        call DestroyEffect(AddSpecialEffectTarget( "Abilities\\Spells\\Undead\\ReplenishMana\\SpiritTouchTarget.mdl", udg_DamageEventSource, "origin" ))
    endif
endfunction

//===========================================================================
function InitTrig_Mana_Berries takes nothing returns nothing
    set gg_trg_Mana_Berries = CreateTrigger(  )
    call TriggerRegisterVariableEvent( gg_trg_Mana_Berries, "udg_AfterDamageEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_Mana_Berries, Condition( function Trig_Mana_Berries_Conditions ) )
    call TriggerAddAction( gg_trg_Mana_Berries, function Trig_Mana_Berries_Actions )
endfunction

