function Trig_IA_EndWork_Actions takes nothing returns nothing
    local group g = CreateGroup()
    local unit u
    local integer cyclA = 1
    
    set udg_fightmod[2] = false
    call DisableTrigger( gg_trg_IA_TPBattle )
    set bj_livingPlayerUnitsTypeId = 'h00J'
    call GroupEnumUnitsOfPlayer(g, Player( 10 ), filterLivingPlayerUnitsOfTypeId)
    loop
        set u = FirstOfGroup(g)
        exitwhen u == null
        call RemoveUnit( u )
        call GroupRemoveUnit(g,u)
        set u = FirstOfGroup(g)
    endloop
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
    
    call GroupClear( g )
    call DestroyGroup( g )
    set u = null
    set g = null
endfunction

//===========================================================================
function InitTrig_IA_EndWork takes nothing returns nothing
    set gg_trg_IA_EndWork = CreateTrigger(  )
    call TriggerAddAction( gg_trg_IA_EndWork, function Trig_IA_EndWork_Actions )
endfunction

