function Trig_Manaball_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A0GC' or GetSpellAbilityId() == 'A02V'
endfunction

function Trig_Manaball_Actions takes nothing returns nothing
    local unit caster
    local unit target
    local real dmg
    
    if CastLogic() then
        set caster = udg_Caster
        set target = udg_Target
    elseif RandomLogic() then
        set caster = udg_Caster
        set target = randomtarget( caster, 900, "enemy", "", "", "", "" )
        call textst( udg_string[0] + GetObjectName('A0GC'), caster, 64, 90, 10, 1.5 )
        if target == null then
            set caster = null
            return
        endif
    else
        set caster = GetSpellAbilityUnit()
        set target = GetSpellTargetUnit()
    endif

    set dmg = 100 * udg_SpellDamageSpec[GetPlayerId(GetOwningPlayer(caster)) + 1]
    if IsUniqueUpgraded(caster) then
        set dmg = 2*dmg
    endif
    
    call spectimeunit( target, "Abilities\\Spells\\Undead\\ReplenishMana\\ReplenishManaCaster.mdl", "head", 1 )
    call UnitTakeDamage( caster, target, dmg, DAMAGE_TYPE_MAGIC)
    
    set caster = null
    set target = null
endfunction

//===========================================================================
function InitTrig_Manaball takes nothing returns nothing
    set gg_trg_Manaball = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Manaball, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_Manaball, Condition( function Trig_Manaball_Conditions ) )
    call TriggerAddAction( gg_trg_Manaball, function Trig_Manaball_Actions )
endfunction

