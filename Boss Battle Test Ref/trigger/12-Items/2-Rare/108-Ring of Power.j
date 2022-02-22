function Trig_Ring_of_Power_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A144'
endfunction

function Trig_Ring_of_Power_Actions takes nothing returns nothing
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
        set target = randomtarget( caster, 900, "enemy", "pris", "", "", "" )
        call textst( udg_string[0] + GetObjectName('A0EO'), caster, 64, 90, 10, 1.5 )
        if target == null then
            set caster = null
            return
        endif
    else
        set caster = GetSpellAbilityUnit()
        set target = GetSpellTargetUnit()
    endif
    
    call AddSpecialEffectTarget( "Abilities\\Spells\\NightElf\\FaerieDragonInvis\\FaerieDragon_Invis.mdl", target, "head")
    call UnitApplyTimedLife( target, 'BTLF', 30.)
    call SetUnitOwner( target, GetOwningPlayer( caster ), true )
    
    set caster = null
    set target = null
endfunction

//===========================================================================
function InitTrig_Ring_of_Power takes nothing returns nothing
    set gg_trg_Ring_of_Power = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Ring_of_Power, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_Ring_of_Power, Condition( function Trig_Ring_of_Power_Conditions ) )
    call TriggerAddAction( gg_trg_Ring_of_Power, function Trig_Ring_of_Power_Actions )
endfunction

