function Trig_PoliSub_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A14L'
endfunction

function Trig_PoliSub_Actions takes nothing returns nothing
    local integer cyclA = 1
    local integer cyclAEnd
    local unit caster
    local unit target
    local integer x
    
    if CastLogic() then
        set caster = udg_Caster
        set target = udg_Target
    elseif RandomLogic() then
        set caster = udg_Caster
        set target = randomtarget( caster, 900, "enemy", "", "", "", "" )
        call textst( udg_string[0] + GetObjectName('A032'), caster, 64, 90, 10, 1.5 )
        if target == null then
            set caster = null
            return
        endif
    else
        set caster = GetSpellAbilityUnit()
        set target = GetSpellTargetUnit()
    endif

    set x = eyest( caster )
    
    if luckylogic( caster, 75, 1, 100 ) then
        call UnitPoly( caster, target, 'n02L', 3 )
    else
        call UnitRemoveAbility( caster, 'BNsi')
        call UnitPoly( caster, caster, 'n02L', 3 )
    endif
    
    set caster = null
    set target = null
endfunction

//===========================================================================
function InitTrig_PoliSub takes nothing returns nothing
    set gg_trg_PoliSub = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_PoliSub, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_PoliSub, Condition( function Trig_PoliSub_Conditions ) )
    call TriggerAddAction( gg_trg_PoliSub, function Trig_PoliSub_Actions )
endfunction

