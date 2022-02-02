function Trig_War1_Conditions takes nothing returns boolean
    return GetUnitTypeId(udg_DamageEventTarget) == 'o011'
endfunction

function War1Light takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    call DestroyLightning( LoadLightningHandle( udg_hash, id, StringHash( "enba" ) ) )
    call FlushChildHashtable( udg_hash, id )
endfunction

function War1Cast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local integer id1
    local unit boss = LoadUnitHandle( udg_hash, id, StringHash( "bswr" ) )
    local lightning l
    local integer cyclA
    local unit u = null
    
    if GetUnitState( boss, UNIT_STATE_LIFE) <= 0.405 or not( udg_fightmod[0] ) then
        call DestroyTimer( GetExpiredTimer() )
        call FlushChildHashtable( udg_hash, id )
    else
        set cyclA = 1
        loop
            exitwhen cyclA > 4
            if GetUnitState( udg_hero[cyclA], UNIT_STATE_LIFE ) > 0.405 and GetUnitLifePercent(udg_hero[cyclA]) >= GetUnitLifePercent(udg_hero[cyclA - 1] ) and GetUnitLifePercent(udg_hero[cyclA]) >= GetUnitLifePercent(udg_hero[cyclA - 2] ) and GetUnitLifePercent(udg_hero[cyclA]) >= GetUnitLifePercent(udg_hero[cyclA - 3] ) then
                set u = udg_hero[cyclA]
            endif
            set cyclA = cyclA + 1
        endloop
        
        if u != null then
            set l = AddLightningEx("AFOD", true, GetUnitX(boss), GetUnitY(boss), GetUnitFlyHeight(boss) + 50, GetUnitX(u), GetUnitY(u), GetUnitFlyHeight(u) + 50 )
            
            set id1 = GetHandleId( l )
            if LoadTimerHandle( udg_hash, id1, StringHash( "enba" ) ) == null  then
                call SaveTimerHandle( udg_hash, id1, StringHash( "enba" ), CreateTimer() )
            endif
            set id1 = GetHandleId( LoadTimerHandle( udg_hash, id1, StringHash( "enba" ) ) ) 
            call SaveLightningHandle( udg_hash, id1, StringHash( "enba" ), l )
            call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( l ), StringHash( "enba" ) ), 0.5, false, function War1Light )
            
            call DestroyEffect( AddSpecialEffect("Objects\\Spawnmodels\\Orc\\OrcSmallDeathExplode\\OrcSmallDeathExplode.mdl", GetUnitX( u ), GetUnitY( u ) ) )
            call SetUnitState( u, UNIT_STATE_LIFE, RMaxBJ(0,GetUnitState( u, UNIT_STATE_LIFE) - ( GetUnitState( u, UNIT_STATE_MAX_LIFE) * 0.5 ) ) )
        endif
    endif
    
    set l = null
    set u = null
    set boss = null
endfunction 

function Trig_War1_Actions takes nothing returns nothing
    local integer id = GetHandleId( udg_DamageEventTarget )

    call DisableTrigger( GetTriggeringTrigger() )
    
    if LoadTimerHandle( udg_hash, id, StringHash( "bswr" ) ) == null  then
        call SaveTimerHandle( udg_hash, id, StringHash( "bswr" ), CreateTimer() )
    endif
	set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "bswr" ) ) ) 
    call SaveUnitHandle( udg_hash, id, StringHash( "bswr" ), udg_DamageEventTarget )
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( udg_DamageEventTarget ), StringHash( "bswr" ) ), bosscast(20), true, function War1Cast )
endfunction

//===========================================================================
function InitTrig_War1 takes nothing returns nothing
    set gg_trg_War1 = CreateTrigger(  )
    call DisableTrigger( gg_trg_War1 )
    call TriggerRegisterVariableEvent( gg_trg_War1, "udg_AfterDamageEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_War1, Condition( function Trig_War1_Conditions ) )
    call TriggerAddAction( gg_trg_War1, function Trig_War1_Actions )
endfunction

