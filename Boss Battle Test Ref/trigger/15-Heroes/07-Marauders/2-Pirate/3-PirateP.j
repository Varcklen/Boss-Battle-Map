function Trig_PirateP_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A01F' 
endfunction

function PiratePEnd takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer( ) )

    call GroupRemoveUnit( udg_BlackMark, LoadUnitHandle( udg_hash, id, StringHash( "pmt" ) ) )
    call UnitRemoveAbility( LoadUnitHandle( udg_hash, id, StringHash( "pmt" ) ), 'A07V' )
    call UnitRemoveAbility( LoadUnitHandle( udg_hash, id, StringHash( "pmt" ) ), 'B01I' )
    call FlushChildHashtable( udg_hash, id )
endfunction

function Trig_PirateP_Actions takes nothing returns nothing
	local integer id
    local unit caster
    local unit target
    local integer lvl
    local integer money
    local real t
    
    if CastLogic() then
        set caster = udg_Caster
        set target = udg_Target
        set lvl = udg_Level
        set t = udg_Time
    elseif RandomLogic() then
        set caster = udg_Caster
        set target = randomtarget( caster, 900, "enemy", "", "", "", "" )
        set lvl = udg_Level
        set t = 20
        call textst( udg_string[0] + GetObjectName('A01F'), caster, 64, 90, 10, 1.5 )
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
    set money = (6 * lvl) + 12
    set id = GetHandleId( target )
    
    call UnitAddAbility( target, 'A07V' )
    call SetUnitAbilityLevel( target, 'A07S', lvl )
    call GroupAddUnit( udg_BlackMark, target )
    if LoadTimerHandle( udg_hash, id, StringHash( "pmt" ) ) == null then
        call SaveTimerHandle( udg_hash, id, StringHash( "pmt" ), CreateTimer() )
    endif
    set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "pmt" ) ) )
    call SaveUnitHandle( udg_hash, id, StringHash( "pmt" ), target )
    call SaveInteger( udg_hash, id, StringHash( "pmt" ), money )
    call SaveInteger( udg_hash, id, StringHash( "pmtlvl" ), lvl )
    call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( target ), StringHash( "pmt" ) ), t, false, function PiratePEnd )
    if BuffLogic() then
        call debuffst( caster, target, "Trig_PirateP_Actions", lvl, t )
    endif
    
    set caster = null
    set target = null
endfunction

//===========================================================================
function InitTrig_PirateP takes nothing returns nothing
    set gg_trg_PirateP = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_PirateP, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_PirateP, Condition( function Trig_PirateP_Conditions ) )
    call TriggerAddAction( gg_trg_PirateP, function Trig_PirateP_Actions )
endfunction

