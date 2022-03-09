function Trig_BunnieE_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A1BB'
endfunction

function Trig_BunnieE_Actions takes nothing returns nothing
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
        call textst( udg_string[0] + GetObjectName('A1BB'), caster, 64, 90, 10, 1.5 )
        if target == null then
            set caster = null
            return
        endif
    else
        set caster = GetSpellAbilityUnit()
        set target = GetSpellTargetUnit()
        set lvl = LoadInteger( udg_hash, GetHandleId( caster ), StringHash( "rlbae" ) )
    endif
    set dmg = 150 + ( 50 * lvl )
    
    call DestroyEffect( AddSpecialEffectTarget("Abilities\\Spells\\Other\\Stampede\\StampedeMissileDeath.mdl", target, "chest") )
    call dummyspawn( caster, 1, 0, 0, 0 )
    call UnitDamageTarget(bj_lastCreatedUnit, target, dmg, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS)
    call UnitStun(caster, caster, 3 )
    
    set caster = null
    set target = null
endfunction

//===========================================================================
function InitTrig_BunnieE takes nothing returns nothing
    set gg_trg_BunnieE = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_BunnieE, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_BunnieE, Condition( function Trig_BunnieE_Conditions ) )
    call TriggerAddAction( gg_trg_BunnieE, function Trig_BunnieE_Actions )
endfunction

