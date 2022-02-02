library SpecAnimLib

    function spectimeend takes nothing returns nothing
        local integer id = GetHandleId( GetExpiredTimer() )
        local effect e = LoadEffectHandle( udg_hash, id, StringHash( "anim" ) )

        call DestroyEffect( e )
        call FlushChildHashtable( udg_hash, id )
        
        set e = null
    endfunction

    function spectimeunit takes unit u, string what, string where, real t returns nothing
        local integer id

        set bj_lastCreatedEffect = AddSpecialEffectTarget(what, u, where)
        
        set id = GetHandleId(bj_lastCreatedEffect)
        if LoadTimerHandle( udg_hash, id, StringHash( "anim" ) ) == null  then
            call SaveTimerHandle( udg_hash, id, StringHash( "anim" ), CreateTimer() )
        endif
        set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "anim" ) ) ) 
        call SaveEffectHandle( udg_hash, id, StringHash( "anim" ), bj_lastCreatedEffect )
        call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( bj_lastCreatedEffect ), StringHash( "anim" ) ), t, false, function spectimeend )
        
        set u = null
    endfunction

    function spectime takes string what, real x, real y, real t returns nothing
        local integer id

        set bj_lastCreatedEffect = AddSpecialEffect(what, x, y)
        
        set id = GetHandleId(bj_lastCreatedEffect)
        if LoadTimerHandle( udg_hash, id, StringHash( "anim" ) ) == null  then
            call SaveTimerHandle( udg_hash, id, StringHash( "anim" ), CreateTimer() )
        endif
        set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "anim" ) ) ) 
        call SaveEffectHandle( udg_hash, id, StringHash( "anim" ), bj_lastCreatedEffect )
        call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( bj_lastCreatedEffect ), StringHash( "anim" ) ), t, false, function spectimeend )
    endfunction

endlibrary
