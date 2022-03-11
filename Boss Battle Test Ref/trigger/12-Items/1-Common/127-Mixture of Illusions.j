scope MixtureOfIllusions initializer init

    globals
        private constant integer ID_ITEM =  'I0E1'
    endglobals

    private function AfterHeal_Conditions takes nothing returns boolean
        return IsHealFromPotion and IsHeroHasItem( Event_AfterHeal_Caster, ID_ITEM )
    endfunction
    
    private function AfterHeal takes nothing returns nothing
        local integer i = 1
        local unit caster = Event_AfterHeal_Caster
        local unit hero
        local real heal = Event_AfterHeal_Heal
        
        loop
            exitwhen i > PLAYERS_LIMIT
            set hero = udg_hero[i]
            if hero != caster and IsUnitAlive( udg_hero[i] ) and IsUnitAlly( hero, GetOwningPlayer( caster ) ) then
                call healst( caster, hero, heal )
            endif
            set i = i + 1
        endloop
        
        set caster = null
        set hero = null
    endfunction

    //===========================================================================
    private function init takes nothing returns nothing
        call CreateEventTrigger("Event_AfterHeal_Real", function AfterHeal, function AfterHeal_Conditions )
    endfunction
endscope