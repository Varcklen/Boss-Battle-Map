function Trig_Crusher_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A177'
endfunction

function CrusherCast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer( ) )
    call UnitRemoveAbility( LoadUnitHandle( udg_hash, id, StringHash( "crush" ) ), 'A179' )
    call UnitRemoveAbility( LoadUnitHandle( udg_hash, id, StringHash( "crush" ) ), 'B07H' )
    call FlushChildHashtable( udg_hash, id )
endfunction

function Trig_Crusher_Actions takes nothing returns nothing
    local integer id
    local unit caster
    local unit target
    local integer x
    local real t
    local boolean l = false
    
    if CastLogic() then
        set caster = udg_Caster
        set target = udg_Target
        set t = udg_Time
    elseif RandomLogic() then
        set caster = udg_Caster
        set target = randomtarget( caster, 900, "all", "", "", "", "" )
        call textst( udg_string[0] + GetObjectName('A177'), caster, 64, 90, 10, 1.5 )
        set t = 20
        if target == null then
            set caster = null
            return
        endif
    else
        set caster = GetSpellAbilityUnit()
        set target = GetSpellTargetUnit()
        set t = 20
    endif
    set t = timebonus( caster, t )
    set id = GetHandleId( target )
    set x = eyest( caster )

    call UnitAddAbility( target, 'A179' )
    if IsUnitAlly( target, GetOwningPlayer( caster ) ) then
        call SetUnitAbilityLevel( target, 'A178', 2 )
        set l = true
    endif
    
    if LoadTimerHandle( udg_hash, id, StringHash( "crush" ) ) == null then
        call SaveTimerHandle( udg_hash, id, StringHash( "crush" ), CreateTimer() )
    endif
	set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "crush" ) ) ) 
	call SaveUnitHandle( udg_hash, id, StringHash( "crush" ), target )
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( target ), StringHash( "crush" ) ), t, false, function CrusherCast )
    
    if BuffLogic() then
        if l then
            call effst( caster, target, "Trig_Crusher_Actions", 1, t )
        else
            call debuffst( caster, target, "Trig_Crusher_Actions", 1, t )
        endif
    endif

    set caster = null
    set target = null
endfunction

//===========================================================================
function InitTrig_Crusher takes nothing returns nothing
    set gg_trg_Crusher = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Crusher, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_Crusher, Condition( function Trig_Crusher_Conditions ) )
    call TriggerAddAction( gg_trg_Crusher, function Trig_Crusher_Actions )
endfunction

