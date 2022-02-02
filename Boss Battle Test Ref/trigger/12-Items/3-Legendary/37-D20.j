function Trig_D20_Conditions takes nothing returns boolean
    return GetItemTypeId(GetManipulatedItem()) == 'I0FB' and combat( GetManipulatingUnit(), false, 0 ) and not(udg_fightmod[3])
endfunction

function Trig_D20_Actions takes nothing returns nothing
    local unit u = GetManipulatingUnit()
    local integer cyclA = 0
    local item it
    local integer i
    local integer h = eyest( u )
    local string rarity = null
    
    loop
        exitwhen cyclA > 5
        set it = UnitItemInSlot( u, cyclA )
        set i = 0
        if it != null and GetItemTypeId(it) != 'I0FB' then
            if GetItemType(it) == ITEM_TYPE_ARTIFACT then
                set i = 1
            elseif GetItemType(it) == ITEM_TYPE_CAMPAIGN then
                set i = 2
            elseif GetItemType(it) == ITEM_TYPE_PERMANENT then
                set i = 3
            endif
            if i != 0 then
                if i == 1 then
                    set rarity = "legendary"
                elseif i == 2 then
                    set rarity = "rare"
                elseif i == 3 then
                    set rarity = "common"
                endif
                call Inventory_ReplaceItemByNew(u, it, ItemRandomizerItemId( u, rarity ))
            endif
        endif
        set cyclA = cyclA + 1
    endloop
    call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\Human\\Polymorph\\PolyMorphDoneGround.mdl", GetUnitX( GetManipulatingUnit() ), GetUnitY( GetManipulatingUnit() ) ) )
    
    set u = null
    set it = null
endfunction

//===========================================================================
function InitTrig_D20 takes nothing returns nothing
    set gg_trg_D20 = CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ( gg_trg_D20, EVENT_PLAYER_UNIT_USE_ITEM )
    call TriggerAddCondition( gg_trg_D20, Condition( function Trig_D20_Conditions ) )
    call TriggerAddAction( gg_trg_D20, function Trig_D20_Actions )
endfunction

