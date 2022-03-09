library LuckylogicLib requires Luck

    private function OtherUses takes unit u, integer k returns integer
        local integer ch = k
        if inv(u, 'I01E') > 0 then
            set ch = ch * 2
        endif
        
        set u = null
        return ch
    endfunction

    //Use this if you need to set the minimum and maximum edges of a die. Otherwise use LuckChance.
    function luckylogic takes unit u, integer ch, integer min, integer max returns boolean
        local boolean l = false
        
        if GetRandomInt( min, max ) <= ( OtherUses(u, ch) + GetUnitLuck(u) ) then
            set l = true
        endif
        set u = null
        return l
    endfunction

    function LuckChance takes unit u, integer ch returns boolean
        return luckylogic(u, ch, 1, 100 )
    endfunction

endlibrary