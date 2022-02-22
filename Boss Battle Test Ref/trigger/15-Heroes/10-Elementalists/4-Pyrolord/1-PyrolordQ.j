globals 
    constant real PYROLORD_Q_DURATION = 8
endglobals

function Trig_PyrolordQ_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A0NH'
endfunction

function PyrolordQCast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer( ) )
    local unit target = LoadUnitHandle( udg_hash, id, StringHash( "prlq" ) )
    local unit caster = LoadUnitHandle( udg_hash, id, StringHash( "prlq1" ) )
    local real dmg = LoadReal( udg_hash, id, StringHash( "prlq" ) )
    
    if GetUnitState( target, UNIT_STATE_LIFE) > 0.405 and GetUnitAbilityLevel( target, 'B034') > 0 then
        call UnitRemoveAbility( target, 'A0NJ' )
        call UnitRemoveAbility( target, 'B034' )
        call dummyspawn( caster, 1, 0, 'A0N5', 0 )
        call UnitDamageTarget(bj_lastCreatedUnit, target, dmg, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS)
        call DestroyEffect( AddSpecialEffectTarget("Abilities\\Spells\\Other\\Doom\\DoomDeath.mdl", target , "origin" ) )
    endif
    call FlushChildHashtable( udg_hash, id )
    
    set target = null
    set caster = null
endfunction

function Trig_PyrolordQ_Actions takes nothing returns nothing
    local integer id 
    local unit caster
    local unit target
    local integer lvl
    local real dmg
    local real t
    
    if CastLogic() then
        set caster = udg_Caster
        set target = udg_Target
        set lvl = udg_Level
        set t = udg_Time
    elseif RandomLogic() then
        set caster = udg_Caster
        set target = randomtarget( caster, 900, "enemy", "", "", "", "" )
        set lvl = udg_Level
        set t = PYROLORD_Q_DURATION
        call textst( udg_string[0] + GetObjectName('A0NH'), caster, 64, 90, 10, 1.5 )
        if target == null then
            set caster = null
            return
        endif
    else
        set caster = GetSpellAbilityUnit()
        set target = GetSpellTargetUnit()
        set lvl = GetUnitAbilityLevel(GetSpellAbilityUnit(), GetSpellAbilityId())
        set t = PYROLORD_Q_DURATION
    endif
    set t = timebonus(caster, t)
    
    set dmg = ( PyrolordExtraDamage + 200 + ( 50 * lvl ) ) * GetUnitSpellPower(caster)
    set id = GetHandleId( target )

    call UnitAddAbility( target, 'A0NJ' )
    if LoadTimerHandle( udg_hash, id, StringHash( "prlq" ) ) == null then
        call SaveTimerHandle( udg_hash, id, StringHash( "prlq" ), CreateTimer() )
    endif
	set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "prlq" ) ) ) 
	call SaveUnitHandle( udg_hash, id, StringHash( "prlq" ), target )
    call SaveUnitHandle( udg_hash, id, StringHash( "prlq1" ), caster )
    call SaveReal( udg_hash, id, StringHash( "prlq" ), dmg )
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( target ), StringHash( "prlq" ) ), t, false, function PyrolordQCast )

    call debuffst( caster, target, null, lvl, t )
    
    set caster = null
    set target = null
endfunction
//===========================================================================
function InitTrig_PyrolordQ takes nothing returns nothing
    set gg_trg_PyrolordQ = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_PyrolordQ, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_PyrolordQ, Condition( function Trig_PyrolordQ_Conditions ) )
    call TriggerAddAction( gg_trg_PyrolordQ, function Trig_PyrolordQ_Actions )
endfunction

