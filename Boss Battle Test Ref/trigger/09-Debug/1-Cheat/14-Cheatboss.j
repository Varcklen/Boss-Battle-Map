function Trig_Cheatboss_Conditions takes nothing returns boolean
    return SubString(GetEventPlayerChatString(), 0, 5) == "-boss"
endfunction

function Trig_Cheatboss_Actions takes nothing returns nothing
    local integer cyclA = 1
    local integer cyclB
    local integer i
    
    set udg_Boss_Number = SubString(GetEventPlayerChatString(), 6, 7)
    set udg_Boss_Random = S2I(udg_Boss_Number)
    set i = DB_Boss_id[udg_Boss_LvL][udg_Boss_Random]
    call DisplayTimedTextToForce( bj_FORCE_ALL_PLAYERS, 5.00, "Босс изменен на босса |cffffcc00№" + udg_Boss_Number + "|r" )
    loop
        exitwhen cyclA > 4
        if GetPlayerSlotState(Player(cyclA - 1)) == PLAYER_SLOT_STATE_PLAYING then
            set cyclB = 1
            loop
                exitwhen cyclB > 6
                call UnitRemoveAbility( udg_unit[cyclA + 17], Boss_Info[udg_Boss_LvL][cyclB] )
                call UnitRemoveAbility( gg_unit_h00D_0024, Boss_Info[udg_Boss_LvL][cyclB] )
                if cyclB == S2I(udg_Boss_Number) then
                    call UnitAddAbility( udg_unit[cyclA + 17], Boss_Info[udg_Boss_LvL][cyclB] )
                    call UnitAddAbility( gg_unit_h00D_0024, Boss_Info[udg_Boss_LvL][cyclB] )
                endif
                set cyclB = cyclB + 1
            endloop
        endif
        set cyclA = cyclA + 1
    endloop
endfunction

//===========================================================================
function InitTrig_Cheatboss takes nothing returns nothing
    local integer cyclA = 0
    set gg_trg_Cheatboss = CreateTrigger(  )
    call DisableTrigger( gg_trg_Cheatboss )
    loop
        exitwhen cyclA > 3
        call TriggerRegisterPlayerChatEvent( gg_trg_Cheatboss, Player(cyclA), "-boss ", false )
        set cyclA = cyclA + 1
    endloop
    call TriggerAddCondition( gg_trg_Cheatboss, Condition( function Trig_Cheatboss_Conditions ) )
    call TriggerAddAction( gg_trg_Cheatboss, function Trig_Cheatboss_Actions )
endfunction

