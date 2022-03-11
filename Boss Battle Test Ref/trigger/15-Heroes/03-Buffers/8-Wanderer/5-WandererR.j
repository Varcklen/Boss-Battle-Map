function Trig_WandererR_Conditions takes nothing returns boolean
    return GetSpellAbilityId( ) == 'A0LF'
endfunction

function WandererREnd takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer( ) )
    local unit u = LoadUnitHandle( udg_hash, id, StringHash( "wndr" ) )
    
    call pausest( u, -1 )
    call SetUnitTimeScale( u, 1 )
    call UnitRemoveAbility( u, 'A0LH' )
    call UnitRemoveAbility( u, 'B01Y' )
    call FlushChildHashtable( udg_hash, id )
    
    set u = null
endfunction

function Trig_WandererR_Actions takes nothing returns nothing
    local integer id
    local unit caster
    local unit target
    local integer lvl
    local real t
    local real dmg
    local integer bns
    
    if CastLogic() then
        set caster = udg_Caster
        set target = udg_Target
        set lvl = udg_Level
        set t = 1.5+(0.5*lvl)
    elseif RandomLogic() then
        set caster = udg_Caster
        set target = randomtarget( caster, 900, "enemy", "", "", "", "" )
        set lvl = udg_Level
        call textst( udg_string[0] + GetObjectName('A0LF'), caster, 64, 90, 10, 1.5 )
        set t = 1.5+(0.5*lvl)
        if target == null then
            set caster = null
            return
        endif
    else
        set caster = GetSpellAbilityUnit()
        set target = GetSpellTargetUnit()
        set lvl = GetUnitAbilityLevel(GetSpellAbilityUnit(), GetSpellAbilityId())
        set t = 1.5+(0.5*lvl)
    endif
    set t = timebonus(caster, t)
    
    set dmg = 50 + ( 30 * lvl )
    set bns = 5 + (3*lvl)
    call dummyspawn( caster, 1, 0, 0, 0 )
    call UnitDamageTarget( bj_lastCreatedUnit, target, dmg, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS)
    
    if GetUnitState( target, UNIT_STATE_LIFE) > 0.405 then
        if GetUnitAbilityLevel( target, 'A0LH') == 0 then
            call pausest( target, 1 )
            call SetUnitTimeScale( target, 0 )
        endif

        call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Other\\HowlOfTerror\\HowlCaster.mdl", target, "origin") )
        call UnitAddAbility( target, 'A0LH' )
        call SaveInteger( udg_hash, GetHandleId( target ), StringHash( "wndrb" ), bns )
        if LoadTimerHandle( udg_hash, GetHandleId( target ), StringHash( "wndr" ) ) == null  then
            call SaveTimerHandle( udg_hash, GetHandleId( target ), StringHash( "wndr" ), CreateTimer() )
        endif
        set id = GetHandleId( LoadTimerHandle(udg_hash, GetHandleId( target ), StringHash( "wndr" ) ) )
        call SaveUnitHandle( udg_hash, id, StringHash( "wndr" ), target )
        call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( target ), StringHash( "wndr" ) ), t, false, function WandererREnd )
        
        call debuffst( caster, target, null, lvl, t )
        endif
    call SetUnitState( caster, UNIT_STATE_LIFE, RMaxBJ(0,GetUnitState( caster, UNIT_STATE_LIFE) - (0.1*GetUnitState( caster, UNIT_STATE_MAX_LIFE)) ))
    
    set caster = null
    set target = null
endfunction

//===========================================================================
function InitTrig_WandererR takes nothing returns nothing
    set gg_trg_WandererR = CreateTrigger( )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_WandererR, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_WandererR, Condition( function Trig_WandererR_Conditions ) )
    call TriggerAddAction( gg_trg_WandererR, function Trig_WandererR_Actions )
endfunction

