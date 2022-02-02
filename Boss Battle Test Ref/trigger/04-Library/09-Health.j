library Health requires Inventory

    globals
        private unit conditionTarget = null
    endglobals

    private function ResourceCondition takes unit caster, unit target returns boolean
        local boolean isWork = true
    
        if IsHeroHasItem(caster, 'I09N') then
            set isWork = false
        elseif IsUnitEnemy(target, GetOwningPlayer(caster)) then
            set isWork = false
        elseif IsUnitDead(target) then
            set isWork = false
        elseif IsUnitInDuel(target) and IsUnitInDuel(caster) == false and udg_fightmod[3] then
            set isWork = false
        endif
    
        set caster = null
        set target = null
        return isWork
    endfunction
    
    function HeroLessHP takes unit caster returns unit
        local integer cyclA = 1
        
        set conditionTarget = null
        loop
            exitwhen cyclA > 4
            if ResourceCondition(caster, udg_hero[cyclA]) and ( RMinBJ(GetUnitLifePercent(udg_hero[cyclA]), GetUnitLifePercent(udg_hero[cyclA - 3])) == GetUnitLifePercent(udg_hero[cyclA]) or GetUnitState(udg_hero[cyclA - 3], UNIT_STATE_LIFE) <= 0.405 ) and ( RMinBJ(GetUnitLifePercent(udg_hero[cyclA]), GetUnitLifePercent(udg_hero[cyclA - 1])) == GetUnitLifePercent(udg_hero[cyclA]) or GetUnitState(udg_hero[cyclA - 1], UNIT_STATE_LIFE) <= 0.405 ) and ( RMinBJ(GetUnitLifePercent(udg_hero[cyclA]), GetUnitLifePercent(udg_hero[cyclA - 2])) == GetUnitLifePercent(udg_hero[cyclA]) or GetUnitState(udg_hero[cyclA - 2], UNIT_STATE_LIFE) <= 0.405 ) then
                set conditionTarget = udg_hero[cyclA]
            endif
            set cyclA = cyclA + 1
        endloop
        set caster = null
        return conditionTarget
    endfunction

    function HeroLessMP takes unit caster returns unit
        local integer cyclA = 1
        
        set conditionTarget = null
        loop
            exitwhen cyclA > 4
            if ResourceCondition(caster, udg_hero[cyclA]) and ( RMinBJ(GetUnitManaPercent(udg_hero[cyclA]), GetUnitManaPercent(udg_hero[cyclA - 3])) == GetUnitManaPercent(udg_hero[cyclA]) or GetUnitState(udg_hero[cyclA - 3], UNIT_STATE_LIFE) <= 0.405 ) and ( RMinBJ(GetUnitManaPercent(udg_hero[cyclA]), GetUnitManaPercent(udg_hero[cyclA - 1])) == GetUnitManaPercent(udg_hero[cyclA]) or GetUnitState(udg_hero[cyclA - 1], UNIT_STATE_LIFE) <= 0.405 ) and ( RMinBJ(GetUnitManaPercent(udg_hero[cyclA]), GetUnitManaPercent(udg_hero[cyclA - 2])) == GetUnitManaPercent(udg_hero[cyclA]) or GetUnitState(udg_hero[cyclA - 2], UNIT_STATE_LIFE) <= 0.405 ) then
                set conditionTarget = udg_hero[cyclA]
            endif
            set cyclA = cyclA + 1
        endloop
        
        set caster = null
        return conditionTarget
    endfunction

    function GetHealthPercent takes unit whichUnit returns real
        local real value    = GetUnitState(whichUnit, UNIT_STATE_LIFE)
        local real maxValue = GetUnitState(whichUnit, UNIT_STATE_MAX_LIFE)

        // Return 0 for null units.
        if whichUnit == null or maxValue == 0 then
            return 0.0
        endif

        set whichUnit = null
        return value / maxValue * 100.0
    endfunction

    function GetManaPercent takes unit whichUnit returns real
        local real value    = GetUnitState(whichUnit, UNIT_STATE_MANA)
        local real maxValue = GetUnitState(whichUnit, UNIT_STATE_MAX_MANA)

        // Return 0 for null units.
        if whichUnit == null or maxValue == 0 then
            return 0.0
        endif

        set whichUnit = null
        return value / maxValue * 100.0
    endfunction

    function GetHealthFromPercent takes unit whichUnit, integer percent returns real
        local real value    = GetUnitState(whichUnit, UNIT_STATE_LIFE)
        local real maxValue = GetUnitState(whichUnit, UNIT_STATE_MAX_LIFE)

        // Return 0 for null units.
        if whichUnit == null or maxValue == 0 then
            return 0.0
        endif
        if percent < 0 then
            set percent = 0
        elseif percent > 100 then
            set percent = 100
        endif

        set whichUnit = null
        return value / maxValue * percent
    endfunction

    function GetManaFromPercent takes unit whichUnit, integer percent returns real
        local real value    = GetUnitState(whichUnit, UNIT_STATE_MANA)
        local real maxValue = GetUnitState(whichUnit, UNIT_STATE_MAX_MANA)

        // Return 0 for null units.
        if whichUnit == null or maxValue == 0 then
            return 0.0
        endif
        if percent < 0 then
            set percent = 0
        elseif percent > 100 then
            set percent = 100
        endif

        set whichUnit = null
        return value / maxValue * percent
    endfunction
    
    function IsUnitHealthIsFull takes unit whichUnit returns boolean
        local boolean isFull = GetUnitState(whichUnit, UNIT_STATE_LIFE) == GetUnitState(whichUnit, UNIT_STATE_MAX_LIFE)
        set whichUnit = null
        return isFull
    endfunction

    function AddHealthPercent takes unit whichUnit, integer percent returns real
        local real value    = GetUnitState(whichUnit, UNIT_STATE_LIFE)
        local real maxValue = GetUnitState(whichUnit, UNIT_STATE_MAX_LIFE)
        local real addedValue = maxValue * percent / 100

        // Return 0 for null units.
        if whichUnit == null or maxValue == 0 then
            return value
        endif

        call SetUnitState( whichUnit, UNIT_STATE_LIFE, RMaxBJ(0,GetUnitState( whichUnit, UNIT_STATE_LIFE) + addedValue ))
        set whichUnit = null
        return GetUnitState( whichUnit, UNIT_STATE_LIFE)
    endfunction
    
    function AddManaPercent takes unit whichUnit, integer percent returns real
        local real value    = GetUnitState(whichUnit, UNIT_STATE_MANA)
        local real maxValue = GetUnitState(whichUnit, UNIT_STATE_MAX_MANA)
        local real addedValue = maxValue * percent / 100

        // Return 0 for null units.
        if whichUnit == null or maxValue == 0 then
            return value
        endif

        call SetUnitState( whichUnit, UNIT_STATE_MANA, RMaxBJ(0,GetUnitState( whichUnit, UNIT_STATE_MANA) + addedValue ))
        set whichUnit = null
        return GetUnitState( whichUnit, UNIT_STATE_MANA)
    endfunction

endlibrary