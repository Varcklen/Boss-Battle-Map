function Trig_Cosmic_reed_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A0T7'
endfunction

function Trig_Cosmic_reed_Actions takes nothing returns nothing
    local integer cyclA = 1
    local integer cyclAEnd
    local integer i
    local unit caster
    local unit target
    
    if CastLogic() then
        set caster = udg_Caster
        set target = udg_Target
    elseif RandomLogic() then
        set caster = udg_Caster
        set target = randomtarget( caster, 900, "enemy", "", "", "", "" )
        call textst( udg_string[0] + GetObjectName('A0T7'), caster, 64, 90, 10, 1.5 )
        if target == null then
            set caster = null
            return
        endif
    else
        set caster = GetSpellAbilityUnit()
        set target = GetSpellTargetUnit()
    endif

    set i = GetPlayerId(GetOwningPlayer(caster) ) + 1
    set cyclAEnd = eyest( caster )
    call dummyspawn( caster, 1, 0, 0, 0 )
    loop
        exitwhen cyclA > cyclAEnd
        call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\NightElf\\EntanglingRoots\\EntanglingRootsTarget.mdl", GetUnitX( target ), GetUnitY( target ) ) )
        call UnitDamageTarget( bj_lastCreatedUnit, target, 0.35*udg_HealFight[i], true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS)
        set cyclA = cyclA + 1
    endloop
    
    set caster = null
    set target = null
endfunction

//===========================================================================
function InitTrig_Cosmic_reed takes nothing returns nothing
    set gg_trg_Cosmic_reed = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Cosmic_reed, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_Cosmic_reed, Condition( function Trig_Cosmic_reed_Conditions ) )
    call TriggerAddAction( gg_trg_Cosmic_reed, function Trig_Cosmic_reed_Actions )
endfunction

