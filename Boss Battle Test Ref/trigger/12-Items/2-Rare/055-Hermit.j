function Trig_Hermit_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A11P'
endfunction

function Trig_Hermit_Actions takes nothing returns nothing
    local integer cyclA = 0
    
    call IconFrame( "Hermit", udg_DB_BonusFrame_Icon[3], udg_DB_BonusFrame_Name[3], udg_DB_BonusFrame_Tooltip[3] )
    set udg_logic[34] = true
    
    call StartSound(gg_snd_QuestLog)
    call DestroyEffect( AddSpecialEffectTarget( "Abilities\\Spells\\Human\\Resurrect\\ResurrectTarget.mdl", GetSpellAbilityUnit(), "origin") )
    call statst( GetSpellAbilityUnit(), 1, 1, 1, 0, true )
    call stazisst( GetSpellAbilityUnit(), GetItemOfTypeFromUnitBJ( GetSpellAbilityUnit(), 'I0AS') )
endfunction

//===========================================================================
function InitTrig_Hermit takes nothing returns nothing
    set gg_trg_Hermit = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Hermit, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_Hermit, Condition( function Trig_Hermit_Conditions ) )
    call TriggerAddAction( gg_trg_Hermit, function Trig_Hermit_Actions )
endfunction

