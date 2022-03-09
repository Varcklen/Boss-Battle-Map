function Trig_MagnataurW_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A0VG'
endfunction

function MagnataurWCast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer( ) )
    call UnitRemoveAbility( LoadUnitHandle( udg_hash, id, StringHash( "mgtw" ) ), 'A0L6' )
    call UnitRemoveAbility( LoadUnitHandle( udg_hash, id, StringHash( "mgtw" ) ), 'B03O' )
    call FlushChildHashtable( udg_hash, id )
endfunction

function Trig_MagnataurW_Actions takes nothing returns nothing
    local integer id
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
        set target = randomtarget( caster, 300, "enemy", "", "", "", "" )
        set lvl = udg_Level
        call textst( udg_string[0] + GetObjectName('A0VG'), caster, 64, 90, 10, 1.5 )
        set t = 6 + lvl
        if target == null then
            set caster = null
            return
        endif
    else
        set caster = GetSpellAbilityUnit()
        set target = GetSpellTargetUnit()
        set lvl = GetUnitAbilityLevel(GetSpellAbilityUnit(), GetSpellAbilityId())
        set t = 6 + lvl
    endif
    set t = timebonus(caster, t)

    set id = GetHandleId( target )
    
    call UnitAddAbility( target, 'A0L6' )

    if LoadTimerHandle( udg_hash, id, StringHash( "mgtw" ) ) == null then
        call SaveTimerHandle( udg_hash, id, StringHash( "mgtw" ), CreateTimer() )
    endif
	set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "mgtw" ) ) ) 
	call SaveUnitHandle( udg_hash, id, StringHash( "mgtw" ), target )
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( target ), StringHash( "mgtw" ) ), t, false, function MagnataurWCast )
    
    if BuffLogic() then
        call debuffst( caster, target, null, lvl, t )
    endif
    
    set caster = null
    set target = null
endfunction

//===========================================================================
function InitTrig_MagnataurW takes nothing returns nothing
    set gg_trg_MagnataurW = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_MagnataurW, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_MagnataurW, Condition( function Trig_MagnataurW_Conditions ) )
    call TriggerAddAction( gg_trg_MagnataurW, function Trig_MagnataurW_Actions )
endfunction

