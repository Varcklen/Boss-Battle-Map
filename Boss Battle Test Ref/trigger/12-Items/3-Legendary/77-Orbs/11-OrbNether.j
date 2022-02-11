function Trig_OrbNether_Conditions takes nothing returns boolean
    return inv(GetSpellAbilityUnit(), 'I0ET') > 0 and not(LoadBoolean( udg_hash, GetHandleId( GetSpellAbilityUnit() ), StringHash( "orbnt" ) ) )
endfunction

function OrbNetherEnd takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer( ) )
    local unit u = LoadUnitHandle( udg_hash, id, StringHash( "orbnt" ) )
    
	call SaveBoolean( udg_hash, GetHandleId( u ), StringHash( "orbnt" ), false )
    call FlushChildHashtable( udg_hash, id )

    set u = null
endfunction

function OrbNetherSpell takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer( ) )
    local integer p = LoadInteger( udg_hash, id, StringHash( "orbntc1" ) )
    local unit u = LoadUnitHandle( udg_hash, id, StringHash( "orbntc1" ) )

    call spdstpl( p, -1 * LoadReal( udg_hash, GetHandleId( u ), StringHash( "orbntc1" ) ) )
    call UnitRemoveAbility( u, 'A0WU' )
    call UnitRemoveAbility( u, 'B098' )
    call RemoveSavedReal( udg_hash, GetHandleId( u ), StringHash( "orbntc1" ) )
    call FlushChildHashtable( udg_hash, id )
    
    set u = null
endfunction

function OrbNetherCast takes nothing returns nothing 
	local integer id = GetHandleId( GetExpiredTimer( ) )
    local unit n = LoadUnitHandle( udg_hash, id, StringHash( "orbntc" ) )
    local integer id1
    local real isum
    local group g = CreateGroup()
    local unit u
    local real t
    
    if GetUnitState( n, UNIT_STATE_LIFE) <= 0.405 then
        call FlushChildHashtable( udg_hash, id )
        call DestroyTimer( GetExpiredTimer() )
    else
        call GroupEnumUnitsInRange( g, GetUnitX( n ), GetUnitY( n ), 300, null )
        loop
            set u = FirstOfGroup(g)
            exitwhen u == null
            if unitst( u, n, "ally" ) and IsUnitType( u, UNIT_TYPE_HERO) then
                set t = timebonus(u, 10)
                call UnitAddAbility( u, 'A0WU')
                call spdst( u, 2 )
                set isum = LoadReal( udg_hash, GetHandleId( u ), StringHash( "orbntc1" ) ) + 2
                call SaveReal( udg_hash, GetHandleId( u ), StringHash( "orbntc1" ), isum )
                
                set id1 = GetHandleId( u )
                if LoadTimerHandle( udg_hash, id1, StringHash( "orbntc1" ) ) == null then
                    call SaveTimerHandle( udg_hash, id1, StringHash( "orbntc1" ), CreateTimer() )
                endif
                set id1 = GetHandleId( LoadTimerHandle( udg_hash, id1, StringHash( "orbntc1" ) ) ) 
                call SaveUnitHandle( udg_hash, id1, StringHash( "orbntc1" ), u )
                call SaveInteger( udg_hash, id1, StringHash( "orbntc1" ), GetPlayerId( GetOwningPlayer( u ) ) )
                call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( u ), StringHash( "orbntc1" ) ), t, false, function OrbNetherSpell )
            
                call effst( n, u, null, 1, t )
            endif
            call GroupRemoveUnit(g,u)
        endloop
    endif
    
    call GroupClear( g )
    call DestroyGroup( g )
    set g = null
    set u = null
    set n = null
endfunction 

function Trig_OrbNether_Actions takes nothing returns nothing
    local integer id

    call SaveBoolean( udg_hash, GetHandleId( GetSpellAbilityUnit() ), StringHash( "orbnt" ), true )
    call BlzStartUnitAbilityCooldown( GetSpellAbilityUnit(), 'A0XL', 20 )
    
    set id = GetHandleId( GetSpellAbilityUnit() )
    if LoadTimerHandle( udg_hash, id, StringHash( "orbnt" ) ) == null then
        call SaveTimerHandle( udg_hash, id, StringHash( "orbnt" ), CreateTimer() )
    endif
    call SaveTimerHandle( udg_hash, id, StringHash( "orbnt" ), CreateTimer( ) ) 
    set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "orbnt" ) ) ) 
    call SaveUnitHandle( udg_hash, id, StringHash( "orbnt" ), GetSpellAbilityUnit() ) 
    call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( GetSpellAbilityUnit() ), StringHash( "orbnt" ) ), 20, false, function OrbNetherEnd )
    
    set bj_lastCreatedUnit = CreateUnit( GetOwningPlayer( GetSpellAbilityUnit() ), 'u000', GetUnitX( GetSpellAbilityUnit() )+GetRandomReal(-500, 500), GetUnitY( GetSpellAbilityUnit() )+GetRandomReal(-500, 500), 270 )
    call UnitAddAbility( bj_lastCreatedUnit, 'A0WS' )
    call UnitApplyTimedLife(bj_lastCreatedUnit, 'BTLF', 20 )
    
    set id = GetHandleId( bj_lastCreatedUnit )
    if LoadTimerHandle( udg_hash, id, StringHash( "orbntc" ) ) == null then
        call SaveTimerHandle( udg_hash, id, StringHash( "orbntc" ), CreateTimer() )
    endif
    call SaveTimerHandle( udg_hash, id, StringHash( "orbntc" ), CreateTimer( ) ) 
    set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "orbntc" ) ) ) 
    call SaveUnitHandle( udg_hash, id, StringHash( "orbntc" ), bj_lastCreatedUnit ) 
    call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( bj_lastCreatedUnit ), StringHash( "orbntc" ) ), 1, true, function OrbNetherCast )
endfunction

//===========================================================================
function InitTrig_OrbNether takes nothing returns nothing
    set gg_trg_OrbNether = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_OrbNether, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_OrbNether, Condition( function Trig_OrbNether_Conditions ) )
    call TriggerAddAction( gg_trg_OrbNether, function Trig_OrbNether_Actions )
endfunction