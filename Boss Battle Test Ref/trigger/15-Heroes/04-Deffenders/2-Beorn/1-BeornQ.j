globals
    constant integer BEORN_Q_DAMAGE_FIRST_LEVEL = 60
    constant integer BEORN_Q_DAMAGE_LEVEL_BONUS = 40
    constant integer BEORN_Q_STUN_DURATION = 4
    
    constant real BEORN_Q_STUN_DURATION_BONUS_ALTERNATIVE = 0.5
    
    constant string BEORN_Q_ANIMATION = "Abilities\\Spells\\Other\\Stampede\\StampedeMissileDeath.mdl"
endglobals

function Trig_BeornQ_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A00C'
endfunction

function BeornQ_Alternative takes unit caster, unit target, real duration returns nothing
    set duration = duration + (duration * BEORN_Q_STUN_DURATION_BONUS_ALTERNATIVE)

    call UnitStun(caster, target, duration )

    set caster = null
    set target = null
endfunction

function BeornQ takes unit caster, unit target, real damage, real duration returns nothing

    call UnitStun(caster, target, duration )
    call dummyspawn( caster, 1, 0, 0, 0 )
    call UnitDamageTarget(bj_lastCreatedUnit, target, damage, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS)
    
    set caster = null
    set target = null
endfunction

function Trig_BeornQ_Actions takes nothing returns nothing
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
        call textst( udg_string[0] + GetObjectName('A0B4'), caster, 64, 90, 10, 1.5 )
        if target == null then
            set caster = null
            return
        endif
    else
        set caster = GetSpellAbilityUnit()
        set target = GetSpellTargetUnit()
        set lvl = GetUnitAbilityLevel(GetSpellAbilityUnit(), GetSpellAbilityId())
    endif
    
    set dmg = BEORN_Q_DAMAGE_FIRST_LEVEL + ( BEORN_Q_DAMAGE_LEVEL_BONUS * lvl )

    if Aspects_IsHeroAspectActive( caster, ASPECT_01 ) then
        call BeornQ_Alternative( caster, target, BEORN_Q_STUN_DURATION )
    else
        call BeornQ( caster, target, dmg, BEORN_Q_STUN_DURATION )
    endif
    call DestroyEffect( AddSpecialEffectTarget( BEORN_Q_ANIMATION, target, "chest") )
    
    set caster = null
    set target = null
endfunction

//===========================================================================
function InitTrig_BeornQ takes nothing returns nothing
    set gg_trg_BeornQ = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_BeornQ, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_BeornQ, Condition( function Trig_BeornQ_Conditions ) )
    call TriggerAddAction( gg_trg_BeornQ, function Trig_BeornQ_Actions )
endfunction

