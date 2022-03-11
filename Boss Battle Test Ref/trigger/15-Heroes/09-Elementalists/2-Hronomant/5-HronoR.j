function Trig_HronoR_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A09S'
endfunction

function HronoRCast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer( ) )
    local unit u = LoadUnitHandle( udg_hash, id, StringHash( "hrnr" ) )

    call SaveInteger( udg_hash, GetHandleId( u ), StringHash( "hrnrs" ), 0 )
    call UnitRemoveAbility( u, 'A09X' )
    call UnitRemoveAbility( u, 'B01Q' )
    call UnitRemoveAbility( u, 'A0A0' )
    call UnitRemoveAbility( u, 'A0RX' )
    call FlushChildHashtable( udg_hash, id )

    set u = null
endfunction

function Trig_HronoR_Actions takes nothing returns nothing
    local integer id 
    local integer lvl
    local unit caster
    local real t
    local integer stack
    
    if CastLogic() then
        set caster = udg_Caster
        set lvl = udg_Level
        set t = udg_Time
    elseif RandomLogic() then
        set caster = udg_Caster
        set lvl = udg_Level
        call textst( udg_string[0] + GetObjectName('A09S'), caster, 64, 90, 10, 1.5 )
        set t = 20
    else
        set caster = GetSpellAbilityUnit()
        set lvl = GetUnitAbilityLevel(GetSpellAbilityUnit(), GetSpellAbilityId())
        set t = 20
    endif
    set id = GetHandleId( caster )

    set stack = LoadInteger( udg_hash, GetHandleId( caster ), StringHash( "hrnrs" ) ) + 1
    if stack > 3 then
        set stack = 3
    endif
    call SaveInteger( udg_hash, GetHandleId( caster ), StringHash( "hrnrs" ), stack )
    call textst( "|cFF7EBFF1" + I2S(stack), caster, 64, GetRandomReal( 80, 100 ), 12, 1 )

    call UnitAddAbility( caster, 'A0A0' )
    call UnitAddAbility( caster, 'A0RX' )
    call SetUnitAbilityLevel( caster, 'A0A0', (5*(stack-1))+lvl )
    call SetUnitAbilityLevel( caster, 'A0RX', (5*(stack-1))+lvl )

    call UnitAddAbility( caster, 'A09X')
    
     if LoadTimerHandle( udg_hash, id, StringHash( "hrnr" ) ) == null then
        call SaveTimerHandle( udg_hash, id, StringHash( "hrnr" ), CreateTimer() )
    endif
	set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "hrnr" ) ) ) 
	call SaveUnitHandle( udg_hash, id, StringHash( "hrnr" ), caster )
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( caster ), StringHash( "hrnr" ) ), t, false, function HronoRCast )
    
    call effst( caster, caster, null, lvl, t )
    
    set caster = null
endfunction

//===========================================================================
function InitTrig_HronoR takes nothing returns nothing
    set gg_trg_HronoR = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_HronoR, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_HronoR, Condition( function Trig_HronoR_Conditions ) )
    call TriggerAddAction( gg_trg_HronoR, function Trig_HronoR_Actions )
endfunction

