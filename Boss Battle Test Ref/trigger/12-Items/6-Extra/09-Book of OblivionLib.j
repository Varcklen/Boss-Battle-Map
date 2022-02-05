library BookOfOblivion

    globals
        integer array Book_Of_Oblivion_Cost[PLAYERS_LIMIT_ARRAYS]
        constant integer BOOK_OF_OBLIVION_BASE_COST = 150
    endglobals
    
    function Book_Of_Oblivion takes nothing returns nothing
        local player p = GetTriggerPlayer()
        local integer index = GetPlayerId(GetTriggerPlayer()) + 1
        local integer cost = Book_Of_Oblivion_Cost[index]
        local unit hero = udg_hero[index]
        
        if GetLocalPlayer() == p then
            call BlzFrameSetVisible( BlzGetTriggerFrame(),false)
            call BlzFrameSetVisible( BlzGetTriggerFrame(),true)
        endif
        
        if hero == null then
            return
        endif
        
        if GetPlayerState(p, PLAYER_STATE_RESOURCE_GOLD) >= cost then
            call UnitAddItem( hero, CreateItem( 'I03S', GetUnitX(hero), GetUnitY(hero) ) )
            call SetPlayerState(p, PLAYER_STATE_RESOURCE_GOLD, IMaxBJ(0,GetPlayerState(p, PLAYER_STATE_RESOURCE_GOLD) - cost))
        endif
        
        set p = null
        set hero = null
    endfunction

    public function Change_Cost takes player whichPlayer, integer newCost returns nothing
        local integer index = GetPlayerId(whichPlayer) + 1
        set Book_Of_Oblivion_Cost[index] = newCost
        
        if GetLocalPlayer() == whichPlayer then
            call BlzFrameSetText( bookOfOblivionCostText, I2S(newCost) + " G" )
        endif
    endfunction
endlibrary