globals
    real Event_UnitAddWeapon_Real
    unit Event_UnitAddWeapon_Hero
    item Event_UnitAddWeapon_Item
    
    real Event_UnitLoseWeapon_Real
    unit Event_UnitLoseWeapon_Hero
    item Event_UnitLoseWeapon_Item
endglobals

function Trig_WeaponG_Conditions takes nothing returns boolean
    if udg_logic[36] then
        return false
    endif
    if not( Weapon_Logic(GetManipulatedItem()) ) then
        return false
    endif
    return true
endfunction

function WeaponWord takes string s returns string
	local integer cyclA = 0
	local integer cyclAEnd = StringLength(s)
	local integer i = 0

	loop
		exitwhen cyclA > cyclAEnd
		if SubString(s, cyclA, cyclA+8) == "Weapon|r" then
			set i = cyclA+10
			set cyclA = cyclAEnd
		endif
		set cyclA = cyclA + 1
	endloop

	return SubString(s, i, StringLength(s))
endfunction

function Trig_WeaponG_Actions takes nothing returns nothing
    local unit u = GetManipulatingUnit()//udg_hero[GetPlayerId(GetOwningPlayer(GetManipulatingUnit())) + 1]
    local integer i = CorrectPlayer(u)//GetPlayerId(GetOwningPlayer(n)) + 1
    local integer cyclA
    local integer cyclAEnd
    local integer k
    local boolean l = false
    local item it = GetManipulatedItem()
    local item t
    local string st = GetItemName( it )
    local string dt = ""
    local string js
    local boolean array lm

    if not( udg_logic[i + 54] ) then
        set udg_Set_Weapon_Number[i] = udg_Set_Weapon_Number[i] + 1
        
        set Event_UnitAddWeapon_Hero = u
        set Event_UnitAddWeapon_Item = it
        
        set Event_UnitAddWeapon_Real = 0.00
        set Event_UnitAddWeapon_Real = 1.00
        set Event_UnitAddWeapon_Real = 0.00
        
        if not( udg_logic[i + 54] ) and udg_Set_Weapon_Number[i] >= 3 and Multiboard_Condition(i) then
            set udg_logic[i + 54] = true

            set cyclA = 1
            set cyclAEnd = udg_Database_NumberItems[11]
            loop
                exitwhen cyclA > cyclAEnd
                set lm[cyclA] = false
                set cyclA = cyclA + 1
            endloop

            set cyclA = 0
            loop
                exitwhen cyclA > 5
                set t = UnitItemInSlot( u, cyclA )
                set js = "|n> "+WeaponWord(BlzGetItemDescription(UnitItemInSlot( u, cyclA )))
                if GetItemTypeId( UnitItemInSlot( u, cyclA ) ) == 'I04Y' then
                    set udg_Set_Weapon_Logic[i] = true
                    set l = true
                    if not(lm[1]) then
                        set dt = dt+js
                        set lm[1] = true
                    endif
                elseif GetItemTypeId( UnitItemInSlot( u, cyclA ) ) == 'I02E' then
                    set udg_Set_Weapon_Logic[i + 4] = true
                    set l = true
		    if not(lm[2]) then
	    	    	set dt = dt+js
			set lm[2] = true
		    endif
            elseif GetItemTypeId( UnitItemInSlot( u, cyclA ) ) == 'I02P' then
                    set udg_Set_Weapon_Logic[i + 8] = true
                    set l = true
		    if not(lm[3]) then
	    	    	set dt = dt+js
			set lm[3] = true
		    endif
            elseif GetItemTypeId( UnitItemInSlot( u, cyclA ) ) == 'I046'  then
                    set udg_Set_Weapon_Logic[i + 12] = true
                    set l = true
                if not(lm[4]) then
	    	    	set dt = dt+js
			set lm[4] = true
		    endif
            elseif GetItemTypeId( UnitItemInSlot( u, cyclA ) ) == 'I025'  then
                set udg_Set_Weapon_Logic[i + 16] = true
                set l = true
                if not(lm[5]) then
	    	    	set dt = dt+js
                    set lm[5] = true
                endif
            elseif GetItemTypeId( UnitItemInSlot( u, cyclA ) ) == 'I0H8'  then
                set udg_Set_Weapon_Logic[i + 20] = true
                set l = true
                if not(lm[6]) then
	    	    	set dt = dt+js
                    set lm[6] = true
                endif
            elseif GetItemTypeId( UnitItemInSlot( u, cyclA ) ) == 'I04W' then
                set udg_Set_Weapon_Logic[i + 24] = true
                set l = true
                if not(lm[7]) then
                    set dt = dt+js
                    set lm[7] = true
                endif
            elseif GetItemTypeId( UnitItemInSlot( u, cyclA ) ) == 'I00W' then
                set udg_Set_Weapon_Logic[i + 28] = true
                set l = true
                if not(lm[8]) then
                    set dt = dt+js
                    set lm[8] = true
                endif
            elseif GetItemTypeId( UnitItemInSlot( u, cyclA ) ) == 'I04T' then
                    set udg_Set_Weapon_Logic[i + 32] = true
                    set l = true
		    if not(lm[9]) then
	    	    	set dt = dt+js
			set lm[9] = true
		    endif
            elseif GetItemTypeId( UnitItemInSlot( u, cyclA ) ) == 'I0DX' then
                set udg_Set_Weapon_Logic[i + 36] = true
                set l = true
                if not(lm[10]) then
	    	    	set dt = dt+js
                    set lm[10] = true
                endif
            elseif GetItemTypeId( UnitItemInSlot( u, cyclA ) ) == 'I02O' then
                    set udg_Set_Weapon_Logic[i + 40] = true
                    set l = true
		    if not(lm[11]) then
	    	    	set dt = dt+js
			set lm[11] = true
		    endif
            elseif GetItemTypeId( UnitItemInSlot( u, cyclA ) ) == 'I0AV' then
                set udg_Set_Weapon_Logic[i + 44] = true
                set l = true
                if not(lm[12]) then
                    set dt = dt+js
                    set lm[12] = true
                endif
            elseif GetItemTypeId( UnitItemInSlot( u, cyclA ) ) == 'I04S' then
                    set udg_Set_Weapon_Logic[i + 48] = true
                    set l = true
		    if not(lm[13]) then
	    	    	set dt = dt+js
			set lm[13] = true
		    endif
            elseif GetItemTypeId( UnitItemInSlot( u, cyclA ) ) == 'I00X' then
                set udg_Set_Weapon_Logic[i + 52] = true
                set l = true
                if not(lm[14]) then
	    	    	set dt = dt+js
                set lm[14] = true
		    endif
            elseif GetItemTypeId( UnitItemInSlot( u, cyclA ) ) == 'I079' then
                    set udg_Set_Weapon_Logic[i + 56] = true
                    set l = true
		    if not(lm[15]) then
	    	    	set dt = dt+js
			set lm[15] = true
		    endif
            elseif GetItemTypeId( UnitItemInSlot( u, cyclA ) ) == 'I07N' then
                    set udg_Set_Weapon_Logic[i + 60] = true
                    set l = true
		    if not(lm[16]) then
	    	    	set dt = dt+js
			set lm[16] = true
		    endif
            elseif GetItemTypeId( UnitItemInSlot( u, cyclA ) ) == 'I09F' then
                    set udg_Set_Weapon_Logic[i + 64] = true
                    set l = true
		    if not(lm[17]) then
	    	    	set dt = dt+js
			set lm[17] = true
		    endif
            elseif GetItemTypeId( UnitItemInSlot( u, cyclA ) ) == 'I09T' then
                    set udg_Set_Weapon_Logic[i + 68] = true
                    set l = true
		    if not(lm[18]) then
	    	    	set dt = dt+js
			set lm[18] = true
		    endif
                elseif GetItemTypeId( UnitItemInSlot( u, cyclA ) ) == 'I0CF' then
                    set udg_Set_Weapon_Logic[i + 72] = true
                    set l = true
		    if not(lm[19]) then
	    	    	set dt = dt+js
			set lm[19] = true
		    endif
                elseif GetItemTypeId( UnitItemInSlot( u, cyclA ) ) == 'I0CP' then
                    set udg_Set_Weapon_Logic[i + 76] = true
                    set l = true
		    if not(lm[20]) then
	    	    	set dt = dt+js
			set lm[20] = true
		    endif
                elseif GetItemTypeId( UnitItemInSlot( u, cyclA ) ) == 'I0CR' then
                    set udg_Set_Weapon_Logic[i + 80] = true 
                    set l = true
		    if not(lm[21]) then
	    	    	set dt = dt+js
			set lm[21] = true
		    endif
                elseif GetItemTypeId( UnitItemInSlot( u, cyclA ) ) == 'I0D4' then
                    set udg_Set_Weapon_Logic[i + 84] = true 
                    set l = true
		    if not(lm[22]) then
	    	    	set dt = dt+js
			set lm[22] = true
		    endif
                elseif GetItemTypeId( UnitItemInSlot( u, cyclA ) ) == 'I0DB' then
                    set udg_Set_Weapon_Logic[i + 88] = true 
                    set l = true
		    if not(lm[23]) then
	    	    	set dt = dt+js
			set lm[23] = true
		    endif
                elseif GetItemTypeId( UnitItemInSlot( u, cyclA ) ) == 'I03Z' then
                    set udg_Set_Weapon_Logic[i + 92] = true 
                    set l = true
                    if not(lm[24]) then
                        set dt = dt+js
                        set lm[24] = true
                    endif
                elseif GetItemTypeId( UnitItemInSlot( u, cyclA ) ) == 'I05Z' then
                    set udg_Set_Weapon_Logic[i + 96] = true 
                    set l = true
                    if not(lm[25]) then
                        set dt = dt+js
                        set lm[25] = true
                    endif
                elseif GetItemTypeId( UnitItemInSlot( u, cyclA ) ) == 'I08T' then
                    set udg_Set_Weapon_Logic[i + 100] = true 
                    set l = true
                    if not(lm[26]) then
                        set dt = dt+js
                        set lm[26] = true
                    endif
                elseif GetItemTypeId( UnitItemInSlot( u, cyclA ) ) == 'I08U' then
                    set udg_Set_Weapon_Logic[i + 104] = true 
                    set l = true
                    if not(lm[27]) then
                        set dt = dt+js
                        set lm[27] = true
                    endif
                elseif GetItemTypeId( UnitItemInSlot( u, cyclA ) ) == 'I0GA' then
                    set udg_Set_Weapon_Logic[i + 108] = true 
                    set l = true
                    if not(lm[28]) then
                        set dt = dt+js
                        set lm[28] = true
                    endif
                endif
                if l then
                    call UnitRemoveItemFromSlot( u, cyclA )
                    call RemoveItem(t)
                    set l = false
                endif
                set cyclA = cyclA + 1
            endloop
            //set udg_logic[36] = true
            //set cyclA = 0
            //loop
            //    exitwhen cyclA > 5
            //    set t = UnitItemInSlot( u, cyclA )
            //    call UnitRemoveItem( u, t )
            //    call UnitAddItem( u, t )
            //    set cyclA = cyclA + 1
            //endloop
            //set udg_logic[36] = false
            /*if GetUnitAbilityLevel( u, 'A09I') > 0 then
                call BlzSetUnitBaseDamage( u, BlzGetUnitBaseDamage(u, 0) - udg_WepSum, 0 )
            endif*/
            set Event_UnitLoseUltimateWeapon_Hero = u
            set Event_UnitLoseUltimateWeapon_Item = null
            
            set Event_UnitLoseUltimateWeapon_Real = 0.00
            set Event_UnitLoseUltimateWeapon_Real = 1.00
            set Event_UnitLoseUltimateWeapon_Real = 0.00
            
            set t = CreateItem( 'I030', GetUnitX( u ), GetUnitY( u ) )
            call UnitAddItem( u, t )
            call BlzSetItemIconPath( t, BlzGetItemExtendedTooltip(t)+dt )
            
            if udg_Set_Weapon_Logic[i + 44] then
                set udg_Caster = u
                set udg_CastLogic = true
                set udg_CastItem = t
                call TriggerExecute( gg_trg_AggressiveShield )
            endif
            if udg_Set_Weapon_Logic[i + 52] then
                set udg_Caster = u
                set udg_CastLogic = true
                set udg_CastItem = t
                call TriggerExecute( gg_trg_SpellbraikerShield )
            endif
            if udg_Set_Weapon_Logic[i + 60] then
                set udg_Caster = u
                set udg_CastLogic = true
                set udg_CastItem = t
                call TriggerExecute( gg_trg_Scimitar )
            endif
            if udg_Set_Weapon_Logic[i + 104] then
                set udg_Caster = u
                set udg_CastLogic = true
                set udg_CastItem = t
                call TriggerExecute( gg_trg_Crystal_Barrier )
            endif
        endif
    else
        if GetInventoryIndexOfItemTypeBJ( u, 'I030') > 0 then
            set dt = "|n> "+WeaponWord(BlzGetItemExtendedTooltip(it))
            if GetItemTypeId( it ) == 'I04Y' and not( udg_Set_Weapon_Logic[i] ) then
                call RemoveItem( it )
                set udg_Set_Weapon_Logic[i] = true
                set l = true
            elseif GetItemTypeId( it ) == 'I02E' and not( udg_Set_Weapon_Logic[i + 4] ) then
                call RemoveItem( it )
                set udg_Set_Weapon_Logic[i + 4] = true
                call UnitAddAbility( u, 'A05I' )
                set l = true
            elseif GetItemTypeId( it ) == 'I02P' and not( udg_Set_Weapon_Logic[i + 8] ) then
                call RemoveItem( it )
                set udg_Set_Weapon_Logic[i + 8] = true
                set l = true
            elseif GetItemTypeId( it ) == 'I046' and not( udg_Set_Weapon_Logic[i + 12] ) then
                call RemoveItem( it )
                set udg_Set_Weapon_Logic[i + 12] = true
                call UnitAddAbility( u, 'A0P3' )
                call UnitAddAbility( u, 'A0P4' )
                set l = true
            elseif GetItemTypeId( it ) == 'I025' and not( udg_Set_Weapon_Logic[i + 16] ) then
                call RemoveItem( it )
                set udg_Set_Weapon_Logic[i + 16] = true
                call UnitAddAbility( u, 'A0YX' )
                set l = true
            elseif GetItemTypeId( it ) == 'I0H8' and not( udg_Set_Weapon_Logic[i + 20] ) then
                call RemoveItem( it )
                set udg_Set_Weapon_Logic[i + 20] = true
                call TriggerExecute( gg_trg_Bo_Staff )
                call UnitAddAbility( u, 'A1DI' )
                set l = true
            elseif GetItemTypeId( it ) == 'I04W' and not( udg_Set_Weapon_Logic[i + 24] ) then
                call RemoveItem( it )
                set udg_Set_Weapon_Logic[i + 24] = true
                set l = true
            elseif GetItemTypeId( it ) == 'I00W' and not( udg_Set_Weapon_Logic[i + 28] ) then
                call RemoveItem( it )
                set udg_Set_Weapon_Logic[i + 28] = true
                call UnitAddAbility( u, 'A0R2' )
                call UnitAddAbility( u, 'A0R3' )
                set l = true
            elseif GetItemTypeId( it ) == 'I04T' and not( udg_Set_Weapon_Logic[i + 32] ) then
                call RemoveItem( it )
                set udg_Set_Weapon_Logic[i + 32] = true
                set l = true
            elseif GetItemTypeId( it ) == 'I0DX' and not( udg_Set_Weapon_Logic[i + 36] ) then
                call RemoveItem( it )
                set udg_Set_Weapon_Logic[i + 36] = true
                set l = true
            elseif GetItemTypeId( it ) == 'I02O' and not( udg_Set_Weapon_Logic[i + 40] ) then
                call RemoveItem( it )
                set udg_Set_Weapon_Logic[i + 40] = true
                call UnitAddAbility( u, 'A0QX' )
                set l = true
            elseif GetItemTypeId( it ) == 'I0AV' and not( udg_Set_Weapon_Logic[i + 44] ) then
                call RemoveItem( it )
                set udg_Caster = u
                set udg_CastLogic = true
                set udg_CastItem = GetItemOfTypeFromUnitBJ( u, 'I030')
                call TriggerExecute( gg_trg_AggressiveShield )
                set udg_Set_Weapon_Logic[i + 44] = true
                call UnitAddAbility( u, 'A11S' )
                set l = true
            elseif GetItemTypeId( it ) == 'I04S' and not( udg_Set_Weapon_Logic[i + 48] ) then
                call RemoveItem( it )
                set udg_Set_Weapon_Logic[i + 48] = true
                set l = true
            elseif GetItemTypeId( it ) == 'I00X' and not( udg_Set_Weapon_Logic[i + 52] ) then
                call RemoveItem( it )   
                set udg_Set_Weapon_Logic[i + 52] = true
                set udg_Caster = u
                set udg_CastLogic = true
                set udg_CastItem = GetItemOfTypeFromUnitBJ( u, 'I030')
                call TriggerExecute( gg_trg_SpellbraikerShield )
                set l = true
            elseif GetItemTypeId( it ) == 'I079' and not( udg_Set_Weapon_Logic[i + 56] ) then
                call RemoveItem( it ) 
                set udg_Set_Weapon_Logic[i + 56] = true
                set l = true
            elseif GetItemTypeId( it ) == 'I07N' and not( udg_Set_Weapon_Logic[i + 60] ) then
                call RemoveItem( it ) 
                set udg_Caster = u
                set udg_CastLogic = true
                set udg_CastItem = GetItemOfTypeFromUnitBJ( u, 'I030')
                call TriggerExecute( gg_trg_Scimitar )
                set udg_Set_Weapon_Logic[i + 60] = true
                set l = true
            elseif GetItemTypeId( it ) == 'I09F' and not( udg_Set_Weapon_Logic[i + 64] ) then
                call RemoveItem( it )
                set udg_Set_Weapon_Logic[i + 64] = true
                call UnitAddAbility( u, 'A0WH' )
                set l = true
            elseif GetItemTypeId( it ) == 'I09T' and not( udg_Set_Weapon_Logic[i + 68] ) then
                call RemoveItem( it )
                set udg_Set_Weapon_Logic[i + 68] = true
                set udg_Set_Weapon_TextNumber[i] = udg_Set_Weapon_TextNumber[i] + 8
                call UnitAddAbility( u, 'A0X7' )
                set l = true
            elseif GetItemTypeId( it ) == 'I0CF' and not( udg_Set_Weapon_Logic[i + 72] ) then
                call RemoveItem( it )
                set udg_Set_Weapon_Logic[i + 72] = true
                set l = true
            elseif GetItemTypeId( it ) == 'I0CP' and not( udg_Set_Weapon_Logic[i + 76] ) then
                call RemoveItem( it )
                set udg_Set_Weapon_Logic[i + 76] = true
                set l = true
            elseif GetItemTypeId( it ) == 'I0CR' and not( udg_Set_Weapon_Logic[i + 80] ) then
                call RemoveItem( it )
                set udg_Set_Weapon_Logic[i + 80] = true
                set l = true
            elseif GetItemTypeId( it ) == 'I0D4' and not( udg_Set_Weapon_Logic[i + 84] ) then
                call RemoveItem( it )
                call UnitAddAbility( u, 'A175' )
                set udg_Set_Weapon_Logic[i + 84] = true
                set l = true
            elseif GetItemTypeId( it ) == 'I0DB' and not( udg_Set_Weapon_Logic[i + 88] ) then
                call RemoveItem( it )
                set udg_Set_Weapon_Logic[i + 88] = true
                set l = true
            elseif GetItemTypeId( it ) == 'I03Z' and not( udg_Set_Weapon_Logic[i + 92] ) then
                call RemoveItem( it )
                set udg_Set_Weapon_Logic[i + 92] = true
                set l = true
            elseif GetItemTypeId( it ) == 'I05Z' and not( udg_Set_Weapon_Logic[i + 96] ) then
                call RemoveItem( it )
                call spdst( u, -30 )
                set udg_Set_Weapon_Logic[i + 96] = true
                set l = true
            elseif GetItemTypeId( it ) == 'I08T' and not( udg_Set_Weapon_Logic[i + 100] ) then
                call RemoveItem( it )
                call spdst( u, 10 )
                set udg_Set_Weapon_Logic[i + 100] = true
                call UnitAddAbility( u, 'A18J' )
                set l = true
            elseif GetItemTypeId( it ) == 'I08U' and not( udg_Set_Weapon_Logic[i + 104] ) then
                call RemoveItem( it )
                call TriggerExecute( gg_trg_Crystal_Barrier )
                set udg_Set_Weapon_Logic[i + 104] = true
                set l = true
            elseif GetItemTypeId( it ) == 'I0GA' and not( udg_Set_Weapon_Logic[i + 108] ) then
                call RemoveItem( it )
                set udg_Set_Weapon_Logic[i + 108] = true
                set l = true
            endif
            if l then
                call DisplayTimedTextToPlayer(GetOwningPlayer( u ), 0, 0, 10, "Artifact |cffffcc00'" + st + "'|r added to |cff2d9995Ultimate Weapon|r." )
                set t = GetItemOfTypeFromUnitBJ( u, 'I030')
                call BlzSetItemIconPath( t, BlzGetItemExtendedTooltip(t) + dt )
                /*if GetUnitAbilityLevel( u, 'A09I') > 0 then
                    call BlzSetUnitBaseDamage( u, BlzGetUnitBaseDamage(u, 0) + armsAttackBons, 0 )
                    set udg_WepSum = udg_WepSum + armsAttackBons
                endif*/
                
                set Event_UnitAddWeapon_Hero = u
                set Event_UnitAddWeapon_Item = t
                
                set Event_UnitAddWeapon_Real = 0.00
                set Event_UnitAddWeapon_Real = 1.00
                set Event_UnitAddWeapon_Real = 0.00
                
            endif
        endif
    endif
    
    //call AllSetRing( u, 7, it )
    
    set t = null
    set it = null
    set u = null
endfunction

//===========================================================================
function InitTrig_WeaponG takes nothing returns nothing
    set gg_trg_WeaponG = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_WeaponG, EVENT_PLAYER_UNIT_PICKUP_ITEM )
    call TriggerAddCondition( gg_trg_WeaponG, Condition( function Trig_WeaponG_Conditions ) )
    call TriggerAddAction( gg_trg_WeaponG, function Trig_WeaponG_Actions )
endfunction

