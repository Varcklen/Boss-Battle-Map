function Trig_ShadowArcherW_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A0I6'
endfunction

function ShadowArcherWCast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer( ) )
    call UnitRemoveAbility( LoadUnitHandle( udg_hash, id, StringHash( "sdaw" ) ), 'A0J0' )
    call UnitRemoveAbility( LoadUnitHandle( udg_hash, id, StringHash( "sdaw" ) ), 'B04F' )
    call FlushChildHashtable( udg_hash, id )
endfunction

function Trig_ShadowArcherW_Actions takes nothing returns nothing
    local integer id 
    local integer lvl
    local unit caster
    local real t
    
    if CastLogic() then
        set caster = udg_Caster
        set lvl = udg_Level
        set t = udg_Time
    elseif RandomLogic() then
        set caster = udg_Caster
        set lvl = udg_Level
        call textst( udg_string[0] + GetObjectName('A0I6'), caster, 64, 90, 10, 1.5 )
        set t = 8
    else
        set caster = GetSpellAbilityUnit()
        set lvl = GetUnitAbilityLevel(GetSpellAbilityUnit(), GetSpellAbilityId() )
        set t = 8
    endif
    set t = timebonus(caster, t)
    
    set id = GetHandleId( caster )
    call dummyspawn( caster, 1, 'A0J2', 0, 0 )
    call IssueTargetOrder( bj_lastCreatedUnit, "invisibility", caster )
    call shadowst( caster )
    
    call UnitAddAbility( caster, 'A0J0' )
    call SetUnitAbilityLevel( caster, 'A0J4', lvl )
    
    if LoadTimerHandle( udg_hash, id, StringHash( "sdaw" ) ) == null then 
        call SaveTimerHandle( udg_hash, id, StringHash( "sdaw" ), CreateTimer() )
    endif
	set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "sdaw" ) ) ) 
	call SaveUnitHandle( udg_hash, id, StringHash( "sdaw" ), caster )
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( caster ), StringHash( "sdaw" ) ), t, false, function ShadowArcherWCast )
    
    if BuffLogic() then
        call effst( caster, caster, "Trig_ShadowArcherW_Actions", lvl, t )
    endif
    
    set caster = null
endfunction

//===========================================================================
function InitTrig_ShadowArcherW takes nothing returns nothing
    set gg_trg_ShadowArcherW = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_ShadowArcherW, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_ShadowArcherW, Condition( function Trig_ShadowArcherW_Conditions ) )
    call TriggerAddAction( gg_trg_ShadowArcherW, function Trig_ShadowArcherW_Actions )
endfunction

