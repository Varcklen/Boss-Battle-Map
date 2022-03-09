function Trig_NerubW_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A0CW'
endfunction

function NerubWCast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer( ) )
    local real counter = LoadReal( udg_hash, id, StringHash( "nerwt" ) ) + 1
    local real counterEnd = LoadReal( udg_hash, id, StringHash( "nerwend" ) )
    local real heal = LoadReal( udg_hash, id, StringHash( "nerw" ) )
    local unit target = LoadUnitHandle( udg_hash, id, StringHash( "nerw" ) )
    local unit caster = LoadUnitHandle( udg_hash, id, StringHash( "nerw1" ) )

    if counter >= counterEnd or GetUnitState( target, UNIT_STATE_LIFE) <= 0.405 or GetUnitAbilityLevel( target, 'A0RK' ) == 0 then
        call UnitRemoveAbility( target, 'A0RK' )
        call UnitRemoveAbility( target, 'B022' )
        call DestroyTimer( GetExpiredTimer() )
        call FlushChildHashtable( udg_hash, id )
    else
        call healst( caster, target, heal )
        call SaveReal( udg_hash, id, StringHash( "nerwt" ), counter )
    endif
    
    set caster = null
    set target = null
endfunction

function Trig_NerubW_Actions takes nothing returns nothing
    local integer id
    local integer cyclA = 1
    local real heal
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
        call textst( udg_string[0] + GetObjectName('A0CW'), caster, 64, 90, 10, 1.5 )
        set t = 8 + (2*lvl)
    else
        set caster = GetSpellAbilityUnit()
        set lvl = GetUnitAbilityLevel(GetSpellAbilityUnit(), GetSpellAbilityId())
        set t = 8 + (2*lvl)
    endif
    set t = timebonus(caster, t)
    set heal = 0.005 * GetUnitState( caster, UNIT_STATE_MAX_LIFE)
    
    loop
        exitwhen cyclA > 4
        if GetUnitState(udg_hero[cyclA], UNIT_STATE_LIFE) > 0.405 and IsUnitAlly(udg_hero[cyclA], GetOwningPlayer( caster ) ) then
            set id = GetHandleId( udg_hero[cyclA] )
            call UnitAddAbility( udg_hero[cyclA], 'A0RK' )

            if LoadTimerHandle( udg_hash, id, StringHash( "nerw" ) ) == null then
                call SaveTimerHandle( udg_hash, id, StringHash( "nerw" ), CreateTimer() )
            endif
            set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "nerw" ) ) ) 
            call SaveUnitHandle( udg_hash, id, StringHash( "nerw" ), udg_hero[cyclA] )
            call SaveUnitHandle( udg_hash, id, StringHash( "nerw1" ), caster ) 
            call SaveReal( udg_hash, id, StringHash( "nerw" ), heal ) 
            call SaveReal( udg_hash, id, StringHash( "nerwend" ), t )
            call SaveReal( udg_hash, GetHandleId( udg_hero[cyclA] ), StringHash( "nerwd" ), 0.02 + (0.02*lvl) )
            call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( udg_hero[cyclA] ), StringHash( "nerw" ) ), 1, true, function NerubWCast )
            
            if BuffLogic() then
                call effst( caster, udg_hero[cyclA], null, lvl, t )
            endif
        endif
        set cyclA = cyclA + 1
    endloop
    
    set caster = null
endfunction

//===========================================================================
function InitTrig_NerubW takes nothing returns nothing
    set gg_trg_NerubW = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_NerubW, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_NerubW, Condition( function Trig_NerubW_Conditions ) )
    call TriggerAddAction( gg_trg_NerubW, function Trig_NerubW_Actions )
endfunction