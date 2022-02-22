scope BloodyMary initializer init

    globals
        private constant integer ID_ITEM = 'I0DO'

        private constant integer HEAL = 10
        
        private boolean Loop = false
    endglobals
    
    function Trig_Bloody_Mary_Conditions takes nothing returns boolean
        local integer index = GetPlayerId( GetOwningPlayer( udg_DamageEventSource ) ) + 1
        return IsHeroHasItem(udg_hero[index], ID_ITEM) and ( GetUnitTypeId(udg_DamageEventSource) == 'u000' or udg_DamageEventSource == udg_hero[index] ) and Loop == false
    endfunction
    
    function Trig_Bloody_Mary_Actions takes nothing returns nothing
        set Loop = true
        call healst( udg_hero[GetPlayerId( GetOwningPlayer( udg_DamageEventSource ) ) + 1], null, HEAL )
        set Loop = false
    endfunction

    //===========================================================================
    private function init takes nothing returns nothing
        call CreateEventTrigger( "udg_AfterDamageEvent", function Trig_Bloody_Mary_Actions, function Trig_Bloody_Mary_Conditions )
    endfunction
endscope

