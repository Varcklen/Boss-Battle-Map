function BossClear takes unit u returns nothing
    local integer s = 1
    local integer n = 1
    local integer k = 1
    local integer h = 0
    local integer cyclA = 1
    local integer cyclB = 1
    local integer i = DB_Boss_id[1][1]
    local boolean l = false
    
    loop
        exitwhen cyclA > 1
        if i == GetUnitTypeId( u ) then
            set cyclB = 1
            set l = false
            loop
                exitwhen l
                set h = cyclB + ( ( s - 1 ) * 10 )
                if DB_Trigger_Boss[n][h] != null and cyclB <= 10 then
                    call DisableTrigger( DB_Trigger_Boss[n][h] )
                    set cyclB = cyclB + 1
                else
                    set l = true
                endif
            endloop
        elseif k < 500 then
            set cyclA = cyclA - 1 
            set s = s + 1
            set i = DB_Boss_id[n][s]
            if i == 0 then
                set s = 1
                set n = n + 1
                set i = DB_Boss_id[n][s]
            endif
        endif
        set k = k + 1
        set cyclA = cyclA + 1
    endloop
    set u = null
endfunction

function onRemovalBoss takes unit u returns nothing
    if IsUnitType(u, UNIT_TYPE_ANCIENT) then
        if GetUnitUserData(u) == 5 then
            call RemoveShield(u)
            call BossClear(u)
        endif
    endif
    set u = null
endfunction

hook RemoveUnit onRemovalBoss