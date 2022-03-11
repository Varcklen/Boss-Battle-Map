globals
    constant real SEAL_OF_BROTHERHOOD_DAMAGE = 75
    constant real SEAL_OF_BROTHERHOOD_BONUS_DAMAGE = 3
    
    real SealOfBrotherhoodBonus = 0
endglobals

function Trig_Seal_of_Brotherhood_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A0EG'
endfunction

function Trig_Seal_of_Brotherhood_Actions takes nothing returns nothing
    local unit caster
    local unit target
    local real dmg
    
    if CastLogic() then
        set caster = udg_Caster
        set target = udg_Target
    elseif RandomLogic() then
        set caster = udg_Caster
        set target = randomtarget( caster, 900, "enemy", "", "", "", "" )
        call textst( udg_string[0] + GetObjectName('A19Q'), caster, 64, 90, 10, 1.5 )
        if target == null then
            set caster = null
            return
        endif
    else
        set caster = GetSpellAbilityUnit()
        set target = GetSpellTargetUnit()
    endif

    set dmg = SEAL_OF_BROTHERHOOD_DAMAGE + SealOfBrotherhoodBonus
    
    call DestroyEffect( AddSpecialEffect("Abilities\\Spells\\Orc\\WarStomp\\WarStompCaster.mdl", GetUnitX(target), GetUnitY(target) ) )
    call UnitTakeDamage( caster, target, dmg, DAMAGE_TYPE_MAGIC)
    if combat(caster, false, 0) and not(udg_fightmod[3]) then
        set SealOfBrotherhoodBonus = SealOfBrotherhoodBonus + SEAL_OF_BROTHERHOOD_BONUS_DAMAGE
        call BlzSetAbilityExtendedTooltip( 'A0EG', words( caster, BlzGetAbilityExtendedTooltip('A0EG', 0), "|cffbe81f7", "|r", I2S(R2I(SealOfBrotherhoodBonus+SEAL_OF_BROTHERHOOD_DAMAGE)) ), 0 )
    endif
    
    set caster = null
    set target = null
endfunction

//===========================================================================
function InitTrig_Seal_of_Brotherhood takes nothing returns nothing
    set gg_trg_Seal_of_Brotherhood = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Seal_of_Brotherhood, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_Seal_of_Brotherhood, Condition( function Trig_Seal_of_Brotherhood_Conditions ) )
    call TriggerAddAction( gg_trg_Seal_of_Brotherhood, function Trig_Seal_of_Brotherhood_Actions )
endfunction

