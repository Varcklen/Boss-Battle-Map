globals
    constant integer DEVILFLAME_POTION_DAMAGE = 750
    
    constant string DEVILFLAME_POTION_ANIMATION = "Abilities\\Spells\\Other\\Incinerate\\FireLordDeathExplode.mdl"
endglobals

function Trig_Devilflame_Potion_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A14W'
endfunction

function Trig_Devilflame_Potion_Actions takes nothing returns nothing
    local unit caster
    local unit target
    local real dmg
    
    if CastLogic() then
        set caster = udg_Caster
        set target = udg_Target
    elseif RandomLogic() then
        set caster = udg_Caster
        set target = randomtarget( caster, 900, "enemy", "", "", "", "" )
        call textst( "|cf0FF2020 Devilflame", udg_Caster, 64, 90, 10, 1.5 )
        if target == null then
            set caster = null
            return
        endif
    else
        set caster = GetSpellAbilityUnit()
        set target = GetSpellTargetUnit()
    endif
    
    set dmg = DEVILFLAME_POTION_DAMAGE * udg_SpellDamagePotion[GetPlayerId( GetOwningPlayer( caster ) ) + 1]
    
    call UnitTakeDamage(caster, target, dmg, DAMAGE_TYPE_MAGIC)
    call PlaySpecialEffect( DEVILFLAME_POTION_ANIMATION, target )
    call potionst( caster )
    
    set target = null
    set caster = null
endfunction

//===========================================================================
function InitTrig_Devilflame_Potion takes nothing returns nothing
    set gg_trg_Devilflame_Potion = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Devilflame_Potion, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_Devilflame_Potion, Condition( function Trig_Devilflame_Potion_Conditions ) )
    call TriggerAddAction( gg_trg_Devilflame_Potion, function Trig_Devilflame_Potion_Actions )
endfunction

