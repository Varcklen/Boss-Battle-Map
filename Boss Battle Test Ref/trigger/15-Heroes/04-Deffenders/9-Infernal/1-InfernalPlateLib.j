library InfernalPlateLib requires TextLib

function platest takes unit u, integer i returns nothing
	local integer g = GetUnitAbilityLevel(u, 'A1A6')
    local integer lvl = GetUnitAbilityLevel(u, 'A1A5')
    local integer lim = lvl+3
    local integer k

    if IsUnitType( u, UNIT_TYPE_HERO) and lvl > 0 then
        if g + i > lim then
            set g = lim
        elseif g + i < 1 then
            set g = 1
        else
            set g = g + i
        endif
        call SetUnitAbilityLevel(u, 'A1A6', g )
        if GetUnitAbilityLevel(u, 'A1A6') == 1 and GetUnitAbilityLevel(u, 'A1A7') > 0 then
            call UnitRemoveAbility( u, 'A1A7')
        elseif GetUnitAbilityLevel(u, 'A1A6') > 1 and GetUnitAbilityLevel(u, 'A1A7') == 0 then
            call UnitAddAbility( u, 'A1A7')
        endif

        call textst( "|cFF57E5C6" + I2S(g-1), u, 64, GetRandomReal( 80, 100 ), 12, 1 )
        if i < 0 then
            set i = -1*i
        endif
    endif
endfunction

endlibrary