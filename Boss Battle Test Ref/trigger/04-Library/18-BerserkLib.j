library BerserkLib requires BuffDeleteLib 

    private function berserkRemove takes unit u returns nothing
        if GetUnitAbilityLevel(u, 'A06S') > 0 then
            call UnitRemoveAbility(u, 'A06S')
            call SaveBoolean( udg_hash, GetHandleId( u ), StringHash( "bers" ), false )
            if GetOwningPlayer( u ) == Player(10) then
                call DelBuff( u, false )
                call SetUnitOwner( u, Player( LoadInteger( udg_hash, GetHandleId( u ), StringHash( "control" ) ) ), true )
            endif
            call RemoveSavedInteger( udg_hash, GetHandleId( u ), StringHash( "control" ) )
        endif
        
        set u = null
    endfunction

    private function berserkAdd takes unit u returns nothing
        if GetUnitAbilityLevel(u, 'A06S') == 0 then
            call UnitAddAbility(u, 'A06S')
            if GetOwningPlayer(u) != Player(10) then
                call SaveInteger( udg_hash, GetHandleId( u ), StringHash( "control" ), GetPlayerId( GetOwningPlayer( u ) ) )
            endif
            call SaveBoolean( udg_hash, GetHandleId( u ), StringHash( "bers" ), true )
            call DelBuff( u, false )
            call SetUnitOwner( u, Player(10), true )
        endif

        set u = null
    endfunction

    function berserk takes unit u, integer i returns nothing
        local integer k = GetPlayerId(GetOwningPlayer( u )) + 1
        local integer g = LoadInteger( udg_hash, GetHandleId( u ), StringHash( "bers" ) )
        local boolean b = LoadBoolean( udg_hash, GetHandleId( u ), StringHash( "bers" ) )

        if IsUnitType( u, UNIT_TYPE_HERO) or IsUnitType( u, UNIT_TYPE_ANCIENT) then
            call SaveInteger( udg_hash, GetHandleId( u ), StringHash( "bers" ), g + i )
            set g = LoadInteger( udg_hash, GetHandleId( u ), StringHash( "bers" ) )

            if g >= 1 and not(b) then
                call berserkAdd(u)
            elseif g < 1 and b then
                call berserkRemove(u)
            endif
        endif
        
        set u = null
    endfunction

    function berserkDelete takes unit u returns nothing
        call SaveInteger( udg_hash, GetHandleId( u ), StringHash( "bers" ), 0 )
        call berserkRemove(u)
        
        set u = null
    endfunction

endlibrary