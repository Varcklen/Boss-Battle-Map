function Trig_GoldBug_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A13Z'
endfunction

function GoldBugCast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer( ) )
    call UnitRemoveAbility( LoadUnitHandle( udg_hash, id, StringHash( "gb" ) ), 'A0JS' )
    call UnitRemoveAbility( LoadUnitHandle( udg_hash, id, StringHash( "gb" ) ), 'B01F' )
    call FlushChildHashtable( udg_hash, id )
endfunction

function Trig_GoldBug_Actions takes nothing returns nothing
    local integer id
    local unit caster
    local unit target
    local integer i = 1
    local integer x
    local real t
    
    
    if CastLogic() then
        set caster = udg_Caster
        set target = udg_Target
        set t = udg_Time
    elseif RandomLogic() then
        set caster = udg_Caster
        set target = randomtarget( caster, 900, "ally", "", "", "", "" )
        call textst( udg_string[0] + GetObjectName('A07A'), caster, 64, 90, 10, 1.5 )
        set t = 30
        if target == null then
            set caster = null
            return
        endif
    else
        set caster = GetSpellAbilityUnit()
        set target = GetSpellTargetUnit()
        set t = 30
    endif
    set t = timebonus(caster, t)

    set x = eyest( caster )
    set id = GetHandleId( target )

    if GetPlayerState(GetOwningPlayer( caster ), PLAYER_STATE_RESOURCE_GOLD ) >= 200 then
        set i = i + 1
    endif
    call UnitAddAbility( target, 'A0JS' )
    call SetUnitAbilityLevel( target, 'A0JP', i )
    
    if LoadTimerHandle( udg_hash, id, StringHash( "gb" ) ) == null then
        call SaveTimerHandle( udg_hash, id, StringHash( "gb" ), CreateTimer() )
    endif
	set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "gb" ) ) ) 
	call SaveUnitHandle( udg_hash, id, StringHash( "gb" ), target )
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( target ), StringHash( "gb" ) ), t, false, function GoldBugCast )
    
    call effst( caster, target, null, 1, t )

    set caster = null
    set target = null
endfunction

//===========================================================================
function InitTrig_GoldBug takes nothing returns nothing
    set gg_trg_GoldBug = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_GoldBug, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_GoldBug, Condition( function Trig_GoldBug_Conditions ) )
    call TriggerAddAction( gg_trg_GoldBug, function Trig_GoldBug_Actions )
endfunction

