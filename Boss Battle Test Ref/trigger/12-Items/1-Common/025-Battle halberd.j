function Trig_Battle_halberd_Conditions takes nothing returns boolean
    return ( ( inv( udg_DamageEventSource, 'I025') > 0 ) or ( ( inv( udg_DamageEventSource, 'I030') > 0 ) and udg_Set_Weapon_Logic[GetPlayerId(GetOwningPlayer(udg_DamageEventSource)) + 1 + 16] ) ) and not( udg_IsDamageSpell ) and GetUnitTypeId(udg_DamageEventSource) != 'u000'
endfunction

function Trig_Battle_halberd_Actions takes nothing returns nothing
    local integer id 
    local unit target = udg_DamageEventTarget
    local unit caster = udg_DamageEventSource
    local real t = 7
    
    set t = timebonus( caster, t )
    set id = GetHandleId( target )

    call bufst( caster, target, 'A0ZR', 'B089', "btlh", t )

    if BuffLogic() then
        call debuffst( caster, target, null, 1, t )
    endif
    
    set caster = null
    set target = null
endfunction

//===========================================================================
function InitTrig_Battle_halberd takes nothing returns nothing
    set gg_trg_Battle_halberd = CreateTrigger(  )
    call TriggerRegisterVariableEvent( gg_trg_Battle_halberd, "udg_AfterDamageEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_Battle_halberd, Condition( function Trig_Battle_halberd_Conditions ) )
    call TriggerAddAction( gg_trg_Battle_halberd, function Trig_Battle_halberd_Actions )
endfunction