library TimePlayLib

    private function bufend takes nothing returns nothing
        local integer id = GetHandleId( GetExpiredTimer() )
        local string str = LoadStr( udg_hash, id, 1 )
        local integer g = StringHash( str )
        local integer sp = LoadInteger( udg_hash, id, StringHash( str+"1" ) )
        local integer bf = LoadInteger( udg_hash, id, StringHash( str+"2" ) )
        local unit u = LoadUnitHandle( udg_hash, id, g )
        
        call UnitRemoveAbility( u, sp )
        call UnitRemoveAbility( u, bf )
        call FlushChildHashtable( udg_hash, id )
        
        set u = null
    endfunction

    function bufst takes unit caster, unit target, integer sp, integer bf, string str, real t returns nothing
        local integer id = GetHandleId( target )
        local integer g = StringHash( str )
        local real h = t + 0.01

        call UnitAddAbility( target, sp )
        
        if LoadTimerHandle( udg_hash, id, g ) == null then
            call SaveTimerHandle( udg_hash, id, g, CreateTimer() )
        endif
        set id = GetHandleId( LoadTimerHandle( udg_hash, id, g ) ) 
        call SaveInteger( udg_hash, id, g, sp )
        call SaveUnitHandle( udg_hash, id, g, target )
        call SaveStr( udg_hash, id, 1, str )
        call SaveInteger( udg_hash, id, StringHash( str+"1" ), sp )
        call SaveInteger( udg_hash, id, StringHash( str+"2" ), bf )
        call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( target ), g ), h, false, function bufend )
        
        set caster = null
        set target = null
    endfunction

endlibrary
