function Trig_SunKingWxxx_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A02E'
endfunction

function SunKingWCast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer( ) )
    local unit u = LoadUnitHandle( udg_hash, id, StringHash( "snkw" ) )
    
	if GetUnitAbilityLevel( u, 'A02F' ) > 0 then
        call pausest( u, -1 )
        call UnitRemoveAbility( u, 'A02F' )
        call UnitRemoveAbility( u, 'A02G' )
        call UnitRemoveAbility( u, 'B08R' )
    endif
    call FlushChildHashtable( udg_hash, id )

	set u = null
endfunction

function Trig_SunKingWxxx_Actions takes nothing returns nothing 
    local unit caster
    local unit target
    local integer lvl
    local integer id
    local real t
    
    if CastLogic() then
        set caster = udg_Caster
        set target = udg_Target
        set lvl = udg_Level
        set t = udg_Time
    elseif RandomLogic() then
        set caster = udg_Caster
        set target = randomtarget( caster, 900, "ally", "notcaster", "hero", "", "" )
        set lvl = udg_Level
        call textst( udg_string[0] + GetObjectName('A02E'), caster, 64, 90, 10, 1.5 )
        set t = 4
        if target == null then
            set caster = null
            return
        endif
    else
        set caster = GetSpellAbilityUnit()
        set target = GetSpellTargetUnit()
        set lvl = GetUnitAbilityLevel(GetSpellAbilityUnit(), GetSpellAbilityId())
        set t = 4
    endif
    set t = timebonus(caster, t)
    
    set id = GetHandleId( target )
    
	if GetUnitAbilityLevel( target, 'A02F' ) == 0 then
        call pausest( target, 1 )
    endif
    call DestroyEffect( AddSpecialEffect( "Objects\\Spawnmodels\\NightElf\\NECancelDeath\\NECancelDeath.mdl", GetUnitX( target ), GetUnitY( target ) ) )
    call UnitAddAbility( target, 'A02F' )
    call UnitAddAbility( target, 'A02G' )
    
    if LoadTimerHandle( udg_hash, id, StringHash( "snkw" ) ) == null then
        call SaveTimerHandle( udg_hash, id, StringHash( "snkw" ), CreateTimer() )
    endif
	set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "snkw" ) ) ) 
	call SaveUnitHandle( udg_hash, id, StringHash( "snkw" ), target )
    call SaveReal( udg_hash, GetHandleId( target ), StringHash( "snkwh" ), 0.1 * lvl )
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( target ), StringHash( "snkw" ) ), t, false, function SunKingWCast )
    
    if BuffLogic() then
        call effst( caster, target, null, lvl, t )
    endif
    
    set caster = null
    set target = null
endfunction

//===========================================================================
function InitTrig_SunKingWxxx takes nothing returns nothing
    set gg_trg_SunKingWxxx = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_SunKingWxxx, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_SunKingWxxx, Condition( function Trig_SunKingWxxx_Conditions ) )
    call TriggerAddAction( gg_trg_SunKingWxxx, function Trig_SunKingWxxx_Actions )
endfunction

