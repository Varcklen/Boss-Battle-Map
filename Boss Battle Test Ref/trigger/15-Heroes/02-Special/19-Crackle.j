function Trig_Crackle_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A07H'
endfunction

function Trig_Crackle_Actions takes nothing returns nothing
    local unit caster
    local unit target
    local real t
    
    if CastLogic() then
        set caster = udg_Caster
        set target = udg_Target
    elseif RandomLogic() then
        set caster = udg_Caster
        set target = randomtarget( caster, 900, "enemy", "", "", "", "" )
        call textst( udg_string[0] + GetObjectName('A07H'), caster, 64, 90, 10, 1.5 )
        if target == null then
            set caster = null
            return
        endif
    else
        set caster = GetSpellAbilityUnit()
        set target = GetSpellTargetUnit()
    endif
    set t = timebonus(caster, 1.5)

    if GetUnitState( target, UNIT_STATE_LIFE) <= 0.4*GetUnitState( target, UNIT_STATE_MAX_LIFE) then
        set t = t * 2
    endif

    call UnitStun(caster, target, t )
    call DestroyEffect( AddSpecialEffect("Abilities\\Spells\\Other\\Monsoon\\MonsoonBoltTarget.mdl", GetUnitX( target ), GetUnitY( target ) ) )
    call DestroyEffect( AddSpecialEffect("Abilities\\Weapons\\FarseerMissile\\FarseerMissile.mdl", GetUnitX( target ), GetUnitY( target ) ) )
    
    set caster = null
    set target = null
endfunction

//===========================================================================
function InitTrig_Crackle takes nothing returns nothing
    set gg_trg_Crackle = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Crackle, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_Crackle, Condition( function Trig_Crackle_Conditions ) )
    call TriggerAddAction( gg_trg_Crackle, function Trig_Crackle_Actions )
endfunction

