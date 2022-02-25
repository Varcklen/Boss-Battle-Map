function Trig_Sun_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A143' and not( udg_fightmod[3] ) and combat( GetSpellAbilityUnit(), true, GetSpellAbilityId() )
endfunction

function Trig_Sun_Actions takes nothing returns nothing
    local unit caster
    local unit target
    
    if CastLogic() then
        set caster = udg_Caster
        set target = udg_Target
    elseif RandomLogic() then
        set caster = udg_Caster
        set target = randomtarget( caster, 900, "enemy", "", "", "", "" )
        call textst( udg_string[0] + GetObjectName('A04R'), caster, 64, 90, 10, 1.5 )
        if target == null then
            set caster = null
            return
        endif
    else
        set caster = GetSpellAbilityUnit()
        set target = GetSpellTargetUnit()
    endif

    call dummyspawn( caster, 1, 0, 0, 0 )
    call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\Other\\Incinerate\\FireLordDeathExplode.mdl", GetUnitX( target ), GetUnitY( target ) ) )
    call UnitDamageTarget( bj_lastCreatedUnit, target, 2000, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS)
    
    call stazisst( caster, GetItemOfTypeFromUnitBJ( caster, 'I0B1') )
    
    set caster = null
    set target = null
endfunction

//===========================================================================
function InitTrig_Sun takes nothing returns nothing
    set gg_trg_Sun = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Sun, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_Sun, Condition( function Trig_Sun_Conditions ) )
    call TriggerAddAction( gg_trg_Sun, function Trig_Sun_Actions )
endfunction

