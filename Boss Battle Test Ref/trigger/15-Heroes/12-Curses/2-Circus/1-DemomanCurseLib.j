library DemomanCurseLib requires TimePlayLib, TimebonusLib, BuffsLibLib

function DemomanCurse takes unit caster, unit target returns nothing
    local integer array k
    local integer rand
    local integer i
    local integer cyclA
    local real t
    
    set cyclA = 1
    set i = 0
    loop
        exitwhen cyclA > 4
        set k[cyclA] = 0
        if GetUnitAbilityLevel( target, 'A1A0' + cyclA) == 0 then
            set i = i + 1
            set k[i] = cyclA
        endif
        set cyclA = cyclA + 1
    endloop
    
    set t = timebonus(caster, 15)
    if i > 0 then
        set rand = k[GetRandomInt(1, i)]
        call bufst( caster, target, 'A1A0' + rand, 'B1B0' + rand, "demc" + I2S( rand ), t )
        
        call debuffst( caster, target, null, 1, t )
    endif
endfunction

endlibrary