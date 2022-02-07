function Trig_Insatiable_flame_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A0OK'
endfunction

function Trig_Insatiable_flame_Actions takes nothing returns nothing
    local integer cyclA = 1
    local integer cyclAEnd
    local unit caster
    local unit target
    
    if CastLogic() then
        set caster = udg_Caster
        set target = udg_Target
    elseif RandomLogic() then
        set caster = udg_Caster
        set target = randomtarget( caster, 900, "enemy", "", "", "", "" )
        call textst( udg_string[0] + GetObjectName('A0OK'), caster, 64, 90, 10, 1.5 )
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
    call spectime("Abilities\\Spells\\Human\\FlameStrike\\FlameStrike1.mdl", GetUnitX( target ), GetUnitY( target ), 8 )
    loop
        exitwhen cyclA > cyclAEnd
        call UnitDamageTarget( bj_lastCreatedUnit, target, 1000, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS)
        set cyclA = cyclA + 1
    endloop
    
    set caster = null
    set target = null
endfunction

//===========================================================================
function InitTrig_Insatiable_flame takes nothing returns nothing
    set gg_trg_Insatiable_flame = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Insatiable_flame, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_Insatiable_flame, Condition( function Trig_Insatiable_flame_Conditions ) )
    call TriggerAddAction( gg_trg_Insatiable_flame, function Trig_Insatiable_flame_Actions )
endfunction

