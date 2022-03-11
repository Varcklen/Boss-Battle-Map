library Conditions

    function IsPotionItemIsUsed takes nothing returns boolean
        if GetSpellAbilityId() == 'A0QT' then 
            return true
        elseif GetSpellAbilityId() == 'A0JH' then
            return true
        elseif GetSpellAbilityId() == 'A0K3' then
            return true
        elseif GetSpellAbilityId() == 'A13W' then
            return true
        elseif GetSpellAbilityId() == 'A0GJ' then
            return true
        elseif GetSpellAbilityId() == 'A0IY' then
            return true
        elseif GetSpellAbilityId() == 'A0QS' then
            return true
        elseif GetSpellAbilityId() == 'A0RN' then
            return true
        elseif GetSpellAbilityId() == 'A04E' then
            return true
        elseif GetSpellAbilityId() == 'A0KF' then
            return true
        elseif GetSpellAbilityId() == 'A0IB' then
            return true
        elseif GetSpellAbilityId() == 'A14W' then
            return true
        elseif GetSpellAbilityId() == 'A165' then
            return true
        elseif GetSpellAbilityId() == 'A166' then
            return true
        elseif GetSpellAbilityId() == 'A169' then
            return true
        elseif GetSpellAbilityId() == 'A168' then
            return true
        elseif GetSpellAbilityId() == 'A167' then
            return true
        endif
        return false
    endfunction

    function IsUnitHasAbility takes unit caster, integer myBuff returns boolean
        local boolean isWork = GetUnitAbilityLevel( caster, myBuff) > 0
        set caster = null
        return isWork
    endfunction
    
    function GetHeroNumber takes integer heroId returns integer
        local integer i = 1
        loop
            exitwhen i > udg_Database_InfoNumberHeroes
            if udg_Database_Hero[i] == heroId then
                return i
            endif
            set i = i + 1
        endloop
        return 0
    endfunction

endlibrary