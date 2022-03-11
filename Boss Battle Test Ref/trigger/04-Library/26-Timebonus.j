library TimebonusLib requires SetCount

    function timebonus takes unit u, real r returns real
        local real t = r
        local integer i = GetUnitUserData(u)
        
        set t = t + (udg_RandomBonus_BuffDuration[i]*r)
        
        if inv( u, 'I0D1' ) > 0 then
            set t = t + (0.5*r)
        endif
        if udg_modgood[28] then
            set t = t + (0.25*r)
        endif
        if inv( u, 'I0GG' ) > 0 then
            set t = t + (SetCount_GetPieces(u, SET_MECH)*0.15*r)
        endif

        set u = null
        return t
    endfunction

endlibrary