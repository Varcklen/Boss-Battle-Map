function Trig_OwlW_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A0E2'
endfunction

function OwlWCast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer( ) )
    local unit caster = LoadUnitHandle( udg_hash, id, StringHash( "owlw" ) )
    
    call UnitRemoveAbility( caster, 'A0EE' )
    call UnitRemoveAbility( caster, 'B003' ) 
    call FlushChildHashtable( udg_hash, id )
    
    set caster = null
endfunction

function Trig_OwlW_Actions takes nothing returns nothing
    local integer id
    local integer cyclA = 1
    local integer mana
    local unit caster
    local integer lvl
    local real t

    if CastLogic() then
        set caster = udg_Caster
        set lvl = udg_Level
        set t = udg_Time
    elseif RandomLogic() then
        set caster = udg_Caster
        set lvl = udg_Level
        call textst( udg_string[0] + GetObjectName('A0E2'), caster, 64, 90, 10, 1.5 )
        set t = 20
    else
        set caster = GetSpellAbilityUnit()
        set lvl = GetUnitAbilityLevel(GetSpellAbilityUnit(), GetSpellAbilityId())
        set t = 20
    endif
    set mana = 12 + ( lvl * 4 )
    
    set id = GetHandleId( caster )
    call UnitAddAbility( caster, 'A0EE' )
        
    if LoadTimerHandle( udg_hash, id, StringHash( "owlw" ) ) == null then
        call SaveTimerHandle( udg_hash, id, StringHash( "owlw" ), CreateTimer() )
    endif
    set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "owlw" ) ) ) 
    call SaveUnitHandle( udg_hash, id, StringHash( "owlw" ), caster )
    call SaveInteger( udg_hash, GetHandleId( caster ), StringHash( "owlw" ), mana )
    call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( caster ), StringHash( "owlw" ) ), t, false, function OwlWCast )
    call effst( caster, caster, null, lvl, t )

    set caster = null
endfunction

//===========================================================================
function InitTrig_OwlW takes nothing returns nothing
    set gg_trg_OwlW = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_OwlW, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_OwlW, Condition( function Trig_OwlW_Conditions ) )
    call TriggerAddAction( gg_trg_OwlW, function Trig_OwlW_Actions )
endfunction

