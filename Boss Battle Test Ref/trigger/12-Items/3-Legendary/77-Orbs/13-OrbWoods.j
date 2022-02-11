function Trig_OrbWoods_Conditions takes nothing returns boolean
    return inv(GetSpellAbilityUnit(), 'I0F3') > 0 and not(LoadBoolean( udg_hash, GetHandleId( GetSpellAbilityUnit() ), StringHash( "orbew" ) ) ) and combat( GetSpellAbilityUnit(), false, 0 )
endfunction

function OrbWoodsEnd takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer( ) )
    local unit u = LoadUnitHandle( udg_hash, id, StringHash( "orbew" ) )
    
	call SaveBoolean( udg_hash, GetHandleId( u ), StringHash( "orbew" ), false )
    call FlushChildHashtable( udg_hash, id )

    set u = null
endfunction

function OrbWoodsSpell takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer( ) )
    
    if GetUnitAbilityLevel(gg_unit_u00F_0006, 'A153') > 0 then
        call rainst( -1 )
    endif
    call UnitRemoveAbility( gg_unit_u00F_0006, 'A153' )
    call UnitRemoveAbility( gg_unit_u00F_0006, 'A13E' )
    call FlushChildHashtable( udg_hash, id )
endfunction

function Trig_OrbWoods_Actions takes nothing returns nothing
    local integer id

    if LoadInteger( udg_hash, 1, StringHash( "rain" ) ) <= 0 then
        call rainst( 1 )
    endif

    call SaveBoolean( udg_hash, GetHandleId( GetSpellAbilityUnit() ), StringHash( "orbew" ), true )
    call BlzStartUnitAbilityCooldown( GetSpellAbilityUnit(), 'A156', 90 )
    
    set id = GetHandleId( GetSpellAbilityUnit() )
    if LoadTimerHandle( udg_hash, id, StringHash( "orbew" ) ) == null then
        call SaveTimerHandle( udg_hash, id, StringHash( "orbew" ), CreateTimer() )
    endif
    call SaveTimerHandle( udg_hash, id, StringHash( "orbew" ), CreateTimer( ) ) 
    set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "orbew" ) ) ) 
    call SaveUnitHandle( udg_hash, id, StringHash( "orbew" ), GetSpellAbilityUnit() ) 
    call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( GetSpellAbilityUnit() ), StringHash( "orbew" ) ), 90, false, function OrbWoodsEnd )
    
    call UnitAddAbility( gg_unit_u00F_0006, 'A153' )
    call UnitAddAbility( gg_unit_u00F_0006, 'A13E' )
    call DestroyEffect( AddSpecialEffect("Abilities\\Spells\\Human\\ReviveHuman\\ReviveHuman.mdl", GetUnitX( GetSpellAbilityUnit() ), GetUnitY( GetSpellAbilityUnit() ) ) )
    
    set id = GetHandleId( bj_lastCreatedUnit )
    if LoadTimerHandle( udg_hash, id, StringHash( "orbewc" ) ) == null then
        call SaveTimerHandle( udg_hash, id, StringHash( "orbewc" ), CreateTimer() )
    endif
    call SaveTimerHandle( udg_hash, id, StringHash( "orbewc" ), CreateTimer( ) ) 
    set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "orbewc" ) ) ) 
    call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( bj_lastCreatedUnit ), StringHash( "orbewc" ) ), 30, false, function OrbWoodsSpell )
endfunction

//===========================================================================
function InitTrig_OrbWoods takes nothing returns nothing
    set gg_trg_OrbWoods = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_OrbWoods, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_OrbWoods, Condition( function Trig_OrbWoods_Conditions ) )
    call TriggerAddAction( gg_trg_OrbWoods, function Trig_OrbWoods_Actions )
endfunction