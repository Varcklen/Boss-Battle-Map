function Trig_War3_Conditions takes nothing returns boolean
    return GetUnitTypeId(udg_DamageEventTarget) == 'o011' and GetUnitLifePercent(udg_DamageEventTarget) <= 70
endfunction

function War3End takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local unit dummy = LoadUnitHandle( udg_hash, id, StringHash( "bswr4" ) )
    local integer id1
    local group g = CreateGroup()
    local unit u
    
    call GroupEnumUnitsInRange( g, GetUnitX( dummy ), GetUnitY( dummy ), 300, null )
    loop
        set u = FirstOfGroup(g)
        exitwhen u == null
        if unitst( u, dummy, "enemy" ) and udg_combatlogic[GetPlayerId( GetOwningPlayer( u ) ) + 1] then
            if not(IsUnitType( u, UNIT_TYPE_ANCIENT)) and not(IsUnitType( u, UNIT_TYPE_HERO)) and GetUnitTypeId(u) != 'u00X' then
                call SetUnitOwner( u, Player(PLAYER_NEUTRAL_AGGRESSIVE), true )
                call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\NightElf\\BattleRoar\\RoarCaster.mdl", GetUnitX( u ), GetUnitY( u ) ) )
            else
                if GetOwningPlayer(u) != Player(10) then
                    call berserk( u, 1 )
                endif
                call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\NightElf\\BattleRoar\\RoarCaster.mdl", GetUnitX( u ), GetUnitY( u ) ) )
                
                set id1 = GetHandleId( u ) 
                if LoadTimerHandle( udg_hash, id1, StringHash( "bsbk1" ) ) == null  then
                    call SaveTimerHandle( udg_hash, id1, StringHash( "bsbk1" ), CreateTimer() )
                endif
                set id1 = GetHandleId( LoadTimerHandle( udg_hash, id1, StringHash( "bsbk1" ) ) ) 
                call SaveUnitHandle( udg_hash, id1, StringHash( "bsbk1trg" ), u )
                call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( u ), StringHash( "bsbk1" ) ), 10, false, function BerserkEnd )
            endif
        endif
        call GroupRemoveUnit(g,u)
    endloop
    
    call RemoveUnit( dummy )
    call FlushChildHashtable( udg_hash, id )
    
    call GroupClear( g )
    call DestroyGroup( g )
    set u = null
    set g = null
    set dummy = null
endfunction

function War3Cast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local unit boss = LoadUnitHandle( udg_hash, id, StringHash( "bswr3" ) )
    local integer id1
    
    if GetUnitState( boss, UNIT_STATE_LIFE) <= 0.405 or not( udg_fightmod[0] ) then
        call DestroyTimer( GetExpiredTimer() )
        call FlushChildHashtable( udg_hash, id )
    else
        set bj_lastCreatedUnit = CreateUnit( GetOwningPlayer( boss ), 'u000', GetUnitX( boss ) + GetRandomReal(-400, 400), GetUnitY( boss ) + GetRandomReal(-400, 400), 270 )
        call SetUnitScale(bj_lastCreatedUnit, 3, 3, 3 )
        call UnitAddAbility( bj_lastCreatedUnit, 'A136')
        
        set id1 = GetHandleId( bj_lastCreatedUnit )
        if LoadTimerHandle( udg_hash, id1, StringHash( "bswr4" ) ) == null  then
            call SaveTimerHandle( udg_hash, id1, StringHash( "bswr4" ), CreateTimer() )
        endif
        set id1 = GetHandleId( LoadTimerHandle( udg_hash, id1, StringHash( "bswr4" ) ) ) 
        call SaveUnitHandle( udg_hash, id1, StringHash( "bswr4" ), bj_lastCreatedUnit )
        call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( bj_lastCreatedUnit ), StringHash( "bswr4" ) ), bosscast(3), false, function War3End )
    endif
    
    set boss = null
endfunction 

function Trig_War3_Actions takes nothing returns nothing
    local integer id = GetHandleId( udg_DamageEventTarget )

    call DisableTrigger( GetTriggeringTrigger() )
    
    if LoadTimerHandle( udg_hash, id, StringHash( "bswr3" ) ) == null  then
        call SaveTimerHandle( udg_hash, id, StringHash( "bswr3" ), CreateTimer() )
    endif
	set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "bswr3" ) ) ) 
    call SaveUnitHandle( udg_hash, id, StringHash( "bswr3" ), udg_DamageEventTarget )
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( udg_DamageEventTarget ), StringHash( "bswr3" ) ), bosscast(15), true, function War3Cast )
endfunction

//===========================================================================
function InitTrig_War3 takes nothing returns nothing
    set gg_trg_War3 = CreateTrigger(  )
    call DisableTrigger( gg_trg_War3 )
    call TriggerRegisterVariableEvent( gg_trg_War3, "udg_AfterDamageEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_War3, Condition( function Trig_War3_Conditions ) )
    call TriggerAddAction( gg_trg_War3, function Trig_War3_Actions )
endfunction

