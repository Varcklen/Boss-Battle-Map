function Trig_SirenaW_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A02J'
endfunction

function Trig_SirenaW_Actions takes nothing returns nothing
    local unit caster
    local unit target
    local integer lvl
    local real dmg
    
    if CastLogic() then
        set caster = udg_Caster
        set target = udg_Target
    elseif RandomLogic() then
        set caster = udg_Caster
        set target = randomtarget( caster, 300, "enemy", "org", "", "", "" )
        call textst( udg_string[0] + GetObjectName('A02J'), caster, 64, 90, 10, 1.5 )
        if target == null then
            set caster = null
            return
        endif
    else
        set caster = GetSpellAbilityUnit()
        set target = GetSpellTargetUnit()
    endif
    set dmg = GetHeroStr( caster, true ) + GetHeroAgi( caster, true ) + GetHeroInt( caster, true )
    
    call DestroyEffect( AddSpecialEffectTarget( "Abilities\\Spells\\Undead\\AnimateDead\\AnimateDeadTarget.mdl", target, "origin") )
    call dummyspawn( caster, 1, 0, 0, 0 )
    call UnitDamageTarget( bj_lastCreatedUnit, target, dmg, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS )
    if GetUnitState( target, UNIT_STATE_LIFE) <= 0.405 and combat( caster, false, 0 ) and not( udg_fightmod[3] ) then
        call statst( caster, 0, 2, 0, 0, true )
        set udg_Data[GetPlayerId(GetOwningPlayer(caster)) + 1 + 104] = udg_Data[GetPlayerId(GetOwningPlayer(caster)) + 1 + 104] + 2
        call DestroyEffect( AddSpecialEffectTarget( "Abilities\\Spells\\Undead\\AnimateDead\\AnimateDeadTarget.mdl", caster, "origin") )
    endif
    
    set caster = null
    set target = null
endfunction

//===========================================================================
function InitTrig_SirenaW takes nothing returns nothing
    set gg_trg_SirenaW = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_SirenaW, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_SirenaW, Condition( function Trig_SirenaW_Conditions ) )
    call TriggerAddAction( gg_trg_SirenaW, function Trig_SirenaW_Actions )
endfunction

