globals
    constant string SAMURAI_Q_ANIMATION = "Abilities\\Spells\\Orc\\MirrorImage\\MirrorImageCaster.mdl"

    constant integer SAMURAI_Q_ATTACK_BONUS = 1
    constant integer SAMURAI_Q_HEAL_FIRST_LEVEL = 50
    constant integer SAMURAI_Q_HEAL_LEVEL_BONUS = 50
    
    constant real SAMURAI_Q_HEAL_BONUS = 1.5
endglobals

function Trig_SamuraiQ_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A0QH'
endfunction

function SamuraiQ_Alternative takes unit caster, real heal returns nothing
    set heal = heal + (SAMURAI_Q_HEAL_BONUS*heal)

    call healst( caster, null, heal )
    
    set caster = null
endfunction

function SamuraiQ takes unit caster, real heal, integer attackBonus returns nothing
    local integer index = GetUnitUserData(caster)

    call healst( caster, null, heal )
    if combat( caster, false, 0 ) and not( udg_fightmod[3] ) and IsUnitType( caster, UNIT_TYPE_HERO) then
        call BlzSetUnitBaseDamage( caster, BlzGetUnitBaseDamage(caster, 0) + attackBonus, 0 )
        set udg_Data[index + 116] = udg_Data[index + 116] + attackBonus
    endif

    set caster = null
endfunction

function Trig_SamuraiQ_Actions takes nothing returns nothing
    local integer lvl
    local unit caster
    local real heal
    
    if CastLogic() then
        set caster = udg_Caster
        set lvl = udg_Level
    elseif RandomLogic() then
        set caster = udg_Caster
        set lvl = udg_Level
        call textst( udg_string[0] + GetObjectName('A0QH'), caster, 64, 90, 10, 1.5 )
    else
        set caster = GetSpellAbilityUnit()
        set lvl = GetUnitAbilityLevel(GetSpellAbilityUnit(), GetSpellAbilityId())
    endif
    
    set heal = SAMURAI_Q_HEAL_FIRST_LEVEL + ( SAMURAI_Q_HEAL_LEVEL_BONUS * lvl )
    
    if Aspects_IsHeroAspectActive(caster, ASPECT_01 ) then
        call SamuraiQ_Alternative( caster,  heal)
    else
        call SamuraiQ( caster, heal, SAMURAI_Q_ATTACK_BONUS )
    endif
    call DestroyEffect( AddSpecialEffectTarget( SAMURAI_Q_ANIMATION,  caster, "origin" ) )
     
    set caster = null
endfunction

//===========================================================================
function InitTrig_SamuraiQ takes nothing returns nothing
    set gg_trg_SamuraiQ = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_SamuraiQ, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_SamuraiQ, Condition( function Trig_SamuraiQ_Conditions ) )
    call TriggerAddAction( gg_trg_SamuraiQ, function Trig_SamuraiQ_Actions )
endfunction

