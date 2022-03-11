function Trig_MentorR_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A0NT'
endfunction

function Trig_MentorR_Actions takes nothing returns nothing
    local unit caster
    local unit target
    local integer lvl
    local real heal
    
    if CastLogic() then
        set caster = udg_Caster
        set target = udg_Target
        set lvl = udg_Level
    elseif RandomLogic() then
        set caster = udg_Caster
        set target = randomtarget( caster, 900, "ally", "notfull", "", "", "" )
        set lvl = udg_Level
        call textst( udg_string[0] + GetObjectName('A0NT'), caster, 64, 90, 10, 1.5 )
        if target == null then
            set caster = null
            return
        endif
    else
        set caster = GetSpellAbilityUnit()
        set target = GetSpellTargetUnit()
        set lvl = GetUnitAbilityLevel(GetSpellAbilityUnit(), GetSpellAbilityId())
    endif
    
    set heal = GetUnitState(caster, UNIT_STATE_MANA) * ( 0.60 + ( 0.15 * lvl ) )
 
    call healst( caster, target, heal )
    call DestroyEffect( AddSpecialEffectTarget( "Abilities\\Spells\\Orc\\MirrorImage\\MirrorImageCaster.mdl", target, "origin" ) )
    
    set caster = null
    set target = null
endfunction

//===========================================================================
function InitTrig_MentorR takes nothing returns nothing
    set gg_trg_MentorR = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_MentorR, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_MentorR, Condition( function Trig_MentorR_Conditions ) )
    call TriggerAddAction( gg_trg_MentorR, function Trig_MentorR_Actions )
endfunction

