function Trig_MentorQ_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A07W'
endfunction

function MentorQEnd takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer( ) )
    call UnitRemoveAbility( LoadUnitHandle( udg_hash, id, StringHash( "menq" ) ), 'A0HZ' )
    call UnitRemoveAbility( LoadUnitHandle( udg_hash, id, StringHash( "menq" ) ), 'B036' )
    call FlushChildHashtable( udg_hash, id )
endfunction

function Trig_MentorQ_Actions takes nothing returns nothing
    local integer id 
    local integer i
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
        call textst( udg_string[0] + GetObjectName('A07W'), caster, 64, 90, 10, 1.5 )
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
    
    call UnitAddAbility( target, 'A0HZ' )
    
   if LoadTimerHandle( udg_hash, id, StringHash( "menq" ) ) == null then
        call SaveTimerHandle( udg_hash, id, StringHash( "menq" ), CreateTimer() )
    endif
	set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "menq" ) ) ) 
	call SaveUnitHandle( udg_hash, id, StringHash( "menq" ), target )
    call SaveUnitHandle( udg_hash, id, StringHash( "menqc" ), caster )
    call SaveReal( udg_hash, id, StringHash( "menq1" ), 0.05 * lvl )
    call SaveReal( udg_hash, id, StringHash( "menq2" ), 0.1 + ( 0.1 * lvl ) )
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( target ), StringHash( "menq" ) ), t, false, function MentorQEnd )
    
    call effst( caster, target, null, lvl, t )
    
    set caster = null
    set target = null
endfunction

//===========================================================================
function InitTrig_MentorQ takes nothing returns nothing
    set gg_trg_MentorQ = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_MentorQ, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_MentorQ, Condition( function Trig_MentorQ_Conditions ) )
    call TriggerAddAction( gg_trg_MentorQ, function Trig_MentorQ_Actions )
endfunction

