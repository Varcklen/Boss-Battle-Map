function Trig_MentorW_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A0NQ'
endfunction

function Trig_MentorW_Actions takes nothing returns nothing
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
        call textst( udg_string[0] + GetObjectName('A0NQ'), caster, 64, 90, 10, 1.5 )
        if target == null then
            set caster = null
            return
        endif
    else
        set caster = GetSpellAbilityUnit()
        set target = GetSpellTargetUnit()
        set lvl = GetUnitAbilityLevel(GetSpellAbilityUnit(), GetSpellAbilityId())
    endif

    set heal = 15. + ( 25. * lvl )
    
    if caster == target then
        set heal = heal * 2
    endif
    call healst( caster, target, heal )
    call DestroyEffect( AddSpecialEffectTarget( "Abilities\\Spells\\NightElf\\ManaBurn\\ManaBurnTarget.mdl", target, "origin") )
    
    set caster = null
    set target = null
endfunction

//===========================================================================
function InitTrig_MentorW takes nothing returns nothing
    set gg_trg_MentorW = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_MentorW, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_MentorW, Condition( function Trig_MentorW_Conditions ) )
    call TriggerAddAction( gg_trg_MentorW, function Trig_MentorW_Actions )
endfunction

