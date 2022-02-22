scope BardW initializer init

    globals
        private constant integer ID_ABILITY = 'A1AV'
        private constant integer ID_ABILITY_BUFF = 'B09N'
        
        private constant integer AREA = 500
        private constant integer DURATION = 15
        private constant integer TICK = 3
        
        
        private constant integer ID_DAMAGE_REDUCTION = 'A1AZ'
        private constant integer ID_DAMAGE_REDUCTION_ALTERNATIVE = 'A1C8'
        private constant integer EFFECT_DAMAGE = 'A1AX'
        private constant integer BUFF_DAMAGE = 'B09M'
        
        private constant integer DAMAGE_FIRST_LEVEL = 15
        private constant integer DAMAGE_LEVEL_BONUS = 15
        private constant integer STUN_DURATION = 1
        
        
        private constant integer ID_DAMAGE_BUFF = 'A1AY'
        private constant integer ID_DAMAGE_BUFF_ALTERNATIVE = 'A1C9'
        private constant integer EFFECT_HEAL = 'A1AW'
        private constant integer BUFF_HEAL = 'B09L'
        
        private constant integer HEAL_FIRST_LEVEL = 15
        private constant integer HEAL_LEVEL_BONUS = 15
        
        private group TempGroup = null
    endglobals

    function Trig_BardW_Conditions takes nothing returns boolean
        return GetUnitAbilityLevel(GetOrderedUnit(), ID_ABILITY) > 0 and (GetIssuedOrderId() == OrderId("immolation") or GetIssuedOrderId() == OrderId("unimmolation"))
    endfunction

    function BardWSorrowCast takes nothing returns nothing
        local integer id = GetHandleId( GetExpiredTimer( ) )
        local real dmg = LoadReal( udg_hash, id, StringHash( "barw" ) )
        local unit target = LoadUnitHandle( udg_hash, id, StringHash( "barw" ) )
        local unit caster = LoadUnitHandle( udg_hash, id, StringHash( "barwc" ) )
        
        if IsUnitAlive(target) and GetUnitAbilityLevel( target, EFFECT_DAMAGE) > 0 then
            set IsDisableSpellPower = true
            call UnitTakeDamage(caster, target, dmg, DAMAGE_TYPE_MAGIC)
        else
            call FlushChildHashtable( udg_hash, id )
            call DestroyTimer( GetExpiredTimer() )
        endif
        
        set caster = null
        set target = null
    endfunction

    function BardWJoyCast takes nothing returns nothing
        local integer id = GetHandleId( GetExpiredTimer( ) )
        local real heal = LoadReal( udg_hash, id, StringHash( "barwj" ) )
        local unit target = LoadUnitHandle( udg_hash, id, StringHash( "barwj" ) )
        local unit caster = LoadUnitHandle( udg_hash, id, StringHash( "barwjd" ) )

        if IsUnitAlive(target) and GetUnitAbilityLevel( target, EFFECT_HEAL) > 0 then
            call healst( caster, target, heal )
        else
            call FlushChildHashtable( udg_hash, id )
            call DestroyTimer( GetExpiredTimer() )
        endif
        
        set caster = null
        set target = null
    endfunction
    
    private function DeleteBuffToAffected takes unit caster, boolean isBuff returns group
        local unit u
    
        set TempGroup = LoadGroupHandle(udg_hash, GetHandleId(caster), StringHash( "barwg" ) )
        
        if TempGroup == null then
            set TempGroup = CreateGroup()
            call SaveGroupHandle(udg_hash, GetHandleId(caster), StringHash( "barwg" ), TempGroup )
        endif
        
        loop
            set u = FirstOfGroup(TempGroup)
            exitwhen u == null
            if isBuff then
                call RemoveEffect(u, EFFECT_HEAL, BUFF_HEAL)
                call UnitRemoveAbility(u, ID_DAMAGE_BUFF)
                call UnitRemoveAbility(u, ID_DAMAGE_BUFF_ALTERNATIVE)
            else
                call RemoveEffect(u, EFFECT_DAMAGE, BUFF_DAMAGE)
                call UnitRemoveAbility(u, ID_DAMAGE_REDUCTION)
                call UnitRemoveAbility(u, ID_DAMAGE_REDUCTION_ALTERNATIVE)
            endif
            call GroupRemoveUnit(TempGroup,u)
        endloop
        
        set caster = null
        set u = null
        return TempGroup
    endfunction
    
    private function Heal_Alternative takes unit caster, integer level, real duration returns nothing 
        local group g = CreateGroup()
        local unit n
        local group affected = DeleteBuffToAffected(caster, false)
        
        call GroupEnumUnitsInRange( g, GetUnitX( caster ), GetUnitY( caster ), AREA, null )
        loop
            set n = FirstOfGroup(g)
            exitwhen n == null
            if unitst( n, caster, "ally" ) then
                call bufallst( caster, n, EFFECT_HEAL, ID_DAMAGE_BUFF_ALTERNATIVE, 0, 0, 0, BUFF_HEAL, "brdwj", duration )
                call SetUnitAbilityLevel( n, ID_DAMAGE_BUFF_ALTERNATIVE, level )
                call GroupAddUnit(affected,n)
            endif
            call GroupRemoveUnit(g,n)
        endloop
        
        call GroupClear( g )
        call DestroyGroup( g )
        set n = null
        set g = null
        set affected = null
        set caster = null
    endfunction
    
    private function Heal_Main takes unit caster, integer level, real duration returns nothing 
        local group g = CreateGroup()
        local unit n
        local integer heal
        local integer id
        local group affected = DeleteBuffToAffected(caster, false)
    
        set heal = ( HEAL_FIRST_LEVEL + ( HEAL_LEVEL_BONUS * level ) )
        call GroupEnumUnitsInRange( g, GetUnitX( caster ), GetUnitY( caster ), AREA, null )
        loop
            set n = FirstOfGroup(g)
            exitwhen n == null
            if unitst( n, caster, "ally" ) then
                call bufallst( caster, n, EFFECT_HEAL, ID_DAMAGE_BUFF, 0, 0, 0, BUFF_HEAL, "brdwj", duration )
                call SetUnitAbilityLevel( n, ID_DAMAGE_BUFF, level )
                
                set id = InvokeTimerWithUnit(n, "barwj", TICK, true, function BardWJoyCast ) 
                call SaveUnitHandle( udg_hash, id, StringHash( "barwjd" ), caster ) 
                call SaveReal( udg_hash, id, StringHash( "barwj" ), heal )
                call GroupAddUnit(affected,n)
            endif
            call GroupRemoveUnit(g,n)
        endloop
        
        call GroupClear( g )
        call DestroyGroup( g )
        set n = null
        set g = null
        set caster = null
        set affected = null
    endfunction

    private function Heal takes unit caster, integer level, real duration returns nothing
        if Aspects_IsHeroAspectActive( caster, ASPECT_02 ) then
            call Heal_Alternative( caster, level, duration )
        else
            call Heal_Main( caster, level, duration )
        endif
        
        set caster = null
    endfunction
        
    private function Damage_Alternative takes unit caster, integer level, real duration returns nothing 
        local group g = CreateGroup()
        local unit n
        local group affected = DeleteBuffToAffected(caster, true)
        
        call GroupEnumUnitsInRange( g, GetUnitX( caster ), GetUnitY( caster ), AREA, null )
        loop
            set n = FirstOfGroup(g)
            exitwhen n == null
            if unitst( n, caster, TARGET_ENEMY )  then
                call UnitStun(caster, n, STUN_DURATION )

                call bufallst( caster, n, EFFECT_DAMAGE, ID_DAMAGE_REDUCTION_ALTERNATIVE, 0, 0, 0, BUFF_DAMAGE, "brdws", duration )
                call SetUnitAbilityLevel( n, ID_DAMAGE_REDUCTION_ALTERNATIVE, level )
                call GroupAddUnit(affected,n)
            endif
            call GroupRemoveUnit(g,n)
        endloop
        
        call GroupClear( g )
        call DestroyGroup( g )
        set n = null
        set g = null
        set caster = null
        set affected = null
    endfunction
    
    private function Damage_Main takes unit caster, integer level, real duration returns nothing 
        local integer index = GetUnitUserData(caster)
        local group g = CreateGroup()
        local unit n
        local real damage
        local integer id
        local group affected = DeleteBuffToAffected(caster, true)
        
        set damage = (DAMAGE_FIRST_LEVEL + (DAMAGE_LEVEL_BONUS*level))*GetUnitSpellPower(caster)
        call GroupEnumUnitsInRange( g, GetUnitX( caster ), GetUnitY( caster ), AREA, null )
        loop
            set n = FirstOfGroup(g)
            exitwhen n == null
            if unitst( n, caster, TARGET_ENEMY )  then
                call UnitStun(caster, n, STUN_DURATION )

                call bufallst( caster, n, EFFECT_DAMAGE, ID_DAMAGE_REDUCTION, 0, 0, 0, BUFF_DAMAGE, "brdws", duration )
                call SetUnitAbilityLevel( n, ID_DAMAGE_REDUCTION, level )
                
                set id = InvokeTimerWithUnit( n, "barw", TICK, true, function BardWSorrowCast )
                call SaveUnitHandle( udg_hash, id, StringHash( "barwc" ), caster )
                call SaveReal( udg_hash, id, StringHash( "barw" ), damage )
                call GroupAddUnit(affected,n)
            endif
            call GroupRemoveUnit(g,n)
        endloop
        
        call GroupClear( g )
        call DestroyGroup( g )
        set n = null
        set g = null
        set caster = null
        set affected = null
    endfunction
    
    private function Damage takes unit caster, integer level, real duration returns nothing

        if Aspects_IsHeroAspectActive( caster, ASPECT_02 ) then
            call Damage_Alternative( caster, level, duration )
        else
            call Damage_Main( caster, level, duration )
        endif
        
        set caster = null
    endfunction

    function Trig_BardW_Actions takes nothing returns nothing
        local unit hero = GetOrderedUnit()
        local integer lvl = GetUnitAbilityLevel( hero, ID_ABILITY )
        local real duration = timebonus(hero, DURATION)

        if GetIssuedOrderId() == OrderId("immolation") then
            call Heal(hero, lvl, duration)
        elseif GetIssuedOrderId() == OrderId("unimmolation") and IsUnitHasAbility(hero, ID_ABILITY_BUFF) then
            call Damage(hero, lvl, duration)
        endif
        
        set hero = null
    endfunction
    

    private function DeleteBuff_Conditions takes nothing returns boolean
        return IsUnitHasAbility( Event_DeleteBuff_Unit, EFFECT_HEAL)
    endfunction
    
    private function DeleteBuff takes nothing returns nothing
        call RemoveEffect( Event_DeleteBuff_Unit, EFFECT_HEAL, BUFF_HEAL )
    endfunction

    //===========================================================================
    private function init takes nothing returns nothing
        set gg_trg_BardW = CreateTrigger(  )
        call TriggerRegisterAnyUnitEventBJ( gg_trg_BardW, EVENT_PLAYER_UNIT_ISSUED_ORDER )
        call TriggerAddCondition( gg_trg_BardW, Condition( function Trig_BardW_Conditions ) )
        call TriggerAddAction( gg_trg_BardW, function Trig_BardW_Actions )
        
        call CreateEventTrigger( "Event_DeleteBuff_Real", function DeleteBuff, function DeleteBuff_Conditions )
    endfunction

endscope