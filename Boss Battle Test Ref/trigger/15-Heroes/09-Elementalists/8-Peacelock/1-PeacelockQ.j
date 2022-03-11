function Trig_PeacelockQ_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A01W'
endfunction

function PeacelockQCast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer( ) )
    local real counter = LoadReal( udg_hash, id, StringHash( "pckqt" ) ) - 1
    local unit target = LoadUnitHandle( udg_hash, id, StringHash( "pckq" ) )
    local unit caster = LoadUnitHandle( udg_hash, id, StringHash( "pckq1" ) )
    local real heal = LoadReal( udg_hash, id, StringHash( "pckq" ) )
    
    if GetUnitState( target, UNIT_STATE_LIFE) > 0.405 then
        call healst( caster, target, heal )
    endif
    
    if counter > 0 and GetUnitState( target, UNIT_STATE_LIFE) > 0.405 and GetUnitAbilityLevel( target, 'B00Z' ) > 0 then
        call SaveReal( udg_hash, id, StringHash( "pckqt" ), counter )
    else
        call UnitRemoveAbility( target, 'A038' )
        call UnitRemoveAbility( target, 'B00Z' )
        call DestroyTimer( GetExpiredTimer() )
        call FlushChildHashtable( udg_hash, id )
    endif
    
    set target = null
    set caster = null
endfunction

function Trig_PeacelockQ_Actions takes nothing returns nothing
    local integer id
    local real heal
    local unit caster
    local unit target
    local integer lvl
    local real t
    local integer i

    if CastLogic() then
        set caster = udg_Caster
        set target = udg_Target
        set lvl = udg_Level
        set t = udg_Time
    elseif RandomLogic() then
        set caster = udg_Caster
        set target = randomtarget( caster, 300, "ally", "", "", "", "" )
        set lvl = udg_Level
        call textst( udg_string[0] + GetObjectName('A01W'), caster, 64, 90, 10, 1.5 )
        set t = 6
        if target == null then
            set caster = null
            return
        endif
    else
        set caster = GetSpellAbilityUnit()
        set target = GetSpellTargetUnit()
        set lvl = GetUnitAbilityLevel(GetSpellAbilityUnit(), GetSpellAbilityId())
        set t = 6
    endif
    set t = timebonus(caster, t)
    set heal = 25 + ( 10 * lvl )

    call PlaySoundOnUnitBJ( gg_snd_bonk, 100, target )
    call dummyspawn( caster, 1, 0, 0, 0 )
    call UnitDamageTarget( bj_lastCreatedUnit, target, 75, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS)
    
    if GetUnitState( target, UNIT_STATE_LIFE) > 0.405 then
        set id = GetHandleId( target )
        call UnitAddAbility( target, 'A038' )
        
        if LoadTimerHandle( udg_hash, id, StringHash( "pckq" ) ) == null then
            call SaveTimerHandle( udg_hash, id, StringHash( "pckq" ), CreateTimer() )
        endif
        set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "pckq" ) ) ) 
        call SaveUnitHandle( udg_hash, id, StringHash( "pckq" ), target )
        call SaveUnitHandle( udg_hash, id, StringHash( "pckq1" ), caster )
        call SaveReal( udg_hash, id, StringHash( "pckq" ), heal )
        call SaveReal( udg_hash, id, StringHash( "pckqt" ), t )
        call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( target ), StringHash( "pckq" ) ), 1, true, function PeacelockQCast )
        
        call effst( caster, target, null, lvl, t )
    endif
    
    set caster = null
    set target = null
endfunction

//===========================================================================
function InitTrig_PeacelockQ takes nothing returns nothing
    set gg_trg_PeacelockQ = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_PeacelockQ, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_PeacelockQ, Condition( function Trig_PeacelockQ_Conditions ) )
    call TriggerAddAction( gg_trg_PeacelockQ, function Trig_PeacelockQ_Actions )
endfunction

