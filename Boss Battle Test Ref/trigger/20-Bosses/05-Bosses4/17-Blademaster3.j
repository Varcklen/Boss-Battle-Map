function Trig_Blademaster3_Conditions takes nothing returns boolean
    return GetUnitTypeId(udg_DamageEventTarget) == 'e001' and GetUnitLifePercent(udg_DamageEventTarget) <= 80
endfunction

function Blade2Debuff takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer( ) )
    local unit u = LoadUnitHandle( udg_hash, id, StringHash( "bsbmd2" ) )
    
    call UnitRemoveAbility( u, 'A06V' )
    call UnitRemoveAbility( u, 'B011' )
    call FlushChildHashtable( udg_hash, id )
    
    set u = null
endfunction

function Blade2End takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local unit dummy = LoadUnitHandle( udg_hash, id, StringHash( "bsbmd1" ) )
    local integer id1
    local boolean l = false
    local group g = CreateGroup()
    local unit u
    
    if GetUnitState( dummy, UNIT_STATE_LIFE) <= 0.405 or not( udg_fightmod[0] ) then
        call DestroyTimer( GetExpiredTimer() )
        call FlushChildHashtable( udg_hash, id )
    else
        call GroupEnumUnitsInRange( g, GetUnitX( dummy ), GetUnitY( dummy ), 128, null )
        loop
            set u = FirstOfGroup(g)
            exitwhen u == null
            if unitst( u, dummy, "enemy" ) then
                call DestroyEffect(AddSpecialEffectTarget( "Abilities\\Spells\\Orc\\MirrorImage\\MirrorImageDeathCaster.mdl", u, "origin") )
                set l = true
                call UnitAddAbility( u, 'A06V')
        	
                set id1  = GetHandleId( u )
                if LoadTimerHandle( udg_hash, id1, StringHash( "bsbmd2" ) ) == null  then
                    call SaveTimerHandle( udg_hash, id1, StringHash( "bsbmd2" ), CreateTimer() )
                endif
                set id1 = GetHandleId( LoadTimerHandle( udg_hash, id1, StringHash( "bsbmd2" ) ) ) 
                call SaveUnitHandle( udg_hash, id1, StringHash( "bsbmd2" ), u )
                call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( u ), StringHash( "bsbmd2" ) ), 5, true, function Blade2Debuff )
            endif
            call GroupRemoveUnit(g,u)
            set u = FirstOfGroup(g)
        endloop
        if l then
            call RemoveUnit( dummy )
            call DestroyTimer( GetExpiredTimer() )
            call FlushChildHashtable( udg_hash, id )
        endif
    endif
    
    call GroupClear( g )
    call DestroyGroup( g )
    set u = null
    set g = null
    set dummy = null
endfunction

function Blade2Cast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local unit boss = LoadUnitHandle( udg_hash, id, StringHash( "bsbm3" ) )
    local integer id1

    if GetUnitState( boss, UNIT_STATE_LIFE) <= 0.405 or not( udg_fightmod[0] ) then
        call DestroyTimer( GetExpiredTimer() )
        call FlushChildHashtable( udg_hash, id )
    else
        set bj_lastCreatedUnit = CreateUnit( GetOwningPlayer( boss ), 'u000', GetUnitX( boss ) + GetRandomReal(-900, 900), GetUnitY( boss ) + GetRandomReal(-400, 400), 270 )
        call UnitAddAbility( bj_lastCreatedUnit, 'A0WA')
        call DestroyEffect( AddSpecialEffectTarget( "Abilities\\Spells\\Orc\\MirrorImage\\MirrorImageDeathCaster.mdl", bj_lastCreatedUnit, "origin") )
        set id1 = GetHandleId( bj_lastCreatedUnit )
        
        if LoadTimerHandle( udg_hash, id1, StringHash( "bsbmd1" ) ) == null  then
            call SaveTimerHandle( udg_hash, id1, StringHash( "bsbmd1" ), CreateTimer() )
        endif
        set id1 = GetHandleId( LoadTimerHandle( udg_hash, id1, StringHash( "bsbmd1" ) ) ) 
        call SaveUnitHandle( udg_hash, id1, StringHash( "bsbmd1" ), bj_lastCreatedUnit )
        call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( bj_lastCreatedUnit ), StringHash( "bsbmd1" ) ), 0.5, true, function Blade2End )
    endif
    
    set boss = null
endfunction

function Trig_Blademaster3_Actions takes nothing returns nothing
    local integer id = GetHandleId( udg_DamageEventTarget )

    call DisableTrigger( GetTriggeringTrigger() )
    
    if LoadTimerHandle( udg_hash, id, StringHash( "bsbm3" ) ) == null  then
        call SaveTimerHandle( udg_hash, id, StringHash( "bsbm3" ), CreateTimer() )
    endif
	set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "bsbm3" ) ) ) 
    call SaveUnitHandle( udg_hash, id, StringHash( "bsbm3" ), udg_DamageEventTarget )
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( udg_DamageEventTarget ), StringHash( "bsbm3" ) ), bosscast(8), true, function Blade2Cast )
endfunction

//===========================================================================
function InitTrig_Blademaster3 takes nothing returns nothing
    set gg_trg_Blademaster3 = CreateTrigger(  )
    call DisableTrigger( gg_trg_Blademaster3 )
    call TriggerRegisterVariableEvent( gg_trg_Blademaster3, "udg_AfterDamageEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_Blademaster3, Condition( function Trig_Blademaster3_Conditions ) )
    call TriggerAddAction( gg_trg_Blademaster3, function Trig_Blademaster3_Actions )
endfunction

