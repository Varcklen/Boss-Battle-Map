function Trig_Manashtorm_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A14H'
endfunction

function Trig_Manashtorm_Actions takes nothing returns nothing
    local integer cyclA = 1
    local integer cyclAEnd
    local integer id
    local unit caster
    local unit target
    
    if CastLogic() then
        set caster = udg_Caster
        set target = udg_Target
    elseif RandomLogic() then
        set caster = udg_Caster
        set target = randomtarget( caster, 900, "ally", "pris", "", "", "" )
        call textst( udg_string[0] + GetObjectName('A0KJ'), caster, 64, 90, 10, 1.5 )
        if target == null then
            set caster = null
            return
        endif
    else
        set caster = GetSpellAbilityUnit()
        set target = GetSpellTargetUnit()
    endif

    set cyclAEnd = eyest( caster )
    set id = GetHandleId( caster )

    call DestroyEffect( AddSpecialEffect( "Objects\\Spawnmodels\\Naga\\NagaDeath\\NagaDeath.mdl", GetUnitX( target ), GetUnitY( target ) ) )
    loop
        exitwhen cyclA > cyclAEnd
        call KillUnit( target )
        call manast( caster, null, GetUnitState( caster, UNIT_STATE_MAX_MANA ) * 0.05 )
        set cyclA = cyclA + 1
    endloop
    
    set caster = null
    set target = null
endfunction

//===========================================================================
function InitTrig_Manashtorm takes nothing returns nothing
    set gg_trg_Manashtorm = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Manashtorm, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_Manashtorm, Condition( function Trig_Manashtorm_Conditions ) )
    call TriggerAddAction( gg_trg_Manashtorm, function Trig_Manashtorm_Actions )
endfunction

