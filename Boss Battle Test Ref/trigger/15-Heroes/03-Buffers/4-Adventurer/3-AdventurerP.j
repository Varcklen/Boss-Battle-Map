globals
    constant integer ADVENTURER_E_BOOK_OF_OBLIVION_EXTRA_COST = 350
endglobals

function Trig_AdventurerP_Conditions takes nothing returns boolean
    return GetLearnedSkill() == 'A12S'
endfunction

function Trig_AdventurerP_Actions takes nothing returns nothing
    local player ownPlayer = GetOwningPlayer(GetLearningUnit())
    local integer index = GetPlayerId(ownPlayer) + 1
    local boolean isActive = LoadBoolean(udg_hash, GetHandleId(GetLearningUnit()), StringHash("adve"))
    
    if isActive == false then
        call BookOfOblivion_Change_Cost(ownPlayer, Book_Of_Oblivion_Cost[index] + ADVENTURER_E_BOOK_OF_OBLIVION_EXTRA_COST)
        call SaveBoolean(udg_hash, GetHandleId(GetLearningUnit()), StringHash("adve"), true)
    endif

    call DestroyEffect( AddSpecialEffect( "Abilities\\Weapons\\FrostWyrmMissile\\FrostWyrmMissile.mdl", GetUnitX( GetLearningUnit() ), GetUnitY( GetLearningUnit() ) ) )
    if UnitInventoryCount(GetLearningUnit()) < 6 then
        call UnitAddItem( GetLearningUnit(), CreateItem(udg_DB_Item_Destroyed[GetRandomInt( 1, udg_Database_NumberItems[29] )], GetUnitX(GetLearningUnit()), GetUnitY(GetLearningUnit()) ) )
    endif
    
    set ownPlayer = null
endfunction

//===========================================================================
function InitTrig_AdventurerP takes nothing returns nothing
    set gg_trg_AdventurerP = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_AdventurerP, EVENT_PLAYER_HERO_SKILL )
    call TriggerAddCondition( gg_trg_AdventurerP, Condition( function Trig_AdventurerP_Conditions ) )
    call TriggerAddAction( gg_trg_AdventurerP, function Trig_AdventurerP_Actions )
endfunction

scope AdventurerE initializer Triggs
    private function Use takes nothing returns nothing
        local unit hero = udg_Event_NullingAbility_Unit
        local player ownPlayer = GetOwningPlayer(hero)
        local integer index = GetPlayerId(ownPlayer) + 1
        local boolean isActive = LoadBoolean(udg_hash, GetHandleId(hero), StringHash("adve"))
        
        if isActive then
            call BookOfOblivion_Change_Cost(ownPlayer, Book_Of_Oblivion_Cost[index] - ADVENTURER_E_BOOK_OF_OBLIVION_EXTRA_COST)
            call SaveBoolean(udg_hash, GetHandleId(hero), StringHash("adve"), false)
        endif
        
        set hero = null
        set ownPlayer = null
    endfunction

    private function Triggs takes nothing returns nothing
        local trigger trig = CreateTrigger()
        call TriggerRegisterVariableEvent( trig, "udg_Event_NullingAbility_Real", EQUAL, 1.00 )
        call TriggerAddAction( trig, function Use)
        
        set trig = null
    endfunction
endscope

