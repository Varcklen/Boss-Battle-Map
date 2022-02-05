library GroupLib requires DummyspawnLib, UnitstLib

    function GroupAoE takes unit caster, unit dummy, real x, real y, real dmg, real area, string who, string strall, string str returns group
        local group g = CreateGroup()
        local unit u
        local unit dum
        local real xc
        local real yc

        if x == 0 and y == 0 then
            set xc = GetUnitX(caster)
            set yc = GetUnitY(caster)
        else
            set xc = x
            set yc = y
        endif
        
        if strall != "" and strall != null then
            call DestroyEffect( AddSpecialEffect( strall, xc, yc ) )
        endif
        /*if dummy == null then
            set dum = dummyspawn( caster, 1, 0, 0, 0 )
        else
            set dum = dummy
        endif*/
        call GroupClear( udg_Temp_Group )
        call GroupEnumUnitsInRange( g, xc, yc, area, null )
        loop
            set u = FirstOfGroup(g)
            exitwhen u == null
            if unitst( u, caster, who ) then
                if str != "" and str != null then
                    call DestroyEffect( AddSpecialEffect( str, GetUnitX(u), GetUnitY(u) ) )
                endif
                call UnitTakeDamage( caster, u, dmg, DAMAGE_TYPE_MAGIC )
                call GroupAddUnit(udg_Temp_Group,u)
            endif
            call GroupRemoveUnit(g,u)
        endloop
        
        call GroupClear( g )
        call DestroyGroup( g )
        set u = null
        set g = null
        set caster = null
        set dum = null
        set dummy = null
        
        return udg_Temp_Group
    endfunction

endlibrary