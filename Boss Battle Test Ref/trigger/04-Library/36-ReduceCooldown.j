library ReduceCooldown

    function UnitReduceCooldown takes unit u, real time returns nothing
        local integer array a
        local integer cyclA
        local integer i = GetUnitUserData(u)
        
        if not(IsUnitInGroup(u, udg_heroinfo)) then
            call BJDebugMsg("You are trying to reduce the cooldown of a \"" + GetUnitName(u) + "\" unit that is not a hero! Please report this error to the map author.")
            return
        endif
        
        set cyclA = 1
        loop
            exitwhen cyclA > 4
            set a[cyclA] = 0
            set cyclA = cyclA + 1
        endloop
        
        if GetUnitAbilityLevel( u, udg_DB_Hero_FirstSpell[udg_HeroNum[i]]) > 0 then
            set a[1] = udg_DB_Hero_FirstSpell[udg_HeroNum[i]]
        endif
        if GetUnitAbilityLevel( u, udg_Database_EarringSpell[udg_HeroNum[i]]) > 0 then
            set a[2] = udg_Database_EarringSpell[udg_HeroNum[i]]
        endif
        if GetUnitAbilityLevel( u, udg_DB_Hero_Passive[udg_HeroNum[i]]) > 0 then
            set a[3] = udg_DB_Hero_Passive[udg_HeroNum[i]]
        endif
        if GetUnitAbilityLevel( u, udg_DB_Hero_Fourth[udg_HeroNum[i]]) > 0 then
            set a[4] = udg_DB_Hero_Fourth[udg_HeroNum[i]]
        endif

        set cyclA = 1
        loop
            exitwhen cyclA > 4
            if a[cyclA] != 0 then
                if BlzGetUnitAbilityCooldownRemaining(u,a[cyclA]) > time then
                    call BlzStartUnitAbilityCooldown( u, a[cyclA], RMaxBJ( 0.1,BlzGetUnitAbilityCooldownRemaining(u, a[cyclA]) - time) )
                endif
            endif
            set cyclA = cyclA + 1
        endloop
        
        set cyclA = 1
        loop
            exitwhen cyclA > 4
            set a[cyclA] = 0
            set cyclA = cyclA + 1
        endloop

        set u = null
    endfunction

    function UnitReduceCooldownPercent takes unit u, real percent returns nothing
        local integer array a
        local integer cyclA
        local integer i = GetUnitUserData(u)

        if not(IsUnitInGroup(u, udg_heroinfo)) then
            call BJDebugMsg("You are trying to reduce the cooldown of a \"" + GetUnitName(u) + "\" unit that is not a hero! Please report this error to the map author.")
            return
        endif

        if percent < 0 then
            set percent = 0
        endif

        set cyclA = 1
        loop
            exitwhen cyclA > 4
            set a[cyclA] = 0
            set cyclA = cyclA + 1
        endloop
        
        if GetUnitAbilityLevel( u, udg_DB_Hero_FirstSpell[udg_HeroNum[i]]) > 0 then
            set a[1] = udg_DB_Hero_FirstSpell[udg_HeroNum[i]]
        endif
        if GetUnitAbilityLevel( u, udg_Database_EarringSpell[udg_HeroNum[i]]) > 0 then
            set a[2] = udg_Database_EarringSpell[udg_HeroNum[i]]
        endif
        if GetUnitAbilityLevel( u, udg_DB_Hero_Passive[udg_HeroNum[i]]) > 0 then
            set a[3] = udg_DB_Hero_Passive[udg_HeroNum[i]]
        endif
        if GetUnitAbilityLevel( u, udg_DB_Hero_Fourth[udg_HeroNum[i]]) > 0 then
            set a[4] = udg_DB_Hero_Fourth[udg_HeroNum[i]]
        endif

        set cyclA = 1
        loop
            exitwhen cyclA > 4
            if a[cyclA] != 0 then
                call BlzStartUnitAbilityCooldown( u, a[cyclA], RMaxBJ( 0.1,BlzGetUnitAbilityCooldownRemaining(u, a[cyclA]) * percent) )
            endif
            set cyclA = cyclA + 1
        endloop
        
        set cyclA = 1
        loop
            exitwhen cyclA > 4
            set a[cyclA] = 0
            set cyclA = cyclA + 1
        endloop

        set u = null
    endfunction

endlibrary