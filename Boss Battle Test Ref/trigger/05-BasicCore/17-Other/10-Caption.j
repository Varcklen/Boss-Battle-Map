function Cap takes nothing returns nothing
    local integer id = GetHandleId( gg_unit_h00A_0034 )
    local integer c = LoadInteger( udg_hash, id, StringHash( "capt" ) ) + 2
    
    if udg_logic[43] then
        if udg_Captions[c] == null then
            call DestroyTimer( GetExpiredTimer() )
            call FlushChildHashtable( udg_hash, id )
        else
            if c == 1 then
                call DisplayTimedTextToForce( bj_FORCE_ALL_PLAYERS, 10, "|cffffcc00Acknowledgments:|r" )
            endif
            if udg_Captions[c+1] != null then
                call DisplayTimedTextToForce( bj_FORCE_ALL_PLAYERS, 10, udg_Captions[c] + " |cffffcc00|||r " + udg_Captions[c+1] )
            else
                call DisplayTimedTextToForce( bj_FORCE_ALL_PLAYERS, 10, udg_Captions[c] )
            endif
            call SaveInteger( udg_hash, id, StringHash( "capt" ), c )
        endif
    endif
endfunction

function Cap4 takes nothing returns nothing
    if udg_logic[43] then
        call DisplayTimedTextToForce( bj_FORCE_ALL_PLAYERS, 40, "|cffffcc00Patreon:|r" )
        call DisplayTimedTextToForce( bj_FORCE_ALL_PLAYERS, 40, "www.patreon.com/bbwc3" )
        call SaveInteger( udg_hash, GetHandleId( gg_unit_h00A_0034 ), StringHash( "capt" ), -1 )
        call TimerStart( CreateTimer(), 2, true, function Cap )
    endif
endfunction

function Cap3 takes nothing returns nothing
    if udg_logic[43] then
        call DisplayTimedTextToForce( bj_FORCE_ALL_PLAYERS, 40, "|cffffcc00PayPal:|r" )
        call DisplayTimedTextToForce( bj_FORCE_ALL_PLAYERS, 40, "www.paypal.me/bbwc3" )
        call TimerStart( CreateTimer(), 4, false, function Cap4 )
    endif
endfunction

function Cap2 takes nothing returns nothing
if udg_logic[43] then
    call DisplayTimedTextToForce( bj_FORCE_ALL_PLAYERS, 40, "|cffffcc00Discord.me:|r" )
    call DisplayTimedTextToForce( bj_FORCE_ALL_PLAYERS, 40, "discord.me/bbwc3" )
    call TimerStart( CreateTimer(), 4, false, function Cap3 )
endif
endfunction

function Cap1 takes nothing returns nothing
if udg_logic[43] then
    call DisplayTimedTextToForce( bj_FORCE_ALL_PLAYERS, 40, "|cffffcc00Discord:|r" )
    call DisplayTimedTextToForce( bj_FORCE_ALL_PLAYERS, 40, "discordapp.com/invite/KVfrcby" )
    call TimerStart( CreateTimer(), 4, false, function Cap2 )
endif
endfunction

function Trig_Caption_Actions takes nothing returns nothing
    call DisplayTimedTextToForce( bj_FORCE_ALL_PLAYERS, 10.00, "|cffffcc00Map creator:|r" )
    call DisplayTimedTextToForce( bj_FORCE_ALL_PLAYERS, 10.00, "Varcklen" )
    
    call TimerStart( CreateTimer(), 2, false, function Cap1 )
endfunction

//===========================================================================
function InitTrig_Caption takes nothing returns nothing
    set gg_trg_Caption = CreateTrigger(  )
    call TriggerAddAction( gg_trg_Caption, function Trig_Caption_Actions )
endfunction

