library ChainHealLib requires UnitstLib

    function ChainHealCast takes nothing returns nothing
        local integer id = GetHandleId( GetExpiredTimer() )
        call DestroyLightning( LoadLightningHandle( udg_hash, id, StringHash( "chnlht" ) ) )
        call FlushChildHashtable( udg_hash, id )
    endfunction

    function ChainHeal takes unit caster, unit target returns nothing
        local lightning l
        local integer id 
        local integer cyclA = 1
        local real heal = 100
        local unit lastunit
        local unit u
        local group g = CreateGroup()
        local group h = CreateGroup()
        local group n = CreateGroup()
        local integer f = 0
         
        set lastunit = caster
        loop
            exitwhen cyclA > 1
            set f = f + 1
            set l = AddLightningEx("HWPB", true, GetUnitX(lastunit), GetUnitY(lastunit), GetUnitFlyHeight(lastunit) + 50, GetUnitX(target), GetUnitY(target), GetUnitFlyHeight(target) + 50 )
            set id = GetHandleId( l )

            call SaveTimerHandle( udg_hash, id, StringHash( "chnlht" ), CreateTimer() )
            set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "chnlht" ) ) ) 
            call SaveLightningHandle( udg_hash, id, StringHash( "chnlht" ), l )
            call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( l ), StringHash( "chnlht" ) ), 1, false, function ChainHealCast )
            if GetUnitState( target, UNIT_STATE_LIFE ) > 0.405 then
                call SetUnitState( target, UNIT_STATE_LIFE, GetUnitState( target, UNIT_STATE_LIFE ) + heal )
            endif
            call GroupEnumUnitsInRange( g, GetUnitX( target ), GetUnitY( target ), 400, null )
            loop
                set u = FirstOfGroup(g)
                exitwhen u == null
                if unitst( u, caster, "ally" ) and u != target and not( IsUnitInGroup(u , n ) ) and GetUnitState( u, UNIT_STATE_LIFE ) != GetUnitState( u, UNIT_STATE_MAX_LIFE ) then
                    call GroupAddUnit(h, u)
                endif
                call GroupRemoveUnit(g,u)
            endloop
            if not( IsUnitGroupEmptyBJ(h) ) and f < 5 then
                set cyclA = cyclA - 1
                set lastunit = target
                set target = GroupPickRandomUnit(h)
                call GroupRemoveUnit(h, target)
                call GroupAddUnit(n, target)
            endif
            set cyclA = cyclA + 1
        endloop
        
        call GroupClear( g )
        call DestroyGroup( g )
        call GroupClear( h )
        call DestroyGroup( h )
        call GroupClear( n )
        call DestroyGroup( n )
        set n = null
        set g = null
        set h = null
        set l = null
        set u = null
        set caster = null
        set target = null
        set lastunit = null
    endfunction

endlibrary