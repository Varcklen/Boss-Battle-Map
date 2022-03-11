globals
    constant integer WATERFALL_POTION_HEAL = 1000
    constant integer WATERFALL_POTION_MANA = 800
    
    constant string WATERFALL_POTION_ANIMATION = "war3mapImported\\HolyAwakening.mdx"
endglobals

function Trig_Waterfall_Potion_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A167'
endfunction

function Trig_Waterfall_Potion_Actions takes nothing returns nothing
    local unit caster
    local real hp
    local real mp
    
    if CastLogic() then
        set caster = udg_Caster
    elseif RandomLogic() then
        set caster = udg_Caster
        call textst( "|cf0006400 Waterfall", caster, 64, 90, 10, 1.5 )
    else
        set caster = GetSpellAbilityUnit()
    endif

    set hp = WATERFALL_POTION_HEAL * udg_SpellDamagePotion[GetPlayerId( GetOwningPlayer( caster ) ) + 1]
    set mp = WATERFALL_POTION_MANA * udg_SpellDamagePotion[GetPlayerId( GetOwningPlayer( caster ) ) + 1]
    
    set IsHealFromPotion = true
    call healst( caster, null, hp )
    call manast( caster, null, mp )
    call potionst( caster )
    call DestroyEffect( AddSpecialEffectTarget( WATERFALL_POTION_ANIMATION, caster, "origin" ) )
    
    set caster = null
endfunction

//===========================================================================
function InitTrig_Waterfall_Potion takes nothing returns nothing
    set gg_trg_Waterfall_Potion = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Waterfall_Potion, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_Waterfall_Potion, Condition( function Trig_Waterfall_Potion_Conditions ) )
    call TriggerAddAction( gg_trg_Waterfall_Potion, function Trig_Waterfall_Potion_Actions )
endfunction

