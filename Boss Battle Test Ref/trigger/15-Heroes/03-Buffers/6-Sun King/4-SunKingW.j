scope SunKingW initializer init

    globals
        private constant integer ID_ABILITY = 'AV00'
        
        private constant integer DURATION = 10
        private constant integer STACK_LIMIT = 3
        private constant integer TICK = 1
        private constant integer AREA = 800
        
        private constant integer DAMAGE_FIRST_LEVEL = 0
        private constant integer DAMAGE_LEVEL_BONUS = 25
        private constant integer TICK_DAMAGE_FIRST_LEVEL = 0
        private constant integer TICK_DAMAGE_LEVEL_BONUS = 1
        private constant real MAGIC_DAMAGE_BONUS_FIRST_LEVEL = 0
        private constant real MAGIC_DAMAGE_BONUS_LEVEL_BONUS = 0.01
        
        private constant integer EFFECT = 'A02Y'
        private constant integer BUFF = 'B08S'
    endglobals

    function Trig_SunKingW_Conditions takes nothing returns boolean
        return GetSpellAbilityId() == ID_ABILITY
    endfunction
    
    private function TickDamage takes nothing returns nothing
        local integer id = GetHandleId( GetExpiredTimer() )
        local unit target = LoadUnitHandle( udg_hash, id, StringHash( "snkw" ) )
        local unit caster = LoadUnitHandle(udg_hash, id, StringHash("snkwc") )
        local real damage = LoadReal(udg_hash, id, StringHash("snkw") )
    
        if IsUnitAlive(target) and IsUnitHasAbility(target, EFFECT) then
            call UnitTakeDamage(caster, target, damage, DAMAGE_TYPE_MAGIC )
        else
            call RemoveSavedReal( udg_hash, GetHandleId(target), StringHash("snkwm") )
            call RemoveSavedInteger( udg_hash, GetHandleId(target), StringHash("snkws") )
            call RemoveEffect( target, EFFECT, BUFF )
            call FlushChildHashtable( udg_hash, id )
            call DestroyTimer( GetExpiredTimer() )
        endif
    
        set caster = null
        set target = null
    endfunction
    
    private function DealDamage takes unit caster, unit target, real duration, real damage, real tickDamage, real magicBonus returns nothing
        local integer id
        local integer stack = IMinBJ(STACK_LIMIT, LoadInteger(udg_hash, GetHandleId(target), StringHash("snkws") ) + 1 )
    
        call textst( "|cFFffcc00" + I2S(stack), target, 64, GetRandomReal( 80, 100 ), 12, 1 )
        call UnitTakeDamage(caster, target, damage, DAMAGE_TYPE_MAGIC )
        call bufst(caster, target, EFFECT, BUFF, "snkwe", duration)
        call debuffst( caster, target, null, 1, duration)
        call SaveInteger(udg_hash, GetHandleId(target), StringHash("snkws"), stack )
        call SaveReal(udg_hash, GetHandleId(target), StringHash("snkwm"), magicBonus*stack)
        
        set id = InvokeTimerWithUnit(target, "snkw", TICK, true, function TickDamage )
        call SaveUnitHandle(udg_hash, id, StringHash("snkwc"), caster)
        call SaveReal(udg_hash, id, StringHash("snkw"), tickDamage*stack)
    
        set caster = null
        set target = null
    endfunction

    private function AreaDamage takes unit caster, integer level, real duration returns nothing
        local group g = CreateGroup()
        local unit u
        local real damage = DAMAGE_FIRST_LEVEL + (DAMAGE_LEVEL_BONUS * level)
        local real tickDamage = TICK_DAMAGE_FIRST_LEVEL + (TICK_DAMAGE_LEVEL_BONUS * level)
        local real magicBonus = MAGIC_DAMAGE_BONUS_FIRST_LEVEL + (MAGIC_DAMAGE_BONUS_LEVEL_BONUS * level)
        
        call GroupEnumUnitsInRange( g, GetUnitX( caster ), GetUnitY( caster ), AREA, null )
        loop
            set u = FirstOfGroup(g)
            exitwhen u == null
            if unitst( u, caster, TARGET_ENEMY ) then
                call DealDamage(caster, u, duration, damage, tickDamage, magicBonus)
            endif
            call GroupRemoveUnit(g,u)
        endloop
        
        call GroupClear( g )
        call DestroyGroup( g )
        set u = null
        set g = null
        set caster = null
    endfunction

    function Trig_SunKingW_Actions takes nothing returns nothing
        local unit caster
        local integer lvl
        local real t
        
        if CastLogic() then
            set caster = udg_Caster
            set lvl = udg_Level
            set t = udg_Time
        elseif RandomLogic() then
            set caster = udg_Caster
            set lvl = udg_Level
            call textst( udg_string[0] + GetObjectName(ID_ABILITY), caster, 64, 90, 10, 1.5 )
            set t = DURATION
        else
            set caster = GetSpellAbilityUnit()
            set lvl = GetUnitAbilityLevel(GetSpellAbilityUnit(), GetSpellAbilityId())
            set t = DURATION
        endif
        
        set t = timebonus(caster, t)
        call AreaDamage(caster, lvl, t )

        set caster = null
    endfunction
    
    //Delete buff
    private function DeleteBuff_Conditions takes nothing returns boolean
        return GetUnitAbilityLevel( Event_DeleteBuff_Unit, EFFECT) > 0
    endfunction
    
    private function DeleteBuff takes nothing returns nothing
        call RemoveEffect( Event_DeleteBuff_Unit, EFFECT, BUFF )
    endfunction
    
    //Add magic damage
    private function OnDamageChange_Conditions takes nothing returns boolean
        return GetUnitAbilityLevel( udg_DamageEventTarget, EFFECT) > 0 and udg_IsDamageSpell
    endfunction
    
    private function OnDamageChange takes nothing returns nothing
        local real magicBonus = LoadReal(udg_hash, GetHandleId(udg_DamageEventTarget), StringHash("snkwm") )
        
        set udg_DamageEventAmount = udg_DamageEventAmount + (Event_OnDamageChange_StaticDamage*magicBonus)
    endfunction
    
    //===========================================================================
    private function init takes nothing returns nothing
        set gg_trg_SunKingW = CreateTrigger(  )
        call TriggerRegisterAnyUnitEventBJ( gg_trg_SunKingW, EVENT_PLAYER_UNIT_SPELL_EFFECT )
        call TriggerAddCondition( gg_trg_SunKingW, Condition( function Trig_SunKingW_Conditions ) )
        call TriggerAddAction( gg_trg_SunKingW, function Trig_SunKingW_Actions )
        
        call CreateEventTrigger( "Event_DeleteBuff_Real", function DeleteBuff, function DeleteBuff_Conditions )
        call CreateEventTrigger( "Event_OnDamageChange_Real", function OnDamageChange, function OnDamageChange_Conditions )
        call StackAbilities_AddAbilityStack( ID_ABILITY, 1, 2, 3 )
    endfunction

endscope