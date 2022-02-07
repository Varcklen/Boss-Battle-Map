globals
    constant integer STAFF_OF_PHENOMENAL_POWER_DURATION = 12
endglobals

function Trig_Staff_of_Phenomenal_Power_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A0ER'
endfunction

function Staff_of_Phenomenal_PowerCast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer( ) )
    local integer p = LoadInteger( udg_hash, id, StringHash( "sopp" ) )
    local unit u = LoadUnitHandle( udg_hash, id, StringHash( "sopp" ) )

    call spdstpl( p, -1 * LoadReal( udg_hash, GetHandleId( u ), StringHash( "sopp" ) ) )
    call UnitRemoveAbility( u, 'A0CJ' )
    call UnitRemoveAbility( u, 'B028' )
    call RemoveSavedReal( udg_hash, GetHandleId( u ), StringHash( "sopp" ) )
    call FlushChildHashtable( udg_hash, id )
    
    set u = null
endfunction

function Trig_Staff_of_Phenomenal_Power_Actions takes nothing returns nothing
    local integer id 
    local real r
    local unit caster
    local integer i
    local integer x
    local real t
    
    if CastLogic() then
        set caster = udg_Caster
        set t = udg_Time
    elseif RandomLogic() then
        set caster = udg_Caster
        call textst( udg_string[0] + GetObjectName('A0ER'), caster, 64, 90, 10, 1.5 )
        set t = STAFF_OF_PHENOMENAL_POWER_DURATION
    else
        set caster = GetSpellAbilityUnit()
        set t = STAFF_OF_PHENOMENAL_POWER_DURATION
    endif
    set t = timebonus(caster, t)
    
    set x = eyest( caster )
    set i = GetPlayerId(GetOwningPlayer( caster )) + 1
    if IsUnitType( caster, UNIT_TYPE_HERO) then
        call spdst( caster, -LoadReal( udg_hash, GetHandleId( caster ), StringHash( "sopp" ) ) )
    
        set id = GetHandleId( caster )
        set r = 100 * ( (udg_SpellDamage[i]- 1) * x ) 
        call spdst( caster, r )
        call UnitAddAbility( caster, 'A0CJ')
        
        if LoadTimerHandle( udg_hash, GetHandleId( caster), StringHash( "sopp" ) ) == null   then
            call SaveTimerHandle( udg_hash, GetHandleId( caster), StringHash( "sopp" ), CreateTimer() )
        endif
        set id = GetHandleId( LoadTimerHandle( udg_hash, GetHandleId( caster), StringHash( "sopp" ) ) ) 
        call SaveUnitHandle( udg_hash, id, StringHash( "sopp" ), caster )
        call SaveReal( udg_hash, GetHandleId( caster ), StringHash( "sopp" ), r )
        call SaveInteger( udg_hash, id, StringHash( "sopp" ), GetPlayerId( GetOwningPlayer( caster ) ) )
        call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( caster ), StringHash( "sopp" ) ), t, false, function Staff_of_Phenomenal_PowerCast ) 
        
        call effst( caster, caster, null, 1, t )
    endif
    
    set caster = null
endfunction

//===========================================================================
function InitTrig_Staff_of_Phenomenal_Power takes nothing returns nothing
    set gg_trg_Staff_of_Phenomenal_Power = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Staff_of_Phenomenal_Power, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_Staff_of_Phenomenal_Power, Condition( function Trig_Staff_of_Phenomenal_Power_Conditions ) )
    call TriggerAddAction( gg_trg_Staff_of_Phenomenal_Power, function Trig_Staff_of_Phenomenal_Power_Actions )
endfunction

