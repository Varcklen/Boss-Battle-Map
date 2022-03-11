function Trig_DoctorR_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A04K'
endfunction

function DoctorREnd takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer( ) )
    local unit caster = LoadUnitHandle( udg_hash, id, StringHash( "dctr" ) )
    
    call UnitRemoveAbility( caster, 'A05X' )
    call UnitRemoveAbility( caster, 'B047' )
    call FlushChildHashtable( udg_hash, id )
    
    set caster = null
endfunction

function Trig_DoctorR_Actions takes nothing returns nothing
    local integer id
    local real i
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
        set target = randomtarget( caster, 900, "ally", "hero", "", "", "" )
        set lvl = udg_Level
        call textst( udg_string[0] + GetObjectName('A04K'), caster, 64, 90, 10, 1.5 )
        set t = 15
        if target == null then
            set caster = null
            return
        endif
    else
        set caster = GetSpellAbilityUnit()
        set target = GetSpellTargetUnit()
        set lvl = GetUnitAbilityLevel(GetSpellAbilityUnit(), GetSpellAbilityId())
        set t = 15
    endif
    set t = timebonus(caster, t)
    set i = 0.1 + (0.05*lvl)
    
    call UnitAddAbility( target, 'A05X' )
    call SetUnitAbilityLevel( target, 'A04M', lvl )
    if LoadTimerHandle( udg_hash, GetHandleId( target ), StringHash( "dctr" ) ) == null  then
        call SaveTimerHandle( udg_hash, GetHandleId( target ), StringHash( "dctr" ), CreateTimer() )
    endif
    set id = GetHandleId( LoadTimerHandle(udg_hash, GetHandleId( target ), StringHash( "dctr" ) ) )
    call SaveUnitHandle( udg_hash, id, StringHash( "dctr" ), target )
    call SaveReal( udg_hash, GetHandleId( target ), StringHash( "dctr" ), i )
    call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( target ), StringHash( "dctr" ) ), t, false, function DoctorREnd )
    
    if BuffLogic() then
        call effst( caster, target, "Trig_DoctorR_Actions", lvl, t )
    endif
    
    set caster = null
    set target = null
endfunction

//===========================================================================
function InitTrig_DoctorR takes nothing returns nothing
    set gg_trg_DoctorR = CreateTrigger( )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_DoctorR, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_DoctorR, Condition( function Trig_DoctorR_Conditions ) )
    call TriggerAddAction( gg_trg_DoctorR, function Trig_DoctorR_Actions )
endfunction

