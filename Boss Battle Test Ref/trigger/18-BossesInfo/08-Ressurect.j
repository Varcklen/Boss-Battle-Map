function Trig_Ressurect_Actions takes nothing returns nothing
    local integer cyclA = 1
    local group g = CreateGroup()
    local unit u
    local integer v
    
    set udg_fightmod[1] = false
    call DisableTrigger( gg_trg_MinionsTeleportation )
    call DisableTrigger( gg_trg_Equality )
    call GroupEnumUnitsInRect( g, udg_Boss_Rect, null )
    loop
        set u = FirstOfGroup(g)
        exitwhen u == null
        if GetUnitTypeId( u ) == 'h00C' then
            call KillUnit( u )
        endif
        call GroupRemoveUnit(g,u)
    endloop
    loop
        exitwhen cyclA > 4
        if GetPlayerSlotState(Player(cyclA - 1)) == PLAYER_SLOT_STATE_PLAYING then
            set udg_number[cyclA + 69] = udg_number[cyclA + 69] + 1
            call SetUnitPositionLoc( udg_hero[cyclA], udg_point[cyclA + 21] )
            call SetUnitFacing( udg_hero[cyclA], 90 )
            if udg_number[4] < 3 then
                call moneyst( udg_hero[cyclA], 125 )
            endif
            call PanCameraToTimedLocForPlayer( Player(cyclA - 1), udg_point[cyclA + 21], 0.00 )
        endif
        set cyclA = cyclA + 1
    endloop
    //до выдачи денег
    set udg_number[4] = udg_number[4] + 1
    call FightEnd()

	if udg_Boss_LvL != 10 then
        call IconFrameDel( "boss" )
        if udg_logic[78] and udg_Boss_LvL > 1 then
            call IconFrameDel( "second boss" )
        endif
    endif
    
    call GroupEnumUnitsOfPlayer(g, Player(10), null )
    loop
        set u = FirstOfGroup(g)
        exitwhen u == null
        if not( IsUnitType( u, UNIT_TYPE_HERO) ) and not( IsUnitType( u, UNIT_TYPE_ANCIENT ) ) and GetUnitAbilityLevel( u, 'Avul') == 0 then
            call KillUnit( u )
        endif
        call GroupRemoveUnit(g,u)
    endloop

    // Всегда должен быть в конце
    set cyclA = 1
    loop
        exitwhen cyclA > 4
        if inv(udg_hero[cyclA], 'I00J') > 0 then
            call RemoveItem( GetItemOfTypeFromUnitBJ(udg_hero[cyclA], 'I00J') )
            set udg_Heroes_Chanse = udg_Heroes_Chanse + 1
            call MultiSetValue( udg_multi, 2, 1, I2S(udg_Heroes_Chanse) )
            set cyclA = 4
        endif
        set cyclA = cyclA + 1
    endloop
    
    call GroupClear( g )
    call DestroyGroup( g )
    set u = null
    set g = null
endfunction

//===========================================================================
function InitTrig_Ressurect takes nothing returns nothing
    set gg_trg_Ressurect = CreateTrigger(  )
    call TriggerAddAction( gg_trg_Ressurect, function Trig_Ressurect_Actions )
endfunction

