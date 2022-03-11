function Trig_SniperW_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A0L1'
endfunction

function SniperWEnd takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer( ) )
    call UnitRemoveAbility( LoadUnitHandle( udg_hash, id, StringHash( "snpw1" ) ), 'A0L4' )
    call UnitRemoveAbility( LoadUnitHandle( udg_hash, id, StringHash( "snpw1" ) ), 'B030' )
    call FlushChildHashtable( udg_hash, id )
endfunction

function SniperWCast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local integer id1
    local integer lvl 
    local unit caster
    local real t
    
    if CastLogic() then
        set caster = udg_Target
        set t = udg_Time
        set lvl = udg_Level
        set id1 = GetHandleId( caster )
    else
        set caster = LoadUnitHandle( udg_hash, id, StringHash( "snpw" ) )
        set t = 12
        set lvl = LoadInteger( udg_hash, id, StringHash( "snpw" ) )
        set id1 = GetHandleId( LoadUnitHandle( udg_hash, id, StringHash( "snpw" ) ) )
    endif
    set t = timebonus(caster, t)

    if GetUnitAbilityLevel( caster, 'B02Z') == 0 and GetUnitState( caster, UNIT_STATE_LIFE) > 0.405 then
        call UnitAddAbility( caster, 'A0L4' )
        call SetUnitAbilityLevel( caster, 'A0L8', lvl )
        
        if LoadTimerHandle( udg_hash, id1, StringHash( "snpw1" ) ) == null then
            call SaveTimerHandle( udg_hash, id1, StringHash( "snpw1" ), CreateTimer() )
        endif
        set id1 = GetHandleId( LoadTimerHandle( udg_hash, id1, StringHash( "snpw1" ) ) )
        call SaveUnitHandle( udg_hash, id1, StringHash( "snpw1" ), caster )
	call SaveReal( udg_hash, GetHandleId( caster ), StringHash( "snpw1m" ), 0.02+(0.02 * lvl) )
        call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( caster ), StringHash( "snpw1" ) ), t, false, function SniperWEnd )
        call DestroyTimer( GetExpiredTimer() )
        call FlushChildHashtable( udg_hash, id )
        
        if BuffLogic() then
            call effst( caster, caster, "SniperWCast", lvl, t )
        endif
    endif
    
    set caster = null
endfunction

function Trig_SniperW_Actions takes nothing returns nothing
    local integer id
    local integer lvl
    local unit caster
    local real dmg 
    local group g 
    local unit u
    
    if CastLogic() then
        set caster = udg_Caster
        set lvl = udg_Level
    elseif RandomLogic() then
        set caster = udg_Caster
        set lvl = udg_Level
        call textst( udg_string[0] + GetObjectName('A0L1'), caster, 64, 90, 10, 1.5 )
    else
        set caster = GetSpellAbilityUnit()
        set lvl = GetUnitAbilityLevel(GetSpellAbilityUnit(), GetSpellAbilityId())
    endif

    set id = GetHandleId( caster )
    
    call shadowst( caster )
    call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Orc\\MirrorImage\\MirrorImageDeathCaster.mdl", caster, "origin"))
    call dummyspawn( caster, 1, 'A0L2', 0, 0 )
    call IssueTargetOrder( bj_lastCreatedUnit, "invisibility", caster )
    
    if LoadTimerHandle( udg_hash, id, StringHash( "snpw" ) ) == null then 
        call SaveTimerHandle( udg_hash, id, StringHash( "snpw" ), CreateTimer() )
    endif
	set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "snpw" ) ) ) 
	call SaveUnitHandle( udg_hash, id, StringHash( "snpw" ), caster )
    call SaveInteger( udg_hash, id, StringHash( "snpw" ), lvl )
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( caster ), StringHash( "snpw" ) ), 1, true, function SniperWCast )
    
    set caster = null
endfunction

//===========================================================================
function InitTrig_SniperW takes nothing returns nothing
    set gg_trg_SniperW = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_SniperW, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_SniperW, Condition( function Trig_SniperW_Conditions ) )
    call TriggerAddAction( gg_trg_SniperW, function Trig_SniperW_Actions )
endfunction

