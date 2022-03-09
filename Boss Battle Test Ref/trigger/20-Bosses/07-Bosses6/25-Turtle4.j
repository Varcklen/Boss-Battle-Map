function Trig_Turtle4_Conditions takes nothing returns boolean
    return GetUnitTypeId( udg_DamageEventTarget ) == 'h01R' and GetUnitLifePercent(udg_DamageEventTarget) <= 50
endfunction

function Turtle4End takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local unit u = LoadUnitHandle( udg_hash, id, StringHash( "bstt4" ) )
    
     if GetUnitState( u, UNIT_STATE_LIFE) <= 0.405 or not( udg_fightmod[0] ) then
        call DestroyTimer( GetExpiredTimer() )
        call FlushChildHashtable( udg_hash, id )
    else
        set bj_lastCreatedUnit = CreateUnit( GetOwningPlayer( u ), 'n03S', GetUnitX( u ), GetUnitY( u ), GetRandomReal( 0, 360 ) )
        call DestroyEffect( AddSpecialEffectTarget( "Abilities\\Spells\\Orc\\MirrorImage\\MirrorImageDeathCaster.mdl", bj_lastCreatedUnit, "origin") )
        call KillUnit( u )
    endif
    
    call FlushChildHashtable( udg_hash, id )

    set u = null
endfunction

function Trig_Turtle4_Actions takes nothing returns nothing
    local integer id = GetHandleId( udg_DamageEventTarget )
    local integer cyclA = 1
    local real x
    local real y

    call DisableTrigger( GetTriggeringTrigger() )

    loop
        exitwhen cyclA > 4
        if GetUnitState( udg_hero[cyclA], UNIT_STATE_LIFE) > 0.405 then
            set x = GetUnitX( udg_DamageEventTarget ) + 800 * Cos( ( 45 + ( 90 * cyclA ) ) * 0.0174 )
            set y = GetUnitY( udg_DamageEventTarget ) + 800 * Sin( ( 45 + ( 90 * cyclA ) ) * 0.0174 )
            set bj_lastCreatedUnit = CreateUnit( GetOwningPlayer( udg_DamageEventTarget ), 'h01S', x, y, 45 + ( 90 * cyclA ) )
            call PingMinimapLocForForceEx( bj_FORCE_ALL_PLAYERS, GetUnitLoc( bj_lastCreatedUnit ), 5, bj_MINIMAPPINGSTYLE_ATTACK, 100, 50, 50 )
            set id = GetHandleId( bj_lastCreatedUnit )
            
            if LoadTimerHandle( udg_hash, id, StringHash( "bstt4" ) ) == null  then
                call SaveTimerHandle( udg_hash, id, StringHash( "bstt4" ), CreateTimer() )
            endif
            set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "bstt4" ) ) ) 
            call SaveUnitHandle( udg_hash, id, StringHash( "bstt4" ), bj_lastCreatedUnit )
            call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( bj_lastCreatedUnit ), StringHash( "bstt4" ) ), bosscast(10), false, function Turtle4End )
        endif
        set cyclA = cyclA + 1
    endloop
    
    call DestroyEffect( AddSpecialEffect( "Void Teleport Caster.mdx", GetUnitX( udg_DamageEventTarget ), GetUnitY( udg_DamageEventTarget ) ) )
    call SetUnitPositionLoc( udg_DamageEventTarget, GetRandomLocInRect(udg_Boss_Rect) )
    call DestroyEffect( AddSpecialEffect( "Void Teleport Caster.mdx", GetUnitX( udg_DamageEventTarget ), GetUnitY( udg_DamageEventTarget ) ) )
endfunction

//===========================================================================
function InitTrig_Turtle4 takes nothing returns nothing
    set gg_trg_Turtle4 = CreateTrigger(  )
    call DisableTrigger( gg_trg_Turtle4 )
    call TriggerRegisterVariableEvent( gg_trg_Turtle4, "udg_AfterDamageEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_Turtle4, Condition( function Trig_Turtle4_Conditions ) )
    call TriggerAddAction( gg_trg_Turtle4, function Trig_Turtle4_Actions )
endfunction

