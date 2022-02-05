library QuestDiscLib requires TextLib, ChangeToolLib

    function QuestDiscription takes unit u, integer i, integer k, integer km returns nothing
        local item it = GetItemOfTypeFromUnitBJ(u, i)
        local string s = I2S(k)
        local string sm = I2S(km)
        
        call textst( "|c00ffffff " + s + "/" + sm, u, 64, GetRandomReal( 45, 135 ), 8, 1.5 )
        call BlzSetItemIconPath( it, words( u, BlzGetItemDescription(it), "|cFF959697(", ")|r", s + "/" + sm ) )
        
        set it = null
        set u = null
    endfunction

endlibrary