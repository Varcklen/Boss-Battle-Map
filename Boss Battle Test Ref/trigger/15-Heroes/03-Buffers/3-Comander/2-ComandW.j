function Trig_ComandW_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A0UL'
endfunction

function ComandWCast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    call UnitRemoveAbility( LoadUnitHandle( udg_hash, id, StringHash( "comw" ) ), 'A0UP' )
    call UnitRemoveAbility( LoadUnitHandle( udg_hash, id, StringHash( "comw" ) ), 'B054' )
    call FlushChildHashtable( udg_hash, id )
endfunction

function Trig_ComandW_Actions takes nothing returns nothing
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
        set t = 20
        call textst( udg_string[0] + GetObjectName('A0UL'), caster, 64, 90, 10, 1.5 )
        if target == null then
            set caster = null
            return
        endif
    else
        set caster = GetSpellAbilityUnit()
        set target = GetSpellTargetUnit()
        set lvl = GetUnitAbilityLevel(GetSpellAbilityUnit(), GetSpellAbilityId())
        set t = 20
    endif
    set t = timebonus(caster, t)
    
    set id = GetHandleId( target )
    
    call UnitAddAbility( target, 'A0UP' )
    call SetUnitAbilityLevel( target, 'A0UM', lvl )
    call SetUnitAbilityLevel( target, 'A0UN', lvl )
    
    call SaveReal( udg_hash, GetHandleId( caster ), StringHash( "comwm" ), 1 - ( 0.1 + ( 0.1 * lvl ) ) )
    
    if LoadTimerHandle( udg_hash, id, StringHash( "comw" ) ) == null  then
        call SaveTimerHandle( udg_hash, id, StringHash( "comw" ), CreateTimer() )
    endif
	set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "comw" ) ) ) 
	call SaveUnitHandle( udg_hash, id, StringHash( "comw" ), target )
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( target ), StringHash( "comw" ) ), t, false, function ComandWCast )
    
    if BuffLogic() then
        call effst( caster, target, "Trig_ComandW_Actions", lvl, t )
    endif
    
    set caster = null
    set target = null
endfunction

//===========================================================================
function InitTrig_ComandW takes nothing returns nothing
    set gg_trg_ComandW = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_ComandW, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_ComandW, Condition( function Trig_ComandW_Conditions ) )
    call TriggerAddAction( gg_trg_ComandW, function Trig_ComandW_Actions )
endfunction

