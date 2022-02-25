function Trig_Chameleon_Tarot_Conditions takes nothing returns boolean
    return GetItemTypeId(GetManipulatedItem()) == 'I0EL'
endfunction

function Trig_Chameleon_Tarot_Actions takes nothing returns nothing
    local integer i = GetPlayerId(GetOwningPlayer(GetManipulatingUnit())) + 1
    local integer cyclA
    local item it
    
    call DestroyEffect( AddSpecialEffectTarget( "Abilities\\Spells\\Human\\Resurrect\\ResurrectTarget.mdl", GetManipulatingUnit(), "origin") )
    call statst( GetManipulatingUnit(), 1, 1, 1, 0, true )
    call stazisst( GetManipulatingUnit(), GetItemOfTypeFromUnitBJ( GetManipulatingUnit(), 'I0EL') )
    
    set cyclA = 0
    loop
        exitwhen cyclA > 5
        set it = UnitItemInSlot(GetManipulatingUnit(), cyclA)
        if it != null then
            call BlzSetItemIconPath( it, "|cff00cceeChameleon|r|n" + BlzGetItemDescription(it) )
            call BlzSetItemDescription( it, "|cff00cceeChameleon|r|n" + BlzGetItemDescription(it) )
        endif
        set cyclA = cyclA + 1
    endloop
    
    set it = null
endfunction

//===========================================================================
function InitTrig_Chameleon_Tarot takes nothing returns nothing
    set gg_trg_Chameleon_Tarot = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Chameleon_Tarot, EVENT_PLAYER_UNIT_USE_ITEM )
    call TriggerAddCondition( gg_trg_Chameleon_Tarot, Condition( function Trig_Chameleon_Tarot_Conditions ) )
    call TriggerAddAction( gg_trg_Chameleon_Tarot, function Trig_Chameleon_Tarot_Actions )
endfunction

