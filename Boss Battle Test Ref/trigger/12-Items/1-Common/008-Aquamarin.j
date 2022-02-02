function Trig_Aquamarin_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A0GL'
endfunction

function Trig_Aquamarin_Actions takes nothing returns nothing
    local unit caster
    local unit target
    local integer cyclA = 1
    local integer cyclAEnd
    local real dmg
    local real t
    
    if CastLogic() then
        set caster = udg_Caster
        set target = udg_Target
        set t = udg_Time
    elseif RandomLogic() then
        set caster = udg_Caster
        set target = randomtarget( caster, 900, "ally", "hero", "", "", "" )
        call textst( udg_string[0] + GetObjectName('A11H'), caster, 64, 90, 10, 1.5 )
        set t = 30
        if target == null then
            set caster = null
            return
        endif
    else
        set caster = GetSpellAbilityUnit()
        set target = GetSpellTargetUnit()
        set t = 30
    endif
    set t = timebonus(caster, t)

    set cyclAEnd = eyest( caster )
    loop
        exitwhen cyclA > cyclAEnd
        call shield( caster, target, 300, t )
        call effst( caster, target, null, 1, t )
        set cyclA = cyclA + 1
    endloop
    
    set caster = null
    set target = null
endfunction

//===========================================================================
function InitTrig_Aquamarin takes nothing returns nothing
    set gg_trg_Aquamarin = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Aquamarin, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_Aquamarin, Condition( function Trig_Aquamarin_Conditions ) )
    call TriggerAddAction( gg_trg_Aquamarin, function Trig_Aquamarin_Actions )
endfunction

