function Trig_Debuff_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A0GF' or GetSpellAbilityId() == 'A035'
endfunction

function DebuffCast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer( ) )
    call UnitRemoveAbility( LoadUnitHandle( udg_hash, id, StringHash( "dbff" ) ), LoadInteger( udg_hash, id, StringHash( "dbff" ) ) )
    call UnitRemoveAbility( LoadUnitHandle( udg_hash, id, StringHash( "dbff" ) ), 'B02I' )
    call FlushChildHashtable( udg_hash, id )
endfunction

function Trig_Debuff_Actions takes nothing returns nothing
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
        set target = randomtarget( caster, 900, "enemy", "org", "", "", "" )
        call textst( udg_string[0] + GetObjectName('A0GF'), caster, 64, 90, 10, 1.5 )
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
        set sp = 'A0LV'
    else
        set sp = 'A0KN'
    endif
    
    call spectimeunit( target, "Abilities\\Spells\\Undead\\DeathandDecay\\DeathandDecayTarget.mdl", "overhead", 2 )

    call UnitAddAbility( target, sp )
    if LoadTimerHandle( udg_hash, id, StringHash( "dbff" ) ) == null then
        call SaveTimerHandle( udg_hash, id, StringHash( "dbff" ), CreateTimer() )
    endif
	set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "dbff" ) ) ) 
	call SaveUnitHandle( udg_hash, id, StringHash( "dbff" ), target )
    call SaveInteger( udg_hash, id, StringHash( "dbff" ), sp )
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( target ), StringHash( "dbff" ) ), t, false, function DebuffCast )
    
    call debuffst( caster, target, null, 1, t )
    
    set caster = null
    set target = null
endfunction

//===========================================================================
function InitTrig_Debuff takes nothing returns nothing
    set gg_trg_Debuff = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Debuff, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_Debuff, Condition( function Trig_Debuff_Conditions ) )
    call TriggerAddAction( gg_trg_Debuff, function Trig_Debuff_Actions )
endfunction

