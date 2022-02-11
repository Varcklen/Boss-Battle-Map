function Trig_OldHealer_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A14T'
endfunction

function Trig_OldHealer_Actions takes nothing returns nothing
    local integer cyclA = 1
    local integer cyclAEnd 
    local unit caster
    local unit target
    local real dmg
    
    if CastLogic() then
        set caster = udg_Caster
        set target = udg_Target
    elseif RandomLogic() then
        set caster = udg_Caster
        set target = randomtarget( caster, 900, "ally", "notfull", "", "", "" )
        call textst( udg_string[0] + GetObjectName('A14T'), caster, 64, 90, 10, 1.5 )
        if target == null then
            set caster = null
            return
        endif
    else
        set caster = GetSpellAbilityUnit()
        set target = GetSpellTargetUnit()
    endif

    set cyclAEnd = eyest( caster )
    set dmg = 300. + ( 100. * ( SetCount_GetPieces(caster, SET_MECH) - 1 ) )

    loop
        exitwhen cyclA > cyclAEnd
        call healst( caster, target, dmg )
        call DestroyEffect( AddSpecialEffectTarget( "Abilities\\Spells\\Orc\\MirrorImage\\MirrorImageDeathCaster.mdl", target, "origin" ) )
        call DestroyEffect( AddSpecialEffectTarget( "Abilities\\Spells\\Orc\\MirrorImage\\MirrorImageDeathCaster.mdl", target, "head" ) )
        call DestroyEffect( AddSpecialEffectTarget( "Abilities\\Spells\\Orc\\MirrorImage\\MirrorImageDeathCaster.mdl", target, "chest" ) )
        set cyclA = cyclA + 1
    endloop
    
    set caster = null
    set target = null
endfunction

//===========================================================================
function InitTrig_OldHealer takes nothing returns nothing
    set gg_trg_OldHealer = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_OldHealer, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_OldHealer, Condition( function Trig_OldHealer_Conditions ) )
    call TriggerAddAction( gg_trg_OldHealer, function Trig_OldHealer_Actions )
endfunction

