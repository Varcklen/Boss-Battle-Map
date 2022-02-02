function Trig_ShoggothRcopy_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A14V'
endfunction

function Trig_ShoggothRcopy_Actions takes nothing returns nothing
    local integer t
    local integer lvl
    local unit caster
    local unit target
    
    if CastLogic() then
        set caster = udg_Caster
        set target = udg_Target
        set lvl = udg_Level
    elseif RandomLogic() then
        set caster = udg_Caster
        set target = randomtarget( caster, 900, "ally", "pris", "", "", "" )
        call textst( udg_string[0] + GetObjectName('A14V'), caster, 64, 90, 10, 1.5 )
        set lvl = udg_Level
        if target == null then
            set caster = null
            return
        endif
    else
        set caster = GetSpellAbilityUnit()
        set target = GetSpellTargetUnit()
        set lvl = GetUnitAbilityLevel(GetSpellAbilityUnit(), GetSpellAbilityId())
    endif
    
    call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\Orc\\MirrorImage\\MirrorImageDeathCaster.mdl", GetUnitX( target ), GetUnitY( target ) ) )
        call ShowUnit( target, false)
        set bj_lastCreatedUnit = CreateUnit(GetOwningPlayer(target), 'z000', GetUnitX(target), GetUnitY(target), GetUnitFacing(target))
        call KillUnit( target )
	call UnitApplyTimedLife( bj_lastCreatedUnit , 'BTLF', 5 + (5*lvl) )
    
    set caster = null
    set target = null
endfunction

//===========================================================================
function InitTrig_ShoggothRcopy takes nothing returns nothing
    set gg_trg_ShoggothRcopy = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_ShoggothRcopy, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_ShoggothRcopy, Condition( function Trig_ShoggothRcopy_Conditions ) )
    call TriggerAddAction( gg_trg_ShoggothRcopy, function Trig_ShoggothRcopy_Actions )
endfunction

