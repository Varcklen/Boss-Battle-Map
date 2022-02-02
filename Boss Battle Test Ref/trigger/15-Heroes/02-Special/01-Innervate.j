function Trig_Innervate_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A19N'
endfunction

function Trig_Innervate_Actions takes nothing returns nothing
    local unit caster
    local unit target
    local real heal
    
    if CastLogic() then
        set caster = udg_Caster
        set target = udg_Target
    elseif RandomLogic() then
        set caster = udg_Caster
        set target = randomtarget( caster, 900, "ally", "notfull", "", "", "" )
        call textst( udg_string[0] + GetObjectName('A19N'), caster, 64, 90, 10, 1.5 )
        if target == null then
            set caster = null
            return
        endif
    else
        set caster = GetSpellAbilityUnit()
        set target = GetSpellTargetUnit()
    endif
    
    set heal = 100
    
    if GetUnitState( target, UNIT_STATE_LIFE) <= 0.4*GetUnitState( target, UNIT_STATE_MAX_LIFE) then
        call shield( caster, target, heal, 60 )
    endif
    
    call healst( caster, target, heal )
    call DestroyEffect( AddSpecialEffectTarget("Objects\\Spawnmodels\\NightElf\\EntBirthTarget\\EntBirthTarget.mdl" , target, "origin" ) )
    
    set caster = null
    set target = null
endfunction

//===========================================================================
function InitTrig_Innervate takes nothing returns nothing
    set gg_trg_Innervate = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Innervate, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_Innervate, Condition( function Trig_Innervate_Conditions ) )
    call TriggerAddAction( gg_trg_Innervate, function Trig_Innervate_Actions )
endfunction

