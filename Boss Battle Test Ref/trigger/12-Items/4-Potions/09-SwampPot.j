function Trig_SwampPot_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A0QT'
endfunction

function Trig_SwampPot_Actions takes nothing returns nothing
    local unit caster
    local real hp
    local real mp
    
    if CastLogic() then
        set caster = udg_Caster
    elseif RandomLogic() then
        set caster = udg_Caster
        call textst( "|cf0006400 Swamp", caster, 64, 90, 10, 1.5 )
    else
        set caster = GetSpellAbilityUnit()
    endif

    set hp = 800 * udg_SpellDamagePotion[GetPlayerId( GetOwningPlayer( caster ) ) + 1]
    set mp = 500 * udg_SpellDamagePotion[GetPlayerId( GetOwningPlayer( caster ) ) + 1]
    
    set udg_logic[52] = true
    call healst( caster, null, hp )
    call manast( caster, null, mp )
    call potionst( caster )
    call DestroyEffect( AddSpecialEffectTarget( "war3mapImported\\HolyAwakening.mdx", caster, "origin" ) )
    
    set caster = null
endfunction

//===========================================================================
function InitTrig_SwampPot takes nothing returns nothing
    set gg_trg_SwampPot = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_SwampPot, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_SwampPot, Condition( function Trig_SwampPot_Conditions ) )
    call TriggerAddAction( gg_trg_SwampPot, function Trig_SwampPot_Actions )
endfunction

