function Trig_Metal_MageQ_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A0KM'
endfunction

function Metal_MageQCast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer( ) )
    call UnitRemoveAbility( LoadUnitHandle( udg_hash, id, StringHash( "mtmq" ) ), 'A0KP' )
    call UnitRemoveAbility( LoadUnitHandle( udg_hash, id, StringHash( "mtmq" ) ), 'B06H' )
    call FlushChildHashtable( udg_hash, id )
endfunction

function Trig_Metal_MageQ_Actions takes nothing returns nothing
    local integer cyclA = 1
    local integer id
    local integer lvl
    local unit caster
    local real t
    local unit u
    local integer d
    
    if CastLogic() then
        set caster = udg_Caster
        set lvl = udg_Level
        set t = udg_Time
    elseif RandomLogic() then
        set caster = udg_Caster
        set lvl = udg_Level
        call textst( udg_string[0] + GetObjectName('A0KM'), caster, 64, 90, 10, 1.5 )
        set t = 15
    else
        set caster = GetSpellAbilityUnit()
        set lvl = GetUnitAbilityLevel(GetSpellAbilityUnit(), GetSpellAbilityId())
        set t = 15
    endif
    set t = timebonus(caster, t)
    set d = R2I((25 + (25*lvl))*udg_SpellDamage[GetPlayerId( GetOwningPlayer(caster) ) + 1])

    set id = GetHandleId( caster )
    call UnitAddAbility( caster, 'A0KP' )
    call DestroyEffect( AddSpecialEffectTarget("DarkSwirl.mdx", caster, "overhead" ) )
    
    if LoadTimerHandle( udg_hash, id, StringHash( "mtmq" ) ) == null then
        call SaveTimerHandle( udg_hash, id, StringHash( "mtmq" ), CreateTimer() )
    endif
    set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "mtmq" ) ) ) 
    call SaveUnitHandle( udg_hash, id, StringHash( "mtmq" ), caster )
    call SaveInteger( udg_hash, id, StringHash( "mtmq" ), 3 )
    call SaveInteger( udg_hash, GetHandleId( caster ), StringHash( "mtmqd" ), d )
    call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( caster ), StringHash( "mtmq" ) ), t, false, function Metal_MageQCast )
    
    if BuffLogic() then
        call effst( caster, caster, null, lvl, t )
    endif
    
    set caster = null
    set u = null
endfunction

//===========================================================================
function InitTrig_Metal_MageQ takes nothing returns nothing
    set gg_trg_Metal_MageQ = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Metal_MageQ, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_Metal_MageQ, Condition( function Trig_Metal_MageQ_Conditions ) )
    call TriggerAddAction( gg_trg_Metal_MageQ, function Trig_Metal_MageQ_Actions )
endfunction

