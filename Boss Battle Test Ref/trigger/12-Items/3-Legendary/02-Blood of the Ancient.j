function Trig_Blood_of_the_Ancient_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A0HV'
endfunction

function Trig_Blood_of_the_Ancient_Actions takes nothing returns nothing
    local integer id
    local integer i
    local unit caster
    local unit target
    local integer lvl
    local real t
    local real heal
    
    if CastLogic() then
        set caster = udg_Caster
        set target = udg_Target
        set lvl = udg_Level
        set t = udg_Time
    elseif RandomLogic() then
        set caster = udg_Caster
        set target = randomtarget( caster, 900, "ally", "", "", "", "" )
        set lvl = udg_Level
        call textst( udg_string[0] + GetObjectName('A0HV'), caster, 64, 90, 10, 1.5 )
        set t = 25
        if target == null then
            set caster = null
            return
        endif
    else
        set caster = GetSpellAbilityUnit()
        set target = GetSpellTargetUnit()
        set lvl = GetUnitAbilityLevel(GetSpellAbilityUnit(), GetSpellAbilityId())
        set t = 25
    endif
    set t = timebonus(caster, t)
    
    call eyest( caster )
    call DestroyEffect(AddSpecialEffectTarget("Blood Explosion.mdx", caster, "origin") )
    call bufst( caster, caster, 'A0IU', 'B07T', "bota", t )

    call effst( caster, target, null, lvl, t )
    
    set caster = null
    set target = null
endfunction

//===========================================================================
function InitTrig_Blood_of_the_Ancient takes nothing returns nothing
    set gg_trg_Blood_of_the_Ancient = CreateTrigger( )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Blood_of_the_Ancient, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_Blood_of_the_Ancient, Condition( function Trig_Blood_of_the_Ancient_Conditions ) )
    call TriggerAddAction( gg_trg_Blood_of_the_Ancient, function Trig_Blood_of_the_Ancient_Actions )
endfunction

