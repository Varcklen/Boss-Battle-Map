library SmartUnitDamageLib

    function GetUnitAvgDiceDamage takes unit u returns integer
        local integer damage = R2I( (BlzGetUnitDiceNumber(u, 0) * BlzGetUnitDiceSides(u, 0) + 1) / 2)
        set u = null
        return damage
    endfunction

    function GetUnitDamage takes unit u returns integer
        local integer damage = BlzGetUnitBaseDamage(u, 0) + GetUnitAvgDiceDamage(u)
        set u = null
        return damage
    endfunction

endlibrary