function Trig_Vigilance_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A0IA'
endfunction

function VigilanceCast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer( ) )
    local unit u = LoadUnitHandle( udg_hash, id, StringHash( "vgll" ) )
    
    call UnitRemoveAbility( u, 'A0GZ' )
    call UnitRemoveAbility( u, 'B06E' )
    call FlushChildHashtable( udg_hash, id )
    
    set u = null
endfunction

function Trig_Vigilance_Actions takes nothing returns nothing
    local integer id 
    local unit caster
    local unit target
    local real t
    
    if CastLogic() then
        set caster = udg_Caster
        set target = udg_Target
        set t = udg_Time
    elseif RandomLogic() then
        set caster = udg_Caster
        set target = randomtarget( caster, 900, "enemy", "", "", "", "" )
        call textst( udg_string[0] + GetObjectName('A0IA'), caster, 64, 90, 10, 1.5 )
        set t = 15
        if target == null then
            set caster = null
            return
        endif
    else
        set caster = GetSpellAbilityUnit()
        set target = GetSpellTargetUnit()
        set t = 15
    endif
    set id = GetHandleId( target )

    call UnitAddAbility( target, 'A0GZ' )
    if LoadTimerHandle( udg_hash, id, StringHash( "vgll" ) ) == null then
        call SaveTimerHandle( udg_hash, id, StringHash( "vgll" ), CreateTimer() )
    endif
	set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "vgll" ) ) ) 
	call SaveUnitHandle( udg_hash, id, StringHash( "vgll" ), target )
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( target ), StringHash( "vgll" ) ), t, false, function VigilanceCast )
    
    if BuffLogic() then
        call debuffst( caster, target, "Trig_Vigilance_Actions", 1, t )
    endif
    
    set caster = null
    set target = null
endfunction

//===========================================================================
function InitTrig_Vigilance takes nothing returns nothing
    set gg_trg_Vigilance = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Vigilance, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_Vigilance, Condition( function Trig_Vigilance_Conditions ) )
    call TriggerAddAction( gg_trg_Vigilance, function Trig_Vigilance_Actions )
endfunction

