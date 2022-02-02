library LuckLib requires Multiboard

    function luckyst takes unit u, integer luck returns nothing
        local integer i = GetUnitUserData(u)
        local real lk = 0
        local integer cyclA = 1
        local integer cyclAEnd
        local real k
        
        set udg_lucky[i] = udg_lucky[i] + luck
        set cyclAEnd = udg_lucky[i]
        loop
            exitwhen cyclA > cyclAEnd
            set lk = lk + ( SquareRoot(cyclA ) / ( cyclA + 1 ) )
            set cyclA = cyclA + 1
        endloop
        set udg_luckychance[i] = R2I( lk )

        call MultiSetValue( udg_multi, ( udg_Multiboard_Position[i] * 3 ) - 1, 5,  I2S(udg_luckychance[i]) + udg_perc + " (" + I2S( udg_lucky[i] ) + ")")
        if GetLocalPlayer() == Player(i-1) then
            set luckstr[i] = I2S(udg_luckychance[i])
            set k = StringLength(luckstr[i]) * 0.004
            call BlzFrameSetText(lucktext, luckstr[i] + udg_perc)
            call BlzFrameSetAbsPoint( lucktext, FRAMEPOINT_CENTER, 0.715 - k, 0.578 )
        endif
        
        set u = null
    endfunction

    function luckystpl takes integer p, integer luck returns nothing
        local player pl = Player( p )
        local integer i = GetPlayerId( pl ) + 1
        local real lk = 0
        local integer cyclA = 1
        local integer cyclAEnd
        local real k
        
        set udg_lucky[i] = udg_lucky[i] + luck
        set cyclAEnd = udg_lucky[i]
        loop
            exitwhen cyclA > cyclAEnd
            set lk = lk + ( SquareRoot( cyclA ) / ( cyclA + 1 ) )
            set cyclA = cyclA + 1
        endloop
        set udg_luckychance[i] = R2I( lk )

        call MultiSetValue( udg_multi, ( udg_Multiboard_Position[i] * 3 ) - 1, 5,  I2S(udg_luckychance[i]) + udg_perc + " (" + I2S( udg_lucky[i] ) + ")")
        
        set luckstr[i] = I2S(udg_luckychance[i])
        set k = StringLength(luckstr[i]) * 0.004
        if GetLocalPlayer() == pl then
            call BlzFrameSetText(lucktext, luckstr[i] + udg_perc)
            call BlzFrameSetAbsPoint( lucktext, FRAMEPOINT_CENTER, 0.715 - k, 0.578 )
        endif

        set pl = null
    endfunction
    
    function GetUnitLuck takes unit myUnit returns real
        local real luck = udg_luckychance[GetUnitUserData(myUnit)]
        set myUnit = null
        return luck
    endfunction

endlibrary