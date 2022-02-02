globals
    constant integer THIEF_PIECE_01 = 'I0BK'
    constant integer THIEF_PIECE_02 = 'I0CV'
    constant integer THIEF_PIECE_03 = 'I0AA'
    constant integer THIEF_ARMOR = 'I0EI'
    
    constant string THIEF_ANIMATION = "Abilities\\Spells\\Human\\Resurrect\\ResurrectCaster.mdl"
endglobals

function Trig_Armor_Thief_Conditions takes nothing returns boolean
    return GetItemTypeId(GetManipulatedItem()) == THIEF_PIECE_01 or GetItemTypeId(GetManipulatedItem()) == THIEF_PIECE_02 or GetItemTypeId(GetManipulatedItem()) == THIEF_PIECE_03
endfunction

function Armor_Thief_Conditions takes nothing returns boolean
    return inv(GetManipulatingUnit(), THIEF_PIECE_01) > 0 and inv(GetManipulatingUnit(), THIEF_PIECE_02) > 0 and inv(GetManipulatingUnit(), THIEF_PIECE_03) > 0
endfunction

function Trig_Armor_Thief_Actions takes nothing returns nothing
    local player owner = GetOwningPlayer(GetManipulatingUnit())
    local integer index = GetPlayerId(owner) + 1
    local unit hero = GetManipulatingUnit()
    local item it

    if Armor_Thief_Conditions() then
        call RemoveItem( GetItemOfTypeFromUnitBJ(hero, THIEF_PIECE_01) )
        call RemoveItem( GetItemOfTypeFromUnitBJ(hero, THIEF_PIECE_02) )
        call RemoveItem( GetItemOfTypeFromUnitBJ(hero, THIEF_PIECE_03) )
        set bj_lastCreatedItem = CreateItem(THIEF_ARMOR, GetUnitX(hero), GetUnitY(hero))
        call UnitAddItem(hero, bj_lastCreatedItem)
        
        call DisplayTimedTextToForce( bj_FORCE_ALL_PLAYERS, 10, udg_Player_Color[index] + GetPlayerName(owner) + "|r assembled the " + GetItemName(bj_lastCreatedItem) +"!" )
        call DestroyEffect( AddSpecialEffectTarget( THIEF_ANIMATION, hero, "origin" ) )
    endif
    
    set it = null
    set owner = null
    set hero = null
endfunction

//===========================================================================
function InitTrig_Armor_Thief takes nothing returns nothing
    set gg_trg_Armor_Thief = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Armor_Thief, EVENT_PLAYER_UNIT_PICKUP_ITEM )
    call TriggerAddCondition( gg_trg_Armor_Thief, Condition( function Trig_Armor_Thief_Conditions ) )
    call TriggerAddAction( gg_trg_Armor_Thief, function Trig_Armor_Thief_Actions )
endfunction

