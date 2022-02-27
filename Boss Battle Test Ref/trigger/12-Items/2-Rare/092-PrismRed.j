function Trig_PrismRed_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A14A'
endfunction

function Trig_PrismRed_Actions takes nothing returns nothing
    local unit caster
    local unit target
    local integer cyclA = 1
    local integer cyclAEnd 
    
    if CastLogic() then
        set caster = udg_Caster
        set target = udg_Target
    elseif RandomLogic() then
        set caster = udg_Caster
        set target = randomtarget( caster, 900, "enemy", "", "", "", "" )
        call textst( udg_string[0] + GetObjectName('A14A'), caster, 64, 90, 10, 1.5 )
        if target == null then
            set caster = null
            return
        endif
    else
        set caster = GetSpellAbilityUnit()
        set target = GetSpellTargetUnit()
    endif
    
    set cyclAEnd = eyest( caster )
    call dummyspawn( caster, 1, 0, 0, 0 )
    call DestroyEffect( AddSpecialEffectTarget( "Abilities\\Spells\\Other\\Incinerate\\FireLordDeathExplode.mdl", target, "origin" ) )
    loop
        exitwhen cyclA > cyclAEnd
        call UnitDamageTarget( bj_lastCreatedUnit, target, 250, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS)
        set cyclA = cyclA + 1
    endloop
    
    set caster = null
    set target = null
endfunction

//===========================================================================
function InitTrig_PrismRed takes nothing returns nothing
    set gg_trg_PrismRed = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_PrismRed, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_PrismRed, Condition( function Trig_PrismRed_Conditions ) )
    call TriggerAddAction( gg_trg_PrismRed, function Trig_PrismRed_Actions )
endfunction

