function Trig_Knight2_Conditions takes nothing returns boolean
    return GetUnitTypeId(udg_DamageEventTarget) == 'h000' and GetUnitLifePercent(udg_DamageEventTarget) <= 75
endfunction

function Knight2End takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local integer counter = LoadInteger( udg_hash, id, StringHash( "bskn1" ) )
    local real x = LoadReal( udg_hash, id, StringHash( "bskn1x" ) )
    local real y = LoadReal( udg_hash, id, StringHash( "bskn1y" ) )
    local unit boss = LoadUnitHandle( udg_hash, id, StringHash( "bskn1" ) )
    local real angle = Atan2( y - GetUnitY( boss ), x - GetUnitX( boss ) )
    local real NewX = GetUnitX( boss ) + 30 * Cos( angle )
    local real NewY = GetUnitY( boss ) + 30 * Sin( angle )
    local real IfX = ( ( x - GetUnitX( boss ) ) * ( x - GetUnitX( boss ) ) )
    local real IfY = ( ( y - GetUnitY( boss ) ) * ( y - GetUnitY( boss ) ) )
    
    if GetUnitState( boss, UNIT_STATE_LIFE) <= 0.405 or not( udg_fightmod[0] ) then
        call DestroyTimer( GetExpiredTimer() )
        call FlushChildHashtable( udg_hash, id )
    elseif SquareRoot( IfX + IfY ) > 100 and counter < 100 then
        call SetUnitPosition( boss, NewX, NewY )
        call SaveInteger( udg_hash, id, StringHash( "bskn1" ), counter + 1 )
    else
        call SetUnitPathing( boss, true )
        call pausest( boss, -1 )
        call UnitRemoveAbility( boss, 'A0RO' )
        call UnitRemoveAbility( boss, 'B01G' )
        call FlushChildHashtable( udg_hash, id )
        call DestroyTimer( GetExpiredTimer() )
    endif
    
    set boss = null
endfunction

function Knight2Cast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local integer id1 = GetHandleId( LoadUnitHandle( udg_hash, id, StringHash( "bskn" ) ) )
    local unit boss = LoadUnitHandle( udg_hash, id, StringHash( "bskn" ) )
    local unit target

    if GetUnitState( boss, UNIT_STATE_LIFE) <= 0.405 or not( udg_fightmod[0] ) then
        call DestroyTimer( GetExpiredTimer() )
        call FlushChildHashtable( udg_hash, id )
    else
        set target = randomtarget( boss, 600, "enemy", "", "", "", "" )
        if target != null then
            call dummyspawn( boss, 1, 'A0GP', 0, 0 )
            call IssueTargetOrder( bj_lastCreatedUnit, "thunderbolt", target )
            call UnitAddAbility( boss, 'A0RO' )
    		call pausest( boss, 1 )
            call SetUnitPathing( boss, false )
            call SetUnitFacing( boss, bj_RADTODEG * Atan2(GetUnitY(target) - GetUnitY(boss), GetUnitX(target) - GetUnitX(boss) ) )
            call SetUnitAnimationWithRarity( boss, "walk", RARITY_FREQUENT )
            
            call SaveTimerHandle( udg_hash, id1, StringHash( "bskn1" ), CreateTimer() )
            set id1 = GetHandleId( LoadTimerHandle( udg_hash, id1, StringHash( "bskn1" ) ) ) 
            call SaveUnitHandle( udg_hash, id1, StringHash( "bskn1" ), boss )
            call SaveReal( udg_hash, id1, StringHash( "bskn1x" ), GetUnitX( target ) )
            call SaveReal( udg_hash, id1, StringHash( "bskn1y" ), GetUnitY( target ) )
            call SaveInteger( udg_hash, id1, StringHash( "bskn1" ), 1 )
            call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( boss ), StringHash( "bskn1" ) ), 0.04, true, function Knight2End )
        endif
    endif
    
    set boss = null
    set target = null
endfunction

function Trig_Knight2_Actions takes nothing returns nothing
    local integer id = GetHandleId( udg_DamageEventTarget )
    
    call DisableTrigger( GetTriggeringTrigger() )
    call SetUnitAbilityLevel(udg_DamageEventTarget, 'A03D', 2)
    call SetUnitAbilityLevel(udg_DamageEventTarget, 'A01E', 2)
    call SetUnitAnimation( udg_DamageEventTarget, "stand victory" )
    call DestroyEffect(AddSpecialEffectTarget( "Abilities\\Spells\\Human\\Thunderclap\\ThunderClapCaster.mdl", udg_DamageEventTarget, "origin") )
    
    if LoadTimerHandle( udg_hash, id, StringHash( "bskn" ) ) == null  then
        call SaveTimerHandle( udg_hash, id, StringHash( "bskn" ), CreateTimer() )
    endif
	set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "bskn" ) ) ) 
    call SaveUnitHandle( udg_hash, id, StringHash( "bskn" ), udg_DamageEventTarget )
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( udg_DamageEventTarget ), StringHash( "bskn" ) ), bosscast(10), true, function Knight2Cast )
endfunction

//===========================================================================
function InitTrig_Knight2 takes nothing returns nothing
    set gg_trg_Knight2 = CreateTrigger()
    call DisableTrigger( gg_trg_Knight2 )
    call TriggerRegisterVariableEvent( gg_trg_Knight2, "udg_AfterDamageEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_Knight2, Condition( function Trig_Knight2_Conditions ) )
    call TriggerAddAction( gg_trg_Knight2, function Trig_Knight2_Actions )
endfunction

