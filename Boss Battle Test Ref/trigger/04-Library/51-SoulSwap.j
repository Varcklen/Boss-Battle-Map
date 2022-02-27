library SoulSwap requires BuffDeleteLib

    function heroswap takes nothing returns nothing
        local integer cyclA
        local integer cyclB
        local integer cyclE
        local group array g
        local unit array un
        local unit u
        local integer array m
        local integer p
        local integer i
        
        if udg_Heroes_Amount > 1 and udg_Heroes_Amount - udg_Heroes_Deaths > 1 then
            set cyclA = 1
            loop
                exitwhen cyclA > 4
                set g[cyclA] = CreateGroup()
                set un[cyclA] = null
                set cyclA = cyclA + 1
            endloop
            
            set cyclE = 1
            loop
                exitwhen cyclE > 1
                set cyclA = 1
                loop
                    exitwhen cyclA > 4
                    if GetUnitState(udg_hero[cyclA], UNIT_STATE_LIFE) > 0.405 then
                        set cyclB = 1
                        loop
                            exitwhen cyclB > 4
                            if GetUnitState(udg_hero[cyclB], UNIT_STATE_LIFE) > 0.405 and GetOwningPlayer(udg_hero[cyclB]) != GetOwningPlayer(udg_hero[cyclA]) then
                                call GroupAddUnit(g[cyclB], udg_hero[cyclA])
                            endif
                            set cyclB = cyclB + 1
                        endloop
                    endif
                    set cyclA = cyclA + 1
                endloop
                
                set cyclA = 1
                loop
                    exitwhen cyclA > 4
                    if GetUnitState(udg_hero[cyclA], UNIT_STATE_LIFE) > 0.405 then
                        set un[cyclA] = GroupPickRandomUnit(g[cyclA])
                        set m[cyclA] = GetPlayerId(GetOwningPlayer(un[cyclA]))
                        if m[cyclA] == 10 then
                            set m[cyclA] = LoadInteger( udg_hash, GetHandleId( un[cyclA] ), StringHash( "control" ) )
                        endif
                        set cyclB = 1
                        loop
                            exitwhen cyclB > 4
                            if IsUnitInGroup(un[cyclA], g[cyclB]) then
                                call GroupRemoveUnit(g[cyclB], un[cyclA])
                            endif
                            set cyclB = cyclB + 1
                        endloop
                    endif
                    set cyclA = cyclA + 1
                endloop

                set cyclA = 1
                set p = 0
                loop
                    exitwhen cyclA > 4
                    if (GetUnitState(udg_hero[cyclA], UNIT_STATE_LIFE) > 0.405 and un[cyclA] != null) or GetUnitState(udg_hero[cyclA], UNIT_STATE_LIFE) <= 0.405 then
                        set p = p + 1
                    endif
                    set cyclA = cyclA + 1
                endloop
            
                if p < 4 then
                    set cyclE = cyclE - 1
                endif
                set cyclE = cyclE + 1
            endloop
            
            set cyclA = 1
            loop
                exitwhen cyclA > 4
                if GetUnitState(udg_hero[cyclA], UNIT_STATE_LIFE) > 0.405 then
                    call DelBuff( udg_hero[cyclA], false )
                    set i = m[cyclA]
                    set ChoosedHero[cyclA] = udg_hero[i]
                    if GetOwningPlayer(udg_hero[cyclA]) == Player(10) then
                        call SaveInteger( udg_hash, GetHandleId( udg_hero[cyclA] ), StringHash( "control" ), i )
                    else
                        if Transport[cyclA] != null and IsUnitAlive(Transport[cyclA]) then
                            call PanCameraToTimedForPlayer( Player(i), GetUnitX( Transport[cyclA] ), GetUnitY( udg_hero[cyclA] ), 0.25 )
                            call SetUnitOwner( Transport[cyclA], Player(i), true )
                            call SelectUnitForPlayerSingle( Transport[cyclA], Player(i) )
                        else
                            call PanCameraToTimedForPlayer( Player(i), GetUnitX( udg_hero[cyclA] ), GetUnitY( udg_hero[cyclA] ), 0.25 )
                            call SetUnitOwner( udg_hero[cyclA], Player(i), true )
                            call SelectUnitForPlayerSingle( udg_hero[cyclA], Player(i) )
                        endif
                    endif
                    call DestroyEffect( AddSpecialEffect("Abilities\\Spells\\Other\\Charm\\CharmTarget.mdl", GetUnitX(udg_hero[cyclA]), GetUnitY(udg_hero[cyclA])) )
                endif
                set cyclA = cyclA + 1
            endloop
        endif
        
        set cyclA = 1
        loop
            exitwhen cyclA > 4
            call GroupClear( g[cyclA] )
            call DestroyGroup( g[cyclA]  )
            set g[cyclA] = null
            set un[cyclA] = null
            set cyclA = cyclA + 1
        endloop
        
        set u = null
    endfunction
    
    public function End takes nothing returns nothing
        local integer i
        local player owner
        local unit hero
    
        set i = 1
        loop
            exitwhen i > PLAYERS_LIMIT
            set owner = Player( i - 1 )
            set hero = udg_hero[i]
            if GetPlayerSlotState( owner ) == PLAYER_SLOT_STATE_PLAYING then
                set ChoosedHero[i] = hero
                call DelBuff( hero, false )
                if IsUnitAlive(hero) then
                    call PanCameraToTimedLocForPlayer( owner, GetUnitLoc( hero ), 0 )
                endif
                call SetUnitOwner( hero, owner, true )
            endif
            set i = i + 1
        endloop
        
        set owner = null
        set hero = null
    endfunction

endlibrary