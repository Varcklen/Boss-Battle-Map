globals
    constant integer PARAGON_PIECE_01 = 'I085'
    constant integer PARAGON_PIECE_02 = 'I08C'
    constant integer PARAGON_PIECE_03 = 'I07O'
    constant integer PARAGON_ARMOR = 'I09L'
    
    constant string PARAGON_ANIMATION = "Abilities\\Spells\\Human\\Resurrect\\ResurrectCaster.mdl"
endglobals

function Trig_Armor_Paragon_Conditions takes nothing returns boolean
    return inv(GetManipulatingUnit(), PARAGON_PIECE_01) > 0 and inv(GetManipulatingUnit(), PARAGON_PIECE_02) > 0 and inv(GetManipulatingUnit(), PARAGON_PIECE_03) > 0
endfunction

function Trig_Armor_Paragon_Actions takes nothing returns nothing
    local player owner = GetOwningPlayer(GetManipulatingUnit())
    local integer index = GetPlayerId(owner) + 1
    local unit hero = GetManipulatingUnit()
    local item it

    call DestroyEffect( AddSpecialEffectTarget( PARAGON_ANIMATION, hero, "origin" ) )

    call RemoveItem( GetItemOfTypeFromUnitBJ(hero, PARAGON_PIECE_01) )
    call RemoveItem( GetItemOfTypeFromUnitBJ(hero, PARAGON_PIECE_02) )
    call RemoveItem( GetItemOfTypeFromUnitBJ(hero, PARAGON_PIECE_03) )
    set bj_lastCreatedItem = CreateItem(PARAGON_ARMOR, GetUnitX(hero), GetUnitY(hero))
    call UnitAddItem(hero, bj_lastCreatedItem)
    
    call DisplayTimedTextToForce( bj_FORCE_ALL_PLAYERS, 10, udg_Player_Color[index] + GetPlayerName(owner) + "|r assembled the " + GetItemName(bj_lastCreatedItem) +"!" )
    
    set it = null
    set owner = null
    set hero = null
endfunction

//===========================================================================
function InitTrig_Armor_Paragon takes nothing returns nothing
    set gg_trg_Armor_Paragon = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Armor_Paragon, EVENT_PLAYER_UNIT_PICKUP_ITEM )
    call TriggerAddCondition( gg_trg_Armor_Paragon, Condition( function Trig_Armor_Paragon_Conditions ) )
    call TriggerAddAction( gg_trg_Armor_Paragon, function Trig_Armor_Paragon_Actions )
endfunction

