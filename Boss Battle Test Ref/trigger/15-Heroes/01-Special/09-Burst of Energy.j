function Trig_Burst_of_Energy_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A1AF'
endfunction

function Trig_Burst_of_Energy_Actions takes nothing returns nothing
    local unit caster
    local unit target
    local real mana
    
    if CastLogic() then
        set caster = udg_Caster
        set target = udg_Target
    elseif RandomLogic() then
        set caster = udg_Caster
        set target = randomtarget( caster, 900, "ally", "", "", "", "" )
        call textst( udg_string[0] + GetObjectName('A1AF'), caster, 64, 90, 10, 1.5 )
        if target == null then
            set caster = null
            return
        endif
    else
        set caster = GetSpellAbilityUnit()
        set target = GetSpellTargetUnit()
    endif
    
    set mana = 35
    
    if GetUnitAbilityLevel( target, 'B05P') > 0 then
        set mana = mana*2
    endif
    
    call manast( caster, target, mana )
    call DestroyEffect( AddSpecialEffectTarget("Abilities\\Spells\\Undead\\FreezingBreath\\FreezingBreathMissile.mdl" , target, "origin" ) )
    
    set caster = null
    set target = null
endfunction

//===========================================================================
function InitTrig_Burst_of_Energy takes nothing returns nothing
    set gg_trg_Burst_of_Energy = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Burst_of_Energy, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_Burst_of_Energy, Condition( function Trig_Burst_of_Energy_Conditions ) )
    call TriggerAddAction( gg_trg_Burst_of_Energy, function Trig_Burst_of_Energy_Actions )
endfunction

