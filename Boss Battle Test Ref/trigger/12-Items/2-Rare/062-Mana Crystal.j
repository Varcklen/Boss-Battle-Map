function Trig_Mana_Crystal_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A14B'
endfunction

function Trig_Mana_Crystal_Actions takes nothing returns nothing
    local integer cyclA = 1
    local integer cyclAEnd
    local unit caster
    local unit target
    local real dmg
    
    if CastLogic() then
        set caster = udg_Caster
        set target = udg_Target
    elseif RandomLogic() then
        set caster = udg_Caster
        set target = randomtarget( caster, 900, "enemy", "", "", "", "" )
        call textst( udg_string[0] + GetObjectName('A0F4'), caster, 64, 90, 10, 1.5 )
        if target == null then
            set caster = null
            return
        endif
    else
        set caster = GetSpellAbilityUnit()
        set target = GetSpellTargetUnit()
    endif
    
    set dmg = 100
    set cyclAEnd = eyest( caster )
    call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\Human\\Slow\\SlowCaster.mdl", GetUnitX( caster ), GetUnitY(caster ) ) )
    call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\Human\\Invisibility\\InvisibilityTarget.mdl", GetUnitX( target ), GetUnitY( target ) ) )
    call dummyspawn( caster, 1, 0, 0, 0 )
    loop
        exitwhen cyclA > cyclAEnd
        call UnitDamageTarget(bj_lastCreatedUnit, target, dmg, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS)
        call manast( GetSpellAbilityUnit(), null, dmg )
        set cyclA = cyclA + 1
    endloop
    
    set caster = null
    set target = null
endfunction

//===========================================================================
function InitTrig_Mana_Crystal takes nothing returns nothing
    set gg_trg_Mana_Crystal = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Mana_Crystal, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_Mana_Crystal, Condition( function Trig_Mana_Crystal_Conditions ) )
    call TriggerAddAction( gg_trg_Mana_Crystal, function Trig_Mana_Crystal_Actions )
endfunction

