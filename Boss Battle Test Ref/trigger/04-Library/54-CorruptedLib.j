library CorruptedLib requires TextLib, QuestDiscLib

    function stazisst_SetTooltip takes unit u, integer i returns nothing
        local item it = GetItemOfTypeFromUnitBJ(u, 'I01I')
        if (it != null) then
            call BlzSetItemIconPath( it, words( u, BlzGetItemDescription(it), "|cFF959697(", ")|r", I2S(udg_CorruptedUsed[i]) ) )
        endif
        set it = null
        set u = null
    endfunction

    function stazisst takes unit u, item it returns nothing
        local integer i = GetPlayerId( GetOwningPlayer( u ) ) + 1
        local boolean l = true
        local integer p
        
        if GetUnitAbilityLevel(u, 'B085') > 0 then
            call UnitRemoveAbility(u, 'A0VX')
            call UnitRemoveAbility(u, 'B085')
            set l = false
        endif
        if l then
            if inv( u, 'I061' ) > 0 then
                call RemoveItem( GetItemOfTypeFromUnitBJ( u, 'I061') )
            else
                call RemoveItem( it )
            endif
        endif
        if inv( u, 'I024' ) > 0 then
            call UnitAddAbility( u, 'A031' )
        endif
        
        if GetUnitState( u, UNIT_STATE_LIFE) > 0.405 and inv(u, 'I06V' ) > 0 and not(udg_fightmod[3]) then
            set p = LoadInteger( udg_hash, GetHandleId(u), StringHash( udg_QuestItemCode[1] ) ) + 1
            call SaveInteger( udg_hash, GetHandleId(u), StringHash( udg_QuestItemCode[1] ), p )

            if p >= udg_QuestNum[1] then
                call SaveReal( udg_hash, GetHandleId(u), StringHash( udg_QuestItemCode[1] ), 0 )
                call RemoveItem(GetItemOfTypeFromUnitBJ(u, 'I06V'))
                call UnitAddItem(u, CreateItem( 'I0EJ', GetUnitX(u), GetUnitY(u)))
                call textst( "|c00ffffff Splitting the World done!", u, 64, GetRandomReal( 45, 135 ), 12, 1.5 )
                call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\Human\\ReviveHuman\\ReviveHuman.mdl", GetUnitX(u), GetUnitY(u) ) )
                set udg_QuestDone[i] = true
            else
                call QuestDiscription( u, 'I06V', p, udg_QuestNum[1] )
            endif
        endif
        
        set udg_CorruptedUsed[i] = udg_CorruptedUsed[i] + 1
        if inv(u, 'I01I' ) > 0 then
            call stazisst_SetTooltip(u, i)
        endif
        
        set u = null
    endfunction

endlibrary