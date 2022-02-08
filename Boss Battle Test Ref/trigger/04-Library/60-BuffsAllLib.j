library BuffsAllLib requires TimebonusLib

    function bufallend takes nothing returns nothing
        local integer id = GetHandleId( GetExpiredTimer() )
        local string str = LoadStr( udg_hash, id, 1 )
        local integer sp1 = LoadInteger( udg_hash, id, StringHash( str+"1" ) )
        local integer sp2 = LoadInteger( udg_hash, id, StringHash( str+"2" ) )
        local integer sp3 = LoadInteger( udg_hash, id, StringHash( str+"3" ) )
        local integer sp4 = LoadInteger( udg_hash, id, StringHash( str+"4" ) )
        local integer sp5 = LoadInteger( udg_hash, id, StringHash( str+"5" ) )
        local integer bf = LoadInteger( udg_hash, id, StringHash( str+"6" ) )
        local unit u = LoadUnitHandle( udg_hash, id, StringHash( str ) )
        
        call UnitRemoveAbility( u, sp1 )
        call UnitRemoveAbility( u, sp2 )
        call UnitRemoveAbility( u, sp3 )
        call UnitRemoveAbility( u, sp4 )
        call UnitRemoveAbility( u, sp5 )
        call UnitRemoveAbility( u, bf )
        call FlushChildHashtable( udg_hash, id )
        
        set u = null
    endfunction

    function bufallst takes unit caster, unit target, integer sp1, integer sp2, integer sp3, integer sp4, integer sp5, integer bf, string str, real t returns nothing
        local integer id
        local integer g = StringHash( str )
        local real h = timebonus(caster, t) + 0.01
        local unit u
        
        if target == null then
            set u = caster
        else
            set u = target
        endif

        if sp1 != 0 then
            call UnitAddAbility( u, sp1 )
        endif
        if sp2 != 0 then
            call UnitAddAbility( u, sp2 )
        endif
        if sp3 != 0 then
            call UnitAddAbility( u, sp3 )
        endif
        if sp4 != 0 then
            call UnitAddAbility( u, sp4 )
        endif
        if sp5 != 0 then
            call UnitAddAbility( u, sp5 )
        endif
        
        set id = GetHandleId( u )
        if LoadTimerHandle( udg_hash, id, g ) == null then
            call SaveTimerHandle( udg_hash, id, g, CreateTimer() )
        endif
        set id = GetHandleId( LoadTimerHandle( udg_hash, id, g ) ) 
        call SaveUnitHandle( udg_hash, id, g, u )
        call SaveStr( udg_hash, id, 1, str )
        call SaveInteger( udg_hash, id, StringHash( str+"1" ), sp1 )
        call SaveInteger( udg_hash, id, StringHash( str+"2" ), sp2 )
        call SaveInteger( udg_hash, id, StringHash( str+"3" ), sp3 )
        call SaveInteger( udg_hash, id, StringHash( str+"4" ), sp4 )
        call SaveInteger( udg_hash, id, StringHash( str+"5" ), sp5 )
        call SaveInteger( udg_hash, id, StringHash( str+"6" ), bf )
        call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( u ), g ), h, false, function bufallend )
        
        set caster = null
        set target = null
        set u = null
    endfunction

endlibrary