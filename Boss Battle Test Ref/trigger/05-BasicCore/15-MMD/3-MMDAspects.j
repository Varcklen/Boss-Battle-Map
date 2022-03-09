scope MMDAspects initializer init

    globals
        private integer array LastChoosedAspect[PLAYERS_LIMIT_ARRAYS]
    endglobals

    private function FightStartGlobal takes nothing returns nothing
        local integer i
        
        set i = 1
        loop
            exitwhen i > PLAYERS_LIMIT
            if LastChoosedAspect[i] != ChoosedAspect[i] and GetPlayerSlotState( Player( i - 1 ) ) == PLAYER_SLOT_STATE_PLAYING then
                set LastChoosedAspect[i] = ChoosedAspect[i]
                if ChoosedAspect[i] != 0 then
                    call MMD_LogEvent2("aspect_" + I2S(i),GetUnitName(udg_hero[i]),BlzGetAbilityTooltip(ChoosedAspect[i], 0) )
                else
                    call MMD_LogEvent2("aspect_" + I2S(i),GetUnitName(udg_hero[i]),"none" )
                endif
            endif
            set i = i + 1
        endloop
    endfunction
    
    private function init takes nothing returns nothing
        local integer i
        
        call CreateEventTrigger( "udg_FightStartGlobal_Real", function FightStartGlobal, null )
        
        set i = 1
        loop
            exitwhen i > PLAYERS_LIMIT
            set LastChoosedAspect[i] = 0
            //call MMD_UpdateValueString("aspect_"+ I2S(i),Player(i-1),"none")
            //call MMD_DefineEvent2("aspect_"+ I2S(i),"{0} {1}","Hero","Aspect")
            set i = i + 1
        endloop
    endfunction
endscope

