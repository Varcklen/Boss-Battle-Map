function Trig_CircusQ_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A0SH'
endfunction

function Trig_CircusQ_Actions takes nothing returns nothing
    local unit caster
    local unit target
    local integer lvl
    local integer i = 1
    local integer cyclA = 1
    local real dmg
    
    if CastLogic() then
        set caster = udg_Caster
        set target = udg_Target
        set lvl = udg_Level
    elseif RandomLogic() then
        set caster = udg_Caster
        set target = randomtarget( caster, 900, "enemy", "", "", "", "" )
        set lvl = udg_Level
        call textst( udg_string[0] + GetObjectName('A0SH'), caster, 64, 90, 10, 1.5 )
        if target == null then
            set caster = null
            return
        endif
    else
        set caster = GetSpellAbilityUnit()
        set target = GetSpellTargetUnit()
        set lvl = GetUnitAbilityLevel(GetSpellAbilityUnit(), GetSpellAbilityId())
    endif

    call dummyspawn( caster, 1, 0, 0, 0 )
    set dmg = 60 + ( 40 * lvl )
    loop
        exitwhen cyclA > 1
        call DestroyEffect( AddSpecialEffectTarget("Abilities\\Spells\\Human\\Thunderclap\\ThunderClapCaster.mdl", target, "origin" ) )
        call UnitDamageTarget( bj_lastCreatedUnit, target, dmg, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS)
        call DemomanCurse( caster, target )
        if luckylogic( caster, 25 + ( 5 * lvl ), 1, 100 ) and GetUnitState( target, UNIT_STATE_LIFE) > 0.405 and i <= 10 then
            set cyclA = cyclA - 1
            set i = i + 1
        endif
        set cyclA = cyclA + 1
    endloop
    
    set caster = null
    set target = null
endfunction

//===========================================================================
function InitTrig_CircusQ takes nothing returns nothing
    set gg_trg_CircusQ = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_CircusQ, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_CircusQ, Condition( function Trig_CircusQ_Conditions ) )
    call TriggerAddAction( gg_trg_CircusQ, function Trig_CircusQ_Actions )
endfunction

