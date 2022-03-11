scope ArmsmasterW initializer init

    globals
        private constant integer ID_ABILITY = 'A07R'
        
        private constant integer EFFECT = 'A097'
        private constant integer BUFF = 'B08Y'
        
        private constant integer TAUNT_TRIGGERING = 1
        private constant real DURATION = 4
        private constant real REDUCTION_FIRST_LEVEL = 0.05
        private constant real REDUCTION_LEVEL_BONUS = 0.03
        
        private constant integer ALTERNATIVE_AREA = 500
        
        private constant string ANIMATION = "Abilities\\Spells\\NightElf\\Taunt\\TauntCaster.mdl"
    endglobals

    function Trig_ArmsW_Conditions takes nothing returns boolean
        return GetSpellAbilityId() == ID_ABILITY
    endfunction

    function ArmsWCast takes nothing returns nothing
        local integer id = GetHandleId( GetExpiredTimer( ) )
        local unit target = LoadUnitHandle( udg_hash, id, StringHash( "armw" ) )
        local unit caster = LoadUnitHandle( udg_hash, id, StringHash( "armwc" ) )
        
        if IsUnitAlive(caster) and IsUnitAlive(target) and GetUnitAbilityLevel( target, EFFECT) > 0 then
            call IssueTargetOrder( target, "attack", caster )
        else
            call IssueImmediateOrder( target, "stop" )
            call UnitRemoveAbility( target, EFFECT )
            call UnitRemoveAbility( target, BUFF )
            call UnitRemoveAbility( caster, EFFECT )
            call UnitRemoveAbility( caster, BUFF )
            call FlushChildHashtable( udg_hash, id )
            call DestroyTimer( GetExpiredTimer() )
        endif
        
        set target = null
        set caster = null
    endfunction
    
    private function Main takes unit caster, unit target, real reduction, real duration returns nothing
        local integer id
        local integer casterId = GetHandleId( caster )
        local integer targetId = GetHandleId( target )
    
        call UnitAddAbility( target, EFFECT )
        call UnitAddAbility( caster, EFFECT )
        call bufallst(caster, target, EFFECT, 0, 0, 0, 0, BUFF, "armwe", duration)
        
        call SaveUnitHandle( udg_hash, targetId, StringHash( "armwt" ), caster )
        call SaveReal( udg_hash, targetId, StringHash( "armwr" ), reduction )
        call SaveReal( udg_hash, casterId, StringHash( "armwr" ), reduction )
        
        call IssueTargetOrder( target, "attack", caster )
        
        set id = InvokeTimerWithUnit( target, "armw", TAUNT_TRIGGERING, true, function ArmsWCast )
        call SaveUnitHandle( udg_hash, id, StringHash( "armw" ), target )
        call SaveUnitHandle( udg_hash, id, StringHash( "armwc" ), caster )
        
        call debuffst( caster, target, null, 1, duration )
        
        set target = null
        set caster = null
    endfunction
    
    private function Alternative takes unit caster, real reduction, real duration returns nothing 
        local group g = CreateGroup()
        local unit u
    
        call GroupEnumUnitsInRange( g, GetUnitX( caster ), GetUnitY( caster ), ALTERNATIVE_AREA, null )
        loop
            set u = FirstOfGroup(g)
            exitwhen u == null
            if unitst( u, caster, TARGET_ENEMY ) then 
                call Main( caster, u, reduction, duration )
            endif
            call GroupRemoveUnit(g,u)
        endloop
        
        call GroupClear( g )
        call DestroyGroup( g )
        set u = null
        set g = null
        set caster = null
    endfunction
    
    function Trig_ArmsW_Actions takes nothing returns nothing 
        local unit caster
        local unit target
        local integer lvl
        local real reduction
        local real t
        
        if CastLogic() then
            set caster = udg_Caster
            set target = udg_Target
            set lvl = udg_Level
            set t = udg_Time
        elseif RandomLogic() then
            set caster = udg_Caster
            set target = randomtarget( caster, 600, "enemy", "", "", "", "" )
            set lvl = udg_Level
            set t = DURATION
            call textst( udg_string[0] + GetObjectName(ID_ABILITY), caster, 64, 90, 10, 1.5 )
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
        
        set reduction = REDUCTION_FIRST_LEVEL+(REDUCTION_LEVEL_BONUS*lvl)
        
        if Aspects_IsHeroAspectActive( caster, ASPECT_02 ) then
            call Alternative( caster, reduction, t )
        else
            call Main( caster, target, reduction, t )
        endif
        call DestroyEffect( AddSpecialEffectTarget( ANIMATION, caster, "origin" ) )
        
         set caster = null
         set target = null
    endfunction
    
    private function OnDamageChange_Condition takes nothing returns boolean
        return udg_IsDamageSpell == false and GetUnitAbilityLevel(udg_DamageEventSource, 'B08Y') > 0
    endfunction
    
    private function Damage_Alternative takes unit dealer, unit target returns nothing
        local real damageReduction = LoadReal( udg_hash, GetHandleId( dealer ), StringHash( "armwr" ))
        local integer targetId = GetHandleId( target )
        
        set udg_DamageEventAmount = udg_DamageEventAmount - (Event_OnDamageChange_StaticDamage*damageReduction)
        if LoadUnitHandle( udg_hash, targetId, StringHash( "armwt" ) ) == dealer then
            set udg_DamageEventAmount = udg_DamageEventAmount - (Event_OnDamageChange_StaticDamage*damageReduction)
            call bufallst(dealer, target, EFFECT, 0, 0, 0, 0, BUFF, "armwe", DURATION)
            call debuffst( dealer, target, null, 1, DURATION )
        endif
        
        set dealer = null
        set target = null
    endfunction
    
    private function Damage_Main takes unit dealer, unit target returns nothing
        local real damageReduction = LoadReal( udg_hash, GetHandleId( dealer ), StringHash( "armwr" ))
        local integer targetId = GetHandleId( target )
        
        set udg_DamageEventAmount = udg_DamageEventAmount - (Event_OnDamageChange_StaticDamage*damageReduction)
        if LoadUnitHandle( udg_hash, targetId, StringHash( "armwt" ) ) == dealer then
            call bufallst(dealer, target, EFFECT, 0, 0, 0, 0, BUFF, "armwe", DURATION)
            call debuffst( dealer, target, null, 1, DURATION )
        endif
        
        set dealer = null
        set target = null
    endfunction
    
    private function OnDamageChange takes nothing returns nothing
        if Aspects_IsHeroAspectActive(udg_DamageEventSource, ASPECT_02) then
            call Damage_Alternative(udg_DamageEventSource, udg_DamageEventTarget)
        else
            call Damage_Main( udg_DamageEventSource, udg_DamageEventTarget )
        endif
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
        set gg_trg_ArmsW = CreateTrigger(  )
        call TriggerRegisterAnyUnitEventBJ( gg_trg_ArmsW, EVENT_PLAYER_UNIT_SPELL_EFFECT )
        call TriggerAddCondition( gg_trg_ArmsW, Condition( function Trig_ArmsW_Conditions ) )
        call TriggerAddAction( gg_trg_ArmsW, function Trig_ArmsW_Actions )
        
        call CreateEventTrigger( "Event_OnDamageChange_Real", function OnDamageChange, function OnDamageChange_Condition )
        
        call CreateEventTrigger( "Event_DeleteBuff_Real", function DeleteBuff, function DeleteBuff_Conditions )
    endfunction

endscope