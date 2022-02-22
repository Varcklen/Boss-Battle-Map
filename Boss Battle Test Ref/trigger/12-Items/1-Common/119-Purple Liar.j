function Trig_Purple_Liar_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A0YF'
endfunction

function Trig_Purple_Liar_Actions takes nothing returns nothing
    local integer x 
    local unit caster
    local integer heroId
    
    if CastLogic() then
        set caster = udg_Caster
    elseif RandomLogic() then
        set caster = udg_Caster
        call textst( udg_string[0] + GetObjectName('A0YF'), caster, 64, 90, 10, 1.5 )
    else
        set caster = GetSpellAbilityUnit()
    endif

    set x = eyest( caster )
    set heroId = GetUnitUserData(caster)
    call spectimeunit( caster, "Abilities\\Spells\\Human\\MarkOfChaos\\MarkOfChaosDone.mdl", "origin", 2 )
    call BlzEndUnitAbilityCooldown( caster, udg_Ability_Uniq[heroId] )
    
    set caster = null
endfunction

//===========================================================================
function InitTrig_Purple_Liar takes nothing returns nothing
    set gg_trg_Purple_Liar = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Purple_Liar, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_Purple_Liar, Condition( function Trig_Purple_Liar_Conditions ) )
    call TriggerAddAction( gg_trg_Purple_Liar, function Trig_Purple_Liar_Actions )
endfunction

