library Luck requires Multiboard

    globals
        private constant integer KEY_LUCK = StringHash("luck")
        private constant integer KEY_LUCK_PERCENT = StringHash("luckp")
    endglobals
    
    private function UpdateFrames takes integer heroIndex, integer newLuckPercent, integer newLuck returns nothing
        local string luckText
        local real k
    
        set luckText = I2S(newLuckPercent)
        call MultiSetValue( udg_multi, ( udg_Multiboard_Position[heroIndex] * 3 ) - 1, 5,  luckText + udg_perc + " (" + I2S( newLuck ) + ")")
        set k = StringLength(luckText) * 0.004
        if GetLocalPlayer() == Player(heroIndex-1) then
            call BlzFrameSetText(lucktext, luckText + udg_perc)
            call BlzFrameSetAbsPoint( lucktext, FRAMEPOINT_CENTER, 0.715 - k, 0.578 )
        endif
    endfunction

    function luckyst takes unit u, integer luck returns nothing
        local integer index = GetUnitUserData(u)
        local integer unitId = GetHandleId(u)
        local integer oldLuck = LoadInteger(udg_hash, unitId, KEY_LUCK )
        local integer newLuck 
        local integer newLuckPercent
        
        if index <= 0 or index > PLAYERS_LIMIT then
            set u = null
            return
        endif
        
        set newLuck = oldLuck + luck
        set newLuckPercent = R2I( RMaxBJ(0, ( SquareRoot( newLuck ) * 2 ) - 2 ) )
        call SaveInteger(udg_hash, unitId, KEY_LUCK, newLuck )
        call SaveInteger(udg_hash, unitId, KEY_LUCK_PERCENT, newLuckPercent )

        call UpdateFrames( index, newLuckPercent, newLuck )
        
        set u = null
    endfunction
    
    function GetUnitLuck takes unit myUnit returns real
        local real luck = LoadInteger(udg_hash, GetHandleId(myUnit), KEY_LUCK_PERCENT )
        set myUnit = null
        return luck
    endfunction

endlibrary