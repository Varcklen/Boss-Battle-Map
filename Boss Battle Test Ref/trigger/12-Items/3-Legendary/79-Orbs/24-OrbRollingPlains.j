scope OrbRollingPlains initializer init

    globals
        private constant integer ID_ITEM = 'I0FP'

        private constant integer COUNT_NEEDED = 100
        private constant integer JUMPS_LIMIT = 4
        private constant integer HEAL = 100
        private constant integer AREA_FIRST_JUMP = 600
        private constant integer AREA_JUMP = 400
        private constant integer LIGHTNING_LIFE_TIME = 1
        
        private boolean IsLoop = false
    endglobals

    private function AddPotencialTargets takes unit caster, unit target, group potencialTarget, group affected returns nothing
        local group g = CreateGroup()
        local unit u
    
        call GroupClear( potencialTarget )
        call GroupEnumUnitsInRange( g, GetUnitX( target ), GetUnitY( target ), AREA_JUMP, null )
        loop
            set u = FirstOfGroup(g)
            exitwhen u == null
            if unitst( u, caster, TARGET_ALLY ) and u != target and IsUnitInGroup(u , affected) == false and IsUnitHealthIsFull(u) == false then
                call GroupAddUnit(potencialTarget, u)
            endif
            call GroupRemoveUnit(g,u)
        endloop
    
        set caster = null
        set target = null
        set affected = null
        set potencialTarget = null
        set g = null
        set u = null
    endfunction

    private function ChainHeal takes unit caster returns nothing
        local unit target
        local unit lastunit
        local group potencialTarget = CreateGroup()
        local group affected = CreateGroup()
        local integer i
        
        set target = randomtarget( caster, AREA_FIRST_JUMP, TARGET_ALLY, RANDOM_TARGET_NOT_FULL_HEALTH, "", "", "" )
        
        if target != null then
            set lastunit = caster
            set i = 1
            loop
                call Lightning_CreateLightning( "HWPB", GetUnitX(lastunit), GetUnitY(lastunit), GetUnitFlyHeight(lastunit) + 50, GetUnitX(target), GetUnitY(target), GetUnitFlyHeight(target) + 50, LIGHTNING_LIFE_TIME )
                
                call healst(caster, target, HEAL)
                
                call AddPotencialTargets( caster, target, potencialTarget, affected )
                exitwhen i >= JUMPS_LIMIT or IsUnitGroupEmptyBJ(potencialTarget)
                set lastunit = target
                set target = GroupPickRandomUnit(potencialTarget)
                call GroupAddUnit(affected, target)
                set i = i + 1
            endloop
        endif
        
        call GroupClear( potencialTarget )
        call DestroyGroup( potencialTarget )
        call GroupClear( affected )
        call DestroyGroup( affected )
        set affected = null
        set potencialTarget = null
        set caster = null
        set target = null
        set lastunit = null
    endfunction


    //Damage Trigger
    private function AfterDamageEvent_Conditions takes nothing returns boolean
        return IsHeroHasItem( udg_DamageEventSource, ID_ITEM) and udg_DamageEventAmount >= COUNT_NEEDED and IsLoop == false
    endfunction
    
    private function AfterDamageEvent takes nothing returns nothing
        set IsLoop = true
        call ChainHeal( udg_DamageEventSource )
        set IsLoop = false
    endfunction


    //Heal Trigger
    private function AfterHeal_Conditions takes nothing returns boolean
        return IsHeroHasItem( Event_AfterHeal_Caster, ID_ITEM) and Event_AfterHeal_Heal >= COUNT_NEEDED and IsLoop == false
    endfunction
    
    private function AfterHeal takes nothing returns nothing
        set IsLoop = true
        call ChainHeal( Event_AfterHeal_Caster )
        set IsLoop = false
    endfunction
    
    private function init takes nothing returns nothing
        call CreateEventTrigger( "Event_AfterHeal_Real", function AfterHeal, function AfterHeal_Conditions )
        call CreateEventTrigger( "udg_AfterDamageEvent", function AfterDamageEvent, function AfterDamageEvent_Conditions )
    endfunction

endscope