scope BloodyMary initializer init

    globals
        private constant integer ID_ITEM = 'I0DO'

        private constant integer HEAL = 10
        private constant real COOLDOWN = 0.5
    endglobals
    
    function Trig_Bloody_Mary_Conditions takes nothing returns boolean
        local integer index = GetPlayerId( GetOwningPlayer( udg_DamageEventSource ) ) + 1
        return IsHeroHasItem(udg_hero[index], ID_ITEM) and ( GetUnitTypeId(udg_DamageEventSource) == 'u000' or udg_DamageEventSource == udg_hero[index] ) and LoadBoolean( udg_hash, GetHandleId( udg_hero[index] ), StringHash( "blmr" ) ) == false
    endfunction
    
    private function Cooldown takes nothing returns nothing
        local integer id = GetHandleId( GetExpiredTimer( ) )
        local unit hero = LoadUnitHandle( udg_hash, id, StringHash( "blmr" ) )
        
        call SaveBoolean( udg_hash, GetHandleId( hero ), StringHash( "blmr" ), false )
        call FlushChildHashtable( udg_hash, id )
        
        set hero = null
    endfunction
    
    function Trig_Bloody_Mary_Actions takes nothing returns nothing
        local unit hero = udg_hero[GetPlayerId( GetOwningPlayer( udg_DamageEventSource ) ) + 1]
        
        call healst( hero, null, HEAL )
        
        call InvokeTimerWithUnit( hero, "blmr", COOLDOWN, false, function Cooldown )
        call SaveBoolean( udg_hash, GetHandleId( hero ), StringHash( "blmr" ), true )
        
        set hero = null
    endfunction

    //===========================================================================
    private function init takes nothing returns nothing
        call CreateEventTrigger( "udg_AfterDamageEvent", function Trig_Bloody_Mary_Actions, function Trig_Bloody_Mary_Conditions )
    endfunction
endscope

