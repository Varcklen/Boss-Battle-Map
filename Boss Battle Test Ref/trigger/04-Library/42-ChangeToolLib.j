library ChangeToolLib

    function words takes unit caster, string s, string color, string end, string new returns string
        local integer cyclA = 0
        local integer cyclAEnd = StringLength(s)
        local integer cyclB
        local boolean cyclL
        local integer k = 0
        local integer size = StringLength(color)
        local integer esize = StringLength(end)
        local integer j
        local string done

        loop
            exitwhen cyclA > cyclAEnd
            set j = cyclA+size
            //call DisplayTimedTextToForce( GetPlayersAll(), 5.00, SubString(s, cyclA, j) )
            if SubString(s, cyclA, j) == color then
                set cyclB = 1
                set cyclL = false
                loop
                    exitwhen cyclL == true
                    //call DisplayTimedTextToForce( GetPlayersAll(), 5.00, SubString(s, j + cyclB, j + cyclB+2) )
                    if SubString(s, j + cyclB, j + cyclB+esize) == end then
                        set cyclL = true
                        set k = j + cyclB
                    elseif cyclB >= 32 then
                        set cyclL = true
                        set k = j + 1
                    endif
                    set cyclB = cyclB + 1
                endloop
                set cyclA = cyclAEnd
            endif
            set cyclA = cyclA + 1
        endloop

        if k != 0 then
            set done = SubString(s, 0, j)+new+SubString(s, k, cyclAEnd)
        else
            set done = s
        endif
        //call DisplayTimedTextToForce( GetPlayersAll(), 5.00, done )
        set caster = null
        return done
    endfunction

    function ChangeToolItem takes unit caster, integer itm, string color, string end, string new returns nothing
        local item it = GetItemOfTypeFromUnitBJ( caster, itm)
        
        if it != null then
            call BlzSetItemExtendedTooltip( it, words( caster, BlzGetItemExtendedTooltip(it), color, end, new ) )
        endif
        
        set caster = null
        set it = null
    endfunction

    function wordscurrent takes unit caster, string s, string color, string new returns string
        local integer cyclA = 0
        local integer cyclAEnd = StringLength(s)
        local boolean l = false
        local integer size = StringLength(color)
        local integer g = 0
        local integer j
        local string done

        loop
            exitwhen cyclA > cyclAEnd
            set j = cyclA+size
            //call DisplayTimedTextToForce( GetPlayersAll(), 5.00, SubString(s, cyclA, j) )
            if SubString(s, cyclA, j) == color then
                set g = cyclA
                set l = true
                set cyclA = cyclAEnd
            endif
            set cyclA = cyclA + 1
        endloop

        if l then
            set done = SubString(s, 0, g)+new+SubString(s, j, cyclAEnd)
        else
            set done = s
        endif
        set caster = null
        //call DisplayTimedTextToForce( GetPlayersAll(), 5.00, done )
        return done
    endfunction

    function ChangeToolCurrentItem takes unit caster, integer itm, string color, string new returns nothing
        local item it = GetItemOfTypeFromUnitBJ( caster, itm)
        
        if it != null then
            call BlzSetItemIconPath( it, wordscurrent( caster, BlzGetItemExtendedTooltip(it), color, new ) )
        endif
        
        set caster = null
        set it = null
    endfunction

endlibrary
