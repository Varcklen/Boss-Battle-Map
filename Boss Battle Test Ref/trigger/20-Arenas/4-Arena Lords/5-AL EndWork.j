function Trig_AL_EndWork_Actions takes nothing returns nothing
    local integer cyclA = 1
    
    set udg_fightmod[4] = false
    call DisableTrigger( gg_trg_IA_TPBattle )
    call DisableTrigger( gg_trg_AL_End )
    call UnitAddAbility( gg_unit_u00F_0006, 'A03U' )

    loop
        exitwhen cyclA > 4
        if GetPlayerSlotState(Player(cyclA - 1)) == PLAYER_SLOT_STATE_PLAYING then
            call ReviveHeroLoc( udg_hero[cyclA], udg_point[cyclA + 21], true )
            call SetUnitPositionLoc( udg_hero[cyclA], udg_point[cyclA + 21] )
            call SetUnitFacing( udg_hero[cyclA], 90 )
            if GetLocalPlayer() == Player(cyclA - 1) then
                call PanCameraToTimed(GetLocationX( udg_point[cyclA + 21]), GetLocationY( udg_point[cyclA + 21]), 0.)
            endif
            if inv(udg_hero[cyclA], 'I03V') > 0 then
		call SetHeroLevel(udg_hero[cyclA], GetHeroLevel(udg_hero[cyclA]) + 2, false)
            endif
        endif
        set cyclA = cyclA + 1
    endloop
    call FightEnd()
endfunction

//===========================================================================
function InitTrig_AL_EndWork takes nothing returns nothing
    set gg_trg_AL_EndWork = CreateTrigger(  )
    call TriggerAddAction( gg_trg_AL_EndWork, function Trig_AL_EndWork_Actions )
endfunction

