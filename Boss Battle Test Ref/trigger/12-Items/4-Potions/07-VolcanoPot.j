function Trig_VolcanoPot_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A13W'
endfunction

function Trig_VolcanoPot_Actions takes nothing returns nothing
    local unit caster
    local unit target
    local real dmg
    local real heal
    
    if CastLogic() then
        set caster = udg_Caster
        set target = udg_Target
    elseif RandomLogic() then
        set caster = udg_Caster
        set target = randomtarget( caster, 900, "enemy", "", "", "", "" )
        call textst( "|cf0901010 Volcano", udg_Caster, 64, 90, 10, 1.5 )
        if target == null then
            set caster = null
            return
        endif
    else
        set caster = GetSpellAbilityUnit()
        set target = GetSpellTargetUnit()
    endif

    set dmg = 250 * udg_SpellDamagePotion[GetPlayerId( GetOwningPlayer( caster ) ) + 1]
    set heal = 300 * udg_SpellDamagePotion[GetPlayerId( GetOwningPlayer( caster ) ) + 1]
    
    call dummyspawn( caster, 1, 0, 0, 0 ) 
    call UnitDamageTarget( bj_lastCreatedUnit, target, dmg, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS)
    set udg_logic[52] = true
    call healst( caster, null, heal )
    call potionst( caster )
    call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\Other\\Incinerate\\FireLordDeathExplode.mdl", GetUnitX( target ), GetUnitY( target ) ) )
    call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\Other\\Incinerate\\FireLordDeathExplode.mdl", GetUnitX( caster ), GetUnitY( caster ) ) )
    
    set target = null
    set caster = null
endfunction

//===========================================================================
function InitTrig_VolcanoPot takes nothing returns nothing
    set gg_trg_VolcanoPot = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_VolcanoPot, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_VolcanoPot, Condition( function Trig_VolcanoPot_Conditions ) )
    call TriggerAddAction( gg_trg_VolcanoPot, function Trig_VolcanoPot_Actions )
endfunction

