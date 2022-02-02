library SpdLibLib requires TextLib

    function spdst takes unit u, real spd returns nothing
        local integer i = GetUnitUserData(u)
        local real r 
        local real a
        local real k
        
        set udg_SpellDamage[i] = udg_SpellDamage[i] + ( spd / 100 ) 
        set r = 100 * ( udg_SpellDamage[i] - 1 )
        set a = r - 1

        if a < 0 and a > -1 then
            set a = 0
        endif

        call MultiSetValue( udg_multi, ( udg_Multiboard_Position[i] * 3 ) - 1, 4, R2SW( a, 1, 2 ) + udg_perc )
        call MultiSetValue( udg_multi, ( udg_Multiboard_Position[i] * 3 ) - 1, 4, R2SW( a, 1, 2 ) + udg_perc )
        set spellstr[i] = R2SW( a, 1, 2 )
        set k = StringLength(spellstr[i]) * 0.004
        if GetLocalPlayer() == Player(i-1) then
            call BlzFrameSetText(spelltext, spellstr[i] + udg_perc)
            call BlzFrameSetAbsPoint( spelltext, FRAMEPOINT_CENTER, 0.636 - k, 0.578 )
        endif
        
        set u = null
    endfunction

    function SpellPotionUnit takes unit hero, real spd returns nothing
        local integer p = GetUnitUserData(hero)
        local player pl = GetOwningPlayer(hero)
        local integer i = p
        local string str
        local real r 
        local real a
        local real k
        
        set udg_SpellDamagePotion[i] = udg_SpellDamagePotion[i] + ( spd / 100 ) 
        set r = 100 * ( udg_SpellDamagePotion[i] - 1 )
        set a = r - 1

        if a < 0 and a > -1 then
            set a = 0
        endif

        set str = R2SW( a, 1, 2 )
        set k = StringLength(str) * 0.004
        if GetLocalPlayer() == pl then
            call BlzFrameSetText(extraPanelNumPotion, str + udg_perc)
            call BlzFrameSetPoint(extraPanelNumPotion, FRAMEPOINT_LEFT, extraPanelBackground, FRAMEPOINT_LEFT, 0.051 - k, -0.006)
        endif
        
        set hero = null
        set pl = null
    endfunction

    function SpellUniqueUnit takes unit hero, real spd returns nothing
        local integer i = GetUnitUserData(hero)
        local player pl = GetOwningPlayer(hero)
        local string str
        local real r 
        local real a
        local real k
        
        set udg_SpellDamageSpec[i] = udg_SpellDamageSpec[i] + ( spd / 100 ) 
        set r = 100 * ( udg_SpellDamageSpec[i] - 1 )
        set a = r - 1

        if a < 0 and a > -1 then
            set a = 0
        endif
        
        set str = R2SW( a, 1, 2 )
        set k = StringLength(str) * 0.004
        if GetLocalPlayer() == pl then
            call BlzFrameSetText(extraPanelNumUnique, str + udg_perc)
            call BlzFrameSetPoint(extraPanelNumUnique, FRAMEPOINT_LEFT, extraPanelBackground, FRAMEPOINT_LEFT, 0.051 - k, -0.025)
        endif

        set pl = null
        set hero = null
    endfunction
    
    function GetUnitSpellPower takes unit myUnit returns real
        local player owner = GetOwningPlayer(myUnit)
        local real spellPower
        
        if owner == Player(10) or owner == Player(11) or owner == Player(PLAYER_NEUTRAL_AGGRESSIVE) then
            set spellPower = udg_SpellDamage[0]
        elseif IsUnitInGroup(myUnit, udg_heroinfo) then
            set spellPower = udg_SpellDamage[GetUnitUserData(myUnit)]
        else
            set spellPower = udg_SpellDamage[GetPlayerId( GetOwningPlayer(myUnit) ) + 1]
        endif
        set owner = null
        set myUnit = null
        return spellPower
    endfunction
    
    function GetPotionSpellPower takes unit myUnit returns real
        local real spellPower = udg_SpellDamagePotion[GetUnitUserData(myUnit)]
        
        set myUnit = null
        return spellPower
    endfunction
    
    function GetUniqueSpellPower takes unit myUnit returns real
        local real spellPower = udg_SpellDamageSpec[GetUnitUserData(myUnit)]
        
        set myUnit = null
        return spellPower
    endfunction
    
    //Obsolete. Do not use.
    function spdstpl takes integer p, real spd returns nothing
        local player pl = Player( p )
        local integer i = GetPlayerId( pl ) + 1
        local real r 
        local real a
        local real k
        
        set udg_SpellDamage[i] = udg_SpellDamage[i] + ( spd / 100 ) 
        set r = 100 * ( udg_SpellDamage[i] - 1 )
        set a = r - 1

        if a < 0 and a > -1 then
            set a = 0
        endif
        call MultiSetValue( udg_multi, ( udg_Multiboard_Position[i] * 3 ) - 1, 4, R2SW( a, 1, 2 ) + udg_perc )
        call MultiSetValue( udg_multi, ( udg_Multiboard_Position[i] * 3 ) - 1, 4, R2SW( a, 1, 2 ) + udg_perc )
        
        set spellstr[i] = R2SW( a, 1, 2 )
        set k = StringLength(spellstr[i]) * 0.004
        if GetLocalPlayer() == pl then
            call BlzFrameSetText(spelltext, spellstr[i] + udg_perc)
            call BlzFrameSetAbsPoint( spelltext, FRAMEPOINT_CENTER, 0.636 - k, 0.578 )
        endif
        
        set pl = null
    endfunction

    //Obsolete. Do not use.
    function SpellPotion takes integer p, real spd returns nothing
        local player pl = Player( p-1 )
        local integer i = GetPlayerId( pl ) + 1
        local string str
        local real r 
        local real a
        local real k
        
        set udg_SpellDamagePotion[i] = udg_SpellDamagePotion[i] + ( spd / 100 ) 
        set r = 100 * ( udg_SpellDamagePotion[i] - 1 )
        set a = r - 1

        if a < 0 and a > -1 then
            set a = 0
        endif

        set str = R2SW( a, 1, 2 )
        set k = StringLength(str) * 0.004
        if GetLocalPlayer() == pl then
            call BlzFrameSetText(extraPanelNumPotion, str + udg_perc)
            call BlzFrameSetPoint(extraPanelNumPotion, FRAMEPOINT_LEFT, extraPanelBackground, FRAMEPOINT_LEFT, 0.051 - k, -0.006)
        endif
        
        set pl = null
    endfunction

endlibrary