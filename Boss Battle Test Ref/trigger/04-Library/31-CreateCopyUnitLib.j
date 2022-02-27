library CreateCopyUnitLib

    globals
        unit CreateUnitCopy_Original
        unit CreateUnitCopy_Copy
        real CreateUnitCopy_Real
    endglobals

    function CreateUnitCopy takes unit original, real x, real y, real face returns unit
        local unit copy = CreateUnit( GetOwningPlayer( original ), GetUnitTypeId( original ), x, y, face )
        
        call BlzSetUnitMaxHP( copy, BlzGetUnitMaxHP(original) )
        if GetUnitState( original, UNIT_STATE_LIFE) > 0.405 then
            call SetUnitLifePercentBJ( copy, GetUnitLifePercent(original) )
        else
            call SetUnitLifePercentBJ( copy, 100 )
        endif
        call BlzSetUnitBaseDamage( copy, BlzGetUnitBaseDamage(original, 0), 0 )
        call BlzSetUnitArmor( copy, BlzGetUnitArmor(original) )
        call SetUnitMoveSpeed( copy, GetUnitDefaultMoveSpeed(original) )
        
        set CreateUnitCopy_Original = original
        set CreateUnitCopy_Copy = copy
        set CreateUnitCopy_Real = 0.00
        set CreateUnitCopy_Real = 1.00
        set CreateUnitCopy_Real = 0.00
        
        set udg_Temp_Unit = copy
        set copy = null
        set original = null
        return udg_Temp_Unit
    endfunction

endlibrary