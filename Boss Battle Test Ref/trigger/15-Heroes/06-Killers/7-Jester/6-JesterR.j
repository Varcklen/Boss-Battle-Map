function Trig_JesterR_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A0ON'
endfunction

function Trig_JesterR_Actions takes nothing returns nothing
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
        call textst( udg_string[0] + GetObjectName('A0ON'), caster, 64, 90, 10, 1.5 )
        if target == null then
            set caster = null
            return
        endif
    else
        set caster = GetSpellAbilityUnit()
        set target = GetSpellTargetUnit()
        set lvl = GetUnitAbilityLevel(GetSpellAbilityUnit(), GetSpellAbilityId())
    endif
    set dmg = 40 + ( 10 * lvl ) + ( (5 + (5*lvl))*LoadInteger( udg_hash, GetHandleId( target ), StringHash( "jpsng" ) ) )
    
    call dummyspawn( caster, 1, 0, 0, 0 )
    call DestroyEffect( AddSpecialEffect( "Objects\\Spawnmodels\\Undead\\UndeadLargeDeathExplode\\UndeadLargeDeathExplode.mdl", GetUnitX( target), GetUnitY( target ) ) )
    call UnitDamageTarget( bj_lastCreatedUnit, target, dmg, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS)
    
    set caster = null
    set target = null
endfunction

//===========================================================================
function InitTrig_JesterR takes nothing returns nothing
    set gg_trg_JesterR = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_JesterR, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_JesterR, Condition( function Trig_JesterR_Conditions ) )
    call TriggerAddAction( gg_trg_JesterR, function Trig_JesterR_Actions )
endfunction

