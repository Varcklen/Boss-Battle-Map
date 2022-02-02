function Trig_Antonidas_Symbol_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A14N'
endfunction

function Trig_Antonidas_Symbol_Actions takes nothing returns nothing
    local integer cyclA = 1
    local integer cyclAEnd
    local unit caster
    local unit target
    
    if CastLogic() then
        set caster = udg_Caster
        set target = udg_Target
    elseif RandomLogic() then
        set caster = udg_Caster
        set target = randomtarget( caster, 900, "enemy", "pris", "", "", "" )
        call textst( udg_string[0] + GetObjectName('A14N'), caster, 64, 90, 10, 1.5 )
        if target == null then
            set caster = null
            return
        endif
    else
        set caster = GetSpellAbilityUnit()
        set target = GetSpellTargetUnit()
    endif
    
    set cyclAEnd = eyest( caster )
    
    call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\Human\\Polymorph\\PolyMorphDoneGround.mdl", GetUnitX( target ), GetUnitY( target ) ) )
    loop
        exitwhen cyclA > cyclAEnd
        call ShowUnit( target, false)
        set bj_lastCreatedUnit = CreateUnit(GetOwningPlayer(target), ID_SHEEP, GetUnitX(target), GetUnitY(target), GetUnitFacing(target))
        call KillUnit( target )
        set target = bj_lastCreatedUnit
        set cyclA = cyclA + 1
    endloop
    
    set caster = null
    set target = null
endfunction

//===========================================================================
function InitTrig_Antonidas_Symbol takes nothing returns nothing
    set gg_trg_Antonidas_Symbol = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Antonidas_Symbol, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_Antonidas_Symbol, Condition( function Trig_Antonidas_Symbol_Conditions ) )
    call TriggerAddAction( gg_trg_Antonidas_Symbol, function Trig_Antonidas_Symbol_Actions )
endfunction