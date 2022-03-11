function Trig_DragonQ_Conditions takes nothing returns boolean
    return (GetSpellAbilityId() == 'A0OC') and combat( GetSpellAbilityUnit(), true, GetSpellAbilityId() )
endfunction

function DragonQCast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer( ) )
    local unit u = LoadUnitHandle( udg_hash, id, StringHash( "drq" ) )
    
    call UnitRemoveAbility( u, 'A0O6' )
    call UnitRemoveAbility( u, 'B01J' )
    call UnitRemoveAbility( u, 'A0O7' )
    call UnitRemoveAbility( u, 'B037' )
    call FlushChildHashtable( udg_hash, id )
    
    set u = null
endfunction

function Trig_DragonQ_Actions takes nothing returns nothing
    local integer id 
    local unit caster
    local unit target
    local integer lvl
    local real t
    
    if CastLogic() then
        set caster = udg_Caster
        set target = udg_Target
        set lvl = udg_Level
        set t = udg_Time
    elseif RandomLogic() then
        set caster = udg_Caster
        set target = randomtarget( caster, 900, "ally", "", "", "", "" )
        set lvl = udg_Level
        set t = udg_Level
        call textst( udg_string[0] + GetObjectName('A0OC'), caster, 64, 90, 10, 1.5 )
        if target == null then
            set caster = null
            return
        endif
    else
        set caster = GetSpellAbilityUnit()
        set target = GetSpellTargetUnit()
        set lvl = GetUnitAbilityLevel(GetSpellAbilityUnit(), GetSpellAbilityId())
        set t = 10 + udg_cristal
    endif
    set t = timebonus(caster, t)
    set id = GetHandleId( target )
    
    call UnitAddAbility( target, 'A0O6' )
    call UnitAddAbility( target, 'A0O7' )
    call SetUnitAbilityLevel( target, 'A04S', lvl )
    call SetUnitAbilityLevel( target, 'A08H', lvl )
    
    if LoadTimerHandle( udg_hash, id, StringHash( "drq" ) ) == null then
        call SaveTimerHandle( udg_hash, id, StringHash( "drq" ), CreateTimer() )
    endif
	set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "drq" ) ) ) 
	call SaveUnitHandle( udg_hash, id, StringHash( "drq" ), target )
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( target ), StringHash( "drq" ) ), t, false, function DragonQCast )
    
    call effst( caster, target, null, lvl, t )
    
    set caster = null
    set target = null
endfunction

//===========================================================================
function InitTrig_DragonQ takes nothing returns nothing
    set gg_trg_DragonQ = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_DragonQ, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_DragonQ, Condition( function Trig_DragonQ_Conditions ) )
    call TriggerAddAction( gg_trg_DragonQ, function Trig_DragonQ_Actions )
endfunction

