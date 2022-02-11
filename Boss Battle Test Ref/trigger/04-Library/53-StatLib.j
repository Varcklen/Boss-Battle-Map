library StatLib requires TextLib, QuestDiscLib

    function statst takes unit u, integer st, integer ag, integer in, integer data, boolean isPermanent returns nothing
        local integer i = GetPlayerId( GetOwningPlayer( u ) ) + 1
        local integer j = i + data
        local integer s
        
        if IsUnitType( u, UNIT_TYPE_HERO) then
            if st != 0 then
                call SetHeroStr( u, GetHeroStr( u, false) + st, true)
                if data != 0 then
                    set udg_Data[j] = udg_Data[j] + st
                endif
            endif
            if ag != 0 then
                call SetHeroAgi( u, GetHeroAgi( u, false) + ag, true)
                if data != 0 then
                    set udg_Data[j] = udg_Data[j] + ag
                endif
            endif
            if in != 0 then
                if inv( u, 'I08W' ) > 0 and in > 0 and isPermanent then
                    set s = LoadInteger( udg_hash, GetHandleId( u ), StringHash( udg_QuestItemCode[11] ) ) + in
                    call SaveInteger( udg_hash, GetHandleId( u ), StringHash( udg_QuestItemCode[11] ), s )
                    if s >= udg_QuestNum[11] then
                        call RemoveItem(GetItemOfTypeFromUnitBJ( u, 'I08W'))
                        set bj_lastCreatedItem = CreateItem( 'I08X', GetUnitX(u), GetUnitY(u))
                        call UnitAddItem(u, bj_lastCreatedItem)
                        call textst( "|c00ffffff Immortal story done!", u, 64, GetRandomReal( 45, 135 ), 12, 1.5 )
                        call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\Human\\ReviveHuman\\ReviveHuman.mdl", GetUnitX(u), GetUnitY(u) ) )
                        set udg_QuestDone[i] = true
                    else
                        call QuestDiscription( u, 'I08W', s, udg_QuestNum[11] )
                    endif
                endif
            
                call SetHeroInt( u, GetHeroInt( u, false) + in, true)
                if data != 0 then
                    set udg_Data[j] = udg_Data[j] + in
                endif
            endif
        endif
        
        set u = null
    endfunction

endlibrary