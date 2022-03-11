function Trig_Rock1_Conditions takes nothing returns boolean
    return GetUnitTypeId(udg_DamageEventTarget) == 'n03J'
endfunction

function Rock1Cast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer( ) )
    local unit boss = LoadUnitHandle( udg_hash, id, StringHash( "bsrk" ) )
    local item it
    local integer cyclA = 1
    local integer i = 0
    local integer rand 

    if GetUnitState( boss, UNIT_STATE_LIFE) <= 0.405 or not( udg_fightmod[0] ) then
        call DestroyTimer( GetExpiredTimer() )
        call FlushChildHashtable( udg_hash, id )
    else
        loop
            exitwhen cyclA > 1
            if i < 30 then
                set rand = GetRandomInt( 0, 2 )
                set it = CreateItem( 'III1' + rand, GetUnitX( boss ) + GetRandomReal( -400, 400 ), GetUnitY( boss ) + GetRandomReal( -400, 400 ) )
                if RectContainsItem( it, udg_Boss_Rect ) then
                    call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\Human\\Thunderclap\\ThunderClapCaster.mdl", GetItemX( it ), GetItemY( it ) ) )
                else
                    call RemoveItem( it )
                    set cyclA = cyclA - 1
                endif
            endif
            set i = i + 1
            set cyclA = cyclA + 1
        endloop
    endif
    
    set boss = null
    set it = null
endfunction

function Trig_Rock1_Actions takes nothing returns nothing
    local integer id = GetHandleId( udg_DamageEventTarget )

    call DisableTrigger( GetTriggeringTrigger() )

    if LoadTimerHandle( udg_hash, id, StringHash( "bsrk" ) ) == null  then
        call SaveTimerHandle( udg_hash, id, StringHash( "bsrk" ), CreateTimer() )
    endif
	set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "bsrk" ) ) ) 
    call SaveUnitHandle( udg_hash, id, StringHash( "bsrk" ), udg_DamageEventTarget )
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( udg_DamageEventTarget ), StringHash( "bsrk" ) ), bosscast(5), true, function Rock1Cast )
endfunction

//===========================================================================
function InitTrig_Rock1 takes nothing returns nothing
    set gg_trg_Rock1 = CreateTrigger(  )
    call DisableTrigger( gg_trg_Rock1 )
    call TriggerRegisterVariableEvent( gg_trg_Rock1, "udg_AfterDamageEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_Rock1, Condition( function Trig_Rock1_Conditions ) )
    call TriggerAddAction( gg_trg_Rock1, function Trig_Rock1_Actions )
endfunction

