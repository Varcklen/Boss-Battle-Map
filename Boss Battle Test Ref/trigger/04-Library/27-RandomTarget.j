library RandomTargetLib initializer init requires UnitstLib

    globals
        constant string RANDOM_TARGET_NOT_STUNNED = "notstun"//0
        constant string RANDOM_TARGET_UNDEAD = "undead"//1
        constant string RANDOM_TARGET_ORGANIC = "org"//2
        constant string RANDOM_TARGET_NOT_UNDEAD = "notundead"//3
        constant string RANDOM_TARGET_NOT_CASTER = "notcaster"//4
        constant string RANDOM_TARGET_MINION = "pris"//5
        constant string RANDOM_TARGET_HERO = "hero"//6
        constant string RANDOM_TARGET_NOT_FULL_HEALTH = "notfull"//7
        constant string RANDOM_TARGET_VULNERABLE = "vulnerable"//8
        constant string RANDOM_TARGET_CAN_MOVE = "notstand"//9
        constant string RANDOM_TARGET_NOT_PROVOKED = "notprovoked"//10
        
        private constant integer PROVOKE_TYPES_COUNT = 11
        private constant integer PROVOKE_TYPES_COUNT_ARRAYS = PROVOKE_TYPES_COUNT + 1
        
        private string array RandomTargetTypes[PROVOKE_TYPES_COUNT_ARRAYS]
        
        private unit TempUnit = null
    endglobals
    
    private function init takes nothing returns nothing
        set RandomTargetTypes[0] = RANDOM_TARGET_NOT_STUNNED 
        set RandomTargetTypes[1] = RANDOM_TARGET_UNDEAD
        set RandomTargetTypes[2] = RANDOM_TARGET_ORGANIC
        set RandomTargetTypes[3] = RANDOM_TARGET_NOT_UNDEAD
        set RandomTargetTypes[4] = RANDOM_TARGET_NOT_CASTER 
        set RandomTargetTypes[5] = RANDOM_TARGET_MINION 
        set RandomTargetTypes[6] = RANDOM_TARGET_HERO
        set RandomTargetTypes[7] = RANDOM_TARGET_NOT_FULL_HEALTH
        set RandomTargetTypes[8] = RANDOM_TARGET_VULNERABLE 
        set RandomTargetTypes[9] = RANDOM_TARGET_CAN_MOVE
        set RandomTargetTypes[10] = RANDOM_TARGET_NOT_PROVOKED
    endfunction
    
    private struct ProvokeTypes
        boolean array isTypeActive[PROVOKE_TYPES_COUNT_ARRAYS]
    endstruct
    
    private function IsCanBeTarget takes unit caster, unit target, ProvokeTypes provokeTypes returns boolean
        local boolean isWork = true
    
        if provokeTypes.isTypeActive[0] and IsUnitHasAbility( target, 'BPSE' ) then
            set isWork = false
        elseif provokeTypes.isTypeActive[1] and IsUnitType( target, UNIT_TYPE_UNDEAD ) == false then
            set isWork = false
        elseif provokeTypes.isTypeActive[2] and IsUnitType( target, UNIT_TYPE_MECHANICAL) then 
            set isWork = false
        elseif provokeTypes.isTypeActive[3] and IsUnitType( target, UNIT_TYPE_UNDEAD ) == false then 
            set isWork = false
        elseif provokeTypes.isTypeActive[4] and caster == target then 
            set isWork = false
        elseif provokeTypes.isTypeActive[5] and ( IsUnitType( target, UNIT_TYPE_HERO) or IsUnitType( target, UNIT_TYPE_ANCIENT) ) then 
            set isWork = false
        elseif provokeTypes.isTypeActive[6] and IsUnitType( target, UNIT_TYPE_HERO) == false then 
            set isWork = false
        elseif provokeTypes.isTypeActive[7] and IsUnitHealthIsFull(target) then 
            set isWork = false
        elseif provokeTypes.isTypeActive[8] and IsUnitHasAbility( target, 'Avul' ) then 
            set isWork = false
        elseif provokeTypes.isTypeActive[9] and GetUnitDefaultMoveSpeed(target) == 0 then 
            set isWork = false
        elseif provokeTypes.isTypeActive[10] and IsUnitHasAbility( target, 'A09H' ) then 
            set isWork = false
        endif
        
        set caster = null
        set target = null
        call provokeTypes.destroy()
        return isWork
    endfunction

    function randomtarget takes unit caster, real r, string str, string str1, string str2, string str3, string str4 returns unit
        local integer i
        local integer k
        local group utr = CreateGroup()
        local group g = CreateGroup()
        local unit u
        local string array s
        local ProvokeTypes provokeTypes = ProvokeTypes.create()

        if str != "ally" and str != "all" and str != "enemy" then
            call BJDebugMsg("An ability that was applied accidentally has an incorrect target. Please notify the developer about this.")
            set str = "all"
        endif
        
        set s[1] = str1
        set s[2] = str2
        set s[3] = str3
        set s[4] = str4
        
        set i = 1
        loop 
            exitwhen i > 4
            if s[i] != null and s[i] != "" then
                set k = 1
                loop
                    exitwhen k > PROVOKE_TYPES_COUNT
                    if s[i] == RandomTargetTypes[k] then
                        set provokeTypes.isTypeActive[k] = true 
                        set k = PROVOKE_TYPES_COUNT
                    endif
                    set k = k + 1
                endloop 
            endif
            set i = i + 1
        endloop 
        
        call GroupEnumUnitsInRange( g, GetUnitX( caster ), GetUnitY( caster ), r, null )
        loop
            set u = FirstOfGroup(g)
            exitwhen u == null
            if unitst( u, caster, str ) and IsCanBeTarget( caster, u, provokeTypes ) then
                call GroupAddUnit( utr, u )
            endif
            call GroupRemoveUnit(g,u)
        endloop
        
        set TempUnit = null
        if IsUnitGroupEmptyBJ( utr ) == false then
            set TempUnit = GroupPickRandomUnit( utr )
        endif

        call GroupClear( g )
        call GroupClear( utr )
        call DestroyGroup( g )
        call DestroyGroup( utr )
        set u = null
        set g = null
        set utr = null
        set caster = null
        return TempUnit
    endfunction

endlibrary