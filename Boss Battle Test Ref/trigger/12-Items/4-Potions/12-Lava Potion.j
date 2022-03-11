globals
    constant integer LAVA_POTION_DAMAGE = 400
    constant integer LAVA_POTION_HEAL = 600
    
    constant string LAVA_POTION_ANIMATION = "Abilities\\Spells\\Other\\Incinerate\\FireLordDeathExplode.mdl"
endglobals

function Trig_Lava_Potion_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A165'
endfunction

function Trig_Lava_Potion_Actions takes nothing returns nothing
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
        call textst( "|cf0901010 Lava", udg_Caster, 64, 90, 10, 1.5 )
        if target == null then
            set caster = null
            return
        endif
    else
        set caster = GetSpellAbilityUnit()
        set target = GetSpellTargetUnit()
    endif

    set dmg = LAVA_POTION_DAMAGE * udg_SpellDamagePotion[GetPlayerId( GetOwningPlayer( caster ) ) + 1]
    set heal = LAVA_POTION_HEAL * udg_SpellDamagePotion[GetPlayerId( GetOwningPlayer( caster ) ) + 1]
    
    call UnitTakeDamage(caster, target, dmg, DAMAGE_TYPE_MAGIC)
    set IsHealFromPotion = true
    call healst( caster, null, heal )
    call potionst( caster )
    call PlaySpecialEffect( LAVA_POTION_ANIMATION, target )
    call PlaySpecialEffect( LAVA_POTION_ANIMATION, caster )
    
    set target = null
    set caster = null
endfunction

//===========================================================================
function InitTrig_Lava_Potion takes nothing returns nothing
    set gg_trg_Lava_Potion = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Lava_Potion, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_Lava_Potion, Condition( function Trig_Lava_Potion_Conditions ) )
    call TriggerAddAction( gg_trg_Lava_Potion, function Trig_Lava_Potion_Actions )
endfunction

