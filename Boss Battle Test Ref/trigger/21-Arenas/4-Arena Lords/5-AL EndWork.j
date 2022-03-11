scope ArenaLordsWorkEnd

    function Trig_AL_EndWork_Actions takes nothing returns nothing
        local integer i = 1
        local unit hero
        local real locX
        local real locY
        
        set udg_fightmod[4] = false
        call DisableTrigger( gg_trg_IA_TPBattle )
        call DisableTrigger( gg_trg_AL_End )
        call UnitAddAbility( gg_unit_u00F_0006, 'A03U' )

        loop
            exitwhen i > PLAYERS_LIMIT
            if GetPlayerSlotState(Player(i - 1)) == PLAYER_SLOT_STATE_PLAYING then
                set hero = udg_hero[i]
                set locX = GetLocationX( udg_point[i + 21])
                set locY = GetLocationY( udg_point[i + 21])
                
                call ReviveHero( hero, locX, locY, true )
                call SetUnitPosition( hero, locX, locY )
                call SetUnitFacing( hero, 90 )
                if GetLocalPlayer() == Player(i - 1) then
                    call PanCameraToTimed(locX, locY, 0)
                endif
            endif
            set i = i + 1
        endloop
        call FightEnd()
        
        set hero = null
    endfunction

    //===========================================================================
    function InitTrig_AL_EndWork takes nothing returns nothing
        set gg_trg_AL_EndWork = CreateTrigger(  )
        call TriggerAddAction( gg_trg_AL_EndWork, function Trig_AL_EndWork_Actions )
    endfunction

endscope