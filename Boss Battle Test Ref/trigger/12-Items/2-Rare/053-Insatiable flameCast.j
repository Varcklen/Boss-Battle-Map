function Trig_Insatiable_flameCast_Conditions takes nothing returns boolean
    return combat(GetSpellAbilityUnit(), false, 0) and not( udg_fightmod[3] ) and inv( GetSpellAbilityUnit(), 'I0DY' ) > 0 and GetSpellAbilityId() != 'A0OK'
endfunction

function Trig_Insatiable_flameCast_Actions takes nothing returns nothing
    local item it = GetItemOfTypeFromUnitBJ( GetSpellAbilityUnit(), 'I0DY')
    local ability ab
    
    if it != null then
        set ab = BlzGetItemAbility( it, 'A0OK' )
        if ab != null then
            call BlzSetAbilityIntegerLevelFieldBJ( ab, ABILITY_ILF_MANA_COST, 0, IMaxBJ(0,BlzGetAbilityIntegerLevelField(ab, ABILITY_ILF_MANA_COST, 0) - 5) )
        endif
    endif

    set ab = null
    set it = null
endfunction

//===========================================================================
function InitTrig_Insatiable_flameCast takes nothing returns nothing
    set gg_trg_Insatiable_flameCast = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Insatiable_flameCast, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_Insatiable_flameCast, Condition( function Trig_Insatiable_flameCast_Conditions ) )
    call TriggerAddAction( gg_trg_Insatiable_flameCast, function Trig_Insatiable_flameCast_Actions )
endfunction

