library Multiboard

    globals
        private constant integer NAME_SYMBOLS_LIMIT = 10
    endglobals

    private function GetSmallPlayerName takes string playerName, integer index returns string
        local integer symbols = StringLength(playerName)
        local string newName
        
        if symbols > NAME_SYMBOLS_LIMIT and index < udg_Heroes_Amount then
            set newName = SubString(playerName, 0, NAME_SYMBOLS_LIMIT-1) + "..."
        else
            set newName = playerName
        endif

        return newName
    endfunction
    
    function MultiSetValue takes multiboard mb, integer col, integer row, string val returns nothing
        local multiboarditem mbitem = MultiboardGetItem( mb, row - 1, col - 1 )
        
        call MultiboardSetItemValue( mbitem, val )
        call MultiboardReleaseItem( mbitem )
        
        set mb = null
        set mbitem = null
    endfunction

    function MultiSetColor takes multiboard mb, integer col, integer row, real red, real green, real blue, real transparency returns nothing
        local multiboarditem mbitem = MultiboardGetItem( mb, row - 1, col - 1 )
        local integer array i
        local integer cyclA = 0
        
        set i[0] = R2I( red * 2.25 )
        set i[1] = R2I( green * 2.25 )
        set i[2] = R2I( blue * 2.25 )
        set i[3] = R2I( (100.-transparency) * 2.25 )
        
        loop
            exitwhen cyclA > 3
            if i[cyclA] < 0 then
                set i[cyclA] = 0
            elseif i[cyclA] > 225 then
                set i[cyclA] = 225
            endif
            set cyclA = cyclA + 1
        endloop
        
        call MultiboardSetItemValueColor(mbitem, i[0], i[1], i[2], i[3])
        call MultiboardReleaseItem(mbitem)
        
        set mb = null
        set mbitem = null
    endfunction

    function MultiSetWidth takes multiboard mb, integer col, integer row, real width returns nothing
        local multiboarditem mbitem = MultiboardGetItem( mb, row - 1, col - 1 )
        
        call MultiboardSetItemWidth(mbitem, width/100.0)
        call MultiboardReleaseItem(mbitem)
        
        set mb = null
        set mbitem = null
    endfunction

    function MultiSetStyle takes multiboard mb, integer col, integer row, boolean showValue, boolean showIcon returns nothing
        local multiboarditem mbitem = MultiboardGetItem( mb, row - 1, col - 1 )
        
        call MultiboardSetItemStyle(mbitem, showValue, showIcon)
        call MultiboardReleaseItem(mbitem)
        
        set mb = null
        set mbitem = null
    endfunction

    function MultiSetIcon takes multiboard mb, integer col, integer row, string iconFileName returns nothing
        local multiboarditem mbitem = MultiboardGetItem( mb, row - 1, col - 1 )
        
        call MultiboardSetItemIcon(mbitem, iconFileName)
        call MultiboardReleaseItem(mbitem)
        
        set mb = null
        set mbitem = null
    endfunction

    function Init_Multiboard takes nothing returns nothing
        local integer cyclA = 1
        local integer cyclAEnd
        local integer cyclB 
        local integer i
        
        call DisableTrigger( GetTriggeringTrigger() )
        set udg_multi = CreateMultiboard()
        set bj_lastCreatedMultiboard = udg_multi
        call MultiboardSetRowCount( udg_multi, 15 )
        call MultiboardSetColumnCount( udg_multi, ( 3 * udg_Heroes_Amount ) + 2 )
        call MultiboardSetTitleText( udg_multi, "Statistics [0:0:0]")
        call MultiboardDisplay( udg_multi, true)
        call MultiSetValue( udg_multi, 2, 1, I2S(udg_Heroes_Chanse) )
        call MultiSetValue( udg_multi, 2, 2, I2S(udg_Heroes_Ressurect) )
        call MultiSetValue( udg_multi, 3, 1, udg_Version )
        call MultiSetValue( udg_multi, 3, 2, "Common +0" )
        call MultiSetValue( udg_multi, 5, 1, "1/10" )
        call MultiSetValue( udg_multi, 1, 1, "Attempts Left:" )
        call MultiSetValue( udg_multi, 1, 2, "Resurrections:" )
        call MultiSetValue( udg_multi, 1, 4, "Spell power" )
        call MultiSetValue( udg_multi, 1, 5, "Luck" )
        call MultiSetValue( udg_multi, 1, 6, "Damage Dealt (Game)" )
        call MultiSetValue( udg_multi, 1, 7, "Damage Dealt (Fight)" )
        call MultiSetValue( udg_multi, 1, 8, "DPS" )
        call MultiSetValue( udg_multi, 1, 9, "Healing (Game)" )
        call MultiSetValue( udg_multi, 1, 10, "Healing (Fight)" )
        call MultiSetValue( udg_multi, 1, 11, "Mana (Game)" )
        call MultiSetValue( udg_multi, 1, 12, "Mana (Fight)" )
        call MultiSetValue( udg_multi, 1, 13, "Damage Taken (Game)" )
        call MultiSetValue( udg_multi, 1, 14, "Damage Taken (Fight)" )
        call MultiSetValue( udg_multi, 1, 15, "Sets" )
        call MultiSetValue( udg_multi, 4, 2, "IA" )
        call MultiSetValue( udg_multi, 5, 2, "AL" )
        call MultiSetValue( udg_multi, 4, 1, "Level:" )
        call MultiSetColor( udg_multi, 3, 1, 100.00, 80.00, 0.00, 0.00 )
        call MultiSetColor( udg_multi, 4, 1, 100.00, 80.00, 0.00, 0.00 )
        if udg_Heroes_Amount == 1 then
            call MultiSetColor( udg_multi, 3, 2, 80.00, 0.00, 0.00, 0.00 )
            set udg_logic[0] = true
        else
            call MultiSetColor( udg_multi, 3, 2, 100.00, 80.00, 0.00, 0.00 )
        endif
        loop
            exitwhen cyclA > 4
            set i = ( 3 * udg_Multiboard_Position[cyclA] ) - 1
            if GetPlayerSlotState(Player(cyclA - 1)) == PLAYER_SLOT_STATE_PLAYING then
                call MultiSetColor( udg_multi, i, 3, udg_Color_Player_Red[cyclA], udg_Color_Player_Green[cyclA], udg_Color_Player_Blue[cyclA], 0.00 )
                call MultiSetValue( udg_multi, i, 3, GetSmallPlayerName(GetPlayerName(Player(cyclA - 1)), cyclA) )
                call MultiSetIcon( udg_multi, i, 3, "ReplaceableTextures\\CommandButtons\\BTNSelectHeroOn.blp" )
                call MultiSetValue( udg_multi, i, 4, "0%" )
                call MultiSetValue( udg_multi, i, 5, "0% (0)" )
                call MultiSetWidth( udg_multi, i, 15, 1.00 )
                call MultiSetWidth( udg_multi, i + 1, 15, 1.00 )
                call MultiSetWidth( udg_multi, i + 2, 15, 6.00 )
                set udg_Color_Player_Red[cyclA] = 0.
                set udg_Color_Player_Green[cyclA] = 0.
                set udg_Color_Player_Blue[cyclA] = 0.
                if i + 2 != 1 then
                    call MultiSetColor( udg_multi, i + 2, 15, 101, 67, 33, 0. )
                    call MultiSetValue( udg_multi, i + 2, 15, "0" )
                endif
                set cyclB = 1
                loop
                    exitwhen cyclB > 14
                    call MultiSetWidth( udg_multi, i, cyclB, 7.98 )
                    call MultiSetWidth( udg_multi, i + 1, cyclB, 0.01 )
                    call MultiSetWidth( udg_multi, i + 2, cyclB, 0.01 )
                    if cyclB >= 6 then
                        call MultiSetValue( udg_multi, i, cyclB, "0" )
                    endif
                    set cyclB = cyclB + 1
                endloop
            endif
            set cyclA = cyclA + 1
        endloop
        
        set cyclA = 1
        loop
            exitwhen cyclA > 15
            call MultiSetWidth( udg_multi, 1, cyclA, 14 )
            call MultiSetStyle( udg_multi, 1, cyclA, true, false )
            set cyclA = cyclA + 1
        endloop
        set cyclA = 1
        set cyclAEnd = ( 3 * udg_Heroes_Amount ) + 2
        loop
            exitwhen cyclA > cyclAEnd
            call MultiSetColor( udg_multi, cyclA, 4, 100.00, 50.00, 100.00, 0.00 )
            call MultiSetColor( udg_multi, cyclA, 5, 90.00, 70.00, 35.00, 0.00 )
            call MultiSetColor( udg_multi, cyclA, 8, 85.00, 85.00, 0.00, 0.00 )
            if cyclA != 1 then
                if cyclA != ( 3 * udg_Heroes_Amount ) + 2 then
                    call MultiSetIcon( udg_multi, cyclA, 15, "ReplaceableTextures\\CommandButtons\\BTNCancel.blp" )
                else
                    call MultiSetStyle( udg_multi, cyclA, 15, true, false )
                endif
                call MultiSetStyle( udg_multi, cyclA, 1, true, false )
                call MultiSetStyle( udg_multi, cyclA, 2, true, false )
                if cyclA != 3 and cyclA != 4 then
                    call MultiSetWidth( udg_multi, cyclA, 1, 2.00 )
                    call MultiSetWidth( udg_multi, cyclA, 2, 2.00 )
                else
                    call MultiSetWidth( udg_multi, cyclA, 1, 6 )
                    call MultiSetWidth( udg_multi, cyclA, 2, 6 )
                endif
                if cyclA != 2 and cyclA != 5 and cyclA != 8 and cyclA != 11 then
                    call MultiSetStyle( udg_multi, cyclA, 3, true, false )
                endif
                set cyclB = 4
                loop
                    exitwhen cyclB > 14
                    call MultiSetStyle( udg_multi, cyclA, cyclB, true, false )
                    set cyclB = cyclB + 1
                endloop
            endif
            set cyclA = cyclA + 1
        endloop
        call MultiSetWidth( udg_multi, 4, 1, 6 )
        call MultiSetWidth( udg_multi, 5, 1, 4 )
        call MultiSetWidth( udg_multi, 4, 2, 2. )
        call MultiSetWidth( udg_multi, 3, 2, 8 )
        call MultiSetStyle( udg_multi, ( 3 * udg_Heroes_Amount ) + 2, 3, true, false )
        call MultiSetColor( udg_multi, 4, 2, 0, 0, 0, 100.00 )
        call MultiSetColor( udg_multi, 5, 2, 0, 0, 0, 100.00 )
        
        call MultiboardMinimize( udg_multi, true)
    endfunction

endlibrary