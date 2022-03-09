scope ThePlagueW initializer init

    globals
        private constant integer ID_ABILITY = 'A1CU'
        
        private constant integer DURATION = 15
        private constant integer DISTANCE = 200
        private constant integer AREA = 300
        private constant integer CHARGE_LIMIT = 10
        private constant integer DAMAGE_NEEDED = 500
        
        public constant integer EFFECT = 'A1CV'
        private constant integer BUFF = 'B0A9'
        
        private constant integer DAMAGE_FIRST_LEVEL = 75
        private constant integer DAMAGE_LEVEL_BONUS = 25

        private constant string ANIMATION = "Abilities\\Spells\\Orc\\FeralSpirit\\feralspiritdone.mdl"
        private constant string DAMAGE_ANIMATION = "Acid Ex.mdx"
    endglobals

    function Trig_The_PlagueW_Conditions takes nothing returns boolean
        return GetSpellAbilityId() == ID_ABILITY
    endfunction

    private function Spike_End takes nothing returns nothing
        local integer id = GetHandleId( GetExpiredTimer() )
        local unit target = LoadUnitHandle(udg_hash, id, StringHash("tplw"))
        local integer unitId = GetHandleId(target)

        call UnitRemoveAbility( target, EFFECT )
        call UnitRemoveAbility( target, BUFF )
        call RemoveSavedReal( udg_hash, unitId, StringHash( "tplw" ) )
        call RemoveSavedInteger( udg_hash, unitId, StringHash( "tplw" ) )
        call FlushChildHashtable( udg_hash, id )

        set target = null
    endfunction
    
    private function Spike takes unit caster, real damage, real x, real y, real duration returns nothing
        local group g = CreateGroup()
        local unit u
        local integer id 
        local integer charges
    
        call GroupEnumUnitsInRange( g, x, y, AREA, null )
        loop
            set u = FirstOfGroup(g)
            exitwhen u == null
            if unitst( u, caster, "enemy" ) then 
                set id = GetHandleId(u)
                call PlaySpecialEffect(ANIMATION, u)
                call UnitAddAbility( u, EFFECT )
                call InvokeTimerWithUnit(u, "tplw", duration, false, function Spike_End)
                set charges = IMinBJ(LoadInteger(udg_hash, id, StringHash("tplw") ) + 1, CHARGE_LIMIT)
                call SaveInteger(udg_hash, id, StringHash("tplw"), charges )
                call SaveReal(udg_hash, id, StringHash("tplwd"), damage )
                call SaveUnitHandle(udg_hash, id, StringHash("tplwc"), caster )
                call textst( "|cFF57E5C6" + I2S(charges), u, 64, 90, 12, 1 )
                call RemoveSavedReal( udg_hash, id, StringHash( "tplw" ) )
            endif
            call GroupRemoveUnit(g,u)
        endloop
        
        call GroupClear( g )
        call DestroyGroup( g )
        set u = null
        set g = null
        set caster = null
    endfunction

    function Trig_The_PlagueW_Actions takes nothing returns nothing
        local real x 
        local real y
        local real dmg
        local integer lvl
        local unit caster
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
            set lvl = GetUnitAbilityLevel(GetSpellAbilityUnit(), GetSpellAbilityId() )
            set duration = DURATION
        endif
        
        set duration = timebonus(caster, duration)
        set dmg = DAMAGE_FIRST_LEVEL + ( DAMAGE_LEVEL_BONUS * lvl ) 
        set x = GetUnitX( caster ) + DISTANCE * Cos( 0.017 * GetUnitFacing( caster ) )
        set y = GetUnitY( caster ) + DISTANCE * Sin( 0.017 * GetUnitFacing( caster ) )
        
        call Spike(caster, dmg, x, y, duration )   
        
        set caster = null
    endfunction
    
    private function AfterDamageEvent_Conditions takes nothing returns boolean
        return IsUnitHasAbility(udg_DamageEventTarget, EFFECT) and udg_DamageEventAmount > 0
    endfunction
    
    private function Damage takes nothing returns nothing
        local integer id = GetHandleId( GetExpiredTimer() )
        local unit target = LoadUnitHandle(udg_hash, id, StringHash("tplw1"))
        local unit dealer = LoadUnitHandle(udg_hash, id, StringHash("tplw1c"))
        local real damage = LoadReal(udg_hash, id, StringHash("tplw1d") )

        call UnitTakeDamage(dealer, target, damage, DAMAGE_TYPE_MAGIC)
        call FlushChildHashtable( udg_hash, id )

        set dealer = null
        set target = null
    endfunction
    
    private function DealDamage takes unit target, integer unitId returns nothing
        local real damage = LoadReal(udg_hash, unitId, StringHash("tplwd") )
        local integer charges = LoadInteger(udg_hash, unitId, StringHash("tplw") )
        local unit caster = LoadUnitHandle(udg_hash, unitId, StringHash("tplwc") )
        local integer id
        
        set id = InvokeTimerWithUnit(target, "tplw1", 0.01, false, function Damage )
        call SaveUnitHandle(udg_hash, id, StringHash("tplw1c"), caster )
        call SaveReal(udg_hash, id, StringHash("tplw1d"), damage*charges )
        
        set caster = null
        set target = null
    endfunction
    
    private function AfterDamageEvent takes nothing returns nothing
        local unit target = udg_DamageEventTarget
        local integer unitId = GetHandleId(target)
        local real damageDealed = LoadReal(udg_hash, unitId, StringHash( "tplw" ) ) + udg_DamageEventAmount
        local integer id

        if damageDealed >= DAMAGE_NEEDED then
            call DestroyEffect( AddSpecialEffect(DAMAGE_ANIMATION, GetUnitX(target), GetUnitY(target)))
            call UnitRemoveAbility( target, EFFECT )
            call UnitRemoveAbility( target, BUFF )
            call DealDamage(target, unitId)
            call RemoveSavedReal( udg_hash, unitId, StringHash( "tplw" ) )
            call RemoveSavedInteger( udg_hash, unitId, StringHash( "tplw" ) )
        else
            call SaveReal(udg_hash, unitId, StringHash( "tplw" ), damageDealed )
        endif
        
        set target = null
    endfunction
    
    private function DeleteBuff_Conditions takes nothing returns boolean
        return GetUnitAbilityLevel( Event_DeleteBuff_Unit, EFFECT) > 0
    endfunction
    
    private function DeleteBuff takes nothing returns nothing
        local unit hero = Event_DeleteBuff_Unit

        call UnitRemoveAbility( hero, EFFECT )
        call UnitRemoveAbility( hero, BUFF )
        call RemoveSavedReal( udg_hash, GetHandleId( hero ), StringHash( "tplw" ) )
        call RemoveSavedInteger( udg_hash, GetHandleId( hero ), StringHash( "tplw" ) )
        
        set hero = null
    endfunction

    //===========================================================================
    private function init takes nothing returns nothing
        set gg_trg_The_PlagueW = CreateTrigger(  )
        call TriggerRegisterAnyUnitEventBJ( gg_trg_The_PlagueW, EVENT_PLAYER_UNIT_SPELL_EFFECT )
        call TriggerAddCondition( gg_trg_The_PlagueW, Condition( function Trig_The_PlagueW_Conditions ) )
        call TriggerAddAction( gg_trg_The_PlagueW, function Trig_The_PlagueW_Actions )
        
        call CreateEventTrigger( "Event_DeleteBuff_Real", function DeleteBuff, function DeleteBuff_Conditions )
        call CreateEventTrigger( "udg_AfterDamageEvent", function AfterDamageEvent, function AfterDamageEvent_Conditions )
    endfunction

endscope