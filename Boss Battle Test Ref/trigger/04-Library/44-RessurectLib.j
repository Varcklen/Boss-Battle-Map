library RessurectLib

    function resst takes player p, real x, real y, real fac returns unit
        local integer i = GetPlayerId( p ) + 1
        local integer k = deadminionlim[i]
        local integer rand
        
        if k > 0 then
            set rand = GetRandomInt(1, k)
            set bj_lastCreatedUnit = CreateUnit( p, deadminion[i][rand], x, y, fac )
            call BlzSetUnitBaseDamage( bj_lastCreatedUnit, deadminionat[i][rand], 0 )
            call BlzSetUnitMaxHP( bj_lastCreatedUnit, deadminionhp[i][rand] )
            call SetUnitState( bj_lastCreatedUnit, UNIT_STATE_LIFE, GetUnitState( bj_lastCreatedUnit, UNIT_STATE_MAX_LIFE) )
        else
            set bj_lastCreatedUnit = null
        endif
        set p = null
        return bj_lastCreatedUnit 
    endfunction

endlibrary