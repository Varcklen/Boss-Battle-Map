function Trig_gg_trg_Illusionist1_Conditions takes nothing returns boolean
    return GetUnitTypeId(udg_DamageEventTarget) == 'h020'
endfunction

function Illusionist1Cast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local unit boss = LoadUnitHandle( udg_hash, id, StringHash( "bsil" ) )
    local integer i = 0
    local integer rand 
    local integer cyclA
    local item it
    
    if GetUnitState( boss, UNIT_STATE_LIFE) <= 0.405 or not( udg_fightmod[0] ) then
        call DestroyTimer( GetExpiredTimer() )
        call FlushChildHashtable( udg_hash, id )
    else
	set cyclA = 1
        loop
            exitwhen cyclA > 2
            if i < 30 then
                set rand = GetRandomInt( 1, 2 )
                if rand == 1 then
                    set it = CreateItem( 'I060', GetUnitX( boss ) + GetRandomReal( -400, 400 ), GetUnitY( boss ) + GetRandomReal( -400, 400 ) )
                else
                    set it = CreateItem( 'I03L', GetUnitX( boss ) + GetRandomReal( -400, 400 ), GetUnitY( boss ) + GetRandomReal( -400, 400 ) )
                endif
                if RectContainsItem( it, udg_Boss_Rect ) then
                    call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\Demon\\DarkPortal\\DarkPortalTarget.mdl", GetItemX( it ), GetItemY( it ) ) )
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

function Trig_gg_trg_Illusionist1_Actions takes nothing returns nothing
    local integer id = GetHandleId( udg_DamageEventTarget )

    call DisableTrigger( GetTriggeringTrigger() )
    
    if LoadTimerHandle( udg_hash, id, StringHash( "bsil" ) ) == null  then
        call SaveTimerHandle( udg_hash, id, StringHash( "bsil" ), CreateTimer() )
    endif
	set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "bsil" ) ) ) 
    call SaveUnitHandle( udg_hash, id, StringHash( "bsil" ), udg_DamageEventTarget )
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( udg_DamageEventTarget ), StringHash( "bsil" ) ), bosscast(14), true, function Illusionist1Cast )
endfunction

//===========================================================================
function InitTrig_Illusionist1 takes nothing returns nothing
    set gg_trg_Illusionist1 = CreateTrigger()
    call DisableTrigger( gg_trg_Illusionist1 )
    call TriggerRegisterVariableEvent( gg_trg_Illusionist1, "udg_AfterDamageEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_Illusionist1, Condition( function Trig_gg_trg_Illusionist1_Conditions ) )
    call TriggerAddAction( gg_trg_Illusionist1, function Trig_gg_trg_Illusionist1_Actions )
endfunction

