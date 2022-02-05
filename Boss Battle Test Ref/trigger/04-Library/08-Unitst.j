library UnitstLib

    function unitst takes unit target, unit caster, string str returns boolean
        local boolean l = false
        if GetUnitState( target, UNIT_STATE_LIFE ) > 0.405 and GetUnitTypeId(target) != 'u000' and GetOwningPlayer( target ) != Player( PLAYER_NEUTRAL_PASSIVE ) then
            if IsUnitEnemy( target, GetOwningPlayer( caster ) ) and GetUnitAbilityLevel( target, 'Avul') == 0 and str == "enemy" then
                set l = true
            elseif IsUnitAlly( target, GetOwningPlayer( caster ) ) and str == "ally" then
                set l = true
            elseif GetUnitAbilityLevel( target, 'Avul') == 0 and str == "all" then
                set l = true
            endif
        endif
        set target = null
        set caster = null
        return l
    endfunction
    
    /*function IsRelationCorrectInt takes unit target, unit caster, integer enum returns boolean
        local boolean l = false
        if GetUnitState( target, UNIT_STATE_LIFE ) > 0.405 and GetUnitTypeId(target) != 'u000' and GetOwningPlayer( target ) != Player( PLAYER_NEUTRAL_PASSIVE ) then
            if IsUnitEnemy( target, GetOwningPlayer( caster ) ) and GetUnitAbilityLevel( target, 'Avul') == 0 and enum == TargetRelation.TARGET_ENEMY() then
                set l = true
            elseif IsUnitAlly( target, GetOwningPlayer( caster ) ) and enum == TargetRelation.TARGET_ALLY() then
                set l = true
            elseif GetUnitAbilityLevel( target, 'Avul') == 0 and enum == TargetRelation.TARGET_ALL() then
                set l = true
            endif
        endif
        set target = null
        set caster = null
        return l
    endfunction
    
    function IsRelationCorrect takes unit target, unit caster, TargetRelation relation returns boolean
        local boolean isWork = IsRelationCorrectInt(target, caster, relation.enum )
        call relation.destroy()
        set target = null
        set caster = null
        return isWork
    endfunction*/

endlibrary