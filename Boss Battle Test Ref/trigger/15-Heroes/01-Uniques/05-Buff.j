function Trig_Buff_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A0GD' or GetSpellAbilityId() == 'A05Z'
endfunction

function BuffCast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer( ) )
    call UnitRemoveAbility( LoadUnitHandle( udg_hash, id, StringHash( "buff" ) ), LoadInteger( udg_hash, id, StringHash( "buff" ) ) )
    call UnitRemoveAbility( LoadUnitHandle( udg_hash, id, StringHash( "buff" ) ), 'B02H' )
    call FlushChildHashtable( udg_hash, id )
endfunction

function Trig_Buff_Actions takes nothing returns nothing
    local integer id 
    local integer sp
    local unit caster
    local unit target
    local real t
    
    if CastLogic() then
        set caster = udg_Caster
        set target = udg_Target
    elseif RandomLogic() then
        set caster = udg_Caster
        set target = randomtarget( caster, 900, "ally", "", "", "", "" )
        call textst( udg_string[0] + GetObjectName('A0GD'), caster, 64, 90, 10, 1.5 )
        if target == null then
            set caster = null
            return
        endif
    else
        set caster = GetSpellAbilityUnit()
        set target = GetSpellTargetUnit()
    endif
    set t = timebonus(caster, 15)
    
    set id = GetHandleId( target )
    
    if IsUniqueUpgraded(caster) then
        set sp = 'A0SU'
    else
        set sp = 'A0GE'
    endif
    
    call spectimeunit( target, "Abilities\\Spells\\Human\\Slow\\SlowCaster.mdl", "overhead", 1 )

    call UnitAddAbility( target, sp )
    if LoadTimerHandle( udg_hash, id, StringHash( "buff" ) ) == null  then
        call SaveTimerHandle( udg_hash, id, StringHash( "buff" ), CreateTimer() )
    endif
	set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "buff" ) ) ) 
	call SaveUnitHandle( udg_hash, id, StringHash( "buff" ), target )
    call SaveInteger( udg_hash, id, StringHash( "buff" ), sp )
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( target ), StringHash( "buff" ) ), t, false, function BuffCast )
    
    call effst( caster, target, null, 1, t )
    
    set caster = null
    set target = null
endfunction

//===========================================================================
function InitTrig_Buff takes nothing returns nothing
    set gg_trg_Buff = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Buff, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_Buff, Condition( function Trig_Buff_Conditions ) )
    call TriggerAddAction( gg_trg_Buff, function Trig_Buff_Actions )
endfunction

