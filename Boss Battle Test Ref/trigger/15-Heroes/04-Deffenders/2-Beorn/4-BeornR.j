globals
    constant integer BEORN_R_DURATION = 20
    constant integer BEORN_R_TICK = 1
    constant integer BEORN_R_DAMAGE_FIRST_LEVEL = 10
    constant integer BEORN_R_DAMAGE_LEVEL_BONUS = 6
    
    constant real BEORN_R_DAMAGE_BONUS_ALTERNATIVE = 0.5
    
    constant string BEORN_R_ANIMATION = "Abilities\\Spells\\Other\\Stampede\\StampedeMissileDeath.mdl"
endglobals

function Trig_BeornR_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A0B9'
endfunction

function BeornRCast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer( ) )
    local real dmg = LoadReal( udg_hash, id, StringHash( "berr" ) )
    local unit target = LoadUnitHandle( udg_hash, id, StringHash( "berr" ) )
    local unit dummy = LoadUnitHandle( udg_hash, id, StringHash( "berrd" ) )
    
    if GetUnitState( dummy, UNIT_STATE_LIFE) > 0.405 and GetUnitState( target, UNIT_STATE_LIFE) > 0.405 and GetUnitAbilityLevel( target, 'A0PF') > 0 then
        call UnitDamageTarget( dummy, target, dmg, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS )
    else
        call UnitRemoveAbility( target, 'A0PF' )
        call UnitRemoveAbility( target, 'B001' )
        call RemoveUnit( dummy )
        call FlushChildHashtable( udg_hash, id )
        call DestroyTimer( GetExpiredTimer() )
    endif
    
    set target = null
    set dummy = null
endfunction

function BeornR_Alternative takes unit caster, unit target, real duration, real damage returns nothing
    local unit oldTarget = LoadUnitHandle( udg_hash, GetHandleId(caster), StringHash( "berrt" ) )
    local integer id
    
    if oldTarget != null then
        call UnitRemoveAbility( oldTarget, 'A0PF' )
        call UnitRemoveAbility( oldTarget, 'B001' )
        call RemoveSavedHandle( udg_hash, GetHandleId( caster ), StringHash( "berrt" ) )
    endif
    
    set damage = damage + (damage*BEORN_R_DAMAGE_BONUS_ALTERNATIVE)
    
    call dummyspawn( caster, 0, 0, 'A0N5', 0 )
    call bufallst(caster, target, 'A0PF', 0, 0, 0, 0, 'B001', "berrc", duration )
    
    set id = InvokeTimerWithUnit( target, "berr", BEORN_R_TICK, true, function BeornRCast )
    call SaveUnitHandle( udg_hash, id, StringHash( "berrd" ), bj_lastCreatedUnit )
    call SaveUnitHandle( udg_hash, GetHandleId(caster), StringHash( "berrt" ), target )
    call SaveReal( udg_hash, id, StringHash( "berr" ), damage )
    
    call debuffst( caster, target, null, 1, duration )
    
    set caster = null
    set target = null
    set oldTarget = null
endfunction

function BeornR takes unit caster, unit target, real duration, real damage returns nothing
    local integer id

    call dummyspawn( caster, 0, 0, 'A0N5', 0 )
    call bufallst(caster, target, 'A0PF', 0, 0, 0, 0, 'B001', "berrc", duration )
    
    set id = InvokeTimerWithUnit( target, "berr", BEORN_R_TICK, true, function BeornRCast )
    call SaveUnitHandle( udg_hash, id, StringHash( "berrd" ), bj_lastCreatedUnit )
    call SaveReal( udg_hash, id, StringHash( "berr" ), damage )
    
    call debuffst( caster, target, null, 1, duration )
    
    set caster = null
    set target = null
endfunction

function Trig_BeornR_Actions takes nothing returns nothing 
    local unit caster
    local unit target
    local integer lvl
    local integer id
    local real dmg
    local real t
    
    if CastLogic() then
        set caster = udg_Caster
        set target = udg_Target
        set lvl = udg_Level
        set t = udg_Time
    elseif RandomLogic() then
        set caster = udg_Caster
        set target = randomtarget( caster, 300, "enemy", "", "", "", "" )
        set lvl = udg_Level
        set t = BEORN_R_DURATION
        call textst( udg_string[0] + GetObjectName('A0B9'), caster, 64, 90, 10, 1.5 )
        if target == null then
            set caster = null
            return
        endif
    else
        set caster = GetSpellAbilityUnit()
        set target = GetSpellTargetUnit()
        set lvl = GetUnitAbilityLevel(GetSpellAbilityUnit(), GetSpellAbilityId())
        set t = BEORN_R_DURATION
    endif
    set t = timebonus(caster, t)
    
    set dmg = (BEORN_R_DAMAGE_FIRST_LEVEL + ( BEORN_R_DAMAGE_LEVEL_BONUS * lvl )) * GetUnitSpellPower(caster)
    
    //call BJDebugMsg("aspect1: " + B2S(IsAspectActive[udg_HeroNum[GetUnitUserData(caster)]][1]))
    //call BJDebugMsg("aspect2: " + B2S(IsAspectActive[udg_HeroNum[GetUnitUserData(caster)]][2]))
    //call BJDebugMsg("aspect3: " + B2S(IsAspectActive[udg_HeroNum[GetUnitUserData(caster)]][3]))
    if Aspects_IsHeroAspectActive( caster, ASPECT_03 ) then
        call BeornR_Alternative( caster, target, t, dmg )
    else
        call BeornR( caster, target, t, dmg )
    endif
    
    call DestroyEffect( AddSpecialEffectTarget( BEORN_R_ANIMATION, target, "chest" ) )
    
     set caster = null
     set target = null
endfunction

//===========================================================================
function InitTrig_BeornR takes nothing returns nothing
    set gg_trg_BeornR = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_BeornR, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_BeornR, Condition( function Trig_BeornR_Conditions ) )
    call TriggerAddAction( gg_trg_BeornR, function Trig_BeornR_Actions )
endfunction

scope BeornR initializer Triggs
    private function DeleteBuff_Conditions takes nothing returns boolean
        return GetUnitAbilityLevel( Event_DeleteBuff_Unit, 'A0PF') > 0
    endfunction
    
    private function DeleteBuff takes nothing returns nothing
        local unit hero = Event_DeleteBuff_Unit
        
        call UnitRemoveAbility( hero, 'A0PF' )
        call UnitRemoveAbility( hero, 'B001' )
        
        set hero = null
    endfunction

    private function Triggs takes nothing returns nothing
        call CreateEventTrigger( "Event_DeleteBuff_Real", function DeleteBuff, function DeleteBuff_Conditions )
    endfunction
endscope

