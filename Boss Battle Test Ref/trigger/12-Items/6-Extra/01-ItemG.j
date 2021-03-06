function ItemGLogic takes nothing returns boolean
    if BlzGetItemAbility( GetManipulatedItem(), 'A0Y4' ) != null then 
        return true
    endif
    if BlzGetItemAbility( GetManipulatedItem(), 'A106' ) != null then 
        return true
    endif
    if BlzGetItemAbility( GetManipulatedItem(), 'A108' ) != null then 
        return true
    endif
    if BlzGetItemAbility( GetManipulatedItem(), 'A13L' ) != null then 
        return true
    endif
    if BlzGetItemAbility( GetManipulatedItem(), 'A0G3' ) != null then
        return true
    endif
    if GetItemTypeId(GetManipulatedItem()) == 'I05Z' then
        return true
    endif
    if GetItemTypeId(GetManipulatedItem()) == 'I04F' then
        return true
    endif
    if GetItemTypeId(GetManipulatedItem()) == 'I0BH' then
        return true
    endif
    if GetItemTypeId(GetManipulatedItem()) == 'I0FM' then
        return true
    endif
    if GetItemTypeId(GetManipulatedItem()) == 'I0DK' then
        return true
    endif
    if GetItemTypeId(GetManipulatedItem()) == 'I02R' then
        return true
    endif
    if GetItemTypeId(GetManipulatedItem()) == 'I00L'  then
        return true
    endif
    if  GetItemTypeId(GetManipulatedItem()) == 'I04B'  then
        return true
    endif
    if  GetItemTypeId(GetManipulatedItem()) == 'I04Q'  then
        return true
    endif
    if  GetItemTypeId(GetManipulatedItem()) == 'I05P'  then
        return true
    endif
    if  GetItemTypeId(GetManipulatedItem()) == 'I00B'  then
        return true
    endif
    if  GetItemTypeId(GetManipulatedItem()) == 'I00C' then 
        return true
    endif
    if  GetItemTypeId(GetManipulatedItem()) == 'I06N'  then
        return true
    endif
    if  GetItemTypeId(GetManipulatedItem()) == 'I00O'  then
        return true
    endif
    if  GetItemTypeId(GetManipulatedItem()) == 'I00J'  then
        return true
    endif
    if  GetItemTypeId(GetManipulatedItem()) == 'I02G'  then
        return true
    endif
    if  GetItemTypeId(GetManipulatedItem()) == 'I02Z'  then
        return true
    endif
    if  GetItemTypeId(GetManipulatedItem()) == 'I00M'  then
        return true
    endif
    if  GetItemTypeId(GetManipulatedItem()) == 'I078'  then
        return true
    endif
    if  GetItemTypeId(GetManipulatedItem()) == 'I043'  then
        return true
    endif
    if  GetItemTypeId(GetManipulatedItem()) == 'I04P'  then
        return true
    endif
    if  GetItemTypeId(GetManipulatedItem()) == 'I06H'  then
        return true
    endif
    if GetItemTypeId(GetManipulatedItem()) == 'I077'  then
        return true
    endif
    if GetItemTypeId(GetManipulatedItem()) == 'I07W'  then
        return true
    endif
    if GetItemTypeId(GetManipulatedItem()) == 'I093'  then
        return true
    endif
    if GetItemTypeId(GetManipulatedItem()) == 'I0BL' then 
        return true
    endif
    if GetItemTypeId(GetManipulatedItem()) == 'I00K' then 
        return true
    endif
    if GetItemTypeId(GetManipulatedItem()) == 'I07Z' then 
        return true
    endif
    if GetItemTypeId(GetManipulatedItem()) == 'I0BA' then 
        return true
    endif
    if GetItemTypeId(GetManipulatedItem()) == 'I01I' then
        return true
    endif
    if GetItemTypeId(GetManipulatedItem()) == 'I01K' then
        return true
    endif
    if GetItemTypeId(GetManipulatedItem()) == 'I02K' then
        return true
    endif
    if GetItemTypeId(GetManipulatedItem()) == 'I0FI'  then
        return true
    endif
    return false
endfunction

function Trig_ItemG_Conditions takes nothing returns boolean
    return not( udg_logic[36] ) and ItemGLogic() and GetPlayerSlotState(GetOwningPlayer(GetManipulatingUnit())) == PLAYER_SLOT_STATE_PLAYING
endfunction

function Trig_ItemG_Actions takes nothing returns nothing
    local unit u = GetManipulatingUnit()
    local integer i = CorrectPlayer(u)
    local integer cyclA
    local integer cyclAEnd
    local integer rand
    local string str
    
    if not( udg_logic[i + 26] ) then
        if GetItemTypeId(GetManipulatedItem()) == 'I00B' then
            call UnitAddAbility(u, 'A0Z8')
        elseif GetItemTypeId(GetManipulatedItem()) == 'I00C' then
            call UnitAddAbility(u, 'A0ZA')
        elseif GetItemTypeId(GetManipulatedItem()) == 'I00O' then
            call UnitAddAbility(u, 'A0Z1')
        elseif GetItemTypeId(GetManipulatedItem()) == 'I02G' then
            call UnitAddAbility(u, 'A0YZ')
        elseif GetItemTypeId(GetManipulatedItem()) == 'I02Z' then
            call UnitAddAbility(u, 'A0Z3')
        elseif GetItemTypeId(GetManipulatedItem()) == 'I00M'  then
            call UnitAddAbility(u, 'A0CB')
        elseif GetItemTypeId(GetManipulatedItem()) == 'I078' then
            call UnitAddAbility(u, 'A0L9')
        elseif GetItemTypeId(GetManipulatedItem()) == 'I0BL' then
            call UnitAddAbility(u, 'A0M9')
        endif
    endif
    if BlzGetItemAbility( GetManipulatedItem(), 'A0Y4' ) != null then
        call spdst( u, 8 )
    endif
    if BlzGetItemAbility( GetManipulatedItem(), 'A106' ) != null then 
        call luckyst( u, 8 )
    endif
    if BlzGetItemAbility( GetManipulatedItem(), 'A13L' ) != null then 
        call spdst( u, 10 )
    endif
    if BlzGetItemAbility( GetManipulatedItem(), 'A0G3' ) != null then
        set udg_RandomBonus_BuffDuration[i] = udg_RandomBonus_BuffDuration[i] + 0.2
    endif
    if BlzGetItemAbility( GetManipulatedItem(), 'A108' ) != null then 
        set udg_DamageReduction[i] = udg_DamageReduction[i] + 0.04
    endif
    if GetItemTypeId(GetManipulatedItem()) == 'I00K' then
        set udg_KillInBattle = udg_KillInBattle + 4
    elseif GetItemTypeId(GetManipulatedItem()) == 'I00L'  then
        call spdst( u, 4 )
        set cyclA = 1
        loop
            exitwhen cyclA > 4
            if GetPlayerSlotState(Player(cyclA - 1)) == PLAYER_SLOT_STATE_PLAYING then
                call spdst( udg_hero[cyclA], 8 )
            endif
            set cyclA = cyclA + 1
        endloop
    elseif GetItemTypeId(GetManipulatedItem()) == 'I0BA' then
        if udg_PotionsUsed[i] >= 5 then
            set str = words( u, BlzGetItemDescription(GetManipulatedItem()), "|cFF959697(", ")|r", "Active!" )
        else
            set str = words( u, BlzGetItemDescription(GetManipulatedItem()), "|cFF959697(", ")|r", I2S( udg_PotionsUsed[i] ) + "/5" )
        endif
        call BlzSetItemIconPath( GetManipulatedItem(), str )
    elseif GetItemTypeId(GetManipulatedItem()) == 'I07Z' then
        set rand = LoadInteger( udg_hash, GetHandleId( u ), StringHash( "kill" ) )
        if rand >= 50 then
            set str = words( u, BlzGetItemDescription(GetManipulatedItem()), "|cFF959697(", ")|r", "Active!" )
        else
            set str = words( u, BlzGetItemDescription(GetManipulatedItem()), "|cFF959697(", ")|r", I2S( rand ) + "/50" )
        endif
        call BlzSetItemIconPath( GetManipulatedItem(), str )
    elseif GetItemTypeId(GetManipulatedItem()) == 'I01I' then
         call BlzSetItemIconPath( GetManipulatedItem(), words( u, BlzGetItemDescription(GetManipulatedItem()), "|cFF959697(", ")|r", I2S(udg_CorruptedUsed[i]) ) )
    elseif GetItemTypeId(GetManipulatedItem()) == 'I0BH' then
        call SpellPotion(i, 15)
    elseif GetItemTypeId(GetManipulatedItem()) == 'I04B' then
        call spdst( u, 5 )
    elseif GetItemTypeId(GetManipulatedItem()) == 'I0FM' then
        set cyclA = 1
        loop
            exitwhen cyclA > 4
            if GetPlayerSlotState(Player(cyclA - 1)) == PLAYER_SLOT_STATE_PLAYING then
                call spdst( udg_hero[cyclA], 15 )
            endif
            set cyclA = cyclA + 1
        endloop
    elseif GetItemTypeId(GetManipulatedItem()) == 'I0DK' then
        call spdst( u, 25 )
    elseif GetItemTypeId(GetManipulatedItem()) == 'I04F'  then
        call spdst( u, 30 )
    elseif GetItemTypeId(GetManipulatedItem()) == 'I05Z'  then
        call spdst( u, -30 )
    elseif GetItemTypeId(GetManipulatedItem()) == 'I05P'  then
        call luckyst( u, 15 )
    elseif GetItemTypeId(GetManipulatedItem()) == 'I02R' then
        call spdst( u, 35 )
    elseif GetItemTypeId(GetManipulatedItem()) == 'I00J' then
        set udg_Heroes_Chanse = udg_Heroes_Chanse + 1
        call MultiSetValue( udg_multi, 2, 1, I2S(udg_Heroes_Chanse) )
    elseif GetItemTypeId(GetManipulatedItem()) == 'I043' then
        call RessurectionPoints( 1, true )
    elseif GetItemTypeId(GetManipulatedItem()) == 'I06H'  then
        call spdst( u, 25 )
    elseif GetItemTypeId(GetManipulatedItem()) == 'I06N'  then
        call luckyst( u, 25 )
        if not ( udg_logic[i + 26] ) then
            call UnitAddAbility( u, 'A0OU' )
        endif
    elseif GetItemTypeId(GetManipulatedItem()) == 'I077'  then
        call SpellUniqueUnit(u, 100)
    elseif GetItemTypeId(GetManipulatedItem()) == 'I01K'  then
        call SpellUniqueUnit(u, 150)
    elseif GetItemTypeId(GetManipulatedItem()) == 'I02K'  then
        call SpellUniqueUnit(u, 50)
    elseif GetItemTypeId(GetManipulatedItem()) == 'I0FI'  then
        call SpellUniqueUnit(u, 100)
    endif
    
    set u = null
endfunction

//===========================================================================
function InitTrig_ItemG takes nothing returns nothing
    set gg_trg_ItemG = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_ItemG, EVENT_PLAYER_UNIT_PICKUP_ITEM )
    call TriggerAddCondition( gg_trg_ItemG, Condition( function Trig_ItemG_Conditions ) )
    call TriggerAddAction( gg_trg_ItemG, function Trig_ItemG_Actions )
endfunction

