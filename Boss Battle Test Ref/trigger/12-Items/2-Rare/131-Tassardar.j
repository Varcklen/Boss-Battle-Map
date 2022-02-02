scope Tassardar initializer init

    globals
        private constant integer ID_ITEM = 'I04O'
        
        private constant string ANIMATION = "Abilities\\Spells\\Human\\MarkOfChaos\\MarkOfChaosDone.mdl"
    endglobals

    private function SomeoneDied_Conditions takes nothing returns boolean
        return IsHeroHasItem( Event_SomeoneDied_Unit, ID_ITEM) and IsUnitAlive( Event_SomeoneDied_Unit)
    endfunction

    private function TassardarEnd takes nothing returns nothing
        local integer id = GetHandleId( GetExpiredTimer( ) )
        local unit hero = LoadUnitHandle( udg_hash, id, StringHash( "tsss" ) )

        call spectimeunit( hero, ANIMATION, "origin", 2 )
        call BlzEndUnitAbilityCooldown( hero, udg_Ability_Uniq[GetUnitUserData(hero)] )
        call FlushChildHashtable( udg_hash, id )
        
        set hero = null
    endfunction

    private function SomeoneDied takes nothing returns nothing
        call InvokeTimerWithUnit(Event_SomeoneDied_Unit, "tsss", 0.01, false, function TassardarEnd )
    endfunction

    //===========================================================================
    private function init takes nothing returns nothing
        call CreateEventTrigger( "Event_SomeoneDied_Real", function SomeoneDied, function SomeoneDied_Conditions )
    endfunction

endscope