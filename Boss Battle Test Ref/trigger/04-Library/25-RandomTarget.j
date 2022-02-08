library RandomTargetLib requires UnitstLib

    globals
        constant string RANDOM_TARGET_NOT_STUNNED = "notstun"
        constant string RANDOM_TARGET_UNDEAD = "undead"
        constant string RANDOM_TARGET_ORGANIC = "org"
        constant string RANDOM_TARGET_NOT_UNDEAD = "notundead"
        constant string RANDOM_TARGET_NOT_CASTER = "notcaster"
        constant string RANDOM_TARGET_NOT_MINION = "pris"
        constant string RANDOM_TARGET_HERO = "hero"
        constant string RANDOM_TARGET_NOT_FULL_HEALTH = "notfull"
        constant string RANDOM_TARGET_VULNERABLE = "vulnerable"
        constant string RANDOM_TARGET_CAN_MOVE = "notstand"
    endglobals
    
    function randomtargetype takes player p, integer typ returns unit
        local group g = CreateGroup()
        
        set bj_livingPlayerUnitsTypeId = typ
        call GroupEnumUnitsOfPlayer(g, p, filterLivingPlayerUnitsOfTypeId)
        
        set uret = GroupPickRandomUnit(g)
        
        call GroupClear( g )
        call DestroyGroup( g )
        set g = null
        set p = null
        return uret
    endfunction

    function randomtarget takes unit caster, real r, string str, string str1, string str2, string str3, string str4 returns unit
        local integer cyclA = 1
        local group utr = CreateGroup()
        local group g = CreateGroup()
        local boolean array L
        local string array s
        local unit u

        if str == "ally" then
            set s[0] = "ally"
        elseif str == "all" then
            set s[0] = "all"
        elseif str == "enemy" then
            set s[0] = "enemy"
        else 
            call BJDebugMsg("An ability that was applied accidentally has an incorrect target. Please notify the developer about this.")
            set s[0] = "all"
        endif
        
        if str1 != "" then
            set s[1] = str1
        else
            set s[1] = ""
        endif
        if str2 != "" then
            set s[2] = str2
        else
            set s[2] = ""
        endif
        if str3 != "" then
            set s[3] = str3
        else
            set s[3] = ""
        endif
        if str4 != "" then
            set s[4] = str4
        else
            set s[4] = ""
        endif
        
        set L[0] = false
        set L[1] = false
        loop 
            exitwhen cyclA > 4
            if s[cyclA] == RANDOM_TARGET_NOT_STUNNED then
                set L[0] = true
            endif
            if s[cyclA] == RANDOM_TARGET_UNDEAD then
                set L[1] = true
            endif
            if s[cyclA] == RANDOM_TARGET_ORGANIC then
                set L[2] = true
            endif
            if s[cyclA] == RANDOM_TARGET_NOT_UNDEAD then
                set L[3] = true
            endif
            if s[cyclA] == RANDOM_TARGET_NOT_CASTER then
                set L[4] = true
            endif 
            if s[cyclA] == RANDOM_TARGET_NOT_MINION then
                set L[5] = true
            endif 
            if s[cyclA] == RANDOM_TARGET_HERO then
                set L[6] = true
            endif 
            if s[cyclA] == RANDOM_TARGET_NOT_FULL_HEALTH then
                set L[7] = true
            endif 
            if s[cyclA] == RANDOM_TARGET_VULNERABLE then
                set L[8] = true
            endif 
            if s[cyclA] == RANDOM_TARGET_CAN_MOVE then
                set L[9] = true
            endif 
            set cyclA = cyclA + 1
        endloop 
        
        call GroupEnumUnitsInRange( g, GetUnitX( caster ), GetUnitY( caster ), r, null )
        loop
            set u = FirstOfGroup(g)
            exitwhen u == null
            if ( ( GetUnitDefaultMoveSpeed(u) != 0 and L[9] ) or not( L[9] ) ) and ( (  GetUnitAbilityLevel( u, 'Avul' ) == 0 and L[8] ) or not( L[8] ) ) and unitst( u, caster, s[0] ) and ( ( GetUnitState( u, UNIT_STATE_LIFE) != GetUnitState( u, UNIT_STATE_MAX_LIFE) and L[7] ) or not( L[7] ) ) and ( ( IsUnitType( u, UNIT_TYPE_HERO) and L[6] ) or not( L[6] ) ) and ( ( not( IsUnitType( u, UNIT_TYPE_HERO) ) and not( IsUnitType(u, UNIT_TYPE_ANCIENT) ) and L[5] ) or not( L[5] ) ) and ( ( not( GetUnitAbilityLevel( u, 'BPSE' ) > 0 ) and L[0] ) or not( L[0] ) ) and ( ( IsUnitType( u, UNIT_TYPE_UNDEAD ) and L[1] ) or not( L[1] ) ) and ( ( not( IsUnitType( u, UNIT_TYPE_MECHANICAL) ) and L[2] ) or not( L[2] ) ) and ( ( not( IsUnitType( u, UNIT_TYPE_UNDEAD ) ) and L[3] ) or not( L[3] ) ) and ( ( caster != u and L[4] ) or not( L[4] ) ) then
                call GroupAddUnit( utr, u )
            endif
            call GroupRemoveUnit(g,u)
        endloop
        set uret = null
        if not( IsUnitGroupEmptyBJ( utr ) )  then
            set uret = GroupPickRandomUnit( utr )
        endif

        call GroupClear( g )
        call GroupClear( utr )
        call DestroyGroup( g )
        call DestroyGroup( utr )
        set u = null
        set g = null
        set utr = null
        set caster = null
        return uret
    endfunction

endlibrary