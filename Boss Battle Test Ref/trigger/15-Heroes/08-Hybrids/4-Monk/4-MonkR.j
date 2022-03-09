function Trig_MonkR_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A0NR'
endfunction

function MonkRCast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer( ) )
    local unit u = LoadUnitHandle( udg_hash, id, StringHash( "mnkr" ) )
    
    call UnitRemoveAbility( u, 'A0KE' )
    call UnitRemoveAbility( u, 'B01O' )
    call FlushChildHashtable( udg_hash, id )
    
    set u = null
endfunction

function Trig_MonkR_Actions takes nothing returns nothing
    local integer cyclA = 1
    local integer id
    local integer lvl
    local unit caster
    local real t
    local integer i
    
    if CastLogic() then
        set caster = udg_Caster
        set lvl = udg_Level
        set t = udg_Time
    elseif RandomLogic() then
        set caster = udg_Caster
        set lvl = udg_Level
        call textst( udg_string[0] + GetObjectName('A0NR'), caster, 64, 90, 10, 1.5 )
        set t = 30
    else
        set caster = GetSpellAbilityUnit()
        set lvl = GetUnitAbilityLevel(GetSpellAbilityUnit(), GetSpellAbilityId())
        set t = 30
    endif
    set t = timebonus(caster, t)
    
    set id = GetHandleId( caster )
    call UnitAddAbility( caster, 'A0KE' )
    call DestroyEffect( AddSpecialEffectTarget("EarthDetonation.mdx", caster, "origin" ) )
    
    if LoadTimerHandle( udg_hash, id, StringHash( "mnkr" ) ) == null then
        call SaveTimerHandle( udg_hash, id, StringHash( "mnkr" ), CreateTimer() )
    endif
    set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "mnkr" ) ) ) 
    call SaveUnitHandle( udg_hash, id, StringHash( "mnkr" ), caster )
    call SaveInteger( udg_hash, id, StringHash( "mnkr" ), 4 + ( 2 * lvl ) )
    call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( caster ), StringHash( "mnkr" ) ), t, false, function MonkRCast )
    
    if BuffLogic() then
        call effst( caster, caster, "Trig_MonkR_Actions", lvl, t )
    endif
    
    set caster = null
endfunction

//===========================================================================
function InitTrig_MonkR takes nothing returns nothing
    set gg_trg_MonkR = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_MonkR, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_MonkR, Condition( function Trig_MonkR_Conditions ) )
    call TriggerAddAction( gg_trg_MonkR, function Trig_MonkR_Actions )
endfunction

