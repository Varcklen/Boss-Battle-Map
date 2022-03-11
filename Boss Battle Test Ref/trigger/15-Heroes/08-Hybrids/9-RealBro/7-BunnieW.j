function Trig_BunnieW_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A1B9'
endfunction

function BunnieWCast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer( ) )
    local real dmg = LoadReal( udg_hash, id, StringHash( "bunw" ) )
    local unit target = LoadUnitHandle( udg_hash, id, StringHash( "bunw" ) )
    local unit dummy = LoadUnitHandle( udg_hash, id, StringHash( "bunwd" ) )
    local unit caster = LoadUnitHandle( udg_hash, id, StringHash( "bunwc" ) )
    local unit owner = LoadUnitHandle( udg_hash, id, StringHash( "bunww" ) )
    
    if GetUnitState( target, UNIT_STATE_LIFE) > 0.405 and GetUnitAbilityLevel( target, 'B09P') > 0 then
        call UnitDamageTarget( dummy, target, dmg, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS )
        call healst(caster, null, dmg)
        call healst(caster, owner, dmg)
    else
        call UnitRemoveAbility( target, 'A1B8' )
        call UnitRemoveAbility( target, 'B09P' )
        call RemoveUnit( dummy )
        call FlushChildHashtable( udg_hash, id )
        call DestroyTimer( GetExpiredTimer() )
    endif
    
    set target = null
    set dummy = null
    set caster = null
    set owner = null
endfunction

function Trig_BunnieW_Actions takes nothing returns nothing 
    local unit caster
    local unit target
    local unit owner
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
        set t = 5
        call textst( udg_string[0] + GetObjectName('A1B9'), caster, 64, 90, 10, 1.5 )
        if target == null then
            set caster = null
            return
        endif
    else
        set caster = GetSpellAbilityUnit()
        set target = GetSpellTargetUnit()
        set lvl = LoadInteger( udg_hash, GetHandleId( caster ), StringHash( "rlbaw" ) )
        set t = 5
    endif
    set t = timebonus(caster, t)
    
    set dmg = (7 + ( 4 * lvl )) * GetUnitSpellPower(caster)
    set owner = LoadUnitHandle( udg_hash, GetHandleId( caster ), StringHash( "rlbqac" ) )
    
    call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\Orc\\MirrorImage\\MirrorImageDeathCaster.mdl", GetUnitX( target ), GetUnitY( target ) ) )
    
    call dummyspawn( caster, 0, 0, 'A0N5', 0 )
    call bufst( caster, target, 'A1B8', 'B09P', "bunw1", t )
    
    set id = GetHandleId( target )
    if LoadTimerHandle( udg_hash, id, StringHash( "bunw" ) ) == null then
        call SaveTimerHandle( udg_hash, id, StringHash( "bunw" ), CreateTimer() )
    endif
    set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "bunw" ) ) ) 
    call SaveUnitHandle( udg_hash, id, StringHash( "bunw" ), target )
    call SaveUnitHandle( udg_hash, id, StringHash( "bunwd" ), bj_lastCreatedUnit )
    call SaveUnitHandle( udg_hash, id, StringHash( "bunwc" ), caster )
    call SaveUnitHandle( udg_hash, id, StringHash( "bunww" ), owner )
    call SaveReal( udg_hash, id, StringHash( "bunw" ), dmg )
    call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( target ), StringHash( "bunw" ) ), 1, true, function BunnieWCast )
    
    call debuffst( caster, target, null, lvl, t )
    
    set caster = null
    set target = null
    set owner = null
endfunction

//===========================================================================
function InitTrig_BunnieW takes nothing returns nothing
    set gg_trg_BunnieW = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_BunnieW, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_BunnieW, Condition( function Trig_BunnieW_Conditions ) )
    call TriggerAddAction( gg_trg_BunnieW, function Trig_BunnieW_Actions )
endfunction

