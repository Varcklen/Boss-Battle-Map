//TESH.scrollpos=0
//TESH.alwaysfold=0
function Trig_RuneSton_Conditions takes nothing returns boolean
    return not( udg_IsDamageSpell ) and inv(udg_DamageEventSource, 'I00M' ) > 0
endfunction

function RuneStonCast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer( ) )
    local unit target = LoadUnitHandle( udg_hash, id, StringHash( "ston" ) )
    
    call UnitRemoveAbility( target, 'A0WL' )
    call UnitRemoveAbility( target, 'B018' )
    call FlushChildHashtable( udg_hash, id )
    
    set target = null
endfunction

function Trig_RuneSton_Actions takes nothing returns nothing
    local integer id 
    local unit target
    local unit caster
    local real t
    
    if CastLogic() then
        set caster = udg_Caster
        set target = udg_Target
        set t = udg_Time
    else
        set caster = udg_DamageEventSource
        set target = udg_DamageEventTarget
        set t = 5
    endif
    set t = timebonus(caster, t)

    set id = GetHandleId( target )
    call UnitAddAbility( target, 'A0WL' )
    
    if LoadTimerHandle( udg_hash, id, StringHash( "ston" ) ) == null then
        call SaveTimerHandle( udg_hash, id, StringHash( "ston" ), CreateTimer() )
    endif
	set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "ston" ) ) ) 
	call SaveUnitHandle( udg_hash, id, StringHash( "ston" ), target )
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( target ), StringHash( "ston" ) ), t, false, function RuneStonCast ) 
    
    if BuffLogic() then
        call debuffst( caster, target, "Trig_RuneSton_Actions", 1, t )
    endif
    
    set caster = null
    set target = null
endfunction

//===========================================================================
function InitTrig_RuneSton takes nothing returns nothing
    set gg_trg_RuneSton = CreateTrigger(  )
    call TriggerRegisterVariableEvent( gg_trg_RuneSton, "udg_DamageModifierEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_RuneSton, Condition( function Trig_RuneSton_Conditions ) )
    call TriggerAddAction( gg_trg_RuneSton, function Trig_RuneSton_Actions )
endfunction

