function Trig_Dualism_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A1BK'
endfunction

function Trig_Dualism_Actions takes nothing returns nothing
    local real dmg
    local unit caster
    local unit target
    
    if CastLogic() then
        set caster = udg_Caster
        set target = udg_Target
    elseif RandomLogic() then
        set caster = udg_Caster
        set target = randomtarget( caster, 900, "all", "notfull", "", "", "" )
        call textst( udg_string[0] + GetObjectName('A1BK'), caster, 64, 90, 10, 1.5 )
        if target == null then
            set caster = null
            return
        endif
    else
        set caster = GetSpellAbilityUnit()
        set target = GetSpellTargetUnit()
    endif
    
    set dmg = 75
     
    call DestroyEffect( AddSpecialEffectTarget( "Abilities\\Spells\\Other\\Transmute\\GoldBottleMissile.mdl", target, "overhead" ) )
    if IsUnitAlly( target, GetOwningPlayer( caster ) ) then
        call healst( caster, target, dmg )
    else
        call dummyspawn( caster, 1, 0, 0, 0 )
        call UnitDamageTarget( bj_lastCreatedUnit, target, dmg, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS)
    endif
    
    set caster = null
    set target = null
endfunction

//===========================================================================
function InitTrig_Dualism takes nothing returns nothing
    set gg_trg_Dualism = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Dualism, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_Dualism, Condition( function Trig_Dualism_Conditions ) )
    call TriggerAddAction( gg_trg_Dualism, function Trig_Dualism_Actions )
endfunction

