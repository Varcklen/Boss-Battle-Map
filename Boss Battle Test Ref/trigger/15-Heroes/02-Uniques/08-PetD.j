function Trig_PetD_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A0MW' or GetSpellAbilityId() == 'A084'
endfunction

function Trig_PetD_Actions takes nothing returns nothing
    local integer lvl
    local real i
    local real heal
    local unit caster
    local unit target
  
    if CastLogic() then
        set caster = udg_Caster
        set target = udg_Target
    elseif RandomLogic() then
        set caster = udg_Caster
        set target = randomtarget( caster, 900, "ally", "pris", "notfull", "", "" )
        call textst( udg_string[0] + GetObjectName('A0MW'), caster, 64, 90, 10, 1.5 )
        if target == null then
            set caster = null
            return
        endif
    else
        set caster = GetSpellAbilityUnit()
        set target = GetSpellTargetUnit()
    endif
    
    if IsUnitType( target, UNIT_TYPE_ANCIENT) == false and IsUnitType( target, UNIT_TYPE_HERO) == false then
        set i = 0.50
        if IsUniqueUpgraded(caster) then
            set i = i*2
        endif

        set heal = GetUnitState( target, UNIT_STATE_MAX_LIFE) * i
        
        call healst( caster, target, heal )
        call spectimeunit( target, "Abilities\\Spells\\Human\\Heal\\HealTarget.mdl", "origin", 2 )
    endif
    
    set target = null
    set caster = null
endfunction

//===========================================================================
function InitTrig_PetD takes nothing returns nothing
    set gg_trg_PetD = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_PetD, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_PetD, Condition( function Trig_PetD_Conditions ) )
    call TriggerAddAction( gg_trg_PetD, function Trig_PetD_Actions )
endfunction

