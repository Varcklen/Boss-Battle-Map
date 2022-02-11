function Trig_Contract_Conditions takes nothing returns boolean
    return GetItemTypeId(GetManipulatedItem()) == 'I0BB'
endfunction

function Trig_Contract_Actions takes nothing returns nothing
    local integer i = 0
    local integer cyclA = 0
    
    call stazisst( GetManipulatingUnit(), GetManipulatedItem() )
    
    loop
        exitwhen cyclA > 5
        if UnitHasItem(GetManipulatingUnit(), UnitItemInSlot(GetManipulatingUnit(), cyclA)) and GetItemType(UnitItemInSlot(GetManipulatingUnit(), cyclA)) != ITEM_TYPE_POWERUP and GetItemType(UnitItemInSlot(GetManipulatingUnit(), cyclA)) != ITEM_TYPE_PURCHASABLE  then
            set i = i + 1
        endif
        set cyclA = cyclA + 1
    endloop
    
    if i >= 5 then
        set cyclA = 0
        loop
            exitwhen cyclA > 5
            call RemoveItem( UnitItemInSlot( GetManipulatingUnit(), cyclA ) )
            set cyclA = cyclA + 1
        endloop
        call SetHeroLevel( GetManipulatingUnit(), GetHeroLevel(GetManipulatingUnit()) + 6, true )
    endif
    
    call DestroyEffect( AddSpecialEffectTarget("Abilities\\Spells\\Human\\Polymorph\\PolyMorphDoneGround.mdl", GetManipulatingUnit(), "origin" ) )
    call statst( GetManipulatingUnit(), 1, 1, 1, 0, true )
endfunction

//===========================================================================
function InitTrig_Contract takes nothing returns nothing
    set gg_trg_Contract = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Contract, EVENT_PLAYER_UNIT_USE_ITEM )
    call TriggerAddCondition( gg_trg_Contract, Condition( function Trig_Contract_Conditions ) )
    call TriggerAddAction( gg_trg_Contract, function Trig_Contract_Actions )
endfunction

