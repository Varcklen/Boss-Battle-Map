function Trig_AdmiralQ_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A0RV'
endfunction

function Trig_AdmiralQ_Actions takes nothing returns nothing
    local unit caster
    local unit target
    local integer lvl
    local real dmg 
    
    if CastLogic() then
        set caster = udg_Caster
        set target = udg_Target
        set lvl = udg_Level
    elseif RandomLogic() then
        set caster = udg_Caster
        set target = randomtarget( caster, 300, "enemy", "", "", "", "" )
        set lvl = udg_Level
        call textst( udg_string[0] + GetObjectName('A0RV'), caster, 64, 90, 10, 1.5 )
        if target == null then
            set caster = null
            return
        endif
    else
        set caster = GetSpellAbilityUnit()
        set target = GetSpellTargetUnit()
        set lvl = GetUnitAbilityLevel(GetSpellAbilityUnit(), GetSpellAbilityId())
    endif
    
    set dmg = (75+(25*lvl))+ ( GetPlayerState(GetOwningPlayer( caster ), PLAYER_STATE_RESOURCE_GOLD) * ( 0.15 + ( 0.05 * lvl ) ) )

    call dummyspawn( caster, 1, 0, 0, 0 )
    call UnitDamageTarget( bj_lastCreatedUnit, target, dmg, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS)
    call DestroyEffect(AddSpecialEffect( "Abilities\\Spells\\Other\\Stampede\\StampedeMissileDeath.mdl", GetUnitX( target ), GetUnitY( target ) ) )

    set caster = null
    set target = null
endfunction

//===========================================================================
function InitTrig_AdmiralQ takes nothing returns nothing
    set gg_trg_AdmiralQ = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_AdmiralQ, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_AdmiralQ, Condition( function Trig_AdmiralQ_Conditions ) )
    call TriggerAddAction( gg_trg_AdmiralQ, function Trig_AdmiralQ_Actions )
endfunction

