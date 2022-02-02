scope Confusion initializer init

    globals
        private constant integer DURATION = 10
        private constant string ANIMATION = "Abilities\\Spells\\Undead\\DeathPact\\DeathPactTarget.mdl"
    endglobals
    
    private function FightStart_Conditions takes nothing returns boolean
        return udg_modbad[31]
    endfunction

    private function ReturnMana takes nothing returns nothing
        local integer id = GetHandleId( GetExpiredTimer( ) )
        local unit hero = LoadUnitHandle(udg_hash, id, StringHash("mdb31") )
        local real manaStealed = LoadReal(udg_hash, id, StringHash("mdb31") )
        
        call PlaySpecialEffect(ANIMATION, hero)
        call SetUnitState( hero, UNIT_STATE_MANA, GetUnitState( hero, UNIT_STATE_MANA ) + manaStealed )
        call FlushChildHashtable( udg_hash, id )
        
        set hero = null
    endfunction

    private function FightStart takes nothing returns nothing
        local unit hero = udg_FightStart_Unit
        local real manaStealed = GetUnitState( hero, UNIT_STATE_MANA)
        local integer id
        
        call PlaySpecialEffect(ANIMATION, hero)
        call SetUnitState( hero, UNIT_STATE_MANA, 0 )
        set id = InvokeTimerWithUnit(hero, "mdb31", DURATION, false, function ReturnMana )
        call SaveReal(udg_hash, id, StringHash("mdb31"), manaStealed )
        
        set hero = null
    endfunction

    //===========================================================================
    private function init takes nothing returns nothing
        call CreateEventTrigger( "udg_FightStart_Real", function FightStart, function FightStart_Conditions )
    endfunction

endscope
