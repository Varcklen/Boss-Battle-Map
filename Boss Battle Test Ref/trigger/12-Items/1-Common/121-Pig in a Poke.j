function Trig_Pig_in_a_Poke_Conditions takes nothing returns boolean
    return GetItemTypeId(GetManipulatedItem()) == 'I008' and not(udg_fightmod[0])
endfunction

function Trig_Pig_in_a_Poke_Actions takes nothing returns nothing
    local unit u = GetManipulatingUnit()
    local integer i = GetPlayerId( GetOwningPlayer( u ) ) + 1
    local integer cyclA
    local item it = null
    
    if udg_item[( 3 * i ) - 2] != null or udg_item[( 3 * i ) - 1] != null or udg_item[3 * i] != null then
        call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\Human\\Polymorph\\PolyMorphDoneGround.mdl", GetUnitX( u ), GetUnitY( u ) ) )
        call stazisst( u, GetManipulatedItem() )
        call DisableTrigger( gg_trg_ItemChoise )
        set cyclA = 2
        loop
            exitwhen cyclA < 0
            set it = udg_item[(3 * i) - cyclA]
            if it != null then
                call DestroyEffect( AddSpecialEffectLoc( "Abilities\\Spells\\Human\\Polymorph\\PolyMorphDoneGround.mdl", Location(GetItemX(it), GetItemY(it)) ) )
            endif
            if UnitInventoryCount(u) < 6 and it != null then
                call UnitAddItem( u, it )
            else
                call RemoveItem( it )
            endif
            set udg_item[(3 * i) - cyclA] = null
            set cyclA = cyclA - 1
        endloop
        call EnableTrigger( gg_trg_ItemChoise )
        call AfterItemChoise(GetOwningPlayer(u))
    endif
    
    set u = null
    set it = null
endfunction

//===========================================================================
function InitTrig_Pig_in_a_Poke takes nothing returns nothing
    set gg_trg_Pig_in_a_Poke = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Pig_in_a_Poke, EVENT_PLAYER_UNIT_USE_ITEM )
    call TriggerAddCondition( gg_trg_Pig_in_a_Poke, Condition( function Trig_Pig_in_a_Poke_Conditions ) )
    call TriggerAddAction( gg_trg_Pig_in_a_Poke, function Trig_Pig_in_a_Poke_Actions )
endfunction

