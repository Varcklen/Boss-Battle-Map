function Trig_Horror2_Conditions takes nothing returns boolean
    return GetUnitTypeId(udg_DamageEventTarget) == 'e002'
endfunction

function Horror2Cast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer( ) )
    local unit boss = LoadUnitHandle( udg_hash, id, StringHash( "bshr" ) )
    local item it
    local integer cyclA = 1
    local integer i = 0

    if GetUnitState( boss, UNIT_STATE_LIFE) <= 0.405 or not( udg_fightmod[0] ) then
        call DestroyTimer( GetExpiredTimer() )
        call FlushChildHashtable( udg_hash, id )
    else
        loop
            exitwhen cyclA > 1
            if i < 30 then
                set it = CreateItem( 'I05R', GetUnitX( boss ) + GetRandomReal( -400, 400 ), GetUnitY( boss ) + GetRandomReal( -400, 400 ) )
                if RectContainsItem( it, udg_Boss_Rect ) then
                    call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\Undead\\DeathCoil\\DeathCoilSpecialArt.mdl", GetItemX( it ), GetItemY( it ) ) )
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

function Trig_Horror2_Actions takes nothing returns nothing
    local integer id = GetHandleId( udg_DamageEventTarget )

    call DisableTrigger( GetTriggeringTrigger() )

    if LoadTimerHandle( udg_hash, id, StringHash( "bshr" ) ) == null  then
        call SaveTimerHandle( udg_hash, id, StringHash( "bshr" ), CreateTimer() )
    endif
	set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "bshr" ) ) ) 
    call SaveUnitHandle( udg_hash, id, StringHash( "bshr" ), udg_DamageEventTarget )
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( udg_DamageEventTarget ), StringHash( "bshr" ) ), bosscast(5), true, function Horror2Cast )
endfunction

//===========================================================================
function InitTrig_Horror2 takes nothing returns nothing
    set gg_trg_Horror2 = CreateTrigger(  )
    call DisableTrigger( gg_trg_Horror2 )
    call TriggerRegisterVariableEvent( gg_trg_Horror2, "udg_AfterDamageEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_Horror2, Condition( function Trig_Horror2_Conditions ) )
    call TriggerAddAction( gg_trg_Horror2, function Trig_Horror2_Actions )
endfunction

