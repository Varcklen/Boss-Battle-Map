globals
    constant real SHADOW_ARCHER_Q_DURATION = 15
    constant real SHADOW_ARCHER_Q_ATTACK_BONUS = 1
endglobals

function Trig_ShadowArcherQ_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A0H4'
endfunction

function ShadowArcherQCast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer( ) )
    local unit u = LoadUnitHandle( udg_hash, id, StringHash( "shdq" ) )
    local integer r = LoadInteger( udg_hash, GetHandleId( u ), StringHash( "shdq" ) )

    call BlzSetUnitBaseDamage( u, BlzGetUnitBaseDamage(u, 0) - r, 0 )
    call UnitRemoveAbility( u, 'A0FV' )
    call UnitRemoveAbility( u, 'B06A' )
    call RemoveSavedInteger( udg_hash, GetHandleId( u ), StringHash( "shdq" ) )
    call FlushChildHashtable( udg_hash, id )
    
    set u = null
endfunction

function Trig_ShadowArcherQ_Actions takes nothing returns nothing
    local integer lvl
    local unit caster
    local unit target
    local real t
    local integer bonus
    local integer oldBonus
    
    if CastLogic() then
        set caster = udg_Caster
        set target = udg_Target
        set lvl = udg_Level
        set t = udg_Time
    elseif RandomLogic() then
        set caster = udg_Caster
        set target = randomtarget( caster, 900, "ally", "hero", "", "", "" )
        set lvl = udg_Level
        call textst( udg_string[0] + GetObjectName('A0H4'), caster, 64, 90, 10, 1.5 )
        set t = SHADOW_ARCHER_Q_DURATION
        if target == null then
            set caster = null
            return
        endif
    else
        set caster = GetSpellAbilityUnit()
        set target = GetSpellTargetUnit()
        set lvl = GetUnitAbilityLevel(GetSpellAbilityUnit(), GetSpellAbilityId())
        set t = SHADOW_ARCHER_Q_DURATION
    endif
    set t = timebonus(caster, t)

    set oldBonus = LoadInteger( udg_hash, GetHandleId( target ), StringHash( "shdq" ) )
    call BlzSetUnitBaseDamage( target, BlzGetUnitBaseDamage(target, 0) - oldBonus, 0 )
    call RemoveSavedInteger( udg_hash, GetHandleId( target ), StringHash( "shdq" ) )

    call DestroyEffect( AddSpecialEffectTarget("war3mapImported\\Soul Discharge.mdx", target, "origin" ) )
    set bonus = R2I(GetUnitDamage(target)*SHADOW_ARCHER_Q_ATTACK_BONUS)
    call BlzSetUnitBaseDamage( target, BlzGetUnitBaseDamage(target, 0) + bonus, 0 )
    call UnitAddAbility( target, 'A0FV')
    
    call InvokeTimerWithUnit( target, "shdq", t, false, function ShadowArcherQCast )
    call SaveInteger( udg_hash, GetHandleId( target ), StringHash( "shdq" ), bonus )
    
    call effst( caster, target, null, 1, t )
    
    set caster = null
    set target = null
endfunction

function ShadowArcherQ_BuffDelete takes nothing returns nothing
    local integer r = 0
    if GetUnitAbilityLevel( Event_DeleteBuff_Unit, 'B06A') > 0 then
        set r = LoadInteger( udg_hash, GetHandleId( Event_DeleteBuff_Unit ), StringHash( "shdq" ) )
        call BlzSetUnitBaseDamage( Event_DeleteBuff_Unit, BlzGetUnitBaseDamage(Event_DeleteBuff_Unit, 0) - r, 0 )
        call UnitRemoveAbility( Event_DeleteBuff_Unit, 'A0FV' )
        call UnitRemoveAbility( Event_DeleteBuff_Unit, 'B06A' )
        call RemoveSavedInteger( udg_hash, GetHandleId( Event_DeleteBuff_Unit ), StringHash( "shdq" ) )
    endif
endfunction

//===========================================================================
function InitTrig_ShadowArcherQ takes nothing returns nothing
    set gg_trg_ShadowArcherQ = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_ShadowArcherQ, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_ShadowArcherQ, Condition( function Trig_ShadowArcherQ_Conditions ) )
    call TriggerAddAction( gg_trg_ShadowArcherQ, function Trig_ShadowArcherQ_Actions )
    
    call CreateTrigger_DeleteBuff(function ShadowArcherQ_BuffDelete)
endfunction

