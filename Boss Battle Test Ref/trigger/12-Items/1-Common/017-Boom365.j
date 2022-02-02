function Trig_Boom365_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A0OS'
endfunction

function Trig_Boom365_Actions takes nothing returns nothing
    local integer cyclA = 1
    local integer cyclAEnd
    local unit caster
    local unit target
    
    if CastLogic() then
        set caster = udg_Caster
        set target = udg_Target
    elseif RandomLogic() then
        set caster = udg_Caster
        set target = randomtarget( caster, 900, "enemy", "", "", "", "" )
        call textst( udg_string[0] + GetObjectName('A0OS'), caster, 64, 90, 10, 1.5 )
        if target == null then
            set caster = null
            return
        endif
    else
        set caster = GetSpellAbilityUnit()
        set target = GetSpellTargetUnit()
    endif
    
    set cyclAEnd = eyest( caster )
    call DestroyEffect( AddSpecialEffectTarget( "Abilities\\Spells\\Other\\Incinerate\\FireLordDeathExplode.mdl", caster, "origin") )
    call DestroyEffect( AddSpecialEffectTarget( "Abilities\\Spells\\Other\\Incinerate\\FireLordDeathExplode.mdl", target, "origin" ) )
    loop
        exitwhen cyclA > cyclAEnd
        call UnitStun(caster, target, 6 )
        call UnitStun(caster, caster, 6 )
        set cyclA = cyclA + 1
    endloop

    set caster = null
    set target = null
endfunction

//===========================================================================
function InitTrig_Boom365 takes nothing returns nothing
    set gg_trg_Boom365 = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Boom365, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_Boom365, Condition( function Trig_Boom365_Conditions ) )
    call TriggerAddAction( gg_trg_Boom365, function Trig_Boom365_Actions )
endfunction

