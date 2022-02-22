scope TwilightMeat initializer init

    globals
        private constant integer ID_ABILITY = 'A1CH'
        private constant integer ID_ITEM = 'I0G9'
    endglobals

    function Trig_Twilight_Meat_Conditions takes nothing returns boolean
        return GetSpellAbilityId() == ID_ABILITY
    endfunction

    function Trig_Twilight_Meat_Actions takes nothing returns nothing
        local unit caster
        local integer cyclA = 1
        local integer cyclAEnd 
        
        if CastLogic() then
            set caster = udg_Caster
        elseif RandomLogic() then
            set caster = udg_Caster
            call textst( udg_string[0] + GetObjectName(ID_ABILITY), caster, 64, 90, 10, 1.5 )
        else
            set caster = GetSpellAbilityUnit()
        endif
        
        set cyclAEnd = eyest( caster )
        loop
            exitwhen cyclA > cyclAEnd
            call MoonTrigger(caster)
            set cyclA = cyclA + 1
        endloop
        
        set caster = null
    endfunction
    
    private function UntilMoonSetCast_Conditions takes nothing returns boolean
        return IsHeroHasItem( Event_UntilMoonSetCast_Hero, ID_ITEM)
    endfunction
    
    private function UntilMoonSetCast takes nothing returns nothing
        local unit hero = Event_UntilMoonSetCast_Hero

        set Event_UntilMoonSetCast_Damage = Event_UntilMoonSetCast_Damage + (Event_UntilMoonSetCast_Static_Damage * (udg_SpellDamagePotion[GetUnitUserData(hero)] - 1) )
        
        set hero = null
    endfunction

    //===========================================================================
    private function init takes nothing returns nothing
        set gg_trg_Twilight_Meat = CreateTrigger(  )
        call TriggerRegisterAnyUnitEventBJ( gg_trg_Twilight_Meat, EVENT_PLAYER_UNIT_SPELL_EFFECT )
        call TriggerAddCondition( gg_trg_Twilight_Meat, Condition( function Trig_Twilight_Meat_Conditions ) )
        call TriggerAddAction( gg_trg_Twilight_Meat, function Trig_Twilight_Meat_Actions )
        
        call CreateEventTrigger( "Event_UntilMoonSetCast_Real", function UntilMoonSetCast, function UntilMoonSetCast_Conditions )
    endfunction

endscope

