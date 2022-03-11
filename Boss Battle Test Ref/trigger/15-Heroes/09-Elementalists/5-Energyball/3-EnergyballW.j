function Trig_EnergyballW_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A0V1'
endfunction

function EnergyballWCast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    call UnitRemoveAbility( LoadUnitHandle( udg_hash, id, StringHash( "enbw" ) ), 'A0V3' )
    call UnitRemoveAbility( LoadUnitHandle( udg_hash, id, StringHash( "enbw" ) ), 'B057' )
    call FlushChildHashtable( udg_hash, id )
endfunction

function Trig_EnergyballW_Actions takes nothing returns nothing
    local integer id 
    local real dmg 
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
        set t = 30
        call textst( udg_string[0] + GetObjectName('A0V1'), caster, 64, 90, 10, 1.5 )
        if target == null then
            set caster = null
            return
        endif
    else
        set caster = GetSpellAbilityUnit()
        set target = GetSpellTargetUnit()
        set lvl = GetUnitAbilityLevel(GetSpellAbilityUnit(), GetSpellAbilityId())
        set t = 30
    endif
    set t = timebonus(caster, t)
    
    set id = GetHandleId( target )
    set dmg = 10 * lvl
    
    call UnitAddAbility( target, 'A0V3' )
    if LoadTimerHandle( udg_hash, id, StringHash( "enbw" ) ) == null  then
        call SaveTimerHandle( udg_hash, id, StringHash( "enbw" ), CreateTimer() )
    endif
	set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "enbw" ) ) ) 
	call SaveUnitHandle( udg_hash, id, StringHash( "enbw" ), target )
    call SaveReal( udg_hash, id, StringHash( "enbw" ), dmg )
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( target ), StringHash( "enbw" ) ), t, false, function EnergyballWCast )
    
    if BuffLogic() then
        call effst( caster, target, "Trig_EnergyballW_Actions", lvl, t )
    endif
    
    set caster = null
    set target = null
endfunction

//===========================================================================
function InitTrig_EnergyballW takes nothing returns nothing
    set gg_trg_EnergyballW = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_EnergyballW, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_EnergyballW, Condition( function Trig_EnergyballW_Conditions ) )
    call TriggerAddAction( gg_trg_EnergyballW, function Trig_EnergyballW_Actions )
endfunction

