scope OrbFrozenThundra initializer init

    globals
        private constant integer ID_ITEM = 'I0F5'
        private boolean isLoop = false
        
        private constant integer HEALTH_PERCENT_NEEDED = 40
        private constant integer COOLDOWN = 60
        private constant string ANIMATION = "Abilities\\Spells\\Human\\ReviveHuman\\ReviveHuman.mdl" 
    endglobals

    private function AfterHeal_Conditions takes nothing returns boolean
        if IsHeroHasItem( Event_AfterHeal_Caster, ID_ITEM ) == false then
            return false
        elseif GetHealthPercent( Event_AfterHeal_Target ) - Event_AfterHeal_Heal > HEALTH_PERCENT_NEEDED then
            return false
        elseif LoadBoolean( udg_hash, GetHandleId( Event_AfterHeal_Caster ), StringHash( "orbth" ) ) then
            return false
        elseif isLoop then
            return false
        elseif IsUnitType( Event_AfterHeal_Target, UNIT_TYPE_HERO) == false then
            return false
        endif
        return true
    endfunction
    
    function OrbThundraEnd takes nothing returns nothing
        local integer id = GetHandleId( GetExpiredTimer( ) )
        local unit u = LoadUnitHandle( udg_hash, id, StringHash( "orbth" ) )
        
        call SaveBoolean( udg_hash, GetHandleId( u ), StringHash( "orbth" ), false )
        call FlushChildHashtable( udg_hash, id )

        set u = null
    endfunction    
    
    private function AfterHeal takes nothing returns nothing
        local unit caster = Event_AfterHeal_Caster
        local unit target = Event_AfterHeal_Target
        
        call SaveBoolean( udg_hash, GetHandleId( caster ), StringHash( "orbth" ), true )
        call BlzStartUnitAbilityCooldown( caster, 'A15D', COOLDOWN )
        
        call PlaySpecialEffect(ANIMATION, target)
        set isLoop = true
        call healst( caster, target, GetUnitState( target, UNIT_STATE_MAX_LIFE) )
        set isLoop = false
        
        call InvokeTimerWithUnit(caster, "orbth", COOLDOWN, false, function OrbThundraEnd )
    
        set caster = null
        set target = null
    endfunction

    //===========================================================================
    private function init takes nothing returns nothing
        call CreateEventTrigger("Event_AfterHeal_Real", function AfterHeal, function AfterHeal_Conditions )
    endfunction
endscope