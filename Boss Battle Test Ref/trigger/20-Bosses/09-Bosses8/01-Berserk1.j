function Trig_Berserk1_Conditions takes nothing returns boolean
    return GetUnitTypeId(udg_DamageEventTarget) == 'e00F'
endfunction

function BerserkEnd takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local unit u = LoadUnitHandle( udg_hash, id, StringHash( "bsbk1trg" ) )
    local integer i = LoadInteger( udg_hash, GetHandleId( u ), StringHash( "control" ) )
    
    call berserk( u, -1 )
    call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\Human\\DispelMagic\\DispelMagicTarget.mdl", GetUnitX( u ), GetUnitY( u ) ) )
    call FlushChildHashtable( udg_hash, id )
    
    set u = null
endfunction

function BerserkCast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local integer id1
    local unit boss = LoadUnitHandle( udg_hash, id, StringHash( "bsbk" ) )
    local unit u
    local integer cyclA
    local unit array k
    local integer i = 0
    
    if GetUnitState( boss, UNIT_STATE_LIFE) <= 0.405 or not( udg_fightmod[0] ) then
        call DestroyTimer( GetExpiredTimer() )
        call FlushChildHashtable( udg_hash, id )
    else
        set cyclA = 1
        loop
            exitwhen cyclA > 4
            set k[cyclA] = null
            if GetUnitState(udg_hero[cyclA], UNIT_STATE_LIFE) > 0.405 and GetOwningPlayer(udg_hero[cyclA]) != Player(10) then
                set i = i + 1
                set k[i] = udg_hero[cyclA]
            endif
            set cyclA = cyclA + 1
        endloop
        
        if i > 0 then
            set u = k[GetRandomInt(1,i)]
            if u != null then
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
    endif
    
    set cyclA = 1
    loop
        exitwhen cyclA > 4
        set k[cyclA] = null
        set cyclA = cyclA + 1
    endloop
    
    set u = null
    set boss = null
endfunction 

function Trig_Berserk1_Actions takes nothing returns nothing
    local integer id = GetHandleId( udg_DamageEventTarget )

    call DisableTrigger( GetTriggeringTrigger() )
    
    if LoadTimerHandle( udg_hash, id, StringHash( "bsbk" ) ) == null then 
        call SaveTimerHandle( udg_hash, id, StringHash( "bsbk" ), CreateTimer() )
    endif
	set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "bsbk" ) ) ) 
    call SaveUnitHandle( udg_hash, id, StringHash( "bsbk" ), udg_DamageEventTarget )
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( udg_DamageEventTarget ), StringHash( "bsbk" ) ), bosscast(20), true, function BerserkCast )
endfunction

//===========================================================================
function InitTrig_Berserk1 takes nothing returns nothing
    set gg_trg_Berserk1 = CreateTrigger(  )
    call DisableTrigger( gg_trg_Berserk1 )
    call TriggerRegisterVariableEvent( gg_trg_Berserk1, "udg_AfterDamageEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_Berserk1, Condition( function Trig_Berserk1_Conditions ) )
    call TriggerAddAction( gg_trg_Berserk1, function Trig_Berserk1_Actions )
endfunction

