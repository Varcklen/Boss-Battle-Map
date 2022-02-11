function Trig_Spider1_Conditions takes nothing returns boolean
    return GetUnitTypeId(udg_DamageEventTarget) == 'n01X' and GetUnitLifePercent(udg_DamageEventTarget) <= 90
endfunction

function SpiderPlay takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local integer cyclA = 1
    local integer counter = LoadInteger( udg_hash, id, StringHash( "bssqbf" ) )
    local unit boss = LoadUnitHandle( udg_hash, id, StringHash( "bssqbf" ) )
    local group g = CreateGroup()
    local unit u
    local integer i = 0
    local integer sp = 0
    
    if GetUnitState( boss, UNIT_STATE_LIFE) <= 0.405 or not( udg_fightmod[0] ) then
        call DestroyTimer( GetExpiredTimer() )
        call FlushChildHashtable( udg_hash, id )
    else
        set bj_livingPlayerUnitsTypeId = 'h00N'
        call GroupEnumUnitsOfPlayer(g, GetOwningPlayer( boss ), filterLivingPlayerUnitsOfTypeId)
        loop
            set u = FirstOfGroup(g)
            exitwhen u == null
            set i = i + 1
            call GroupRemoveUnit(g,u)
            set u = FirstOfGroup(g)
        endloop
        
        if i < counter then
            call DestroyEffect( AddSpecialEffectTarget( "Abilities\\Spells\\NightElf\\BattleRoar\\RoarCaster.mdl", boss, "origin") )
            if GetUnitAbilityLevel( boss, 'A029') == 0 then
                call UnitAddAbility( boss, 'A029')
            endif
            set bj_livingPlayerUnitsTypeId = 'n01Y'
            call GroupEnumUnitsOfPlayer(g, GetOwningPlayer( boss ), filterLivingPlayerUnitsOfTypeId)
            loop
                set u = FirstOfGroup(g)
                exitwhen u == null
                set sp = sp + 1
                call GroupRemoveUnit(g,u)
                set u = FirstOfGroup(g)
            endloop
            if sp <= 35 then
                set cyclA = 1
                loop
                    exitwhen cyclA > 4
                    set bj_lastCreatedUnit = CreateUnit( GetOwningPlayer( boss ), 'n01Y', GetUnitX( boss ) + GetRandomReal( -200, 200 ), GetUnitY( boss ) + GetRandomReal( -200, 200 ), GetRandomReal( 0, 360 ) )
                    call DestroyEffect( AddSpecialEffectTarget( "Abilities\\Spells\\Undead\\AnimateDead\\AnimateDeadTarget.mdl", bj_lastCreatedUnit, "origin") )
                    set cyclA = cyclA + 1
                endloop
            endif
            if i == 0 then
                call UnitRemoveAbility( boss, 'A01X')
            else
                call SetUnitAbilityLevel( boss, 'A0DT', i )
                call SetUnitAbilityLevel( boss, 'A0E8', i )
            endif	
	    call BlzSetUnitBaseDamage( boss, R2I(GetUnitDamage(boss)*1.2-GetUnitAvgDiceDamage(boss)), 0 )
        endif
        call SaveInteger( udg_hash, id, StringHash( "bssqbf" ), i )
    endif
    
    call GroupClear( g )
    call DestroyGroup( g )
    set u = null
    set g = null
    set boss = null
endfunction

function SpiderCast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local unit boss = LoadUnitHandle( udg_hash, id, StringHash( "bssq" ) )
    local group g = CreateGroup()
    local unit u
    local integer sp = 0
    
    set bj_livingPlayerUnitsTypeId = 'n01Y'
    call GroupEnumUnitsOfPlayer(g, GetOwningPlayer( boss ), filterLivingPlayerUnitsOfTypeId)
    loop
        set u = FirstOfGroup(g)
        exitwhen u == null
        set sp = sp + 1
        call GroupRemoveUnit(g,u)
        set u = FirstOfGroup(g)
    endloop
    
    if GetUnitState( boss, UNIT_STATE_LIFE) <= 0.405 or not( udg_fightmod[0] ) then
        call DestroyTimer( GetExpiredTimer() )
        call FlushChildHashtable( udg_hash, id )
    else
        set bj_livingPlayerUnitsTypeId = 'h00N'
        call GroupEnumUnitsOfPlayer(g, GetOwningPlayer( boss ), filterLivingPlayerUnitsOfTypeId)
        loop
            set u = FirstOfGroup(g)
            exitwhen u == null
            if sp <= 35 and GetUnitState( u, UNIT_STATE_LIFE) > 0.405 then
                set bj_lastCreatedUnit = CreateUnit( GetOwningPlayer( boss ), 'n01Y', GetUnitX( u ) + GetRandomReal( -200, 200 ), GetUnitY( u ) + GetRandomReal( -200, 200 ), GetRandomReal( 0, 360 ) )
                call DestroyEffect( AddSpecialEffectTarget( "Abilities\\Spells\\Undead\\AnimateDead\\AnimateDeadTarget.mdl", bj_lastCreatedUnit, "origin") )
            endif
            call GroupRemoveUnit(g,u)
            set u = FirstOfGroup(g)
        endloop
    endif
    
    call GroupClear( g )
    call DestroyGroup( g )
    set u = null
    set g = null
    set boss = null
endfunction   
    
function Trig_Spider1_Actions takes nothing returns nothing
    local integer id = GetHandleId( udg_DamageEventTarget )
    local integer i
    local integer cyclA = 1
    local group g = CreateGroup()
    local unit u
    local integer n = 0

    call DisableTrigger( GetTriggeringTrigger() )
    call spectime("Abilities\\Spells\\NightElf\\FanOfKnives\\FanOfKnivesCaster.mdl", GetUnitX( udg_DamageEventTarget ), GetUnitY( udg_DamageEventTarget ), 1.6 )
    call UnitAddAbility(udg_DamageEventTarget, 'A01X')
    loop
        exitwhen cyclA > 2
        if cyclA == 1 then
            set i = 1
        else
            set i = -1
        endif
        set bj_lastCreatedUnit = CreateUnit( GetOwningPlayer( udg_DamageEventTarget ), 'h00N', GetRectCenterX( udg_Boss_Rect ), GetRectCenterY( udg_Boss_Rect ) + 400 + ( i * 1000 ), 270 )
        call spectime("Abilities\\Spells\\NightElf\\FanOfKnives\\FanOfKnivesCaster.mdl", GetUnitX( bj_lastCreatedUnit ), GetUnitY( bj_lastCreatedUnit ), 1.6 )
        set cyclA = cyclA + 1
    endloop
    
    set bj_livingPlayerUnitsTypeId = 'h00N'
    call GroupEnumUnitsOfPlayer(g, GetOwningPlayer( udg_DamageEventTarget ), filterLivingPlayerUnitsOfTypeId)
    loop
        set u = FirstOfGroup(g)
        exitwhen u == null
        set n = n + 1
        call GroupRemoveUnit(g,u)
        set u = FirstOfGroup(g)
    endloop
    
    call SetUnitAbilityLevel(udg_DamageEventTarget, 'A0DT', n )
    call SetUnitAbilityLevel(udg_DamageEventTarget, 'A0E8', n )
    
    if LoadTimerHandle( udg_hash, id, StringHash( "bssqbf" ) ) == null then 
        call SaveTimerHandle( udg_hash, id, StringHash( "bssqbf" ), CreateTimer() )
    endif
	set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "bssqbf" ) ) ) 
    call SaveUnitHandle( udg_hash, id, StringHash( "bssqbf" ), udg_DamageEventTarget )
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( udg_DamageEventTarget ), StringHash( "bssqbf" ) ), 0.5, true, function SpiderPlay )
    
    set id = GetHandleId( udg_DamageEventTarget )
    if LoadTimerHandle( udg_hash, id, StringHash( "bssq" ) ) == null then
        call SaveTimerHandle( udg_hash, id, StringHash( "bssq" ), CreateTimer() )
    endif
	set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "bssq" ) ) ) 
    call SaveUnitHandle( udg_hash, id, StringHash( "bssq" ), udg_DamageEventTarget )
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( udg_DamageEventTarget ), StringHash( "bssq" ) ), bosscast(6), true, function SpiderCast )
endfunction

//===========================================================================
function InitTrig_Spider1 takes nothing returns nothing
    set gg_trg_Spider1 = CreateTrigger(  )
    call DisableTrigger( gg_trg_Spider1 )
    call TriggerRegisterVariableEvent( gg_trg_Spider1, "udg_AfterDamageEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_Spider1, Condition( function Trig_Spider1_Conditions ) )
    call TriggerAddAction( gg_trg_Spider1, function Trig_Spider1_Actions )
endfunction

