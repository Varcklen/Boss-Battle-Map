function Trig_DogEA_Conditions takes nothing returns boolean
    return not(udg_IsDamageSpell) and GetUnitAbilityLevel(udg_DamageEventSource, 'A158') > 0 and luckylogic( udg_DamageEventSource, 10, 1, 100 ) and IsUnitEnemy(udg_DamageEventSource, GetOwningPlayer(udg_DamageEventTarget))
endfunction

function Trig_DogEA_Actions takes nothing returns nothing
    local integer id 
    local unit target
    local unit caster
    local real t
    
    set caster = udg_DamageEventSource
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
    call SaveReal( udg_hash, id, StringHash( "doge" ), (10+(5*GetUnitAbilityLevel(caster, 'A158'))) * udg_SpellDamage[GetPlayerId(GetOwningPlayer( caster ) ) + 1] )
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( target ), StringHash( "doge" ) ), 0.99, true, function DogECast ) 
    
    if BuffLogic() then
        call debuffst( caster, target, null, 1, t )
    endif
    
    set caster = null
    set target = null
endfunction

//===========================================================================
function InitTrig_DogEA takes nothing returns nothing
    set gg_trg_DogEA = CreateTrigger(  )
    call TriggerRegisterVariableEvent( gg_trg_DogEA, "udg_AfterDamageEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_DogEA, Condition( function Trig_DogEA_Conditions ) )
    call TriggerAddAction( gg_trg_DogEA, function Trig_DogEA_Actions )
endfunction

