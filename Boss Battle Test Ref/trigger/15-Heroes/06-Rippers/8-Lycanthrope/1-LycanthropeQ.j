scope LycanthropeQ initializer init

    globals
        private constant integer ID_ABILITY = 'A1CJ'
        
        private constant integer STACK_LIMIT_FIRST_LEVEL = 1
        private constant integer STACK_LIMIT_LEVEL_BONUS = 1
        public constant integer DURATION = 15
        private constant integer AREA = 400
        
        private constant real DAMAGE_BONUS = 0.05
        
        private constant integer EFFECT = 'A1CL'
        private constant integer BUFF = 'B0A4'
        
        private constant integer ALT_DAMAGE_FIRST_LEVEL = 60
        private constant integer ALT_DAMAGE_LEVEL_BONUS = 20
        private constant real ALT_DAMAGE_BONUS = 0.1
        
        private constant integer ALT_EFFECT = 'A1CM'
        private constant integer ALT_BUFF = 'B0A5'
        
        private constant real ALTERNATIVE_DAMAGE_BONUS = 0.03
    
        private constant string ANIMATION = "Abilities\\Spells\\Items\\AIem\\AIemTarget.mdl"
    endglobals

    function Trig_LycanthropeQ_Conditions takes nothing returns boolean
        return GetSpellAbilityId() == ID_ABILITY
    endfunction
    
    private function HumanForm_End takes nothing returns nothing
        local integer id = GetHandleId( GetExpiredTimer() )
        local unit target = LoadUnitHandle(udg_hash, id, StringHash("lcnq") )

        call UnitRemoveAbility(target, EFFECT)
        call UnitRemoveAbility(target, BUFF)
        call RemoveSavedInteger( udg_hash, GetHandleId( target ), StringHash( "lcnq" ) )
        call FlushChildHashtable( udg_hash, id )
        
        set target = null
    endfunction
    
    private function WolfForm_End takes nothing returns nothing
        local integer id = GetHandleId( GetExpiredTimer() )
        local unit target = LoadUnitHandle(udg_hash, id, StringHash("lcnqa") )

        call UnitRemoveAbility(target, ALT_EFFECT)
        call UnitRemoveAbility(target, ALT_BUFF)
        call RemoveSavedInteger( udg_hash, GetHandleId( target ), StringHash( "lcnqa" ) )
        call FlushChildHashtable( udg_hash, id )
        
        set target = null
    endfunction
    
    private function WolfForm takes unit caster, integer level, integer stackLimit, real duration returns nothing
        local group g = CreateGroup()
        local unit u
        local real damageBonus
        local integer currentStack
        local real damage = ALT_DAMAGE_FIRST_LEVEL + (level*ALT_DAMAGE_LEVEL_BONUS)
        local integer id
    
        call GroupEnumUnitsInRange( g, GetUnitX( caster ), GetUnitY( caster ), AREA, null )
        loop
            set u = FirstOfGroup(g)
            exitwhen u == null
            if unitst( u, caster, "enemy" ) then
                call PlaySpecialEffect(ANIMATION, u)
                call UnitTakeDamage(caster, u, damage, DAMAGE_TYPE_MAGIC)
                if IsUnitAlive(u) then
                    set id = GetHandleId(u)
                    call UnitAddAbility(u, ALT_EFFECT)
                    call InvokeTimerWithUnit(u, "lcnqa", duration, false, function WolfForm_End )
                    set currentStack = IMinBJ( stackLimit, LoadInteger(udg_hash, id, StringHash("lcnqa") ) + 1 )
                    set damageBonus = ALT_DAMAGE_BONUS * currentStack
                    call textst( "|cFFDA5061" + I2S(currentStack), u, 64, GetRandomReal( 80, 100 ), 12, 1 )
                    
                    call SaveInteger(udg_hash, id, StringHash("lcnqa"), currentStack )
                    call SaveReal(udg_hash, id, StringHash("lcnqa"), damageBonus )
                    
                    call debuffst( caster, u, null, 1, duration )
                endif
            endif
            call GroupRemoveUnit(g,u)
        endloop
    
        call GroupClear( g )
        call DestroyGroup( g )
        set u = null
        set g = null
        set caster = null
    endfunction
    
    private function LycanthropeQ_Alternative takes unit caster, integer level, integer stackLimit, real duration returns nothing
        local group g = CreateGroup()
        local unit u
        local real damageBonus
        local integer currentStack
        local integer id
        local real bonus = DAMAGE_BONUS + ALTERNATIVE_DAMAGE_BONUS
    
        call GroupEnumUnitsInRange( g, GetUnitX( caster ), GetUnitY( caster ), AREA, null )
        loop
            set u = FirstOfGroup(g)
            exitwhen u == null
            if unitst( u, caster, "ally" ) and u != caster then
                call PlaySpecialEffect(ANIMATION, u)
                set id = GetHandleId(u)
                call UnitAddAbility(u, EFFECT)
                call InvokeTimerWithUnit(u, "lcnq", duration, false, function HumanForm_End )
                set currentStack = IMinBJ( stackLimit, LoadInteger(udg_hash, id, StringHash("lcnq") ) + 1 )
                set damageBonus = bonus * currentStack
                call textst( "|cFF57E5C6" + I2S(currentStack), u, 64, GetRandomReal( 80, 100 ), 12, 1 )
                
                call SaveInteger(udg_hash, id, StringHash("lcnq"), currentStack )
                call SaveReal(udg_hash, id, StringHash("lcnq"), damageBonus )
                
                call effst( caster, u, null, 1, duration )
            endif
            call GroupRemoveUnit(g,u)
        endloop
    
        call GroupClear( g )
        call DestroyGroup( g )
        set u = null
        set g = null
        set caster = null
    endfunction
    
    private function LycanthropeQ_Main takes unit caster, integer level, integer stackLimit, real duration returns nothing
        local group g = CreateGroup()
        local unit u
        local real damageBonus
        local integer currentStack
        local integer id
    
        call GroupEnumUnitsInRange( g, GetUnitX( caster ), GetUnitY( caster ), AREA, null )
        loop
            set u = FirstOfGroup(g)
            exitwhen u == null
            if unitst( u, caster, "ally" ) then
                call PlaySpecialEffect(ANIMATION, u)
                set id = GetHandleId(u)
                call UnitAddAbility(u, EFFECT)
                call InvokeTimerWithUnit(u, "lcnq", duration, false, function HumanForm_End )
                set currentStack = IMinBJ( stackLimit, LoadInteger(udg_hash, id, StringHash("lcnq") ) + 1 )
                set damageBonus = DAMAGE_BONUS * currentStack
                call textst( "|cFF57E5C6" + I2S(currentStack), u, 64, GetRandomReal( 80, 100 ), 12, 1 )
                
                call SaveInteger(udg_hash, id, StringHash("lcnq"), currentStack )
                call SaveReal(udg_hash, id, StringHash("lcnq"), damageBonus )
                
                call effst( caster, u, null, 1, duration )
            endif
            call GroupRemoveUnit(g,u)
        endloop
    
        call GroupClear( g )
        call DestroyGroup( g )
        set u = null
        set g = null
        set caster = null
    endfunction
    
    private function HumanForm takes unit caster, integer level, integer stackLimit, real duration returns nothing
        if Aspects_IsHeroAspectActive(caster, ASPECT_01) then
            call LycanthropeQ_Alternative( caster, level, stackLimit, duration )
        else
            call LycanthropeQ_Main( caster, level, stackLimit, duration )
        endif
    
        set caster = null
    endfunction

    function Trig_LycanthropeQ_Actions takes nothing returns nothing
        local integer lvl
        local unit caster
        local integer stackLimit
        local real duration
        
        if CastLogic() then
            set caster = udg_Caster
            set lvl = udg_Level
            set duration = udg_Time
        elseif RandomLogic() then
            set caster = udg_Caster
            set lvl = udg_Level
            call textst( udg_string[0] + GetObjectName(ID_ABILITY), caster, 64, 90, 10, 1.5 )
            set duration = DURATION
        else
            set caster = GetSpellAbilityUnit()
            set lvl = GetUnitAbilityLevel(GetSpellAbilityUnit(), GetSpellAbilityId())
            set duration = DURATION
        endif
        
        set duration = timebonus(caster, duration)
        set stackLimit = STACK_LIMIT_FIRST_LEVEL + (lvl*STACK_LIMIT_LEVEL_BONUS)
        
        if IsUnitHasAbility(caster, LycanthropeW_WOLF_BUFF) or LycanthropeE_WolfMode then
            call WolfForm(caster, lvl, stackLimit, duration)
        else
            call HumanForm(caster, lvl, stackLimit, duration)
        endif
        
        set caster = null
    endfunction
    
    private function OnDamageChange_Conditions_Alt takes nothing returns boolean
        return GetUnitAbilityLevel( udg_DamageEventTarget, ALT_BUFF) > 0
    endfunction
    
    private function OnDamageChange_Alt takes nothing returns nothing
        local real bonusDamage = LoadReal(udg_hash, GetHandleId(udg_DamageEventTarget), StringHash("lcnqa") )
        
        set udg_DamageEventAmount = udg_DamageEventAmount + (Event_OnDamageChange_StaticDamage * bonusDamage )
    endfunction
    
    private function OnDamageChange_Conditions_01 takes nothing returns boolean
        return GetUnitAbilityLevel( udg_DamageEventTarget, BUFF) > 0
    endfunction
    
    private function OnDamageChange_01 takes nothing returns nothing
        local real bonusDamage = LoadReal(udg_hash, GetHandleId(udg_DamageEventTarget), StringHash("lcnq") )
        
        set udg_DamageEventAmount = udg_DamageEventAmount - (Event_OnDamageChange_StaticDamage * bonusDamage )
    endfunction
    
    private function OnDamageChange_Conditions_02 takes nothing returns boolean
        return GetUnitAbilityLevel( udg_DamageEventSource, BUFF) > 0
    endfunction
    
    private function OnDamageChange_02 takes nothing returns nothing
        local real bonusDamage = LoadReal(udg_hash, GetHandleId(udg_DamageEventSource), StringHash("lcnq") )
        
        set udg_DamageEventAmount = udg_DamageEventAmount + (Event_OnDamageChange_StaticDamage * bonusDamage )
    endfunction
    
    private function DeleteBuff_Conditions takes nothing returns boolean
        return GetUnitAbilityLevel( Event_DeleteBuff_Unit, EFFECT) > 0
    endfunction
    
    private function DeleteBuff takes nothing returns nothing
        local unit hero = Event_DeleteBuff_Unit

        call UnitRemoveAbility( hero, EFFECT )
        call UnitRemoveAbility( hero, BUFF )
        
        set hero = null
    endfunction

    //===========================================================================
    private function init takes nothing returns nothing
        set gg_trg_LycanthropeQ = CreateTrigger(  )
        call TriggerRegisterAnyUnitEventBJ( gg_trg_LycanthropeQ, EVENT_PLAYER_UNIT_SPELL_EFFECT )
        call TriggerAddCondition( gg_trg_LycanthropeQ, Condition( function Trig_LycanthropeQ_Conditions ) )
        call TriggerAddAction( gg_trg_LycanthropeQ, function Trig_LycanthropeQ_Actions )
        
        call CreateEventTrigger( "Event_OnDamageChange_Real", function OnDamageChange_Alt, function OnDamageChange_Conditions_Alt )
        call CreateEventTrigger( "Event_OnDamageChange_Real", function OnDamageChange_01, function OnDamageChange_Conditions_01 )
        call CreateEventTrigger( "Event_OnDamageChange_Real", function OnDamageChange_02, function OnDamageChange_Conditions_02 )
        call CreateEventTrigger( "Event_DeleteBuff_Real", function DeleteBuff, function DeleteBuff_Conditions )
        
    endfunction

endscope

