function Trig_Provoke_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A088' or GetSpellAbilityId() == 'A036' or GetSpellAbilityId() == 'A0RM' or GetSpellAbilityId() == 'A0RE'
endfunction

function Trig_Provoke_Actions takes nothing returns nothing
    local unit caster
    local unit target
    local real t
    local integer x
    
    if CastLogic() then
        set caster = udg_Caster
        set target = udg_Target
    elseif RandomLogic() then
        set caster = udg_Caster
        set target = randomtarget( caster, 600, "enemy", "org", "", "", "" )
        call textst( udg_string[0] + GetObjectName('A088'), caster, 64, 90, 10, 1.5 )
        if target == null then
            set caster = null
            return
        endif
    else
        set caster = GetSpellAbilityUnit()
        set target = GetSpellTargetUnit()
    endif
    set t = timebonus(caster, 4)

    if not( IsUnitType( target, UNIT_TYPE_ANCIENT) ) then
        set t = t * 5
    endif

    call DestroyEffect( AddSpecialEffectTarget("Abilities\\Spells\\NightElf\\Taunt\\TauntCaster.mdl" , caster, "origin" ) )
    
	call taunt( caster, target, t )
    
    set caster = null
    set target = null
endfunction

//===========================================================================
function InitTrig_Provoke takes nothing returns nothing
    set gg_trg_Provoke = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Provoke, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_Provoke, Condition( function Trig_Provoke_Conditions ) )
    call TriggerAddAction( gg_trg_Provoke, function Trig_Provoke_Actions )
endfunction

