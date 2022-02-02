function Trig_BloodStone_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A14E'
endfunction

function Trig_BloodStone_Actions takes nothing returns nothing
    local integer cyclA = 1
    local integer cyclAEnd
    local unit caster
    local unit target
    local real dmg = 200
    
    if CastLogic() then
        set caster = udg_Caster
        set target = udg_Target
    elseif RandomLogic() then
        set caster = udg_Caster
        set target = randomtarget( caster, 900, "enemy", "", "", "", "" )
        call textst( udg_string[0] + GetObjectName('A04R'), caster, 64, 90, 10, 1.5 )
        if target == null then
            set caster = null
            return
        endif
    else
        set caster = GetSpellAbilityUnit()
        set target = GetSpellTargetUnit()
    endif

    if GetUnitState( caster, UNIT_STATE_LIFE) == GetUnitState( caster, UNIT_STATE_MAX_LIFE) then
        set dmg = 3 * dmg
    endif
    set cyclAEnd = eyest( caster )
    call dummyspawn( caster, 1, 0, 0, 0 )
    call DestroyEffect( AddSpecialEffectTarget( "Blood Explosion.mdx", target, "origin") )
    loop
        exitwhen cyclA > cyclAEnd
        call UnitDamageTarget( bj_lastCreatedUnit, target, dmg, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS)
        set cyclA = cyclA + 1
    endloop
    
    set caster = null
    set target = null
endfunction

//===========================================================================
function InitTrig_BloodStone takes nothing returns nothing
    set gg_trg_BloodStone = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_BloodStone, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_BloodStone, Condition( function Trig_BloodStone_Conditions ) )
    call TriggerAddAction( gg_trg_BloodStone, function Trig_BloodStone_Actions )
endfunction

