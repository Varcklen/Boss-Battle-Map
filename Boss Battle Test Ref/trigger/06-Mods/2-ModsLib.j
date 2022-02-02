library Mods requires LibDataAbilities, SpdLibLib, RandomTargetLib, Money, Multiboard, LuckLib, NullingAbility, ModsData, ChallengeData
    globals
        real Event_Mode_Awake_Real = 0
    endglobals
    
    private function EnableGoodMode takes integer index returns boolean
        local integer abilityId = 0
        
        if udg_modgood[index] == false then
            set udg_modgood[index] = true
            set abilityId = udg_DB_GoodMod[index]
            call IconFrame( "ModGood" + I2S(index), BlzGetAbilityIcon(abilityId), BlzGetAbilityTooltip(abilityId, 0), BlzGetAbilityExtendedTooltip(abilityId, 0) )
            return true
        else
            return false
        endif
    endfunction
    
    private function EnableBadMode takes integer index returns boolean
        local integer abilityId = 0
        
        if udg_modbad[index] == false then
            set udg_modbad[index] = true
            set abilityId = udg_DB_BadMod[index]
            call IconFrame( "ModBad" + I2S(index), BlzGetAbilityIcon(abilityId), BlzGetAbilityTooltip(abilityId, 0), BlzGetAbilityExtendedTooltip(abilityId, 0) )
            return true
        else
            return false
        endif
    endfunction
    
    private function ActivateGoodModes takes integer count returns nothing
        local integer i
        local integer rand
        local ListInt modes = ListInt.create() 
        
        set i = 1
        loop
            exitwhen i > udg_Database_NumberItems[7]
            call modes.Add(i)
            set i = i + 1
        endloop
        
        if count > 0 then
            set i = 1
            loop
                exitwhen i > count or modes.Size() <= 0 
                set rand = GetRandomInt( 1, modes.Size())
                call EnableGoodMode(rand)
                call modes.RemoveByIndex(rand)
                set i = i + 1
            endloop
        endif
        
        call modes.destroy()
    endfunction
    
    private function ActivateBadModes takes integer count returns nothing
        local integer i
        local integer rand
        local ListInt modes = ListInt.create() 
        
        set i = 1
        loop
            exitwhen i > udg_Database_NumberItems[22]
            call modes.Add(i)
            set i = i + 1
        endloop
        
        if udg_worldmod[6] then
            set count = udg_Database_NumberItems[22]
        elseif udg_worldmod[7] then
            set i = 1
            loop
                exitwhen i > ChallengeData_CURSES
                set rand = Challenges[Chosen_Challenge][i]
                call EnableBadMode(rand)
                call modes.RemoveByIndex(rand)
                set i = i + 1
            endloop
        endif
        
        if count > 0 then
            set i = 1
            loop
                exitwhen i > count or modes.Size() <= 0 
                set rand = GetRandomInt( 1, modes.Size())
                call EnableBadMode(rand)
                call modes.RemoveByIndex(rand)
                set i = i + 1
            endloop
        endif
        
        call modes.destroy()
    endfunction
    
    public function Awake takes nothing returns nothing
        local integer cyclA = 1
        local integer cyclAEnd
        local integer cyclB
        local integer cyclBEnd
        local integer m = 0
        local integer n = 0
        local integer p = 0
        local integer rand = 0
        local integer g = 0
        local boolean isActivated = false
    
        //Newbie
        if udg_logic[89] then
            set udg_BossHP = udg_BossHP - 0.25
            set udg_BossAT = udg_BossAT - 0.25
            set udg_SpellDamage[0] = udg_SpellDamage[0] - 0.25

            call IconFrame( "Newbie", BlzGetAbilityIcon('A0MC'), BlzGetAbilityTooltip('A0MC', 0), BlzGetAbilityExtendedTooltip('A0MC', 0) )
        endif
        
        //Power Up
        if udg_logic[6] then
            set udg_logic[7] = true
            call IconFrame( "Power up", BlzGetAbilityIcon('A09D'), BlzGetAbilityTooltip('A09D', 0), BlzGetAbilityExtendedTooltip('A09D', 0) )
        endif
        
        //Hardcore
        if udg_logic[100] then
            set udg_logic[101] = true
            call IconFrame( "Hardcore", BlzGetAbilityIcon('A15C'), BlzGetAbilityTooltip('A15C', 0), BlzGetAbilityExtendedTooltip('A15C', 0) )
        endif
    
        //Random Hero
        if udg_logic[77] then
            call IconFrame( "New one", BlzGetAbilityIcon('A0D2'), BlzGetAbilityTooltip('A0D2', 0), BlzGetAbilityExtendedTooltip('A0D2', 0) )

            call resethero()
            call GroupClear( udg_otryad )
            call GroupClear( udg_heroinfo )
            set cyclA = 1
            loop
                exitwhen cyclA > 4
                if GetPlayerSlotState(Player(cyclA - 1)) == PLAYER_SLOT_STATE_PLAYING then
                    call UnitAddAbility( udg_unit[35 + cyclA], 'A0D2' )
                    if udg_number[cyclA + 100] == 7 then
                        call spdst( udg_hero[cyclA], -10 )
                    endif
                    call UnitRemoveAbility( udg_unit[cyclA + 4], udg_HeroStatus[cyclA] )
                    call delspellpas( udg_hero[cyclA + 1] )
                    if GetUnitTypeId(udg_hero[cyclA]) == udg_Database_Hero[1] then
                        call DestroyLeaderboard( udg_panel[1] )
                    elseif GetUnitTypeId(udg_hero[cyclA]) == 'O016' then
                        call DestroyLeaderboard( udg_panel[3] )
                    endif
                    call RemoveUnit( udg_hero[cyclA] )
                    set udg_hero[cyclA] = null
                endif
                set cyclA = cyclA + 1
            endloop
            set cyclA = 0
            loop
                exitwhen cyclA > 3
                if GetPlayerSlotState(Player(cyclA)) == PLAYER_SLOT_STATE_PLAYING then
                    set rand = GetRandomInt(1, udg_Database_InfoNumberHeroes)
                    if CountUnitsInGroup(GetUnitsOfTypeIdAll(udg_Database_Hero[rand])) == 0 then
                        set bj_lastCreatedUnit = CreateUnit(Player(cyclA), udg_Database_Hero[rand], GetRectCenterX(gg_rct_HeroesTp), GetRectCenterY(gg_rct_HeroesTp), 90. )
                        call moneyst( bj_lastCreatedUnit, 250 )
                    else
                        set cyclA = cyclA - 1
                    endif
                endif
                set cyclA = cyclA + 1
            endloop
            call TriggerSleepAction( 0.01 )
        endif
        
        //Bless & Curse
        if udg_worldmod[0] then
            set p = 0
            set udg_logic[0] = true
            call MultiSetColor( udg_multi, 3, 2, 80.00, 0.00, 0.00, 25.00 )
            if udg_worldmod[1] then
                call TriggerExecute( gg_trg_FastStart_Data )
                call TriggerExecute( gg_trg_Fast_Start_Choose )
                set p = 'A03K'
            elseif udg_worldmod[2] then
                set udg_logic[10] = true
                set p = 'A0BK'
            elseif udg_worldmod[3] then
                set m = 1
                set n = 1
                set p = 'A0HK'
            elseif udg_worldmod[4] then
                set m = 2
                set n = 2
                set p = 'A0HL'
            elseif udg_worldmod[5] then
                set m = 4
                set n = 4
                set p = 'A0HM'
            elseif udg_worldmod[6] then
                set n = udg_Database_NumberItems[22]
                set p = 'A1BM'
            elseif udg_worldmod[7] then
                set p = 'A0WT'
            elseif udg_worldmod[8] then
                set udg_logic[51] = true
                set cyclA = 1
                loop
                    exitwhen cyclA > 4
                    if GetPlayerSlotState(Player(cyclA-1)) == PLAYER_SLOT_STATE_PLAYING then
                        set cyclB = 0
                        loop
                            exitwhen cyclB > 5
                            call RemoveItem(UnitItemInSlot(udg_hero[cyclA], cyclB))
                            if cyclB == 0 then
                                call UnitAddItem( udg_hero[cyclA], CreateItem( 'I0FB', GetUnitX(udg_hero[cyclA]), GetUnitY(udg_hero[cyclA]) ) )
                            else
                                call UnitAddItem( udg_hero[cyclA], CreateItem( 'I0B5', GetUnitX(udg_hero[cyclA]), GetUnitY(udg_hero[cyclA]) ) )
                            endif
                            set cyclB = cyclB + 1
                        endloop
                    endif
                    set cyclA = cyclA + 1
                endloop
                call ShowUnit(gg_unit_h01G_0201, false)
                set p = 'A1BX'
            endif
            if p != 0 then
                call IconFrame( "Mode", BlzGetAbilityIcon(p), BlzGetAbilityTooltip(p, 0), BlzGetAbilityExtendedTooltip(p, 0) )
            endif
        endif

        if AnyHasLvL(9) then
            set m = m + 1
            set n = n + 1
        endif
        
        //Bless Choose
        call ActivateGoodModes(m)
        
        //Curse Choose
        call ActivateBadModes(n)

        //Bless Activation
        if m > 0 then
            if udg_modgood[2] then
                call RessurectionPoints( 1, true )
            endif
            if udg_modgood[3] then
                set cyclA = 1
                loop
                    exitwhen cyclA > 4
                    if GetPlayerSlotState(Player(cyclA - 1)) == PLAYER_SLOT_STATE_PLAYING then
                        call ItemRandomizerAll( udg_hero[cyclA], 0 )
                    endif
                    set cyclA = cyclA + 1
                endloop
            endif
            if udg_modgood[4] then
                call EnableTrigger( gg_trg_Thirst )
            endif
            if udg_modgood[5] then
                call EnableTrigger( gg_trg_Malice )
            endif
            if udg_modgood[8] then
                call EnableTrigger( gg_trg_Magic )
            endif
            if udg_modgood[9] then
                set cyclA = 1
                loop
                    exitwhen cyclA > 4
                    if GetPlayerSlotState(Player(cyclA - 1)) == PLAYER_SLOT_STATE_PLAYING then
                        call UnitAddAbility( udg_hero[cyclA], 'A0HQ' )
                    endif
                    set cyclA = cyclA + 1
                endloop
            endif
            if udg_modgood[10] then
                call EnableTrigger( gg_trg_Necropotion )
            endif
            if udg_modgood[13] then
                call ReplaceUnitBJ( gg_unit_h00H_0070, 'h00R', bj_UNIT_STATE_METHOD_RELATIVE )
                call ReplaceUnitBJ( gg_unit_h00V_0071, 'h00X', bj_UNIT_STATE_METHOD_RELATIVE )
                call ReplaceUnitBJ( gg_unit_h00U_0072, 'h00Y', bj_UNIT_STATE_METHOD_RELATIVE )
                call ReplaceUnitBJ( gg_unit_h00T_0073, 'h00W', bj_UNIT_STATE_METHOD_RELATIVE )
            endif
            if udg_modgood[14] then
                call EnableTrigger( gg_trg_Hronospeed )
            endif
            if udg_modgood[15] then
                call UnitAddAbility( gg_unit_u00F_0006, 'A0IT' )
                set cyclA = 1
                loop
                    exitwhen cyclA > 4
                    if GetPlayerSlotState(Player(cyclA - 1)) == PLAYER_SLOT_STATE_PLAYING then
                        call spdst( udg_hero[cyclA], 10 )
                    endif
                    set cyclA = cyclA + 1
                endloop
            endif
            if udg_modgood[17] then
                call EnableTrigger( gg_trg_Reborn )
            endif
            if udg_modgood[18] then
                set cyclA = 1
                loop
                    exitwhen cyclA > 4
                    if GetPlayerSlotState(Player(cyclA - 1)) == PLAYER_SLOT_STATE_PLAYING then
                        call luckyst( udg_hero[cyclA], 10 )
                    endif
                    set cyclA = cyclA + 1
                endloop
            endif
            if udg_modgood[19] then
                call SetRaritySpawn(udg_RarityChance[3] + 5, udg_RarityChance[2] + 10)
            endif
            if udg_modgood[28] then
                set cyclA = 1
                loop
                    exitwhen cyclA > 4
                    if GetPlayerSlotState(Player(cyclA - 1)) == PLAYER_SLOT_STATE_PLAYING then
                        call SpellUniqueUnit(udg_hero[cyclA], 25)
                        call SpellPotion(cyclA, 25)
                    endif
                    set cyclA = cyclA + 1
                endloop
            endif
            if udg_modgood[29] then
                set udg_Heroes_Chanse = udg_Heroes_Chanse + 1
                call MultiSetValue( udg_multi, 2, 1, I2S( udg_Heroes_Chanse ) )
            endif
            if udg_modgood[30] then
                set cyclA = 1
                loop
                    exitwhen cyclA > 4
                    if GetPlayerSlotState(Player(cyclA - 1)) == PLAYER_SLOT_STATE_PLAYING then
                    	set udg_rollbase[cyclA] = udg_rollbase[cyclA] + 1
                    endif
                    set cyclA = cyclA + 1
                endloop
            endif
        endif
        
        //Curse Activation
        if n > 0 then
            if udg_modbad[2] then
                call UnitAddAbility( gg_unit_u00F_0006, 'A0I2' )
            endif
            if udg_modbad[3] then
                call EnableTrigger( gg_trg_Grave )
            endif
            if udg_modbad[4] then
                call EnableTrigger( gg_trg_Flame )
            endif
            if udg_modbad[10] then
                set udg_SpellDamage[0] = udg_SpellDamage[0] + 0.15
            endif
            if udg_modbad[11] then
            	set udg_timelimit = udg_timelimit - 75
            endif
            if udg_modbad[15] then
                call EnableTrigger( gg_trg_Scatter )
            endif
        endif
        
        set Event_Mode_Awake_Real = 0.00
        set Event_Mode_Awake_Real = 1.00
        set Event_Mode_Awake_Real = 0.00
        
        if udg_HardNum > 0 then
            call EnableTrigger( gg_trg_HardModActive )
            set udg_SpellDamage[0] = udg_SpellDamage[0] + (udg_HardNum * 0.25)

            set p = udg_DB_Hardest_On[udg_HardNum]
            call IconFrame( "HardMode", BlzGetAbilityIcon(p), BlzGetAbilityTooltip(p, 0), BlzGetAbilityExtendedTooltip(p, 0) )
            
            set cyclA = 0
            loop
                exitwhen cyclA > 3
                if GetPlayerSlotState( Player( cyclA ) ) == PLAYER_SLOT_STATE_PLAYING then
                    call MMD_UpdateValueString("difficulty", Player(cyclA), BlzGetAbilityTooltip(p, 0))
                endif
                set cyclA = cyclA + 1
            endloop
        endif
    endfunction
endlibrary
