function Trig_OrbConsecration_Conditions takes nothing returns boolean
    return inv(GetSpellAbilityUnit(), 'I0FL') > 0 and not(LoadBoolean( udg_hash, GetHandleId( GetSpellAbilityUnit() ), StringHash( "orbcn" ) ) )
endfunction

function OrbConsecrationEnd takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer( ) )
    local unit u = LoadUnitHandle( udg_hash, id, StringHash( "orbcn" ) )
    
	call SaveBoolean( udg_hash, GetHandleId( u ), StringHash( "orbcn" ), false )
    call FlushChildHashtable( udg_hash, id )

    set u = null
endfunction

function OrbConsecrationCast takes nothing returns nothing 
	local integer id = GetHandleId( GetExpiredTimer( ) )
    local unit n = LoadUnitHandle( udg_hash, id, StringHash( "orbcnc" ) )
    local unit caster = LoadUnitHandle( udg_hash, id, StringHash( "orbcncc" ) )
    local group g = CreateGroup()
    local unit u
    
    if GetUnitState( n, UNIT_STATE_LIFE) <= 0.405 then
        call FlushChildHashtable( udg_hash, id )
        call DestroyTimer( GetExpiredTimer() )
    else
        call GroupEnumUnitsInRange( g, GetUnitX( n ), GetUnitY( n ), 600, null )
        loop
            set u = FirstOfGroup(g)
            exitwhen u == null
            if unitst( u, n, "ally" ) and IsUnitType( u, UNIT_TYPE_HERO) then
                call healst(caster, u, 15)
                call shield( caster, u, 15, 60 )
                call effst( caster, u, null, 1, 60 )   
            endif
            call GroupRemoveUnit(g,u)
        endloop
    endif
    
    call GroupClear( g )
    call DestroyGroup( g )
    set g = null
    set u = null
    set n = null
    set caster = null
endfunction 

function Trig_OrbConsecration_Actions takes nothing returns nothing
    local integer id

    call SaveBoolean( udg_hash, GetHandleId( GetSpellAbilityUnit() ), StringHash( "orbcn" ), true )
    call BlzStartUnitAbilityCooldown( GetSpellAbilityUnit(), 'A0G8', 45 )
    
    set id = GetHandleId( GetSpellAbilityUnit() )
    if LoadTimerHandle( udg_hash, id, StringHash( "orbcn" ) ) == null then
        call SaveTimerHandle( udg_hash, id, StringHash( "orbcn" ), CreateTimer() )
    endif
    call SaveTimerHandle( udg_hash, id, StringHash( "orbcn" ), CreateTimer( ) )
    set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "orbcn" ) ) )
    call SaveUnitHandle( udg_hash, id, StringHash( "orbcn" ), GetSpellAbilityUnit() ) 
    call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( GetSpellAbilityUnit() ), StringHash( "orbcn" ) ), 45, false, function OrbConsecrationEnd )
    
    set bj_lastCreatedUnit = CreateUnit( GetOwningPlayer( GetSpellAbilityUnit() ), 'u000', GetUnitX( GetSpellAbilityUnit() ), GetUnitY( GetSpellAbilityUnit() ), 270 )
    call UnitAddAbility( bj_lastCreatedUnit, 'A0IH' )
    call UnitApplyTimedLife(bj_lastCreatedUnit, 'BTLF', 16 )
    
    set id = GetHandleId( bj_lastCreatedUnit )
    if LoadTimerHandle( udg_hash, id, StringHash( "orbcnc" ) ) == null then
        call SaveTimerHandle( udg_hash, id, StringHash( "orbcnc" ), CreateTimer() )
    endif
    call SaveTimerHandle( udg_hash, id, StringHash( "orbcnc" ), CreateTimer( ) )
    set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "orbcnc" ) ) )
    call SaveUnitHandle( udg_hash, id, StringHash( "orbcnc" ), bj_lastCreatedUnit )
    call SaveUnitHandle( udg_hash, id, StringHash( "orbcncc" ), GetSpellAbilityUnit() )
    call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( bj_lastCreatedUnit ), StringHash( "orbcnc" ) ), 1, true, function OrbConsecrationCast )
endfunction

//===========================================================================
function InitTrig_OrbConsecration takes nothing returns nothing
    set gg_trg_OrbConsecration = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_OrbConsecration, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_OrbConsecration, Condition( function Trig_OrbConsecration_Conditions ) )
    call TriggerAddAction( gg_trg_OrbConsecration, function Trig_OrbConsecration_Actions )
endfunction