globals
    constant integer OBSIDIAN_POTION_DAMAGE = 400
    constant integer OBSIDIAN_POTION_MANA = 500
    
    constant string OBSIDIAN_POTION_ANIMATION = "Objects\\Spawnmodels\\Naga\\NagaDeath\\NagaDeath.mdl"
endglobals

function Trig_Obsidian_Potion_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A169'
endfunction

function Trig_Obsidian_Potion_Actions takes nothing returns nothing
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
        call textst( "|cf0101090 Obsidian", udg_Caster, 64, 90, 10, 1.5 )
        if target == null then
            set caster = null
            return
        endif
    else
        set caster = GetSpellAbilityUnit()
        set target = GetSpellTargetUnit()
    endif

    set dmg = OBSIDIAN_POTION_DAMAGE * udg_SpellDamagePotion[GetPlayerId( GetOwningPlayer( caster ) ) + 1]
    set heal = OBSIDIAN_POTION_MANA * udg_SpellDamagePotion[GetPlayerId( GetOwningPlayer( caster ) ) + 1]
    
    call UnitTakeDamage(caster, target, dmg, DAMAGE_TYPE_MAGIC)
    call manast( caster, null, heal )
    call potionst( caster )
    call PlaySpecialEffect( OBSIDIAN_POTION_ANIMATION, target )
    call PlaySpecialEffect( OBSIDIAN_POTION_ANIMATION, caster )
    
    set target = null
    set caster = null
endfunction

//===========================================================================
function InitTrig_Obsidian_Potion takes nothing returns nothing
    set gg_trg_Obsidian_Potion = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Obsidian_Potion, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_Obsidian_Potion, Condition( function Trig_Obsidian_Potion_Conditions ) )
    call TriggerAddAction( gg_trg_Obsidian_Potion, function Trig_Obsidian_Potion_Actions )
endfunction

