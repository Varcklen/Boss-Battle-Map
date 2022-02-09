scope OrbCenarius initializer init

    globals
        private constant integer ID_ITEM = 'I0F1'
        
        private constant integer DURATION = 5
        private constant integer TICK = 1
        private constant real HEAL_EFFECTIVENESS = 0.1
        
        private constant integer EFFECT = 'A12H'
        private constant integer BUFF = 'B09F'
        
        private boolean IsFromOrbOfCenarius = false
    endglobals

    private function OrbCenariusCast takes nothing returns nothing
        local integer id = GetHandleId( GetExpiredTimer( ) )
        local real heal = LoadReal( udg_hash, id, StringHash( "orbnc" ) )
        local unit caster = LoadUnitHandle( udg_hash, id, StringHash( "orbncc" ) )
        local unit target = LoadUnitHandle( udg_hash, id, StringHash( "orbnc" ) )
        
        if IsUnitAlive( target ) and IsUnitHasAbility(target, EFFECT) then
            set IsFromOrbOfCenarius = true
            call healst(caster, target, heal)
            set IsFromOrbOfCenarius = false
        else
            call UnitRemoveAbility( target, EFFECT )
            call UnitRemoveAbility( target, BUFF )
            call FlushChildHashtable( udg_hash, id )
            call DestroyTimer( GetExpiredTimer() )
        endif
        
        set caster = null
        set target = null
    endfunction

    private function AfterHeal_Conditions takes nothing returns boolean
        return IsHeroHasItem( Event_AfterHeal_Caster, ID_ITEM) and IsFromOrbOfCenarius == false
    endfunction
    
    private function AfterHeal takes nothing returns nothing
        local unit caster = Event_AfterHeal_Caster
        local unit target = Event_AfterHeal_Target
        local real heal = Event_AfterHeal_Heal*HEAL_EFFECTIVENESS
        local real duration = timebonus(caster, DURATION)
        local integer id
    
        call bufallst(caster, target, EFFECT, 0, 0, 0, 0, BUFF, "orbn", duration )
        
        set id = InvokeTimerWithUnit(target, "orbnc", TICK, true, function OrbCenariusCast )
        call SaveUnitHandle( udg_hash, id, StringHash( "orbncc" ), caster )
        call SaveReal( udg_hash, id, StringHash( "orbnc" ), heal )
        
        set caster = null
        set target = null
    endfunction
    
    //Delete buff
    private function DeleteBuff_Conditions takes nothing returns boolean
        return IsUnitHasAbility( Event_DeleteBuff_Unit, EFFECT)
    endfunction
    
    private function DeleteBuff takes nothing returns nothing
        call RemoveEffect( Event_DeleteBuff_Unit, EFFECT, BUFF )
    endfunction
    
    private function init takes nothing returns nothing
        call CreateEventTrigger( "Event_AfterHeal_Real", function AfterHeal, function AfterHeal_Conditions )
        call CreateEventTrigger( "Event_DeleteBuff_Real", function DeleteBuff, function DeleteBuff_Conditions )
    endfunction

endscope