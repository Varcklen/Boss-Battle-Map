scope BardQ initializer init

    globals
        private constant integer ID_ABILITY = 'A1AL'
        
        private constant integer EFFECT = 'A1AM'
        private constant integer BUFF = 'B06T'
        private constant integer DURATION = 20
    
        private constant integer ID_MAGIC_RESISTANCE = 'A1C6'
        private constant real MAGIC_RESISTANCE_BONUS = 0.15
        
        private constant integer ID_DODGE = 'A1CA'
        private constant integer DODGE_BONUS = 20
        
        private constant integer BONUSES_CHANCE = 35
        private constant integer BONUSES_COUNT = 12
        private constant integer BONUSES_COUNT_ARRAY = BONUSES_COUNT+1
        private integer array Bonuses[BONUSES_COUNT_ARRAY]
        
        private constant integer BONUSES_LIMIT = 6
        private constant integer BONUSES_LIMIT_ALTERNATIVE = 12
        
        private constant integer BONUSES_STRING_COUNT = 1
        private constant integer BONUSES_STRING_COUNT_ARRAY = BONUSES_STRING_COUNT+1
        private string array Bonuses_String[BONUSES_STRING_COUNT_ARRAY]
    endglobals
    
    private function SetBonuses takes nothing returns nothing
        set Bonuses[1] = 'A1AN'
        set Bonuses[2] = 'A1AO'
        set Bonuses[3] = 'A1AP'
        set Bonuses[4] = 'A1AQ'
        set Bonuses[5] = 'A1AR'
        set Bonuses[6] = 'A1AS'
        set Bonuses[7] = 'A1C2'
        set Bonuses[8] = 'A1C3'
        set Bonuses[9] = 'A1C4'
        set Bonuses[10] = 'A1C5'
        set Bonuses[11] = 'A1C6'
        set Bonuses[12] = 'A1CA'
        
        set Bonuses_String[0] = " bonus!"
        set Bonuses_String[1] = " bonuses!"
    endfunction

    function Trig_BardQ_Conditions takes nothing returns boolean
        return GetSpellAbilityId( ) == ID_ABILITY
    endfunction

    function BardQEnd takes nothing returns nothing
        local integer id = GetHandleId( GetExpiredTimer( ) )
        local unit caster = LoadUnitHandle( udg_hash, id, StringHash( "brdq" ) )
        local integer cyclA
        
        set cyclA = 1
        loop
            exitwhen cyclA > BONUSES_COUNT
            call UnitRemoveAbility( caster, Bonuses[cyclA] )
            set cyclA = cyclA + 1
        endloop
        call UnitRemoveAbility( caster, EFFECT )
        call UnitRemoveAbility( caster, BUFF )
        call FlushChildHashtable( udg_hash, id )
        
        set caster = null
    endfunction
    
    private function Alternative takes unit caster, unit target, real duration, integer level returns nothing 
        local integer i
        local integer bonuses = 0
        local integer newChance = R2I(BONUSES_CHANCE*(BONUSES_LIMIT/BONUSES_LIMIT_ALTERNATIVE))
        local unit oldTarget = LoadUnitHandle( udg_hash, GetHandleId(caster), StringHash( "brdq" ) )
    
        if oldTarget != null then
            set i = 1
            loop
                exitwhen i > BONUSES_COUNT
                call UnitRemoveAbility( oldTarget, Bonuses[i] )
                set i = i + 1
            endloop
            call UnitRemoveAbility( oldTarget, EFFECT )
            call UnitRemoveAbility( oldTarget, BUFF )
            call RemoveSavedHandle( udg_hash, GetHandleId( caster ), StringHash( "brdq" ) )
        endif
    
        set i = 1
        loop
            exitwhen i > BONUSES_COUNT or bonuses >= BONUSES_LIMIT_ALTERNATIVE
            if LuckChance(caster, newChance) or bonuses < level then
                call UnitAddAbility( target, Bonuses[i] )
                set bonuses = bonuses + 1
            endif
            set i = i + 1
        endloop
        
        if bonuses > 0 then
            call textst( "|cFFFE8A0E +" + I2S(bonuses) + Bonuses_String[IMinBJ(bonuses-1, BONUSES_STRING_COUNT)], caster, 64, 90, 10, 1 )
            
            call UnitAddAbility( target, EFFECT )
            call InvokeTimerWithUnit(target, "brdq",  duration, false, function BardQEnd)
            call SaveUnitHandle( udg_hash, GetHandleId(caster), StringHash( "brdq" ), target )
            
            call effst( caster, target, null, 1, duration )
        endif
        
        set oldTarget = null
        set caster = null
        set target = null
    endfunction
    
    private function Main takes unit caster, unit target, real duration, integer level returns nothing 
        local integer i
        local integer bonuses = 0
    
        set i = 1
        loop
            exitwhen i > BONUSES_COUNT or bonuses >= BONUSES_LIMIT
            if LuckChance(caster, BONUSES_CHANCE) or bonuses < level then
                call UnitAddAbility( target, Bonuses[i] )
                set bonuses = bonuses + 1
            endif
            set i = i + 1
        endloop
        
        if bonuses > 0 then
            call textst( "|cFFFE8A0E +" + I2S(bonuses) + Bonuses_String[IMinBJ(bonuses-1, BONUSES_STRING_COUNT)], caster, 64, 90, 10, 1 )
            
            call UnitAddAbility( target, EFFECT )
            call InvokeTimerWithUnit(target, "brdq",  duration, false, function BardQEnd)
            
            call effst( caster, target, null, 1, duration )
        endif
        
        set caster = null
        set target = null
    endfunction

    function Trig_BardQ_Actions takes nothing returns nothing
        local unit caster
        local unit target
        local integer lvl
        local real t
        
        if CastLogic() then
            set caster = udg_Caster
            set target = udg_Target
            set lvl = udg_Level
            set t = udg_Time
        elseif RandomLogic() then
            set caster = udg_Caster
            set target = randomtarget( caster, 900, "ally", "", "", "", "" )
            set lvl = udg_Level
            call textst( udg_string[0] + GetObjectName(ID_ABILITY), caster, 64, 90, 10, 1.5 )
            set t = DURATION
            if target == null then
                set caster = null
                return
            endif
        else
            set caster = GetSpellAbilityUnit()
            set target = GetSpellTargetUnit()
            set lvl = GetUnitAbilityLevel(GetSpellAbilityUnit(), GetSpellAbilityId())
            set t = DURATION
        endif
        set t = timebonus(caster, t)
        
        if Aspects_IsHeroAspectActive( caster, ASPECT_01 ) then
            call Alternative( caster, target, t, lvl )
        else
            call Main( caster, target, t, lvl )
        endif
        
        set caster = null
        set target = null
    endfunction
    
    private function DeleteBuff_Conditions takes nothing returns boolean
        return GetUnitAbilityLevel( Event_DeleteBuff_Unit, EFFECT) > 0
    endfunction
    
    private function DeleteBuff takes nothing returns nothing
        local unit hero = Event_DeleteBuff_Unit
        local integer i

        set i = 1
        loop
            exitwhen i > BONUSES_COUNT
            call UnitRemoveAbility( hero, Bonuses[i] )
            set i = i + 1
        endloop
        call UnitRemoveAbility( hero, EFFECT )
        call UnitRemoveAbility( hero, BUFF )
        
        set hero = null
    endfunction
    
    //Magic Resistance
    private function OnDamageChange_Conditions takes nothing returns boolean
        return GetUnitAbilityLevel( udg_DamageEventTarget, ID_MAGIC_RESISTANCE) > 0 and udg_IsDamageSpell
    endfunction
    
    private function OnDamageChange takes nothing returns nothing
        local unit hero = udg_DamageEventTarget
        
        set udg_DamageEventAmount = udg_DamageEventAmount - (Event_OnDamageChange_StaticDamage*MAGIC_RESISTANCE_BONUS)
        
        set hero = null
    endfunction
    
    //Dodge
    private function OnDamageChange_Dodge_Conditions takes nothing returns boolean
        return GetUnitAbilityLevel( udg_DamageEventTarget, ID_DODGE) > 0 and udg_IsDamageSpell == false
    endfunction
    
    private function OnDamageChange_Dodge takes nothing returns nothing
        if LuckChance( udg_DamageEventTarget, DODGE_BONUS ) then
            set udg_DamageEventAmount = 0
            set udg_DamageEventType = udg_DamageTypeBlocked
        endif
    endfunction

    //===========================================================================
    private function init takes nothing returns nothing
        call SetBonuses()
    
        set gg_trg_BardQ = CreateTrigger( )
        call TriggerRegisterAnyUnitEventBJ( gg_trg_BardQ, EVENT_PLAYER_UNIT_SPELL_EFFECT )
        call TriggerAddCondition( gg_trg_BardQ, Condition( function Trig_BardQ_Conditions ) )
        call TriggerAddAction( gg_trg_BardQ, function Trig_BardQ_Actions )
        
        call CreateEventTrigger( "Event_DeleteBuff_Real", function DeleteBuff, function DeleteBuff_Conditions )
        call CreateEventTrigger( "Event_OnDamageChange_Real", function OnDamageChange, function OnDamageChange_Conditions )
        call CreateEventTrigger( "Event_OnDamageChange_Real", function OnDamageChange_Dodge, function OnDamageChange_Dodge_Conditions )
    endfunction
    
endscope

