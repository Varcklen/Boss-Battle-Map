globals
    constant string DRUID_Q_END_ANIMATION = "Objects\\Spawnmodels\\NightElf\\EntBirthTarget\\EntBirthTarget.mdl"

    constant integer DRUID_Q_DURATION = 3
    constant integer DRUID_Q_HEAL_FIRST_LEVEL = 175
    constant integer DRUID_Q_HEAL_LEVEL_BONUS = 125
    
    constant integer DRUID_Q_DURATION_ALTERNATIVE = 15
    constant integer DRUID_Q_TICK_ALTERNATIVE = 3
    constant real DRUID_Q_HEAL_ALTERNATIVE = 0.1
endglobals

function Trig_DruidQ_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A0M3'
endfunction

function DruidQCast_Alternative takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer( ) )
    local unit caster = LoadUnitHandle( udg_hash, id, StringHash( "drqac" ) )
    local unit target = LoadUnitHandle( udg_hash, id, StringHash( "drqa" ) )
    local real heal = LoadReal( udg_hash, id, StringHash( "drqa" ) )
    
    if GetUnitState( target, UNIT_STATE_LIFE) > 0.405 and GetUnitAbilityLevel( target, 'A0M2') > 0 then
        call DestroyEffect( AddSpecialEffectTarget( DRUID_Q_END_ANIMATION, target, "origin" ) )
        call healst( caster, target, heal )
    else
        call UnitRemoveAbility( target, 'A0M2' )
        call UnitRemoveAbility( target, 'B004' )
        call FlushChildHashtable( udg_hash, id )
        call DestroyTimer( GetExpiredTimer() )
    endif  

    set caster = null
    set target = null
endfunction

function DruidQCast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer( ) )
    local unit caster = LoadUnitHandle( udg_hash, id, StringHash( "drqc" ) )
    local unit target = LoadUnitHandle( udg_hash, id, StringHash( "drq" ) )
    local real heal = LoadReal( udg_hash, id, StringHash( "drq" ) )
    
    if GetUnitState( target, UNIT_STATE_LIFE) > 0.405 and GetUnitAbilityLevel(target, 'A0M2') > 0 then
        call DestroyEffect( AddSpecialEffectTarget( DRUID_Q_END_ANIMATION, target, "origin" ) )
        call healst( caster, target, heal )
     endif  
    call UnitRemoveAbility( target, 'A0M2' )
    call UnitRemoveAbility( target, 'B004' )
     
    call FlushChildHashtable( udg_hash, id )
    set caster = null
    set target = null
endfunction

function DruidQ_Alternative takes unit caster, unit target, real heal, real duration returns nothing
    local integer id
    local real healPerTick = heal*DRUID_Q_HEAL_ALTERNATIVE
    
    set duration = timebonus(caster, DRUID_Q_DURATION_ALTERNATIVE)
    
    call UnitAddAbility( target, 'A0M2' )
    
    set id = InvokeTimerWithUnit(target, "drq", duration, false, function DruidQCast )
    call SaveUnitHandle( udg_hash, id, StringHash( "drqc" ), caster )
    call SaveReal( udg_hash, id, StringHash( "drq" ), heal )
    
    set id = InvokeTimerWithUnit(target, "drqa", DRUID_Q_TICK_ALTERNATIVE, true, function DruidQCast_Alternative )
    call SaveUnitHandle( udg_hash, id, StringHash( "drqac" ), caster )
    call SaveReal( udg_hash, id, StringHash( "drqa" ), healPerTick )
    
    call effst( caster, target, null, 1, duration )
    
    set caster = null
    set target = null
endfunction

function DruidQ takes unit caster, unit target, real heal, real duration returns nothing
    local integer id
    
    set duration = timebonus(caster, duration)

    call UnitAddAbility( target, 'A0M2' )
    
    set id = InvokeTimerWithUnit(target, "drq", duration, false, function DruidQCast )
    call SaveUnitHandle( udg_hash, id, StringHash( "drqc" ), caster )
    call SaveReal( udg_hash, id, StringHash( "drq" ), heal )
    call effst( caster, target, null, 1, duration )
    
    set caster = null
    set target = null
endfunction

function Trig_DruidQ_Actions takes nothing returns nothing
    local unit caster
    local unit target
    local integer lvl
    local real t
    local real heal
    
    if CastLogic() then
        set caster = udg_Caster
        set target = udg_Target
        set lvl = udg_Level
        set t = udg_Time
    elseif RandomLogic() then
        set caster = udg_Caster
        set target = randomtarget( caster, 900, "ally", "notfull", "", "", "" )
        set lvl = udg_Level
        call textst( udg_string[0] + GetObjectName('A0M3'), caster, 64, 90, 10, 1.5 )
        set t = DRUID_Q_DURATION
        if target == null then
            set caster = null
            return
        endif
    else
        set caster = GetSpellAbilityUnit()
        set target = GetSpellTargetUnit()
        set lvl = GetUnitAbilityLevel(GetSpellAbilityUnit(), GetSpellAbilityId())
        set t = DRUID_Q_DURATION
    endif
    
    set heal = DRUID_Q_HEAL_FIRST_LEVEL + ( DRUID_Q_HEAL_LEVEL_BONUS * lvl )
    
    if Aspects_IsHeroAspectActive(caster, ASPECT_01 ) then
        call DruidQ_Alternative( caster, target,  heal, t )
    else
        call DruidQ( caster, target, heal, t )
    endif
    
    set caster = null
    set target = null
endfunction

//===========================================================================
function InitTrig_DruidQ takes nothing returns nothing
    set gg_trg_DruidQ = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_DruidQ, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_DruidQ, Condition( function Trig_DruidQ_Conditions ) )
    call TriggerAddAction( gg_trg_DruidQ, function Trig_DruidQ_Actions )
endfunction

scope DruidQ initializer Triggs
    private function DeleteBuff_Conditions takes nothing returns boolean
        return GetUnitAbilityLevel( Event_DeleteBuff_Unit, 'A0F7') > 0
    endfunction
    
    private function DeleteBuff takes nothing returns nothing
        local unit hero = Event_DeleteBuff_Unit

        call UnitRemoveAbility( hero, 'A0M2' )
        call UnitRemoveAbility( hero, 'B004' )
        
        set hero = null
    endfunction

    private function Triggs takes nothing returns nothing
        call CreateEventTrigger( "Event_DeleteBuff_Real", function DeleteBuff, function DeleteBuff_Conditions )
    endfunction
endscope

