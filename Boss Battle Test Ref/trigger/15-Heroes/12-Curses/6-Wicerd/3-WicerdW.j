globals
    constant real COOL_WICERD_W_STUN_DURATION = 5
endglobals

function Trig_WicerdW_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A17M'
endfunction

function Trig_WicerdW_Actions takes nothing returns nothing
    local unit caster
    local unit target
    local integer lvl
    local real dmg
    local real t
    
    if CastLogic() then
        set caster = udg_Caster
        set target = udg_Target
        set lvl = udg_Level
	set t = udg_Time
    elseif RandomLogic() then
        set caster = udg_Caster
        set target = randomtarget( caster, 900, "all", "notcaster", "", "", "" )
        set lvl = udg_Level
	set t = 10
        call textst( udg_string[0] + GetObjectName('A17M'), caster, 64, 90, 10, 1.5 )
        if target == null then
            set caster = null
            return
        endif
    else
        set caster = GetSpellAbilityUnit()
        set target = GetSpellTargetUnit()
        set lvl = GetUnitAbilityLevel(GetSpellAbilityUnit(), GetSpellAbilityId())
	set t = 10
    endif
    set dmg = 50 + ( 50 * lvl )
    set t = timebonus(caster, t)
    
    call DestroyEffect( AddSpecialEffect( "Abilities\\Weapons\\FrostWyrmMissile\\FrostWyrmMissile.mdl", GetUnitX(target), GetUnitY(target) ) )
    if GetUnitAbilityLevel( target, 'B07J' ) > 0 or GetUnitAbilityLevel( target, 'B07K' ) > 0 then
    	call dummyspawn( caster, 1, 0, 0, 0 )
    	call UnitDamageTarget(bj_lastCreatedUnit, target, dmg, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS)
        call UnitStun(caster, target, COOL_WICERD_W_STUN_DURATION )
    endif
    call freezest( caster, target, t, lvl )
    
    set caster = null
    set target = null
endfunction

//===========================================================================
function InitTrig_WicerdW takes nothing returns nothing
    set gg_trg_WicerdW = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_WicerdW, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_WicerdW, Condition( function Trig_WicerdW_Conditions ) )
    call TriggerAddAction( gg_trg_WicerdW, function Trig_WicerdW_Actions )
endfunction

