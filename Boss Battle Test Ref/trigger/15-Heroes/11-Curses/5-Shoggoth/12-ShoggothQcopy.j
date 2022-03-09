function Trig_ShoggothQcopy_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A0YQ'
endfunction

function Trig_ShoggothQcopy_Actions takes nothing returns nothing 
    local unit caster
    local unit target
    local integer lvl
    
    if CastLogic() then
        set caster = udg_Caster
        set target = udg_Target
        set lvl = udg_Level
    elseif RandomLogic() then
        set caster = udg_Caster
        set target = randomtarget( caster, 900, "enemy", "", "", "", "" )
        set lvl = udg_Level
        call textst( udg_string[0] + GetObjectName('A0YQ'), caster, 64, 90, 10, 1.5 )
        if target == null then
            set caster = null
            return
        endif
    else
        set caster = GetSpellAbilityUnit()
        set target = GetSpellTargetUnit()
        set lvl = GetUnitAbilityLevel(GetSpellAbilityUnit(), GetSpellAbilityId())
    endif

    call UnitAddAbility( target, 'A0ZC' )
	call SetUnitAbilityLevel( target, 'A0ZC', lvl )
	call UnitAddAbility( target, 'A11W' )

    set caster = null
    set target = null
endfunction

//===========================================================================
function InitTrig_ShoggothQcopy takes nothing returns nothing
    set gg_trg_ShoggothQcopy = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_ShoggothQcopy, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_ShoggothQcopy, Condition( function Trig_ShoggothQcopy_Conditions ) )
    call TriggerAddAction( gg_trg_ShoggothQcopy, function Trig_ShoggothQcopy_Actions )
endfunction