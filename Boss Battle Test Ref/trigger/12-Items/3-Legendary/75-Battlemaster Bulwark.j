scope BattlemasterBulwark initializer init

    globals
        private constant integer ID_ITEM = 'I0GO'
        private constant real BATTLEMASTER_BULWARK_SHIELD_BONUS = 0.4
    endglobals

    private function AfterDamageEvent_Conditions takes nothing returns boolean
        return IsHeroHasItem( ChoosedHero[GetPlayerId( GetOwningPlayer(udg_DamageEventSource) ) + 1], ID_ITEM) and (GetUnitTypeId(udg_DamageEventSource) == 'u000' or IsUnitType( udg_DamageEventSource, UNIT_TYPE_HERO))
    endfunction

    private function AfterDamageEvent takes nothing returns nothing
        local unit hero = ChoosedHero[GetPlayerId( GetOwningPlayer(udg_DamageEventSource) ) + 1]
        
        call shield(hero, hero, udg_DamageEventAmount*BATTLEMASTER_BULWARK_SHIELD_BONUS, 60 )
        
        set hero = null
    endfunction

    //===========================================================================
    private function init takes nothing returns nothing
        call CreateEventTrigger( "udg_AfterDamageEvent", function AfterDamageEvent, function AfterDamageEvent_Conditions )
    endfunction

endscope
