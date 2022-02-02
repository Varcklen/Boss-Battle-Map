scope CorruptedR initializer init

    globals
        private constant integer ID_ABILITY = 'A0OJ'
    
        private constant integer ID_ARMOR_REDUCE = 'A0OJ'
        private constant integer EFFECT = 'A0P7'
        private constant integer BUFF = 'B0A0'
    
        private constant integer DURATION = 5
        private constant integer INTERVAL = 1
        private constant integer DAMAGE_FIRST_LEVEL = 30
        private constant integer DAMAGE_LEVEL_BONUS = 10
        private constant integer HEAL_AREA = 600
        
        private constant integer ALT_AREA = 400
    endglobals

    function Trig_CorruptedEntR_Conditions takes nothing returns boolean
        return GetSpellAbilityId() == ID_ABILITY
    endfunction

    function CorruptedEnrRHeal takes unit caster, real x, real y, integer id returns nothing
        local real heal = LoadReal( udg_hash, id, StringHash( "entrh" ) )
        local group g = CreateGroup()
        local unit u
        
        if heal > 0 then
            call GroupEnumUnitsInRange( g, x, y, HEAL_AREA, null )
            loop
                set u = FirstOfGroup(g)
                exitwhen u == null
                if unitst( u, caster, "ally" ) and IsUnitType( u, UNIT_TYPE_HERO) then
                    call healst(caster, u , heal)
                endif
                call GroupRemoveUnit(g,u)
            endloop
        endif
        
        call GroupClear( g )
        call DestroyGroup( g )
        set g = null
        set u = null
    endfunction

    function CorruptedEnrRCast takes nothing returns nothing
        local integer id = GetHandleId( GetExpiredTimer( ) )
        local unit caster = LoadUnitHandle( udg_hash, id, StringHash( "entrc" ) )
        local unit target = LoadUnitHandle( udg_hash, id, StringHash( "entr" ) )
        local real damage = LoadReal( udg_hash, id, StringHash( "entr" ) )
        
        if IsUnitAlive(target) and IsUnitHasAbility( target, EFFECT)  then
            call CorruptedEnrRHeal(caster, GetUnitX(target), GetUnitY(target), id )
            set IsDisableSpellPower = true
            call UnitTakeDamage( caster, target, damage, DAMAGE_TYPE_MAGIC )
        else
            call FlushChildHashtable( udg_hash, id )
            call DestroyTimer( GetExpiredTimer() )
        endif
        
        set target = null
        set caster = null
    endfunction

    private function Corrupted_EntR_Alternative takes unit caster, unit target, real damage, real duration, integer level returns nothing
        local group g = CreateGroup()
        local unit u
        local integer id
        
        call GroupEnumUnitsInRange( g, GetUnitX(target), GetUnitY(target), ALT_AREA, null )
        loop
            set u = FirstOfGroup(g)
            exitwhen u == null
            if unitst( u, caster, "enemy" ) then
                set id = InvokeTimerWithUnit(u, "entr", INTERVAL, true, function CorruptedEnrRCast)
                call SaveUnitHandle( udg_hash, id, StringHash( "entrc" ), caster )
                call SaveReal( udg_hash, id, StringHash( "entr" ), damage )
                call SaveReal( udg_hash, id, StringHash( "entrh" ), 0 )
                
                call bufallst(caster, u, EFFECT, ID_ARMOR_REDUCE, 0, 0, 0, BUFF, "entrb", duration )
                call SetUnitAbilityLevel( u, ID_ARMOR_REDUCE, level )
                
                call debuffst( caster, u, null, level, duration )
            endif
            call GroupRemoveUnit(g,u)
        endloop
        
        call GroupClear( g )
        call DestroyGroup( g )
        set g = null
        set u = null
        set caster = null
        set target = null
    endfunction

    private function Corrupted_EntR takes unit caster, unit target, real damage, real duration, integer level, real heal returns nothing
        local integer id

        set id = InvokeTimerWithUnit(target, "entr", INTERVAL, true, function CorruptedEnrRCast)
        call SaveUnitHandle( udg_hash, id, StringHash( "entrc" ), caster )
        call SaveReal( udg_hash, id, StringHash( "entr" ), damage )
        call SaveReal( udg_hash, id, StringHash( "entrh" ), heal )
        
        call bufallst(caster, target, EFFECT, ID_ARMOR_REDUCE, 0, 0, 0, BUFF, "entrb", duration )
        call SetUnitAbilityLevel( target, ID_ARMOR_REDUCE, level )
        
        call debuffst( caster, target, null, level, duration )
    
        set caster = null
        set target = null
    endfunction

    function Trig_CorruptedEntR_Actions takes nothing returns nothing
        local unit caster
        local unit target
        local integer lvl
        local real t
        local real damage
        local real heal
        
        if CastLogic() then
            set caster = udg_Caster
            set target = udg_Target
            set lvl = udg_Level
            set t = udg_Time
        elseif RandomLogic() then
            set caster = udg_Caster
            set target = randomtarget( caster, 900, "enemy", "", "", "", "" )
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

        set damage = (DAMAGE_FIRST_LEVEL + (DAMAGE_LEVEL_BONUS * lvl) ) * GetUnitSpellPower(caster)
        set heal = damage
        
        if Aspects_IsHeroAspectActive(caster, ASPECT_03 ) then
            call Corrupted_EntR_Alternative( caster, target, damage, t, lvl )
        else
            call Corrupted_EntR( caster, target, damage, t, lvl, heal )
        endif

        set caster = null
        set target = null
    endfunction

    private function BuffDelete_Condition takes nothing returns boolean
        return GetUnitAbilityLevel( Event_DeleteBuff_Unit, EFFECT) > 0
    endfunction

    private function BuffDelete takes nothing returns nothing
        call UnitRemoveAbility(Event_DeleteBuff_Unit, EFFECT)
        call UnitRemoveAbility(Event_DeleteBuff_Unit, ID_ARMOR_REDUCE)
        call UnitRemoveAbility(Event_DeleteBuff_Unit, BUFF)
    endfunction

    private function Corrupted_End_Q_Condition takes nothing returns boolean
        return IsUnitHasAbility( Event_Corrupted_End_Q_Unit, EFFECT)
    endfunction
    
    private function Corrupted_End_Q takes nothing returns nothing
        call bufallst(Event_Corrupted_End_Q_Caster, Event_Corrupted_End_Q_Unit, EFFECT, ID_ARMOR_REDUCE, 0, 0, 0, BUFF, "entrb", DURATION )
    endfunction

    //===========================================================================
    private function init takes nothing returns nothing
        set gg_trg_CorruptedEntR = CreateTrigger(  )
        call TriggerRegisterAnyUnitEventBJ( gg_trg_CorruptedEntR, EVENT_PLAYER_UNIT_SPELL_EFFECT )
        call TriggerAddCondition( gg_trg_CorruptedEntR, Condition( function Trig_CorruptedEntR_Conditions ) )
        call TriggerAddAction( gg_trg_CorruptedEntR, function Trig_CorruptedEntR_Actions )
        
        call CreateEventTrigger( "Event_Corrupted_End_Q_Real", function Corrupted_End_Q, function Corrupted_End_Q_Condition )
        call CreateEventTrigger( "Event_DeleteBuff_Real", function BuffDelete, function BuffDelete_Condition )
    endfunction

endscope