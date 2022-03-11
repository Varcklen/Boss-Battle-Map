globals
    constant real PYROLORD_W_START_DAMAGE = 75
    constant real PYROLORD_W_UPGRADE_DAMAGE = 15
endglobals

function Trig_PyrolordW_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A0NK'
endfunction

function PyrolordW_Damage takes unit dealer, unit target, real damage returns nothing

    call DestroyEffect( AddSpecialEffect("Abilities\\Spells\\Other\\Incinerate\\FireLordDeathExplode.mdl", GetUnitX(target), GetUnitY(target) ) )
    call UnitDamageTarget( dealer, target, damage, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS)
    
    set dealer = null
    set target = null
endfunction

function Trig_PyrolordW_Actions takes nothing returns nothing
    local real dmg
    local unit caster
    local unit target
    local integer lvl
    
    if CastLogic() then
        set caster = udg_Caster
        set target = udg_Target
        set lvl = udg_Level
    elseif RandomLogic() then
        set caster = udg_Caster
        set target = randomtarget( caster, 900, "enemy", "", "", "", "" )
        set lvl = udg_Level
        call textst( udg_string[0] + GetObjectName('A0NK'), caster, 64, 90, 10, 1.5 )
        if target == null then
            set caster = null
            return
        endif
    else
        set caster = GetSpellAbilityUnit()
        set target = GetSpellTargetUnit()
        set lvl = GetUnitAbilityLevel(GetSpellAbilityUnit(), GetSpellAbilityId())
    endif
    
    set dmg = PyrolordExtraDamage + PYROLORD_W_START_DAMAGE + ( PYROLORD_W_UPGRADE_DAMAGE * lvl )

    call dummyspawn( caster, 1, 0, 0, 0 )
    call PyrolordW_Damage(bj_lastCreatedUnit, target, dmg)
    
    if GetUnitAbilityLevel( target, 'B034') > 0 then
        call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( target ), StringHash( "prlq" ) ), 0.01, false, function PyrolordQCast )
        call PyrolordW_Damage(bj_lastCreatedUnit, target, dmg)
    endif
    
    set caster = null
    set target = null
endfunction

//===========================================================================
function InitTrig_PyrolordW takes nothing returns nothing
    set gg_trg_PyrolordW = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_PyrolordW, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_PyrolordW, Condition( function Trig_PyrolordW_Conditions ) )
    call TriggerAddAction( gg_trg_PyrolordW, function Trig_PyrolordW_Actions )
endfunction

