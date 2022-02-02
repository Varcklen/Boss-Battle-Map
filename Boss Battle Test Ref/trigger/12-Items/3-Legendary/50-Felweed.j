scope Felweed initializer init

    globals
        private constant integer ID_ITEM = 'I0CO'
        
        private constant integer AREA = 600
        
        private constant string ANIMATION = "Abilities\\Spells\\NightElf\\EntanglingRoots\\EntanglingRootsTarget.mdl"
        
        private boolean IsActive = false
    endglobals

    private function DealDamage takes nothing returns nothing
        local integer id = GetHandleId( GetExpiredTimer() )
        local unit target = LoadUnitHandle( udg_hash, id, StringHash( "flwd" ) )
        local unit caster = LoadUnitHandle( udg_hash, id, StringHash( "flwdc" ) )
        local real damage = LoadReal( udg_hash, id, StringHash( "flwd" ) )

        call DestroyEffect( AddSpecialEffectTarget( ANIMATION, target, "origin" ) )
        set IsActive = true
        call UnitTakeDamage( caster, target, damage, DAMAGE_TYPE_MAGIC)
        set IsActive = false
        call FlushChildHashtable( udg_hash, id )

        set caster = null
        set target = null
    endfunction

    function AfterHeal_Conditions takes nothing returns boolean
        return IsHeroHasItem( Event_AfterHeal_Target, ID_ITEM ) and IsActive == false
    endfunction
    
    function AfterHeal takes nothing returns nothing
        local unit caster = Event_AfterHeal_Caster
        local unit target
        local integer id
    
        set target = randomtarget( Event_AfterHeal_Target, AREA, "enemy", "", "", "", "" )
        if target != null then
            set id = InvokeTimerWithUnit(target, "flwd", 0.01, false, function DealDamage )
            call SaveUnitHandle( udg_hash, id, StringHash( "flwdc" ), caster )
            call SaveReal( udg_hash, id, StringHash( "flwd" ), Event_AfterHeal_Heal )
        endif
        
        set caster = null
        set target = null
    endfunction

    //===========================================================================
    private function init takes nothing returns nothing
        call CreateEventTrigger( "Event_AfterHeal_Real", function AfterHeal, function AfterHeal_Conditions )
    endfunction
endscope