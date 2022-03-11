function Trig_HronoW_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A0MS'
endfunction

function HronoWEnd takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer( ) )
    call UnitRemoveAbility( LoadUnitHandle( udg_hash, id, StringHash( "hrnw1" ) ), 'A0MR' )
    call UnitRemoveAbility( LoadUnitHandle( udg_hash, id, StringHash( "hrnw1" ) ), 'B00T' )
    call FlushChildHashtable( udg_hash, id )
endfunction

function HronoWCast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer( ) )
    local unit target 
    local unit caster 
    local integer id1
    local integer lvl
    local real t
    
    if CastLogic() then
        set caster = udg_Caster
        set target = udg_Target
        set lvl = udg_Level
        set t = udg_Time
    else
        set caster = LoadUnitHandle( udg_hash, id, StringHash( "hrnwc" ) )
        set target = LoadUnitHandle( udg_hash, id, StringHash( "hrnw" ) )
        set lvl = LoadInteger( udg_hash, id, StringHash( "hrnwlvl" ) )
        set t = 5
    endif
    set t = timebonus(caster, t)
    
    set id1 = GetHandleId( target )
    call UnitRemoveAbility( target, 'A0ML' )
    call UnitRemoveAbility( target, 'B00S' )
    
    if GetUnitState( target, UNIT_STATE_LIFE) > 0.405 then
        call UnitAddAbility( target, 'A0MR' )
        call SetUnitAbilityLevel( target, 'A08K', lvl )

       if LoadTimerHandle( udg_hash, id1, StringHash( "hrnw1" ) ) == null then
            call SaveTimerHandle( udg_hash, id1, StringHash( "hrnw1" ), CreateTimer() )
        endif
        set id1 = GetHandleId( LoadTimerHandle( udg_hash, id1, StringHash( "hrnw1" ) ) ) 
        call SaveUnitHandle( udg_hash, id1, StringHash( "hrnw1" ), target )
        call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( target ), StringHash( "hrnw1" ) ), t, false, function HronoWEnd )
        
        if BuffLogic() then
            call debuffst( caster, target, "HronoWCast", lvl, t )
        endif
    endif
    
    call FlushChildHashtable( udg_hash, id )
    
    set caster = null
    set target = null
endfunction

function Trig_HronoW_Actions takes nothing returns nothing
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
        call textst( udg_string[0] + GetObjectName('A0MS'), caster, 64, 90, 10, 1.5 )
        set t = 25
        if target == null then
            set caster = null
            return
        endif
    else
        set caster = GetSpellAbilityUnit()
        set target = GetSpellTargetUnit()
        set lvl = GetUnitAbilityLevel(GetSpellAbilityUnit(), GetSpellAbilityId())
        set t = 25
    endif
    set t = timebonus(caster, t)
    set id = GetHandleId( target )
  
    call UnitAddAbility( target, 'A0ML' )
    call SetUnitAbilityLevel( target, 'A06R', lvl )

   if LoadTimerHandle( udg_hash, id, StringHash( "hrnw" ) ) == null then
        call SaveTimerHandle( udg_hash, id, StringHash( "hrnw" ), CreateTimer() )
    endif
	set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "hrnw" ) ) ) 
	call SaveUnitHandle( udg_hash, id, StringHash( "hrnw" ), target )
    call SaveUnitHandle( udg_hash, id, StringHash( "hrnwc" ), caster )
    call SaveInteger( udg_hash, id, StringHash( "hrnwlvl" ), lvl )
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( target ), StringHash( "hrnw" ) ), t, false, function HronoWCast )
    if BuffLogic() then
        call effst( caster, target, "Trig_HronoW_Actions", lvl, t )
    endif
    
    set caster = null
    set target = null
endfunction

//===========================================================================
function InitTrig_HronoW takes nothing returns nothing
    set gg_trg_HronoW = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_HronoW, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_HronoW, Condition( function Trig_HronoW_Conditions ) )
    call TriggerAddAction( gg_trg_HronoW, function Trig_HronoW_Actions )
endfunction

