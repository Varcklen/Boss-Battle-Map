function Trig_DragonW_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A08L' and combat( GetSpellAbilityUnit(), true, GetSpellAbilityId() )
endfunction

function Trig_DragonW_Actions takes nothing returns nothing
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
        call textst( udg_string[0] + GetObjectName('A08L'), caster, 64, 90, 10, 1.5 )
        if target == null then
            set caster = null
            return
        endif
    else
        set caster = GetSpellAbilityUnit()
        set target = GetSpellTargetUnit()
        set lvl = GetUnitAbilityLevel(GetSpellAbilityUnit(), GetSpellAbilityId())
    endif
    set dmg = 100 + ( 50 * lvl )

    call DestroyEffect( AddSpecialEffectTarget( "Abilities\\Spells\\Other\\Incinerate\\FireLordDeathExplode.mdl", target, "origin") )

    call dummyspawn( caster, 1, 0, 0, 0 )
    call UnitDamageTarget( bj_lastCreatedUnit, target, dmg, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS)
    if luckylogic( caster, 50 + ( 10 * lvl ), 1, 100 ) and GetUnitTypeId(caster) == udg_Database_Hero[1] and not(udg_fightmod[3]) then
        call crist( caster, 1 )
    endif
    
    set caster = null
    set target = null
endfunction

//===========================================================================
function InitTrig_DragonW takes nothing returns nothing
    set gg_trg_DragonW = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_DragonW, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_DragonW, Condition( function Trig_DragonW_Conditions ) )
    call TriggerAddAction( gg_trg_DragonW, function Trig_DragonW_Actions )
endfunction

