library OutcastLib

    function OutcastEQEnd takes nothing returns nothing
        local integer id = GetHandleId( GetExpiredTimer() )
        local unit u = LoadUnitHandle( udg_hash, id, StringHash( "outeq" ) )

        if GetUnitAbilityLevel(u, 'A082' ) == 0 then
                call FlushChildHashtable( udg_hash, id )
        else
            set udg_outcast[1] = true
            if GetLocalPlayer() == GetOwningPlayer(u) then
                    call BlzFrameSetVisible( outballframe[1], true )
            endif
        endif

        set u = null
    endfunction

    function OutcastEWEnd takes nothing returns nothing
        local integer id = GetHandleId( GetExpiredTimer() )
        local unit u = LoadUnitHandle( udg_hash, id, StringHash( "outew" ) )

        if GetUnitAbilityLevel(u, 'A082' ) == 0 then
                call FlushChildHashtable( udg_hash, id )
        else
            set udg_outcast[2] = true
            if GetLocalPlayer() == GetOwningPlayer(u) then
                    call BlzFrameSetVisible( outballframe[2], true )
            endif
        endif

        set u = null
    endfunction

    function OutcastEREnd takes nothing returns nothing
        local integer id = GetHandleId( GetExpiredTimer() )
        local unit u = LoadUnitHandle( udg_hash, id, StringHash( "outer" ) )

        if GetUnitAbilityLevel(u, 'A082' ) == 0 then
                call FlushChildHashtable( udg_hash, id )
        else
            set udg_outcast[3] = true
            if GetLocalPlayer() == GetOwningPlayer(u) then
                    call BlzFrameSetVisible( outballframe[3], true )
            endif
        endif

        set u = null
    endfunction

endlibrary