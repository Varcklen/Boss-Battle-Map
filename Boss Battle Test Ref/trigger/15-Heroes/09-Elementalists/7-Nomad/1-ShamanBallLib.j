library ShamanBallLib

    function BallEnergy takes unit u, integer k returns nothing
        local player p = GetOwningPlayer( u )
        local integer i = GetPlayerId(p) + 1
        local integer f

        set udg_lightball[i] = udg_lightball[i] + k

        if udg_lightball[i] < 0 then
            set udg_lightball[i] = 0
        elseif udg_lightball[i] >= 3 then
            set udg_lightball[i] = 3
        endif
        set f = udg_lightball[i]

        if BlzFrameIsVisible( shamanframe ) then
            if GetLocalPlayer() == p then
                if f == 0 then
                    call BlzFrameSetVisible( spfframe[1], false )
                    call BlzFrameSetVisible( spfframe[2], false )
                    call BlzFrameSetVisible( spfframe[3], false )
                elseif f == 1 then
                    call BlzFrameSetVisible( spfframe[1], true )
                    call BlzFrameSetVisible( spfframe[2], false )
                    call BlzFrameSetVisible( spfframe[3], false )
                elseif f == 2 then
                    call BlzFrameSetVisible( spfframe[1], true )
                    call BlzFrameSetVisible( spfframe[2], true )
                    call BlzFrameSetVisible( spfframe[3], false )
                elseif f == 3 then
                    call BlzFrameSetVisible( spfframe[1], true )
                    call BlzFrameSetVisible( spfframe[2], true )
                    call BlzFrameSetVisible( spfframe[3], true )
                endif
            endif
        endif

        set u = null
        set p = null
    endfunction

endlibrary