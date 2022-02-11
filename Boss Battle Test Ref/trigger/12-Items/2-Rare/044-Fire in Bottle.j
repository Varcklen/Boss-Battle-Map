function Trig_Fire_in_Bottle_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A126'
endfunction

function Trig_Fire_in_Bottle_Actions takes nothing returns nothing
    local integer x
    local unit caster
    
    if CastLogic() then
        set caster = udg_Caster
    elseif RandomLogic() then
        set caster = udg_Caster
        call textst( udg_string[0] + GetObjectName('A126'), caster, 64, 90, 10, 1.5 )
    else
        set caster = GetSpellAbilityUnit()
    endif
    
    set x = eyest( caster ) 
    call UnitAddAbility( caster, 'A128' )
    
    set caster = null
endfunction

//===========================================================================
function InitTrig_Fire_in_Bottle takes nothing returns nothing
    set gg_trg_Fire_in_Bottle = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Fire_in_Bottle, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_Fire_in_Bottle, Condition( function Trig_Fire_in_Bottle_Conditions ) )
    call TriggerAddAction( gg_trg_Fire_in_Bottle, function Trig_Fire_in_Bottle_Actions )
endfunction

