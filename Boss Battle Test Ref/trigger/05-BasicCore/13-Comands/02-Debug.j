function Trig_Debug_Conditions takes nothing returns boolean
    return udg_logic[1] == false
endfunction

function DebugHero takes nothing returns boolean
    local integer cyclA = 1
    local integer i = 0
    local boolean l = false
    
    loop
        exitwhen cyclA > 4
        if GetUnitState(udg_hero[cyclA], UNIT_STATE_LIFE) <= 0.405 and GetUnitAbilityLevel(udg_hero[cyclA], 'A0EX') == 0 then
            set i = i + 1
        endif
        set cyclA = cyclA + 1
    endloop
    if i >= 4 then
        set l = true
    endif
    return l
endfunction

function Trig_Debug_Actions takes nothing returns nothing
    local integer cyclA = 1

    call DisplayTimedTextToPlayer(GetTriggerPlayer(), 0, 0, 5, "Bug fixes made.")
    set udg_Heroes_Amount = 0
    loop
        exitwhen cyclA > 4
        set udg_logic[cyclA + 36] = false
        if GetPlayerSlotState(Player(cyclA - 1)) == PLAYER_SLOT_STATE_PLAYING then
            if BlzGetUnitMaxHP(udg_hero[cyclA]) < 0.405 and udg_hero[cyclA] != null then
                call BlzSetUnitMaxHP( udg_hero[cyclA], 100 )
            endif
            set udg_Heroes_Amount = udg_Heroes_Amount + 1
        endif
        set cyclA = cyclA + 1
    endloop
    
    if udg_fightmod[0] then
        if not(udg_fightmod[3]) then
            set cyclA = 1
            loop
                exitwhen cyclA > 4
                if not( RectContainsUnit(udg_Boss_Rect, udg_hero[cyclA]) ) then
                    call SetUnitPositionLoc( udg_hero[cyclA], GetRectCenter( udg_Boss_Rect ) )
                    call PanCameraToTimedForPlayer( Player(cyclA - 1), GetUnitX(udg_hero[cyclA]), GetUnitY(udg_hero[cyclA]), 0 )
                endif
                set cyclA = cyclA + 1
            endloop
        else
            set cyclA = 1
            loop
                exitwhen cyclA > 4
                if not( RectContainsUnit(udg_Boss_Rect, udg_hero[cyclA]) ) and (udg_hero[cyclA] == udg_unit[57] or udg_hero[cyclA] == udg_unit[58] ) then
                    call SetUnitPositionLoc( udg_hero[cyclA], GetRectCenter( udg_Boss_Rect ) )
                    call PanCameraToTimedForPlayer( Player(cyclA - 1), GetUnitX(udg_hero[cyclA]), GetUnitY(udg_hero[cyclA]), 0 )
                endif
                set cyclA = cyclA + 1
            endloop
        endif
        if udg_fightmod[1] and not( udg_logic[1] ) and DebugHero() then
            call Between( "res_boss" )
        elseif udg_fightmod[2] and DebugHero() then
            call Between( "end_IA" )
        elseif udg_fightmod[3] and GetUnitState( udg_unit[57], UNIT_STATE_LIFE) <= 0.405 or GetUnitState( udg_unit[58], UNIT_STATE_LIFE) <= 0.405 then
            call TriggerExecute( gg_trg_PA_End )
        elseif udg_fightmod[4] and DebugHero() then
            call Between( "end_AL" )
        endif
    else
        if not(udg_logic[43]) and udg_Boss_LvL > 1 then
            call BlzFrameSetVisible( fon,true)
            call BlzFrameSetTexture(butbk, "ReplaceableTextures\\CommandButtons\\BTNArcaniteMelee.blp", 0, true)
            call BlzFrameSetVisible( butbk,true)
        endif
        set udg_Player_Readiness = 0
        call UnitRemoveAbility( gg_unit_h00A_0034, 'A08B' )
        call UnitRemoveAbility( gg_unit_h00A_0034, 'A0JQ' )
        if not( udg_logic[31] ) and ( not(udg_logic[71]) or udg_logic[43] ) and udg_Boss_LvL != 1 then
            call UnitAddAbility( gg_unit_h00A_0034, 'A0JQ' )
        endif
        if not( udg_logic[33] ) and not( udg_logic[43] ) and not(udg_logic[71]) and udg_Boss_LvL != 1 then
            call UnitAddAbility( gg_unit_h00A_0034, 'A08B' )
        endif
        set cyclA = 1
        loop
            exitwhen cyclA > 4
            if GetPlayerSlotState(Player(cyclA - 1)) == PLAYER_SLOT_STATE_PLAYING then
                call BlzFrameSetTexture( iconframe[cyclA], "ReplaceableTextures\\CommandButtons\\BTNDivineShieldOff.blp", 0, true )
                set udg_fightlogic[cyclA] = false
                if udg_hero[cyclA] != null then
                    call ReviveHeroLoc( udg_hero[cyclA], udg_point[cyclA + 21], true )
                    call SetUnitPositionLoc(udg_hero[cyclA], udg_point[cyclA + 21])
                    call SetUnitFacing(udg_hero[cyclA], 90)
                    call PanCameraToTimedLocForPlayer( Player(cyclA - 1), udg_point[cyclA + 21], 0. )
                    call SetUnitOwner( udg_hero[cyclA], Player(cyclA - 1), true )
                    call PauseUnit(udg_hero[cyclA], false)
                endif
            endif
            set cyclA = cyclA + 1
        endloop
    endif
    
    //Для случаев софтлока на боссе (нет босса, но бой н закончился)
    if udg_fightmod[1] and IsUnitGroupEmptyBJ(udg_Bosses) then
        call Between( "res_boss" )
    endif
endfunction

//===========================================================================
function InitTrig_Debug takes nothing returns nothing
    local integer i = 0
    set gg_trg_Debug = CreateTrigger(  )
    loop
        exitwhen i > 3
        call TriggerRegisterPlayerChatEvent( gg_trg_Debug, Player(i), "-debug", true )
        set i = i + 1
    endloop
    call TriggerAddCondition( gg_trg_Debug, Condition( function Trig_Debug_Conditions ) )
    call TriggerAddAction( gg_trg_Debug, function Trig_Debug_Actions )
endfunction