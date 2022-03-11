function Trig_HarpyW_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A0TO'
endfunction

function Trig_HarpyW_Actions takes nothing returns nothing
    local real dmg
    local unit caster
    local unit target
    local integer lvl
    
    if CastLogic() then
        set caster = udg_Caster
        set target = udg_Target
        set lvl = udg_Level
    elseif RandomLogic() then
        set caster = udg_Caster
        set target = randomtarget( caster, 900, "all", "notfull", "", "", "" )
        set lvl = udg_Level
        call textst( udg_string[0] + GetObjectName('A0TO'), caster, 64, 90, 10, 1.5 )
        if target == null then
            set caster = null
            return
        endif
    else
        set caster = GetSpellAbilityUnit()
        set target = GetSpellTargetUnit()
        set lvl = GetUnitAbilityLevel(GetSpellAbilityUnit(), GetSpellAbilityId())
    endif
    
    set dmg = 75 + ( 50 * lvl )
     
    call DestroyEffect( AddSpecialEffectTarget( "Abilities\\Spells\\NightElf\\EntanglingRoots\\EntanglingRootsTarget.mdl", target, "origin" ) )
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
function InitTrig_HarpyW takes nothing returns nothing
    set gg_trg_HarpyW = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_HarpyW, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_HarpyW, Condition( function Trig_HarpyW_Conditions ) )
    call TriggerAddAction( gg_trg_HarpyW, function Trig_HarpyW_Actions )
endfunction

