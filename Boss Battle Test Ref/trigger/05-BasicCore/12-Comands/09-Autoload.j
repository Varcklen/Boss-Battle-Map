function Trig_Autoload_Conditions takes nothing returns boolean
    return not( udg_logic[43] ) and not(udg_logic[1])
endfunction

function AutoloadCast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local integer i = LoadInteger( udg_hash, id, StringHash( "auto" ) )

    call LoadProgress( i, "" )
    call BonusLoad(i)
    call FlushChildHashtable( udg_hash, id )
endfunction

function Trig_Autoload_Actions takes nothing returns nothing
    local integer i = GetPlayerId(GetTriggerPlayer()) + 1
    local integer id = GetHandleId( GetTriggerPlayer() )
    
    call Preloader("BossBattleSave\\Boss Battle Progress.txt")
    
    if LoadTimerHandle( udg_hash, id, StringHash( "auto" ) ) == null  then
        call SaveTimerHandle( udg_hash, id, StringHash( "auto" ), CreateTimer() )
    endif
	set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "auto" ) ) ) 
    call SaveInteger( udg_hash, id, StringHash( "auto" ), i )
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( GetTriggerPlayer() ), StringHash( "auto" ) ), 0.5, false, function AutoloadCast )
endfunction

//===========================================================================
function InitTrig_Autoload takes nothing returns nothing
    local integer cyclA = 0
    set gg_trg_Autoload = CreateTrigger()
    loop
        exitwhen cyclA > 3
        call TriggerRegisterPlayerChatEvent( gg_trg_Autoload, Player(cyclA), "-autoload", true )
        set cyclA = cyclA + 1
    endloop
    call TriggerAddCondition( gg_trg_Autoload, Condition( function Trig_Autoload_Conditions ) )
    call TriggerAddAction( gg_trg_Autoload, function Trig_Autoload_Actions )
endfunction