function Trig_SirenaP_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A022'
endfunction

function SirenaPCast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer( ) )
	local unit u = LoadUnitHandle( udg_hash, id, StringHash( "sirp" ) )
	local real heal = LoadReal( udg_hash, id, StringHash( "sirp" ) )

    call healst( u, null, heal )
    if GetUnitAbilityLevel( u, 'B006' ) == 0 then
        call DestroyTimer( GetExpiredTimer( ) )
        call FlushChildHashtable( udg_hash, id ) 
    endif

	set u = null
endfunction

function Trig_SirenaP_Actions takes nothing returns nothing
    local integer id
    local unit caster
    local integer lvl
    local real t
    local real hp

    if CastLogic() then
        set caster = udg_Caster
	set lvl = udg_Level
	set t = udg_Time
    elseif RandomLogic() then
        set caster = udg_Caster
        call textst( udg_string[0] + GetObjectName('A022'), caster, 64, 90, 10, 1.5 )
	set lvl = udg_Level
	set t = 6
    else
        set caster = GetSpellAbilityUnit()
	set lvl = GetUnitAbilityLevel( caster, 'A022' )
        set t = 6
    endif
    set t = timebonus(caster, t)
    
    set hp = (0.005 + ( 0.015 * lvl )) * GetUnitState(caster, UNIT_STATE_MAX_LIFE)

    set id = GetHandleId( caster )
    
    call dummyspawn( caster, 1, 'A00I', 0, 0 )
    call shadowst( caster )
    call IssueTargetOrder( bj_lastCreatedUnit, "invisibility", caster )
    
    call SaveTimerHandle( udg_hash, id, StringHash( "sirp" ), CreateTimer( ) ) 
	set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "sirp" ) ) ) 
    call SaveUnitHandle( udg_hash, id, StringHash( "sirp" ), caster )
    call SaveReal( udg_hash, id, StringHash( "sirp" ), hp )
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( caster ), StringHash( "sirp" ) ), 1, true, function SirenaPCast ) 
    
    if BuffLogic() then
        call effst( caster, caster, "Trig_SirenaP_Actions", lvl, t )
    endif
    
    set caster = null
endfunction

//===========================================================================
function InitTrig_SirenaP takes nothing returns nothing
    set gg_trg_SirenaP = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_SirenaP, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_SirenaP, Condition( function Trig_SirenaP_Conditions ) )
    call TriggerAddAction( gg_trg_SirenaP, function Trig_SirenaP_Actions )
endfunction

