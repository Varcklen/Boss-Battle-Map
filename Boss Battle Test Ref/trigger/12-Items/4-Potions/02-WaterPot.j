function Trig_WaterPot_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A0JH'
endfunction

function Trig_WaterPot_Actions takes nothing returns nothing
    local unit caster
    local real heal
    
    if CastLogic() then
        set caster = udg_Caster
    elseif RandomLogic() then
        set caster = udg_Caster
        call textst( "|cf02020FF Water", caster, 64, 90, 10, 1.5 )
    else
        set caster = GetSpellAbilityUnit()
    endif
    
    set heal = 125 * udg_SpellDamagePotion[GetPlayerId( GetOwningPlayer( caster ) ) + 1]

    call manast( caster, null, heal )
    call potionst( caster )
    call DestroyEffect( AddSpecialEffectTarget( "Abilities\\Spells\\Items\\AIma\\AImaTarget.mdl", caster, "origin" ) )
    
    set caster = null
endfunction

//===========================================================================
function InitTrig_WaterPot takes nothing returns nothing
    set gg_trg_WaterPot = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_WaterPot, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_WaterPot, Condition( function Trig_WaterPot_Conditions ) )
    call TriggerAddAction( gg_trg_WaterPot, function Trig_WaterPot_Actions )
endfunction

