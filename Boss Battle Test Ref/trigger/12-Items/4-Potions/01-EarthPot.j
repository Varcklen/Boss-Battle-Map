function Trig_EarthPot_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A0IY'
endfunction

function Trig_EarthPot_Actions takes nothing returns nothing
    local unit caster
    local real heal
    
    if CastLogic() then
        set caster = udg_Caster
    elseif RandomLogic() then
        set caster = udg_Caster
        call textst( "|cf020FF20 Earth", caster, 64, 90, 10, 1.5 )
    else
        set caster = GetSpellAbilityUnit()
    endif
    
    set heal = 225 * udg_SpellDamagePotion[GetPlayerId( GetOwningPlayer( caster ) ) + 1]
    set IsHealFromPotion = true
    call healst( caster, null, heal )
    call potionst( caster )
    call spectimeunit( caster, "Abilities\\Spells\\Human\\Heal\\HealTarget.mdl", "origin", 2 )
    
    set caster = null
endfunction

//===========================================================================
function InitTrig_EarthPot takes nothing returns nothing
    set gg_trg_EarthPot = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_EarthPot, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_EarthPot, Condition( function Trig_EarthPot_Conditions ) )
    call TriggerAddAction( gg_trg_EarthPot, function Trig_EarthPot_Actions )
endfunction

