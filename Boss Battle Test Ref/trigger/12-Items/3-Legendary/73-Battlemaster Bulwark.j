scope BattlemasterBulwark initializer init

    globals
        private constant integer ID_ITEM = 'I0GO'
        private constant real BATTLEMASTER_BULWARK_SHIELD_BONUS = 0.4
    endglobals

    private function AfterDamageEvent_Conditions takes nothing returns boolean
        return IsHeroHasItem( udg_DamageEventSource, ID_ITEM)
    endfunction

    private function AfterDamageEvent takes nothing returns nothing
        call shield(udg_DamageEventSource, udg_DamageEventSource, udg_DamageEventAmount*BATTLEMASTER_BULWARK_SHIELD_BONUS, 60 )
    endfunction

    //===========================================================================
    private function init takes nothing returns nothing
        call CreateEventTrigger( "udg_AfterDamageEvent", function AfterDamageEvent, function AfterDamageEvent_Conditions )
    endfunction

endscope
