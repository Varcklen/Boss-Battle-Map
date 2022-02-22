function Trig_DogEM_Conditions takes nothing returns boolean
    return udg_IsDamageSpell and GetUnitAbilityLevel(udg_hero[GetPlayerId(GetOwningPlayer(udg_DamageEventSource)) + 1], 'A158') > 0 and IsUnitEnemy(udg_DamageEventSource, GetOwningPlayer(udg_DamageEventTarget)) 
endfunction

function DogECast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer( ) )
    local integer counter = LoadInteger( udg_hash, id, StringHash( "doge" ) ) + 1
    local real t = LoadReal( udg_hash, id, StringHash( "doget" ) )
    local real dmg = LoadReal( udg_hash, id, StringHash( "doge" ) )
    local unit target = LoadUnitHandle( udg_hash, id, StringHash( "doge" ) )
    local unit dummy = LoadUnitHandle( udg_hash, id, StringHash( "doged" ) )
    
    if counter <= t then
        call UnitDamageTarget( dummy, target, dmg, true, false, ATTACK_TYPE_HERO, DAMAGE_TYPE_NORMAL, WEAPON_TYPE_WHOKNOWS )
    endif
    
    if counter >= t or GetUnitState( target, UNIT_STATE_LIFE) <= 0.405 or GetUnitState( dummy, UNIT_STATE_LIFE) <= 0.405 then
        call RemoveUnit( dummy )
        call UnitRemoveAbility( target, 'A15A' )
        call UnitRemoveAbility( target, 'B06Y' )
    	call SaveUnitHandle( udg_hash, id, StringHash( "poisd" ), null )
        call FlushChildHashtable( udg_hash, id )
        call DestroyTimer( GetExpiredTimer() )
    else
        call SaveInteger( udg_hash, id, StringHash( "doge" ), counter )
    endif
    
    set dummy = null
    set target = null
endfunction

function Trig_DogEM_Actions takes nothing returns nothing
    local integer id 
    local unit target
    local unit caster
    local real t
    
    set caster = udg_hero[GetPlayerId(GetOwningPlayer(udg_DamageEventSource)) + 1]
    set target = udg_DamageEventTarget
    
    set t = timebonus( caster, 10 )

    set id = GetHandleId( target )
    call UnitAddAbility( target, 'A15A' )
    call dummyspawn( caster, 0, 'A0N5', 0, 0 )
    
    if LoadTimerHandle( udg_hash, id, StringHash( "doge" ) ) == null then
        call SaveTimerHandle( udg_hash, id, StringHash( "doge" ), CreateTimer() )
    endif
	set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "doge" ) ) ) 
	call SaveUnitHandle( udg_hash, id, StringHash( "doge" ), target )
    call SaveUnitHandle( udg_hash, id, StringHash( "doged" ), bj_lastCreatedUnit )
    call SaveReal( udg_hash, id, StringHash( "doget" ), t )
    call SaveReal( udg_hash, id, StringHash( "doge" ), (10+(5*GetUnitAbilityLevel(caster, 'A158'))) * GetUnitSpellPower(caster) )
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( target ), StringHash( "doge" ) ), 0.99, true, function DogECast ) 
    
    if BuffLogic() then
        call debuffst( caster, target, null, 1, t )
    endif
    
    set caster = null
    set target = null
endfunction

//===========================================================================
function InitTrig_DogEM takes nothing returns nothing
    set gg_trg_DogEM = CreateTrigger(  )
    call TriggerRegisterVariableEvent( gg_trg_DogEM, "udg_AfterDamageEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_DogEM, Condition( function Trig_DogEM_Conditions ) )
    call TriggerAddAction( gg_trg_DogEM, function Trig_DogEM_Actions )
endfunction

