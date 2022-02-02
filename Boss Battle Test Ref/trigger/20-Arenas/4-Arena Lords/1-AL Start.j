function Trig_AL_Start_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A0JQ' 
endfunction

function Trig_AL_Start_Actions takes nothing returns nothing
    local integer cyclA
    local boolean l = false

    if Itemnull() then
        call Between( "start_AL" )
    else
        set cyclA = 0
        loop
            exitwhen cyclA > 3
            if udg_item[( cyclA * 3 ) + 1] != null and GetPlayerSlotState(Player(cyclA)) == PLAYER_SLOT_STATE_PLAYING then
                set l = true
                call PingMinimapLocForForceEx( bj_FORCE_ALL_PLAYERS, udg_itemcentr[2 + ( cyclA * 3 )], 5, bj_MINIMAPPINGSTYLE_ATTACK, 50.00, 100.00, 50.00 )
            endif
            set cyclA = cyclA + 1
        endloop
        if l then
            call DisplayTimedTextToForce( bj_FORCE_ALL_PLAYERS, 5, "Select an artifact-reward before starting the overlords arena." )
        endif
    endif
endfunction

//===========================================================================
function InitTrig_AL_Start takes nothing returns nothing
    set gg_trg_AL_Start = CreateTrigger(  )
    call TriggerRegisterUnitEvent( gg_trg_AL_Start, gg_unit_h00A_0034, EVENT_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_AL_Start, Condition( function Trig_AL_Start_Conditions ) )
    call TriggerAddAction( gg_trg_AL_Start, function Trig_AL_Start_Actions )
endfunction

