function Trig_Cannibalism_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A1BL'
endfunction

function Trig_Cannibalism_Actions takes nothing returns nothing
    local unit caster
    local unit target
    
    if CastLogic() then
        set caster = udg_Target
        set target = null
    elseif RandomLogic() then
        set caster = udg_Caster
        set target = randomtarget( caster, 900, "ally", "pris", "", "", "" )
        call textst( udg_string[0] + GetObjectName('A1BL'), caster, 64, 90, 10, 1.5 )
        if target == null then
            set caster = null
            return
        endif
    else
        set caster = GetSpellAbilityUnit()
        set target = GetSpellTargetUnit()
    endif
    
    call DestroyEffect( AddSpecialEffect( "Blood Whirl.mdx", GetUnitX( target ), GetUnitY( target ) ) )
    call healst(caster, null, GetUnitState( target, UNIT_STATE_MAX_LIFE) * 1.1)
	call KillUnit(target)
    
    set target = null
    set caster = null
endfunction

//===========================================================================
function InitTrig_Cannibalism takes nothing returns nothing
    set gg_trg_Cannibalism = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Cannibalism, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_Cannibalism, Condition( function Trig_Cannibalism_Conditions ) )
    call TriggerAddAction( gg_trg_Cannibalism, function Trig_Cannibalism_Actions )
endfunction

