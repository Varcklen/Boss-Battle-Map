function Trig_SeaGiant3_Conditions takes nothing returns boolean
    return GetUnitTypeId( udg_DamageEventTarget ) == 'n00W' and GetUnitLifePercent(udg_DamageEventTarget) <= 80
endfunction

function SeaGiant3End takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local unit boss = LoadUnitHandle( udg_hash, id, StringHash( "bssg4u" ) )
    local unit dummy = LoadUnitHandle( udg_hash, id, StringHash( "bssg4d" ) )
    local group g = CreateGroup()
    local unit u
    
    call DestroyEffect( AddSpecialEffect( "Objects\\Spawnmodels\\Naga\\NagaDeath\\NagaDeath.mdl", GetUnitX( dummy ), GetUnitY( dummy ) + 100 ) )
    call DestroyEffect( AddSpecialEffect( "Objects\\Spawnmodels\\Naga\\NagaDeath\\NagaDeath.mdl", GetUnitX( dummy ) + 140, GetUnitY( dummy ) - 140 ) )
    call DestroyEffect( AddSpecialEffect( "Objects\\Spawnmodels\\Naga\\NagaDeath\\NagaDeath.mdl", GetUnitX( dummy ) - 140, GetUnitY( dummy ) - 140 ) )
    call GroupEnumUnitsInRange( g, GetUnitX( dummy ), GetUnitY( dummy ), 300, null )
    loop
        set u = FirstOfGroup(g)
        exitwhen u == null
        if unitst( u, boss, "enemy" ) then
            call UnitDamageTarget( dummy, u, 300, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS)
        endif
        call GroupRemoveUnit(g,u)
        set u = FirstOfGroup(g)
    endloop
    
    call RemoveUnit( dummy )
    
    call FlushChildHashtable( udg_hash, id )
    call GroupClear( g )
    call DestroyGroup( g )
    set u = null
    set g = null
    set boss = null
    set dummy = null
endfunction 

function SeaGiant3Cast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local integer id1
    local unit boss = LoadUnitHandle( udg_hash, id, StringHash( "bssg4" ) )
    local integer cyclA
    local integer c
    local boolean l = LoadBoolean( udg_hash, id, StringHash( "bssg4" ) )

    if GetUnitState( boss, UNIT_STATE_LIFE) <= 0.405 or not( udg_fightmod[0] ) then
        call DestroyTimer( GetExpiredTimer() )
        call FlushChildHashtable( udg_hash, id )
    else
        if l then
            set c = LoadInteger( udg_hash, id, StringHash( "bssg4" ) ) - 1
        else
            set c = LoadInteger( udg_hash, id, StringHash( "bssg4" ) ) + 1
        endif
        if c >= 7 then
            set l = true
        elseif c <= 0 then
            set l = false
        endif
        call SaveInteger( udg_hash, id, StringHash( "bssg4" ), c )
        call SaveBoolean( udg_hash, id, StringHash( "bssg4" ), l )
        
        set cyclA = 0
        loop
            exitwhen cyclA > 7
            set bj_lastCreatedUnit = CreateUnit( GetOwningPlayer( boss ), 'u000', GetRectCenterX(udg_Boss_Rect)-1860+(500*c), GetRectCenterY(udg_Boss_Rect)-1860+(500*cyclA), 270 )
            call SetUnitScale(bj_lastCreatedUnit, 3, 3, 3 )
            call UnitAddAbility( bj_lastCreatedUnit, 'A136')
            
            set id1 = GetHandleId( bj_lastCreatedUnit )
            if LoadTimerHandle( udg_hash, id1, StringHash( "bssg4d" ) ) == null  then
                call SaveTimerHandle( udg_hash, id1, StringHash( "bssg4d" ), CreateTimer() )
            endif
            set id1 = GetHandleId( LoadTimerHandle( udg_hash, id1, StringHash( "bssg4d" ) ) ) 
            call SaveUnitHandle( udg_hash, id1, StringHash( "bssg4d" ), bj_lastCreatedUnit )
            call SaveUnitHandle( udg_hash, id1, StringHash( "bssg4u" ), boss )
            call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( bj_lastCreatedUnit ), StringHash( "bssg4d" ) ), bosscast(2), false, function SeaGiant3End )
            
            set bj_lastCreatedUnit = CreateUnit( GetOwningPlayer( boss ), 'u000', GetRectCenterX(udg_Boss_Rect)+1860-(500*c), GetRectCenterY(udg_Boss_Rect)-1860+(500*cyclA), 270 )
            call SetUnitScale(bj_lastCreatedUnit, 3, 3, 3 )
            call UnitAddAbility( bj_lastCreatedUnit, 'A136')
            
            set id1 = GetHandleId( bj_lastCreatedUnit )
            if LoadTimerHandle( udg_hash, id1, StringHash( "bssg4d" ) ) == null then 
                call SaveTimerHandle( udg_hash, id1, StringHash( "bssg4d" ), CreateTimer() )
            endif
            set id1 = GetHandleId( LoadTimerHandle( udg_hash, id1, StringHash( "bssg4d" ) ) ) 
            call SaveUnitHandle( udg_hash, id1, StringHash( "bssg4d" ), bj_lastCreatedUnit )
            call SaveUnitHandle( udg_hash, id1, StringHash( "bssg4u" ), boss )
            call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( bj_lastCreatedUnit ), StringHash( "bssg4d" ) ), bosscast(2), false, function SeaGiant3End )
            set cyclA = cyclA + 1
        endloop
    endif
    
    set boss = null
endfunction

function Trig_SeaGiant3_Actions takes nothing returns nothing
    local integer id = GetHandleId( udg_DamageEventTarget )

    call DisableTrigger( GetTriggeringTrigger() )
    call TransmissionFromUnitWithNameBJ( bj_FORCE_ALL_PLAYERS, udg_DamageEventTarget, GetUnitName(udg_DamageEventTarget), null, "You can’t hide from the wave!", bj_TIMETYPE_SET, 3, false )

    if LoadTimerHandle( udg_hash, id, StringHash( "bssg4" ) ) == null  then
        call SaveTimerHandle( udg_hash, id, StringHash( "bssg4" ), CreateTimer() )
    endif
	set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "bssg4" ) ) ) 
    call SaveUnitHandle( udg_hash, id, StringHash( "bssg4" ), udg_DamageEventTarget )
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( udg_DamageEventTarget ), StringHash( "bssg4" ) ), bosscast(2), true, function SeaGiant3Cast )
endfunction

//===========================================================================
function InitTrig_SeaGiant3 takes nothing returns nothing
    set gg_trg_SeaGiant3 = CreateTrigger(  )
    call DisableTrigger( gg_trg_SeaGiant3 )
    call TriggerRegisterVariableEvent( gg_trg_SeaGiant3, "udg_AfterDamageEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_SeaGiant3, Condition( function Trig_SeaGiant3_Conditions ) )
    call TriggerAddAction( gg_trg_SeaGiant3, function Trig_SeaGiant3_Actions )
endfunction

