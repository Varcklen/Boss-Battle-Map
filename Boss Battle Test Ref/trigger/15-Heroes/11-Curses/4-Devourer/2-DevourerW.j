function Trig_DevourerW_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A10H'
endfunction

function Trig_DevourerW_Actions takes nothing returns nothing
    local unit caster
    local unit target
    local integer rand
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
        call textst( udg_string[0] + GetObjectName('A10H'), caster, 64, 90, 10, 1.5 )
        if target == null then
            set caster = null
            return
        endif
    else
        set caster = GetSpellAbilityUnit()
        set target = GetSpellTargetUnit()
        set lvl = GetUnitAbilityLevel(GetSpellAbilityUnit(), GetSpellAbilityId())
    endif
    
    set dmg = 150 + ( 50 * lvl )
    call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\Undead\\AnimateDead\\AnimateDeadTarget.mdl", GetUnitX( target ), GetUnitY( target ) ) )
    call dummyspawn( caster, 1, 0, 0, 0 )
    call UnitDamageTarget( bj_lastCreatedUnit, target, dmg, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS)
    
    if not( udg_fightmod[3] ) and combat( caster, false, 0 ) then
        call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\Undead\\AnimateDead\\AnimateDeadTarget.mdl", GetUnitX( caster ), GetUnitY( caster ) ) )
        set rand = GetRandomInt(1, 3)
        if rand == 1 then
            call statst( caster, 2, 0, 0, 168, true )
            call textst( "|c00FF2020 +2 strength", caster, 64, 90, 10, 1 )
        elseif rand == 2 then
            call statst( caster, 0, 2, 0, 172, true )
            call textst( "|c0020FF20 +2 agility", caster, 64, 90, 10, 1 )
        elseif rand == 3 then
            call statst( caster, 0, 0, 2, 176, true )
            call textst( "|c002020FF +2 intelligence", caster, 64, 90, 10, 1 )
        endif
    endif
    
    set caster = null
    set target = null
endfunction

//===========================================================================
function InitTrig_DevourerW takes nothing returns nothing
    set gg_trg_DevourerW = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_DevourerW, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_DevourerW, Condition( function Trig_DevourerW_Conditions ) )
    call TriggerAddAction( gg_trg_DevourerW, function Trig_DevourerW_Actions )
endfunction

