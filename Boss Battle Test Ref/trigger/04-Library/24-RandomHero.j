library RandomHero

    globals
        private constant integer ATTEMPTS_TO_PICK_RANDOM_HERO = 3
        private integer array Attempts_Used[PLAYERS_LIMIT_ARRAYS]
        private unit Temp = null
    endglobals

    public function IsCanPick takes player owner returns boolean
        local boolean isCan = Attempts_Used[GetPlayerId(owner) + 1] < ATTEMPTS_TO_PICK_RANDOM_HERO
        
        set owner = null
        return isCan
    endfunction
    
    public function IsCanPickByIndex takes integer playerIndex returns boolean
        return Attempts_Used[playerIndex] < ATTEMPTS_TO_PICK_RANDOM_HERO
    endfunction
    
    public function GetRandomHero takes player p returns unit
        local integer cyclA = 1
        local integer rand
        local integer i = GetPlayerId(p) + 1
        set Temp = null

        if IsCanPick(p) then
            set Attempts_Used[i] = Attempts_Used[i] + 1
            if udg_Boss_LvL == 1 then
                call DisplayTimedTextToPlayer( p, 0, 0, 10., "Attempts left: " + I2S( 3 - Attempts_Used[i] ) )
            endif
            loop
                exitwhen cyclA > 1
                set rand = GetRandomInt(1, udg_Database_InfoNumberHeroes)
                if CountUnitsInGroup(GetUnitsOfTypeIdAll(udg_Database_Hero[rand])) == 0 and udg_UnitHeroLogic[rand] == false and IsBanned[rand] == false then
                    set udg_logic[8] = true
                    set Temp = CreateUnit( p, udg_Database_Hero[rand], GetRectCenterX(gg_rct_HeroesTp), GetRectCenterY(gg_rct_HeroesTp), 270 )
                else
                    set cyclA = cyclA - 1
                endif
                set cyclA = cyclA + 1
            endloop
        endif
        set p = null
        return Temp
    endfunction
    
endlibrary