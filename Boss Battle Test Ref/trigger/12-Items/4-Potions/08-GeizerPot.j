function Trig_GeizerPot_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A0GJ'
endfunction

function Trig_GeizerPot_Actions takes nothing returns nothing
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
        call textst( "|cf0101090 Geizer", udg_Caster, 64, 90, 10, 1.5 )
        if target == null then
            set caster = null
            return
        endif
    else
        set caster = GetSpellAbilityUnit()
        set target = GetSpellTargetUnit()
    endif
    
    set dmg = 250 * udg_SpellDamagePotion[GetPlayerId( GetOwningPlayer( caster ) ) + 1]
    set heal = 150 * udg_SpellDamagePotion[GetPlayerId( GetOwningPlayer( caster ) ) + 1]
    
    call dummyspawn( caster, 1, 0, 0, 0 ) 
    call UnitDamageTarget( bj_lastCreatedUnit, target, dmg, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS)
    call manast( caster, null, heal )
    call potionst( caster )
    call DestroyEffect( AddSpecialEffect( "Objects\\Spawnmodels\\Naga\\NagaDeath\\NagaDeath.mdl", GetUnitX( target ), GetUnitY( target ) ) )
    call DestroyEffect( AddSpecialEffect( "Objects\\Spawnmodels\\Naga\\NagaDeath\\NagaDeath.mdl", GetUnitX( caster ), GetUnitY( caster ) ) )
    
    set target = null
    set caster = null
endfunction

//===========================================================================
function InitTrig_GeizerPot takes nothing returns nothing
    set gg_trg_GeizerPot = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_GeizerPot, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_GeizerPot, Condition( function Trig_GeizerPot_Conditions ) )
    call TriggerAddAction( gg_trg_GeizerPot, function Trig_GeizerPot_Actions )
endfunction

