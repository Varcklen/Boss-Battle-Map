function Trig_SlaveKing1_Conditions takes nothing returns boolean
    return GetUnitTypeId( udg_DamageEventTarget ) == 'o00F' and GetUnitLifePercent(udg_DamageEventTarget) <= 80
endfunction

function SlaveKingCast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local unit boss = LoadUnitHandle( udg_hash, id, StringHash( "bssk" ) )
    local integer rand = GetRandomInt( 1, 2 )
    local group g = CreateGroup()
    local unit u
    local integer i
    local integer sum = CountLivingPlayerUnitsOfTypeId('o012', Player(10)) + CountLivingPlayerUnitsOfTypeId('o00G', Player(10))
    
    if GetUnitState( boss, UNIT_STATE_LIFE) <= 0.405 or not( udg_fightmod[0] ) then
        call DestroyTimer( GetExpiredTimer() )
        call FlushChildHashtable( udg_hash, id )
    elseif sum < 30 then
        if rand == 1 then
            call CreateUnit( GetOwningPlayer( boss ), 'o012', GetUnitX( boss ) + GetRandomReal(-400, 400), GetUnitY( boss ) + GetRandomReal(-400, 400), GetRandomReal(0, 360) )
        else
            call CreateUnit( GetOwningPlayer( boss ), 'o00G', GetUnitX( boss ) + GetRandomReal(-400, 400), GetUnitY( boss ) + GetRandomReal(-400, 400), GetRandomReal(0, 360) )
        endif
        set i = CountLivingPlayerUnitsOfTypeId('o012', Player(10))
        if i > CountLivingPlayerUnitsOfTypeId('o00G', Player(10)) and i >= 4 and CountLivingPlayerUnitsOfTypeId('o012', Player(4)) == 0 then
            set bj_livingPlayerUnitsTypeId = 'o012'
            call GroupEnumUnitsOfPlayer(g, Player(10), filterLivingPlayerUnitsOfTypeId)
            loop
                set u = FirstOfGroup(g)
                exitwhen u == null
                call DestroyEffect( AddSpecialEffectTarget("Abilities\\Spells\\NightElf\\BattleRoar\\RoarCaster.mdl", u, "origin" ) )
                call SetUnitOwner( u, Player(4), true )
                call GroupRemoveUnit(g,u)
                set u = FirstOfGroup(g)
            endloop
        endif
    endif
    
    call GroupClear( g )
    call DestroyGroup( g )
    set u = null
    set g = null
    set boss = null
endfunction

function Trig_SlaveKing1_Actions takes nothing returns nothing
    local integer id = GetHandleId( udg_DamageEventTarget )
    
    call DisableTrigger( GetTriggeringTrigger() )
    
    if LoadTimerHandle( udg_hash, id, StringHash( "bssk" ) ) == null  then
        call SaveTimerHandle( udg_hash, id, StringHash( "bssk" ), CreateTimer() )
    endif
    set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "bssk" ) ) ) 
    call SaveUnitHandle( udg_hash, id, StringHash( "bssk" ), udg_DamageEventTarget )
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( udg_DamageEventTarget ), StringHash( "bssk" ) ), bosscast(2.5), true, function SlaveKingCast )
endfunction

//===========================================================================
function InitTrig_SlaveKing1 takes nothing returns nothing
    set gg_trg_SlaveKing1 = CreateTrigger(  )
    call DisableTrigger( gg_trg_SlaveKing1 )
    call TriggerRegisterVariableEvent( gg_trg_SlaveKing1, "udg_AfterDamageEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_SlaveKing1, Condition( function Trig_SlaveKing1_Conditions ) )
    call TriggerAddAction( gg_trg_SlaveKing1, function Trig_SlaveKing1_Actions )
endfunction

