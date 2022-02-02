function Trig_SetItemInfo_Actions takes nothing returns nothing
    local integer cyclA
    local integer cyclAEnd
    local integer cyclB
    local integer cyclBEnd
    local rect array reg 
    local item it
    
    set reg[1] = gg_rct_Set1
    set reg[2] = gg_rct_Set2
    set reg[3] = gg_rct_Set3
    set reg[4] = gg_rct_Set4
    set reg[5] = gg_rct_Set5
    set reg[6] = gg_rct_Set6
    set reg[7] = gg_rct_Set7
    set reg[8] = gg_rct_Set8
    set reg[9] = gg_rct_Set9
    call CreateText( "|cffb18904Mech|r", Location(GetRectCenterX(gg_rct_Set1), GetRectCenterY(gg_rct_Set1)), 0, 10, 255, 255, 255, 0 )
    call CreateText( "|cff2d9995Weapon|r", Location(GetRectCenterX(gg_rct_Set2), GetRectCenterY(gg_rct_Set2)), 0, 10, 255, 255, 255, 0 )
    call CreateText( "|cff9001fdRing|r", Location(GetRectCenterX(gg_rct_Set3), GetRectCenterY(gg_rct_Set3)), 0, 10, 255, 255, 255, 0 )
    call CreateText( "|cffb40431Blood|r", Location(GetRectCenterX(gg_rct_Set4), GetRectCenterY(gg_rct_Set4)), 0, 10, 255, 255, 255, 0 )
    call CreateText( "|cff848484Rune|r", Location(GetRectCenterX(gg_rct_Set5), GetRectCenterY(gg_rct_Set5)), 0, 10, 255, 255, 255, 0 )
    call CreateText( "|cff5858faMoon|r", Location(GetRectCenterX(gg_rct_Set6), GetRectCenterY(gg_rct_Set6)), 0, 10, 255, 255, 255, 0 )
    call CreateText( "|cff7cfc00Nature|r", Location(GetRectCenterX(gg_rct_Set7), GetRectCenterY(gg_rct_Set7)), 0, 10, 255, 255, 255, 0 )
    call CreateText( "|cfffe9a2eAlchemy|r", Location(GetRectCenterX(gg_rct_Set8), GetRectCenterY(gg_rct_Set8)), 0, 10, 255, 255, 255, 0 )
    call CreateText( "|cff00cceeCrystal|r", Location(GetRectCenterX(gg_rct_Set9), GetRectCenterY(gg_rct_Set9)), 0, 10, 255, 255, 255, 0 )

    set cyclB = 1
    set cyclBEnd = 9
    loop
        exitwhen cyclB > cyclBEnd
        set cyclA = 1
        set cyclAEnd = udg_DB_SetItems_Num[cyclB]
        loop
            exitwhen cyclA > cyclAEnd
            if cyclA < 30 then
                set it = CreateItem( DB_SetItems[cyclB][cyclA], GetRectCenterX(reg[cyclB]), GetRectCenterY(reg[cyclB])-(150*cyclA))
                call SaveBoolean( udg_hash, GetHandleId( it ), StringHash( "sreg" ), true )
            else
                set cyclA = cyclAEnd
            endif
            set cyclA = cyclA + 1
        endloop
        set cyclB = cyclB + 1
    endloop
    
    set cyclA = 1
    set cyclAEnd = 9
    loop
        exitwhen cyclA > cyclAEnd
        set reg[cyclA] = null
        set cyclA = cyclA + 1
    endloop
    
    set it = null
endfunction

//===========================================================================
function InitTrig_SetItemInfo takes nothing returns nothing
    set gg_trg_SetItemInfo = CreateTrigger(  )
    call TriggerRegisterTimerExpireEvent( gg_trg_SetItemInfo, udg_StartTimer )
    call TriggerAddAction( gg_trg_SetItemInfo, function Trig_SetItemInfo_Actions )
endfunction

