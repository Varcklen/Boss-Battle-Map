function Trig_Woodo1_Conditions takes nothing returns boolean
    return GetUnitTypeId(udg_DamageEventTarget) == 'o000'
endfunction

function WoodoCast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local integer r = GetRandomInt(1, 5)
    local integer i = 0
    local integer cyclA = 1
    local integer cyclB = 1
    local unit boss = LoadUnitHandle( udg_hash, id, StringHash( "bswd" ) )
    local integer id1

    if GetUnitState( boss, UNIT_STATE_LIFE) <= 0.405 or not( udg_fightmod[0] ) then
        call DestroyTimer( GetExpiredTimer() )
        call FlushChildHashtable( udg_hash, id )
    else
        call SetUnitAnimation( boss, "spell" )
        loop
            exitwhen cyclA > 5
            if CountLivingPlayerUnitsOfTypeId( 'o000' + cyclA, Player(10) ) > 0 then
                set i = i + 1
            endif
            set cyclA = cyclA + 1
        endloop
        set cyclA = 1
        loop
            exitwhen cyclA > 1
            loop
                exitwhen cyclB > 5
                if r == cyclB and CountLivingPlayerUnitsOfTypeId('o000' + cyclB, Player(10)) == 0 then
                    call CreateUnit( GetOwningPlayer( boss ), 'o000' + cyclB, GetUnitX( boss ) + GetRandomReal( -300, 300 ), GetUnitY( boss ) + GetRandomReal( -300, 300 ), 270 )
                    set cyclB = 5
                elseif i < 5 then
                    set cyclA = cyclA - 1
                endif
                set cyclB = cyclB + 1
            endloop
            set cyclA = cyclA + 1
        endloop
    endif
    
    set boss = null
endfunction

function Trig_Woodo1_Actions takes nothing returns nothing
    local integer id = GetHandleId( udg_DamageEventTarget )

    call DisableTrigger( GetTriggeringTrigger() )
    
    if LoadTimerHandle( udg_hash, id, StringHash( "bswd" ) ) == null  then
        call SaveTimerHandle( udg_hash, id, StringHash( "bswd" ), CreateTimer() )
    endif
	set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "bswd" ) ) ) 
    call SaveUnitHandle( udg_hash, id, StringHash( "bswd" ), udg_DamageEventTarget )
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( udg_DamageEventTarget ), StringHash( "bswd" ) ), bosscast(9), true, function WoodoCast )
endfunction

//===========================================================================
function InitTrig_Woodo1 takes nothing returns nothing
    set gg_trg_Woodo1 = CreateTrigger(  )
    call DisableTrigger( gg_trg_Woodo1 )
    call TriggerRegisterVariableEvent( gg_trg_Woodo1, "udg_AfterDamageEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_Woodo1, Condition( function Trig_Woodo1_Conditions ) )
    call TriggerAddAction( gg_trg_Woodo1, function Trig_Woodo1_Actions )
endfunction

