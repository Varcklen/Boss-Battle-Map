function Trig_Amalgam_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A0GM'
endfunction

function Trig_Amalgam_Actions takes nothing returns nothing
    local unit caster
    local unit target
    local integer cyclA = 1
    local integer cyclAEnd
    local real dmg
    
    if CastLogic() then
        set caster = udg_Caster
        set target = udg_Target
    elseif RandomLogic() then
        set caster = udg_Caster
        set target = randomtarget( caster, 900, "enemy", "", "", "", "" )
        call textst( udg_string[0] + GetObjectName('A11J'), caster, 64, 90, 10, 1.5 )
        if target == null then
            set caster = null
            return
        endif
    else
        set caster = GetSpellAbilityUnit()
        set target = GetSpellTargetUnit()
    endif
    
    set cyclAEnd = eyest( caster )
    call dummyspawn( caster, 1, 0, 0, 0 )
    loop
        exitwhen cyclA > cyclAEnd
        call UnitDamageTarget( bj_lastCreatedUnit, target, 150, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS)
        call DestroyEffect( AddSpecialEffectTarget( "Abilities\\Spells\\Items\\ResourceItems\\ResourceEffectTarget.mdl", target, "origin") )
        call healst( caster, null, 150)
        call shield( caster, caster, 150, 30 )
        if BuffLogic() then
            call effst( caster, target, "Trig_Amalgam_Actions", 1, 30 )
        endif
        set cyclA = cyclA + 1
    endloop
    
    set caster = null
    set target = null
endfunction

//===========================================================================
function InitTrig_Amalgam takes nothing returns nothing
    set gg_trg_Amalgam = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Amalgam, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_Amalgam, Condition( function Trig_Amalgam_Conditions ) )
    call TriggerAddAction( gg_trg_Amalgam, function Trig_Amalgam_Actions )
endfunction

