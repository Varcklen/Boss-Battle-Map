function Trig_WindTaro_Conditions takes nothing returns boolean
    return GetItemTypeId(GetManipulatedItem()) == 'I0BF'
endfunction

function Trig_WindTaro_Actions takes nothing returns nothing
    call DestroyEffect( AddSpecialEffectTarget( "Abilities\\Spells\\Demon\\DarkPortal\\DarkPortalTarget.mdl", GetManipulatingUnit(), "origin" ) )
    if GetUnitAbilityLevel( GetManipulatingUnit(), 'A13N') == 0 then
        call UnitAddAbility( GetManipulatingUnit(), 'A13N')
    elseif GetUnitAbilityLevel( GetManipulatingUnit(), 'A13N') < 10 then
        call SetUnitAbilityLevel(GetManipulatingUnit(), 'A13N', GetUnitAbilityLevel(GetManipulatingUnit(), 'A13N') + 1 )
    endif
    call stazisst( GetManipulatingUnit(), GetItemOfTypeFromUnitBJ( GetManipulatingUnit(), 'I0BF') )
endfunction

//===========================================================================
function InitTrig_WindTaro takes nothing returns nothing
    set gg_trg_WindTaro = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_WindTaro, EVENT_PLAYER_UNIT_USE_ITEM )
    call TriggerAddCondition( gg_trg_WindTaro, Condition( function Trig_WindTaro_Conditions ) )
    call TriggerAddAction( gg_trg_WindTaro, function Trig_WindTaro_Actions )
endfunction

