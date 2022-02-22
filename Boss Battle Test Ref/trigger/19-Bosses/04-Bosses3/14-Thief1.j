function Trig_Thief1_Conditions takes nothing returns boolean
    return GetUnitTypeId(udg_DamageEventTarget) == 'h015' and GetUnitLifePercent(udg_DamageEventTarget) <= 75
endfunction

function ThiefAoE takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local unit boss = LoadUnitHandle( udg_hash, id, StringHash( "bsth1" ) )
    local unit dummy = LoadUnitHandle( udg_hash, id, StringHash( "bsth1d" ) )
    local group g = CreateGroup()
    local unit u
    
    call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\Other\\HowlOfTerror\\HowlCaster.mdl", GetUnitX( dummy ), GetUnitY( dummy ) ) )
    
    call GroupEnumUnitsInRange( g, GetUnitX( dummy ), GetUnitY( dummy ), 125, null )
    loop
        set u = FirstOfGroup(g)
        exitwhen u == null
        if unitst( u, boss, "enemy" ) then
            call UnitDamageTarget( dummy, u, 200, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS)
        endif
        call GroupRemoveUnit(g,u)
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

function ThiefCast takes nothing returns nothing
    local integer cyclA = 1
    local integer id = GetHandleId( GetExpiredTimer() )
    local integer id1
    local unit boss = LoadUnitHandle( udg_hash, id, StringHash( "bsth" ) )
    
    if GetUnitState( boss, UNIT_STATE_LIFE) <= 0.405 or not( udg_fightmod[0] ) then
        call DestroyTimer( GetExpiredTimer() )
        call FlushChildHashtable( udg_hash, id )
    else
        loop
            exitwhen cyclA > 4
            if GetUnitState( udg_hero[cyclA], UNIT_STATE_LIFE) > 0.405 then
                set bj_lastCreatedUnit = CreateUnit( GetOwningPlayer( boss ), 'u000', GetUnitX( udg_hero[cyclA] ), GetUnitY( udg_hero[cyclA] ), 270 )
                if GetOwningPlayer(boss) == Player(10) then
                    call UnitAddAbility( bj_lastCreatedUnit, 'A136')
                endif
                
                set id1 = GetHandleId( udg_hero[cyclA] )
                if LoadTimerHandle( udg_hash, id1, StringHash( "bsth1" ) ) == null  then
                    call SaveTimerHandle( udg_hash, id1, StringHash( "bsth1" ), CreateTimer() )
                endif
                call SaveTimerHandle( udg_hash, id1, StringHash( "bsth1" ), CreateTimer() )
                set id1 = GetHandleId( LoadTimerHandle( udg_hash, id1, StringHash( "bsth1" ) ) ) 
                call SaveUnitHandle( udg_hash, id1, StringHash( "bsth1" ), boss )
                call SaveUnitHandle( udg_hash, id1, StringHash( "bsth1d" ), bj_lastCreatedUnit )
                call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( udg_hero[cyclA] ), StringHash( "bsth1" ) ), bosscast(3), false, function ThiefAoE )
            endif
            set cyclA = cyclA + 1
        endloop
    endif
    
    set boss = null
 endfunction   

function Trig_Thief1_Actions takes nothing returns nothing
    local integer id = GetHandleId( udg_DamageEventTarget )

    call DisableTrigger( GetTriggeringTrigger() )
    
    if LoadTimerHandle( udg_hash, id, StringHash( "bsth" ) ) == null  then
        call SaveTimerHandle( udg_hash, id, StringHash( "bsth" ), CreateTimer() )
    endif
	set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "bsth" ) ) ) 
    call SaveUnitHandle( udg_hash, id, StringHash( "bsth" ), udg_DamageEventTarget )
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( udg_DamageEventTarget ), StringHash( "bsth" ) ), bosscast(7), true, function ThiefCast )
endfunction

//===========================================================================
function InitTrig_Thief1 takes nothing returns nothing
    set gg_trg_Thief1 = CreateTrigger()
    call DisableTrigger( gg_trg_Thief1 )
    call TriggerRegisterVariableEvent( gg_trg_Thief1, "udg_AfterDamageEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_Thief1, Condition( function Trig_Thief1_Conditions ) )
    call TriggerAddAction( gg_trg_Thief1, function Trig_Thief1_Actions )
endfunction

