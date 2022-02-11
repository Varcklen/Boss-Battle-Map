library CommonTimer

    function InvokeTimerWithUnit takes unit myUnit, string stringHash, real time, boolean isPeriodic, code func returns integer
        local integer id = GetHandleId( myUnit )
        local integer secondKey = StringHash( stringHash )

        if LoadTimerHandle( udg_hash, id, secondKey ) == null then
            call SaveTimerHandle( udg_hash, id, secondKey, CreateTimer() )
        endif
        set id = GetHandleId( LoadTimerHandle( udg_hash, id, secondKey ) ) 
        call SaveUnitHandle( udg_hash, id, secondKey, myUnit )
        call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( myUnit ), secondKey ), time, isPeriodic, func )
        
        set myUnit = null
        set func = null
        return id
    endfunction

    function InvokeTimerWithItem takes item myItem, string stringHash, real time, boolean isPeriodic, code func returns integer
        local integer id = GetHandleId( myItem )
        local integer secondKey = StringHash( stringHash )

        if LoadTimerHandle( udg_hash, id, secondKey ) == null then
            call SaveTimerHandle( udg_hash, id, secondKey, CreateTimer() )
        endif
        set id = GetHandleId( LoadTimerHandle( udg_hash, id, secondKey ) ) 
        call SaveItemHandle( udg_hash, id, secondKey, myItem )
        call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( myItem ), secondKey ), time, isPeriodic, func )
        
        set myItem = null
        set func = null
        return id
    endfunction

    function InvokeTimerWithEffect takes effect myEffect, string stringHash, real time, boolean isPeriodic, code func returns integer
        local integer id = GetHandleId( myEffect )
        local integer secondKey = StringHash( stringHash )

        if LoadTimerHandle( udg_hash, id, secondKey ) == null then
            call SaveTimerHandle( udg_hash, id, secondKey, CreateTimer() )
        endif
        set id = GetHandleId( LoadTimerHandle( udg_hash, id, secondKey ) ) 
        call SaveEffectHandle( udg_hash, id, secondKey, myEffect )
        call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( myEffect ), secondKey ), time, isPeriodic, func )
        
        set myEffect = null
        set func = null
        return id
    endfunction

endlibrary