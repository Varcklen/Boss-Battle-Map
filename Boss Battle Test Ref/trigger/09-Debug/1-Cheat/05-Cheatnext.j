function NextTwo takes nothing returns boolean
    local integer cyclA = 0
    local boolean l = false
    
    loop
        exitwhen cyclA > 3
        if GetPlayerController(Player(cyclA)) == MAP_CONTROL_COMPUTER then
            set l = true
        endif
        set cyclA = cyclA + 1
    endloop
   return l
endfunction

function NextOne takes nothing returns boolean
    local integer cyclA = 1
    local integer i = 0
    local boolean l = false
    
    loop
        exitwhen cyclA > 4
        if GetUnitState( udg_hero[cyclA], UNIT_STATE_LIFE ) > 0.405 then
            set i = i + 1
        endif
        set cyclA = cyclA + 1
    endloop
    if i >= 1 and GetTriggerPlayer() == udg_cheater then
        set l = true
    endif
    return l
endfunction

function Trig_Cheatnext_Conditions takes nothing returns boolean
    return SubString(GetEventPlayerChatString(), 0, 5) == "-next" and ( NextOne() or NextTwo() )
endfunction

function CheatNextSquad takes nothing returns nothing
    call KillUnit( GetEnumUnit() )
endfunction

function CheatNext takes nothing returns nothing
    local integer cyclA
    local string str

    if udg_Boss_LvL >= 10 then
        set udg_Boss_LvL = 10
        set str = I2S( udg_Boss_LvL )
    else
        set str = I2S(udg_Boss_LvL + 1)
    endif
    
    set cyclA = 0
    loop
        exitwhen cyclA > 3
        if GetPlayerSlotState( Player( cyclA ) ) == PLAYER_SLOT_STATE_PLAYING then
            call DisplayTimedTextToPlayer( Player(cyclA ), 0, 0, 5, "Установлен уровень боссов: " + str )
        endif
        set cyclA = cyclA + 1
    endloop

    if IsUnitGroupEmptyBJ(udg_Bosses) then
        call Between( "end_boss" )
    else
        call ForGroupBJ( GetUnitsOfPlayerMatching(Player(10), null), function CheatNextSquad )
    endif
endfunction

function Trig_Cheatnext_Actions takes nothing returns nothing
    local string s = I2S( S2I(SubString(GetEventPlayerChatString(), 6, 8)) - 1 )
    local integer cyclA = 1
    local integer cyclB
    
    loop
        exitwhen cyclA > 4
        set cyclB = 1
        loop
            exitwhen cyclB > 6
            call UnitRemoveAbility( udg_unit[cyclA + 17], Boss_Info[udg_Boss_LvL][cyclB] )
            call UnitRemoveAbility( gg_unit_h00D_0024, Boss_Info[udg_Boss_LvL][cyclB] )
            set cyclB = cyclB + 1
        endloop
        set cyclA = cyclA + 1
    endloop
	call BlzFrameSetVisible( rpkmod,false)
    if s != "" and S2I(s) >= 0 and S2I(s) <= 9 then
        set udg_Boss_LvL = S2I(s)
    endif
    if udg_Boss_LvL == 3 and udg_Boss_Random == 2 then
        call KillUnit( (LoadUnitHandle( udg_hash, 32, StringHash( "bsfdtrain" ) )) )
    endif
    set cyclA = 1
    loop
        exitwhen cyclA > 12
        if udg_item[cyclA] != null then
            call RemoveItem( udg_item[cyclA] )
        endif
        set cyclA = cyclA + 1
    endloop

	call PauseTimer( udg_timer[1] )
    call TimerDialogDisplay( udg_timerdialog[2], false )
    call TimerStart( CreateTimer(), 0.25, false, function CheatNext )
endfunction

//===========================================================================
function InitTrig_Cheatnext takes nothing returns nothing
    local integer cyclA = 0
    set gg_trg_Cheatnext = CreateTrigger()
    call DisableTrigger( gg_trg_Cheatnext )
    loop
        exitwhen cyclA > 3
            call TriggerRegisterPlayerChatEvent( gg_trg_Cheatnext, Player(cyclA), "-next", false )
        set cyclA = cyclA + 1
    endloop
    call TriggerAddCondition( gg_trg_Cheatnext, Condition( function Trig_Cheatnext_Conditions ) )
    call TriggerAddAction( gg_trg_Cheatnext, function Trig_Cheatnext_Actions )
endfunction

