function Trig_SirenaR_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A05B'
endfunction

function SirenaRCast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer( ) )
    call UnitRemoveAbility( LoadUnitHandle( udg_hash, id, StringHash( "sirr" ) ), LoadInteger( udg_hash, id, StringHash( "sirr" ) ) )
    call UnitRemoveAbility( LoadUnitHandle( udg_hash, id, StringHash( "sirr" ) ), 'B007' )
    call FlushChildHashtable( udg_hash, id )
endfunction

function Trig_SirenaR_Actions takes nothing returns nothing
    local integer id
    local integer spb 
    local integer sp
    local unit caster
    local integer lvl
    local integer i
    local real t
    
    if CastLogic() then
        set caster = udg_Caster
        set lvl = udg_Level
        set t = udg_Time
    elseif RandomLogic() then
        set caster = udg_Caster
        set lvl = udg_Level
        call textst( udg_string[0] + GetObjectName('A05B'), caster, 64, 90, 10, 1.5 )
        set t = 30
    else
        set caster = GetSpellAbilityUnit()
        set lvl = GetUnitAbilityLevel(GetSpellAbilityUnit(), GetSpellAbilityId())
        set t = 30
    endif
    set t = timebonus(caster, t)
    
    set id = GetHandleId( caster )
    set i = 0
    
        set spb = 'A05A'
        set sp = 'A05D'
    call UnitAddAbility( caster, spb )
    call SetUnitAbilityLevel( caster, sp, lvl + i )
    
    if LoadTimerHandle( udg_hash, id, StringHash( "sirr" ) ) == null  then
        call SaveTimerHandle( udg_hash, id, StringHash( "sirr" ), CreateTimer() )
    endif
	set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "sirr" ) ) ) 
	call SaveUnitHandle( udg_hash, id, StringHash( "sirr" ), caster )
    call SaveInteger( udg_hash, id, StringHash( "sirr" ), spb )
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( caster ), StringHash( "sirr" ) ), t, false, function SirenaRCast )
    call effst( caster, caster, null, lvl, t )
    
    set caster = null
endfunction

//===========================================================================
function InitTrig_SirenaR takes nothing returns nothing
    set gg_trg_SirenaR = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_SirenaR, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_SirenaR, Condition( function Trig_SirenaR_Conditions ) )
    call TriggerAddAction( gg_trg_SirenaR, function Trig_SirenaR_Actions )
endfunction

