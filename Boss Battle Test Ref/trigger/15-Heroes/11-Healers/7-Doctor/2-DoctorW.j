function Trig_DoctorW_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A049'
endfunction

function DoctorWCast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer( ) )
    local real counter = LoadReal( udg_hash, id, StringHash( "dctwt" ) )
    local unit u = LoadUnitHandle( udg_hash, id, StringHash( "dctw" ) )
    local unit caster = LoadUnitHandle( udg_hash, id, StringHash( "dctwc" ) )
    local real dmg = LoadReal( udg_hash, id, StringHash( "dctw" ) )
    local real heal = LoadReal( udg_hash, id, StringHash( "dctwh" ) )
    
    if GetUnitState( u, UNIT_STATE_LIFE) > 0.405 then
        call healst(caster, u, heal )
        call SetUnitState(u, UNIT_STATE_MANA, RMaxBJ(0,GetUnitState(u, UNIT_STATE_MANA) - dmg ))
    endif

    if counter > 1 and GetUnitState( u, UNIT_STATE_LIFE) > 0.405 and GetUnitAbilityLevel( u, 'A04B' ) > 0 then
        call SaveReal( udg_hash, id, StringHash( "dctwt" ), counter - 1 )
    else
        call UnitRemoveAbility( u, 'A04B' )
        call UnitRemoveAbility( u, 'B00X' )
        call DestroyTimer( GetExpiredTimer() )
        call FlushChildHashtable( udg_hash, id )
    endif
    
    set u = null
    set caster = null
endfunction

function Trig_DoctorW_Actions takes nothing returns nothing
    local integer id
    local integer cyclA = 1
    local real dmg
    local real heal
    local unit caster
    local unit target
    local integer lvl
    local real t

    if CastLogic() then
        set caster = udg_Caster
	set target = udg_Target
        set lvl = udg_Level
        set t = udg_Time
    elseif RandomLogic() then
        set caster = udg_Caster
	set target = randomtarget( caster, 900, "ally", "", "", "", "" )
        set lvl = udg_Level
        call textst( udg_string[0] + GetObjectName('A049'), caster, 64, 90, 10, 1.5 )
	set t = 5
	if target == null then
            set caster = null
            return
        endif
    else
        set caster = GetSpellAbilityUnit()
	set target = GetSpellTargetUnit()
        set lvl = GetUnitAbilityLevel(GetSpellAbilityUnit(), GetSpellAbilityId())
        set t = 5
    endif
    set t = timebonus(caster, t)
    set dmg = 3 + ( 2 * lvl )
    set heal = 35 + ( 15 * lvl )
    
    set id = GetHandleId( target )
    call UnitAddAbility( target, 'A04B' )
        
    if LoadTimerHandle( udg_hash, id, StringHash( "dctw" ) ) == null then
        call SaveTimerHandle( udg_hash, id, StringHash( "dctw" ), CreateTimer() )
    endif
    set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "dctw" ) ) ) 
    call SaveUnitHandle( udg_hash, id, StringHash( "dctw" ), target )
    call SaveUnitHandle( udg_hash, id, StringHash( "dctwc" ), caster )
    call SaveReal( udg_hash, id, StringHash( "dctw" ), dmg )
    call SaveReal( udg_hash, id, StringHash( "dctwh" ), heal )
    call SaveReal( udg_hash, id, StringHash( "dctwt" ), t )
    call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( target ), StringHash( "dctw" ) ), 1, true, function DoctorWCast )
    
    call effst( caster, target, null, lvl, t )

    set caster = null
    set target = null
endfunction

//===========================================================================
function InitTrig_DoctorW takes nothing returns nothing
    set gg_trg_DoctorW = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_DoctorW, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_DoctorW, Condition( function Trig_DoctorW_Conditions ) )
    call TriggerAddAction( gg_trg_DoctorW, function Trig_DoctorW_Actions )
endfunction

