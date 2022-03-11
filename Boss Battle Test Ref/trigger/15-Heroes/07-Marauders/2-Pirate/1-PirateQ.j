function Trig_PirateQ_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A07A'
endfunction

function Trig_PirateQ_Actions takes nothing returns nothing
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
        call textst( udg_string[0] + GetObjectName('A07A'), caster, 64, 90, 10, 1.5 )
        if target == null then
            set caster = null
            return
        endif
    else
        set caster = GetSpellAbilityUnit()
        set target = GetSpellTargetUnit()
        set lvl = GetUnitAbilityLevel(GetSpellAbilityUnit(), GetSpellAbilityId())
    endif
    set dmg = 40 + ( 50 * lvl )
    
    call dummyspawn( caster, 1, 0, 0, 0 )
    call UnitDamageTarget( bj_lastCreatedUnit, target, dmg, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS)
    call DestroyEffect( AddSpecialEffectTarget("Abilities\\Spells\\Other\\Transmute\\PileofGold.mdl" , caster, "origin" ) )
    if combat( caster, false, 0 ) and not( udg_fightmod[3] ) then
        call moneyst( caster, 5 + ( 5 * lvl ) )
        set udg_Data[GetPlayerId(GetOwningPlayer(caster)) + 1 + 92] = udg_Data[GetPlayerId(GetOwningPlayer(caster)) + 1 + 92] + 4 + ( 2 * lvl )
    endif
    
    set caster = null
    set target = null
endfunction

//===========================================================================
function InitTrig_PirateQ takes nothing returns nothing
    set gg_trg_PirateQ = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_PirateQ, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_PirateQ, Condition( function Trig_PirateQ_Conditions ) )
    call TriggerAddAction( gg_trg_PirateQ, function Trig_PirateQ_Actions )
endfunction

