library DummyspawnLib

    //Obsolete. Do not use
    function dummyspawn takes unit caster, real dur, integer sp1, integer sp2, integer sp3 returns unit
        set bj_lastCreatedUnit = CreateUnit( GetOwningPlayer( caster ), 'u000', GetUnitX( caster ), GetUnitY( caster ), 270 )
        if dur != 0 then
            call UnitApplyTimedLife( bj_lastCreatedUnit, 'BTLF', dur)
        endif    
        if sp1 != 0 then
            call UnitAddAbility( bj_lastCreatedUnit, sp1)
        endif
        if sp2 != 0 then
            call UnitAddAbility( bj_lastCreatedUnit, sp2)
        endif
        if sp3 != 0 then
            call UnitAddAbility( bj_lastCreatedUnit, sp3)
        endif
        
        set caster = null
        return bj_lastCreatedUnit
    endfunction

endlibrary