function Trig_BuggerW_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A0MX'
endfunction

function Trig_BuggerW_Actions takes nothing returns nothing
    local integer lvl
    local unit caster
    local unit pet
    local real t
    
    if CastLogic() then
        set caster = udg_Caster
        set pet = null
        set lvl = udg_Level
        set t = udg_Time
    elseif RandomLogic() then
        set caster = udg_Caster
        set lvl = udg_Level
        set pet = null
        call textst( udg_string[0] + GetObjectName('A0MX'), caster, 64, 90, 10, 1.5 )
        set t = 4 + (2*lvl)
    else
        set caster = GetSpellAbilityUnit()
        set lvl = GetUnitAbilityLevel(GetSpellAbilityUnit(), GetSpellAbilityId())
        set t = 4 + (2*lvl)
    endif
    set t = timebonus(caster, t)

    set pet = LoadUnitHandle( udg_hash, GetHandleId( caster ), StringHash( "bggr" ) )
    
    call bufst( caster, caster, 'A0N9', 'B033', "bggr", t/2 )
    call effst( caster, caster, null, lvl, t )
    call DestroyEffect( AddSpecialEffectTarget( "Abilities\\Spells\\Items\\SpellShieldAmulet\\SpellShieldCaster.mdl", caster, "origin" ) )
    
    if GetUnitState( pet, UNIT_STATE_LIFE ) > 0.405 and GetOwningPlayer(caster) == GetOwningPlayer(pet) and pet != null then
        call bufst( caster, pet, 'A0N9', 'B033', "bggr", t )
        call effst( caster, pet, null, lvl, t )
        call DestroyEffect( AddSpecialEffectTarget( "Abilities\\Spells\\Items\\SpellShieldAmulet\\SpellShieldCaster.mdl", pet, "origin" ) )
    endif
    
    set pet = null
    set caster = null
endfunction

//===========================================================================
function InitTrig_BuggerW takes nothing returns nothing
    set gg_trg_BuggerW = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_BuggerW, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_BuggerW, Condition( function Trig_BuggerW_Conditions ) )
    call TriggerAddAction( gg_trg_BuggerW, function Trig_BuggerW_Actions )
endfunction

