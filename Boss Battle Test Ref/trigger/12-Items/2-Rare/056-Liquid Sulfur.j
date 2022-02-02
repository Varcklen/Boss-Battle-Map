function Trig_Liquid_Sulfur_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A0G1' and combat( GetSpellAbilityUnit(), true, GetSpellAbilityId() ) and not(udg_fightmod[3])
endfunction

function Trig_Liquid_Sulfur_Actions takes nothing returns nothing
    local unit caster
    local integer i
    local integer iEnd
    local integer k
    local item it
    
    if CastLogic() then
        set caster = udg_Target
    elseif RandomLogic() then
        set caster = udg_Caster
        call textst( udg_string[0] + GetObjectName('A0G1'), caster, 64, 90, 10, 1.5 )
    else
        set caster = GetSpellAbilityUnit()
    endif

    set i = 1
    set iEnd = eyest( caster )
    loop
        exitwhen i > iEnd
        set k = 0
        loop
            exitwhen k > 5
            set it = UnitItemInSlot(caster, k)
            if (it != null and SubString(BlzGetItemExtendedTooltip(it), 0, 16) == "|cff088a08Potion") then
                call BlzSetItemIntegerFieldBJ( it, ITEM_IF_NUMBER_OF_CHARGES, BlzGetItemIntegerField(it, ITEM_IF_NUMBER_OF_CHARGES) + 1 )
            endif
            set k = k + 1
        endloop
        set i = i + 1
    endloop
    
    call DestroyEffect( AddSpecialEffectTarget("Abilities\\Spells\\Items\\TomeOfRetraining\\TomeOfRetrainingCaster.mdl", caster, "origin" ) )

    set caster = null
    set it = null
endfunction

//===========================================================================
function InitTrig_Liquid_Sulfur takes nothing returns nothing
    set gg_trg_Liquid_Sulfur = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Liquid_Sulfur, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_Liquid_Sulfur, Condition( function Trig_Liquid_Sulfur_Conditions ) )
    call TriggerAddAction( gg_trg_Liquid_Sulfur, function Trig_Liquid_Sulfur_Actions )
endfunction

