function Trig_Jester_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A0DB'
endfunction

function Trig_Jester_Actions takes nothing returns nothing
    local integer cyclA = 0

    loop
        exitwhen cyclA > 5
        if ( GetSpellTargetItem() == UnitItemInSlot( GetSpellAbilityUnit(), cyclA ) ) and ( GetItemTypeId(GetSpellTargetItem()) != 'I02C' ) and ( GetItemType(GetSpellTargetItem()) != ITEM_TYPE_POWERUP ) then
            call RemoveItem( GetSpellTargetItem() )
            call AddSpecialEffectTarget( "Abilities\\Spells\\Other\\Doom\\DoomDeath.mdl", GetSpellAbilityUnit(), "origin")
            call stazisst( GetSpellAbilityUnit(), GetItemOfTypeFromUnitBJ( GetSpellAbilityUnit(), 'I02C') )
            set cyclA = 5
        endif
        set cyclA = cyclA + 1
    endloop
endfunction

//===========================================================================
function InitTrig_Jester takes nothing returns nothing
    set gg_trg_Jester = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Jester, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_Jester, Condition( function Trig_Jester_Conditions ) )
    call TriggerAddAction( gg_trg_Jester, function Trig_Jester_Actions )
endfunction

