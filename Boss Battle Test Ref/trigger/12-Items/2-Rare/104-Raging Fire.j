function Trig_Raging_Fire_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A13Y'
endfunction

function Trig_Raging_Fire_Actions takes nothing returns nothing
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
        call textst( udg_string[0] + GetObjectName('A13Y'), caster, 64, 90, 10, 1.5 )
        if target == null then
            set caster = null
            return
        endif
    else
        set caster = GetSpellAbilityUnit()
        set target = GetSpellTargetUnit()
    endif
    
    set cyclAEnd = eyest( caster )
    set dmg = GetUnitState( target, UNIT_STATE_MAX_LIFE) * 0.1

    call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\Other\\Incinerate\\FireLordDeathExplode.mdl", GetUnitX( caster ), GetUnitY( caster ) ) )
    call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\Other\\Incinerate\\FireLordDeathExplode.mdl", GetUnitX( target ), GetUnitY( target ) ) )
    set bj_lastCreatedUnit = CreateUnit(GetOwningPlayer(caster), 'u000', GetUnitX( caster ), GetUnitY( caster ), 270 )
    call UnitApplyTimedLife( bj_lastCreatedUnit, 'BTLF', 1.)
    loop
        exitwhen cyclA > cyclAEnd
        call UnitDamageTarget( bj_lastCreatedUnit, target, dmg, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS )
        set cyclA = cyclA + 1
    endloop
    
    set caster = null
    set target = null
endfunction

//===========================================================================
function InitTrig_Raging_Fire takes nothing returns nothing
    set gg_trg_Raging_Fire = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Raging_Fire, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_Raging_Fire, Condition( function Trig_Raging_Fire_Conditions ) )
    call TriggerAddAction( gg_trg_Raging_Fire, function Trig_Raging_Fire_Actions )
endfunction

