function Trig_InfernalQ_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A1A8'
endfunction

function Trig_InfernalQ_Actions takes nothing returns nothing
    local unit caster
    local unit target
    local integer lvl
    local real heal
    local item it
    local boolean l = false
    
    if CastLogic() then
        set caster = udg_Caster
        set target = udg_Target
        set lvl = udg_Level
    elseif RandomLogic() then
        set caster = udg_Caster
        set target = caster
        set lvl = udg_Level
        call textst( udg_string[0] + GetObjectName('A1A8'), caster, 64, 90, 10, 1.5 )
    else
        set caster = GetSpellAbilityUnit()
        set target = GetSpellTargetUnit()
        set lvl = GetUnitAbilityLevel(GetSpellAbilityUnit(), GetSpellAbilityId())
    endif
    
    set heal = 200 + (75*lvl)
    set it = GetSpellTargetItem()
    
    if GetItemTypeId(it) == 'I0G8' then
        call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\Orc\\MirrorImage\\MirrorImageDeathCaster.mdl", GetItemX( it ), GetItemY( it ) ) )
        call RemoveItem(it)
        set l = true
    elseif GetUnitAbilityLevel(caster, 'A1A6') > 1 then
        call platest(caster, -1 )
        set l = true
    endif

    if l then
        call healst( caster, target, heal )
        call DestroyEffect( AddSpecialEffectTarget( "Abilities\\Spells\\NightElf\\ManaBurn\\ManaBurnTarget.mdl", target, "origin") )
    endif
    
    set caster = null
    set target = null
    set it = null
endfunction

//===========================================================================
function InitTrig_InfernalQ takes nothing returns nothing
    set gg_trg_InfernalQ = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_InfernalQ, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_InfernalQ, Condition( function Trig_InfernalQ_Conditions ) )
    call TriggerAddAction( gg_trg_InfernalQ, function Trig_InfernalQ_Actions )
endfunction

