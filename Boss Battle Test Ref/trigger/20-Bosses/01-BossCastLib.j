library BossCastLib

    function bosscast takes real r returns real
        local real n = r

        if udg_logic[101] then
            set n = n - (0.2*r)
        endif
        if udg_modbad[22] then
            set n = n - (0.1*r)
        endif
        if udg_Endgame > 1 then
            set n = n - (0.1*(udg_Endgame-1))
        endif
        if n < 0.2*r then
            set n = 0.2*r
        endif
        return n
    endfunction

endlibrary