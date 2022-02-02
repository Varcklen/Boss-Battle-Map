function Trig_DestroySub_Conditions takes nothing returns boolean
    local integer cyclA = 0
    local boolean l = false
    
    loop
        exitwhen cyclA > 5
        if GetUnitTypeId(GetSoldUnit()) == 'n00H' + cyclA then 
            set l = true
            set cyclA = 5
        endif
        set cyclA = cyclA + 1
    endloop
    return l
endfunction

function NoThisItem takes item it returns boolean
    local boolean l = true
    
    if GetItemTypeId(it) == 'I03I' or GetItemTypeId(it) == 'I052' or GetItemTypeId(it) == 'I05J' or GetItemTypeId(it) == 'I030' then
        set l = false
    endif
    set it = null
    return l
endfunction

function Trig_DestroySub_Actions takes nothing returns nothing
    local unit u = GetBuyingUnit()
    local unit n = GetSoldUnit()
    local integer cyclA
    local integer cyclAEnd
    local integer cyclB
    local integer cyclBEnd
    local integer i
    local integer j    
    local boolean k = false
    local item it
    local boolean array m
    local boolean l = false

    set m[1] = false
    set m[2] = false
    set m[3] = false
    
    call RemoveUnit( n )
    set cyclA = 0
    loop
        exitwhen cyclA > 5
        if GetUnitTypeId(n) == 'n00H' + cyclA  then
            set it = UnitItemInSlot(u, cyclA)
            if it != null and NoThisItem(it) then
                if GetItemType(it) == ITEM_TYPE_POWERUP or BlzGetItemAbility( it, 'A0G2' ) != null then
                    call SetPlayerState(GetOwningPlayer(u), PLAYER_STATE_RESOURCE_GOLD, GetPlayerState(GetOwningPlayer(u), PLAYER_STATE_RESOURCE_GOLD) + 150)
                endif
                if inv( u, 'I0A3' ) > 0 and GetItemType(it) != ITEM_TYPE_POWERUP and GetItemType(it) != ITEM_TYPE_PURCHASABLE then
                    call moneyst( u, 150 )
                endif
                set l = true
                call DestroyEffect( AddSpecialEffectTarget( "Abilities\\Spells\\Undead\\DarkRitual\\DarkRitualTarget.mdl", u, "origin" ) )
                set i = GetItemTypeId( it )

                if GetItemType(it) == ITEM_TYPE_PERMANENT then
                    set m[1] = true
                endif
                if GetItemType(it) == ITEM_TYPE_CAMPAIGN then
                    set m[2] = true
                endif
                if GetItemType(it) == ITEM_TYPE_ARTIFACT then
                    set m[3] = true
                endif
                call RemoveItem( it )
            endif
            set cyclA = 5
        endif
        set cyclA = cyclA + 1
    endloop
    
    if inv( u, 'I09A' ) > 0 and l then
        set cyclB = 1
        set cyclBEnd = udg_DB_AllSet
        loop
            exitwhen cyclB > cyclBEnd
            if not(udg_Pokeball[cyclB]) then
                set cyclA = 1
                set cyclAEnd = udg_DB_SetItems_Num[cyclB]
                loop
                    exitwhen cyclA > cyclAEnd
                    if i == DB_SetItems[cyclB][cyclA] then
                        set udg_Pokeball[cyclB] = true
                        set cyclA = cyclAEnd
                        call ChangeToolCurrentItem( u, 'I09A', udg_DB_Set_Color[cyclB], "|cff000000" )
                    endif
                    set cyclA = cyclA + 1
                endloop
            endif
            set cyclB = cyclB + 1
        endloop

        if not( udg_Pokeball[10] ) and m[1] then
            set udg_Pokeball[10] = true
            call ChangeToolCurrentItem( u, 'I09A', "|cffbababc", "|cff000000" )
        endif
        if not( udg_Pokeball[11] ) and m[2] then
            set udg_Pokeball[11] = true
            call ChangeToolCurrentItem( u, 'I09A', "|cff4169e1", "|cff000000" )
        endif
        if not( udg_Pokeball[12] ) and m[3] then
            set udg_Pokeball[12] = true
            call ChangeToolCurrentItem( u, 'I09A', "|cffe96a1c", "|cff000000" )
        endif

        set cyclA = 1
        set j = 0
        loop
            exitwhen cyclA > 12
            if udg_Pokeball[cyclA] == true then
                set j = j + 1
            endif
            set cyclA = cyclA + 1
        endloop
        if j >= 12 then
            call RemoveItem(GetItemOfTypeFromUnitBJ( u, 'I09A')) 
            call UnitAddItem(u, CreateItem( 'I03I', GetUnitX(u), GetUnitY(u)))
            call textst( "|c00ffffff Power search done!", u, 64, GetRandomReal( 45, 135 ), 12, 1.5 )
            call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\Human\\ReviveHuman\\ReviveHuman.mdl", GetUnitX(u), GetUnitY(u) ) )
            set udg_QuestDone[GetPlayerId( GetOwningPlayer(u) ) + 1] = true
        else
            call textst( "|c00ffffff " + I2S( j ) + "/12", u, 64, GetRandomReal( 45, 135 ), 8, 1.5 )
        endif
    endif

	set it = null
    set u = null
    set n = null
endfunction

//===========================================================================
function InitTrig_DestroySub takes nothing returns nothing
    set gg_trg_DestroySub = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_DestroySub, EVENT_PLAYER_UNIT_SELL )
    call TriggerAddCondition( gg_trg_DestroySub, Condition( function Trig_DestroySub_Conditions ) )
    call TriggerAddAction( gg_trg_DestroySub, function Trig_DestroySub_Actions )
endfunction

