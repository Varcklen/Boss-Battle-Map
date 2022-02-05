library PauseLib

    function pausest takes unit u, integer i returns nothing
        local integer k = GetPlayerId(GetOwningPlayer( u )) + 1
        local integer g = LoadInteger( udg_hash, GetHandleId( u ), StringHash( "pause" ) )
        local boolean b = LoadBoolean( udg_hash, GetHandleId( u ), StringHash( "pause" ) )

        if IsUnitType( u, UNIT_TYPE_HERO) or IsUnitType( u, UNIT_TYPE_ANCIENT) then
            call SaveInteger( udg_hash, GetHandleId( u ), StringHash( "pause" ), g + i )
            set g = LoadInteger( udg_hash, GetHandleId( u ), StringHash( "pause" ) )

            if g >= 1 and not(b) then
                call SaveBoolean( udg_hash, GetHandleId( u ), StringHash( "pause" ), true )
                call PauseUnit( u, true )
            elseif g < 1 and b then
                call SaveBoolean( udg_hash, GetHandleId( u ), StringHash( "pause" ), false )
                call PauseUnit( u, false )
            endif
        elseif i > 0 then
            call PauseUnit( u, true )
        elseif i < 0 then
            call PauseUnit( u, false )
        endif
        
        set u = null
    endfunction

endlibrary