scope LowHP initializer init

    globals
        private constant integer HEALTH_NEEDED = 35
    endglobals

    private function SetCineFilter takes player owner, boolean isActive returns nothing
        if GetLocalPlayer() == owner then
            call DisplayCineFilter(isActive)
        endif
        call SaveBoolean( udg_hash, GetHandleId(owner), StringHash( "hpvis" ), isActive )
    
        set owner = null
    endfunction

    private function HPVision takes nothing returns nothing
        local integer id = GetHandleId( GetExpiredTimer( ) )
        local unit hero = LoadUnitHandle( udg_hash, id, StringHash( "hpvis" ) )
        local player owner = GetOwningPlayer(hero) 
        local real healthPercent = GetHealthPercent(hero)
        local integer i = GetUnitUserData(hero)
        local boolean isActive = LoadBoolean( udg_hash, GetHandleId(owner), StringHash( "hpvis" ) )
        
        if udg_combatlogic[GetUnitUserData(hero)] == false then
            call SetCineFilter(owner, false)
            call FlushChildHashtable( udg_hash, id )
            call DestroyTimer( GetExpiredTimer() ) 
        elseif healthPercent <= HEALTH_NEEDED and IsUnitAlive(hero) and not(isActive) then
            call SetCineFilter(owner, true)
        elseif (healthPercent > HEALTH_NEEDED or IsUnitDead(hero)) and isActive then
            call SetCineFilter(owner, false)
        endif
        
        set hero = null
        set owner = null
    endfunction
    
    private function FightStart_Conditions takes nothing returns boolean
        return udg_FightStart_Unit != null and udg_combatlogic[GetUnitUserData(udg_FightStart_Unit)]
    endfunction

    private function FightStart takes nothing returns nothing
        call InvokeTimerWithUnit(udg_FightStart_Unit, "hpvis", 1, true, function HPVision )
    endfunction

    private function init takes nothing returns nothing
        call CreateEventTrigger( "udg_FightStart_Real", function FightStart, function FightStart_Conditions )
    endfunction
endscope