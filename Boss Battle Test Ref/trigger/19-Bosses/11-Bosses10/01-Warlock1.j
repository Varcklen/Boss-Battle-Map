function Trig_Warlock1_Conditions takes nothing returns boolean
    return GetUnitTypeId(udg_DamageEventTarget) == 'n00F'
endfunction

function WarlockStorm takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local unit u = LoadUnitHandle( udg_hash, id, StringHash( "bswrstr" ) )
    local integer i = 0
    local boolean l = false
    local real x
    local real y

    if GetUnitState( u, UNIT_STATE_LIFE) <= 0.405 or not( udg_fightmod[0] ) then
        call DestroyTimer( GetExpiredTimer() )
        call FlushChildHashtable( udg_hash, id )
    else
        loop
		exitwhen l or i > 50
		set i = i + 1
		set x = GetUnitX( u ) - (250*i)
		set y = GetUnitY( u )
		if RectContainsLoc(udg_Boss_Rect, Location(x, y)) then
			set bj_lastCreatedUnit = CreateUnit( GetOwningPlayer( u ), 'u000', x, y, 270 )
        		call UnitApplyTimedLife( bj_lastCreatedUnit, 'BTLF', 5)
        		call UnitAddAbility( bj_lastCreatedUnit, 'A068')
			call IssuePointOrder( bj_lastCreatedUnit, "flamestrike", x, y )
		else
			set l = true
		endif
	endloop

	set i = 0
	set l = false
	loop
		exitwhen l or i > 50
		set i = i + 1
		set x = GetUnitX( u ) + (250*i)
		set y = GetUnitY( u )
		if RectContainsLoc(udg_Boss_Rect, Location(x, y)) then
			set bj_lastCreatedUnit = CreateUnit( GetOwningPlayer( u ), 'u000', x, y, 270 )
        		call UnitApplyTimedLife( bj_lastCreatedUnit, 'BTLF', 5)
        		call UnitAddAbility( bj_lastCreatedUnit, 'A068')
			call IssuePointOrder( bj_lastCreatedUnit, "flamestrike", x, y )
		else
			set l = true
		endif
	endloop

	set i = 0
	set l = false
	loop
		exitwhen l or i > 50
		set i = i + 1
		set x = GetUnitX( u ) 
		set y = GetUnitY( u ) - (250*i)
		if RectContainsLoc(udg_Boss_Rect, Location(x, y)) then
			set bj_lastCreatedUnit = CreateUnit( GetOwningPlayer( u ), 'u000', x, y, 270 )
        		call UnitApplyTimedLife( bj_lastCreatedUnit, 'BTLF', 5)
        		call UnitAddAbility( bj_lastCreatedUnit, 'A068')
			call IssuePointOrder( bj_lastCreatedUnit, "flamestrike", x, y )
		else
			set l = true
		endif
	endloop

	set i = 0
	set l = false
	loop
		exitwhen l or i > 50
		set i = i + 1
		set x = GetUnitX( u )
		set y = GetUnitY( u ) + (250*i)
		if RectContainsLoc(udg_Boss_Rect, Location(x, y)) then
			set bj_lastCreatedUnit = CreateUnit( GetOwningPlayer( u ), 'u000', x, y, 270 )
            call UnitApplyTimedLife( bj_lastCreatedUnit, 'BTLF', 5)
            call UnitAddAbility( bj_lastCreatedUnit, 'A068')
			call IssuePointOrder( bj_lastCreatedUnit, "flamestrike", x, y )
		else
			set l = true
		endif
	endloop
    endif
    
    set u = null
endfunction

function WarlEnd takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local unit dummy = LoadUnitHandle( udg_hash, id, StringHash( "bswr1" ) )
    local group g = CreateGroup()
    local unit u
    
    if udg_fightmod[0] then
        set bj_livingPlayerUnitsTypeId = 'h013'
        call GroupEnumUnitsOfPlayer(g, GetOwningPlayer( dummy ), filterLivingPlayerUnitsOfTypeId)
        loop
            set u = FirstOfGroup(g)
            exitwhen u == null
            if GetUnitState( u, UNIT_STATE_LIFE) > 0.405 then
                set bj_lastCreatedUnit = CreateUnit( GetOwningPlayer( dummy ), 'n011', GetUnitX( u ), GetUnitY( u ), GetUnitFacing( u ) )
                call DestroyEffect( AddSpecialEffectTarget( "Abilities\\Spells\\Orc\\FeralSpirit\\feralspirittarget.mdl", bj_lastCreatedUnit, "origin") )
                call KillUnit( u )
            endif
            call GroupRemoveUnit(g,u)
            set u = FirstOfGroup(g)
        endloop
    endif
    
    call FlushChildHashtable( udg_hash, id )
    call GroupClear( g )
    call DestroyGroup( g )
    set u = null
    set g = null
    set dummy = null
endfunction

function WarlCast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local unit boss = LoadUnitHandle( udg_hash, id, StringHash( "bswr" ) )
    local integer cyclA = 1
    local integer id1
    local real x
    local real y

    if GetUnitState( boss, UNIT_STATE_LIFE) <= 0.405 or not( udg_fightmod[0] ) or CountLivingPlayerUnitsOfTypeId('o006', GetOwningPlayer(boss)) > 0 then
        call DestroyTimer( GetExpiredTimer() )
        call FlushChildHashtable( udg_hash, id )
    else
        loop
            exitwhen cyclA > 4
            if CountLivingPlayerUnitsOfTypeId('h013', GetOwningPlayer( boss ) ) + CountLivingPlayerUnitsOfTypeId('n011', GetOwningPlayer( boss ) ) <= 10 then
                set x = GetUnitX( boss ) + 550 * Cos( ( 45 + ( 90 * cyclA ) ) * 0.0174 )
                set y = GetUnitY( boss ) + 550 * Sin( ( 45 + ( 90 * cyclA ) ) * 0.0174 )
                set bj_lastCreatedUnit = CreateUnit( GetOwningPlayer( boss ), 'h013', x, y, 45 + ( 90 * cyclA ) )
                call SetUnitAnimation( bj_lastCreatedUnit, "birth" )

                set id1 = GetHandleId( bj_lastCreatedUnit )
                if LoadTimerHandle( udg_hash, id1, StringHash( "bswr1" ) ) == null  then
                    call SaveTimerHandle( udg_hash, id1, StringHash( "bswr1" ), CreateTimer() )
                endif
                set id1 = GetHandleId( LoadTimerHandle( udg_hash, id1, StringHash( "bswr1" ) ) ) 
                call SaveUnitHandle( udg_hash, id1, StringHash( "bswr1" ), bj_lastCreatedUnit )
                call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( bj_lastCreatedUnit ), StringHash( "bswr1" ) ), bosscast(10), false, function WarlEnd )
            else
                set cyclA = 4
            endif
            set cyclA = cyclA + 1
        endloop
    endif
    
    set boss = null
endfunction

function WarlGhoul takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local unit boss = LoadUnitHandle( udg_hash, id, StringHash( "bswrp" ) )
    local unit new
    local group g = CreateGroup()
    local unit u
    local integer i = LoadInteger( udg_hash, id, StringHash( "bswrp" ) )
    local integer m = LoadInteger( udg_hash, id, StringHash( "bswrps" ) )
    local integer n = 0

    if GetUnitState( boss, UNIT_STATE_LIFE) <= 0.405 or not( udg_fightmod[0] ) then
        call DestroyTimer( GetExpiredTimer() )
        call FlushChildHashtable( udg_hash, id )
    else
        set bj_livingPlayerUnitsTypeId = 'h005'
        call GroupEnumUnitsOfPlayer(g, GetOwningPlayer( boss ), filterLivingPlayerUnitsOfTypeId)
        loop
            set u = FirstOfGroup(g)
            exitwhen u == null
            set n = n + 1
            call GroupRemoveUnit(g,u)
            set u = FirstOfGroup(g)
        endloop
        
        if n == 0 then
            call DisableTrigger( GetTriggeringTrigger() )
            call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\Human\\MassTeleport\\MassTeleportCaster.mdl", GetRectCenterX( udg_Boss_Rect ), GetRectCenterY( udg_Boss_Rect ) + 600 ) )
            call SetUnitPosition( boss, GetRectCenterX( udg_Boss_Rect ), GetRectCenterY( udg_Boss_Rect ) + 600 )
            
            call DelBuff( boss, false )
            call ShowUnit( boss, false)
            set new = CreateUnit(GetOwningPlayer(boss), 'n00F', GetUnitX(boss), GetUnitY(boss), GetUnitFacing(boss))
            call SaveUnitHandle( udg_hash, GetHandleId( LoadTimerHandle( udg_hash, GetHandleId( boss ), StringHash( "aggro" ) ) ) , StringHash( "aggro" ), new )
            call BlzSetUnitBaseDamage( new, BlzGetUnitBaseDamage(boss, 0), 0 )
            call BlzSetUnitArmor( new, BlzGetUnitArmor(boss) )
            call SetUnitState( new, UNIT_STATE_LIFE, GetUnitState( boss, UNIT_STATE_MAX_LIFE ) * 0.3 )
            call GroupRemoveUnit( udg_Bosses, boss )
            call TransmissionFromUnitWithNameBJ( bj_FORCE_ALL_PLAYERS, new, GetUnitName(new), null, "Army! To me!", bj_TIMETYPE_SET, 3, false )
            if bossbar == boss then
                set bossbar = new
            endif
            if bossbar1 == boss then
                set bossbar1 = new
            endif
            call RemoveUnit(boss)
            call aggro( new )

            set id = GetHandleId( new )
            if LoadTimerHandle( udg_hash, id, StringHash( "bswr" ) ) == null  then
                call SaveTimerHandle( udg_hash, id, StringHash( "bswr" ), CreateTimer() )
            endif
            set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "bswr" ) ) ) 
            call SaveUnitHandle( udg_hash, id, StringHash( "bswr" ), new )
            call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( new ), StringHash( "bswr" ) ), bosscast(12), true, function WarlCast )

	    	set id = GetHandleId( new )
    		if LoadTimerHandle( udg_hash, id, StringHash( "bswrstr" ) ) == null  then
        		call SaveTimerHandle( udg_hash, id, StringHash( "bswrstr" ), CreateTimer() )
    		endif
            set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "bswrstr" ) ) ) 
    		call SaveUnitHandle( udg_hash, id, StringHash( "bswrstr" ), new )
            call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( new ), StringHash( "bswrstr" ) ), bosscast(15), true, function WarlockStorm )
        elseif n != m then
            set m = n
            set i = 1 + ( ( 4 - m ) * 2 )
            call SaveInteger( udg_hash, id, StringHash( "bswrp" ), i )
            call SaveInteger( udg_hash, id, StringHash( "bswrps" ), m )
        endif
    endif
    
    call GroupClear( g )
    call DestroyGroup( g )
    set u = null
    set g = null
    set boss = null
    set new = null
endfunction

function Warl2Cast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local unit boss = LoadUnitHandle( udg_hash, id, StringHash( "bswr2" ) )
    local group g = CreateGroup()
    local unit u
    local integer cyclAEnd = LoadInteger( udg_hash, GetHandleId( LoadTimerHandle( udg_hash, GetHandleId( boss ), StringHash( "bswrp" ) ) ), StringHash( "bswrp" ) )
    local integer cyclA 
    local integer n = 0
    
    set bj_livingPlayerUnitsTypeId = 'u00A'
    call GroupEnumUnitsOfPlayer(g, GetOwningPlayer( boss ), filterLivingPlayerUnitsOfTypeId)
    loop
        set u = FirstOfGroup(g)
        exitwhen u == null
        set n = n + 1
        call GroupRemoveUnit(g,u)
        set u = FirstOfGroup(g)
    endloop
    
    if GetUnitState( boss, UNIT_STATE_LIFE) <= 0.405 or not( udg_fightmod[0] ) then
        call DestroyTimer( GetExpiredTimer() )
        call FlushChildHashtable( udg_hash, id )
    else
        set bj_livingPlayerUnitsTypeId = 'h005'
        call GroupEnumUnitsOfPlayer(g, GetOwningPlayer( boss ), filterLivingPlayerUnitsOfTypeId)
        loop
            set u = FirstOfGroup(g)
            exitwhen u == null
            if n <= 30 then
                set cyclA = 1
                loop
                    exitwhen cyclA > cyclAEnd
                    set bj_lastCreatedUnit = CreateUnit( GetOwningPlayer( boss ), 'u00A', GetUnitX( u ), GetUnitY( u ), GetRandomReal( 0, 360 ) )
                    call DestroyEffect( AddSpecialEffectTarget( "Abilities\\Spells\\Orc\\FeralSpirit\\feralspirittarget.mdl", bj_lastCreatedUnit, "origin") )
                    set cyclA = cyclA + 1
                endloop
            endif
            call GroupRemoveUnit(g,u)
        endloop
    endif
    
    call GroupClear( g )
    call DestroyGroup( g )
    set u = null
    set g = null
    set boss = null
endfunction

function Warlock2Akt takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local unit boss
    local unit u = LoadUnitHandle( udg_hash, id, StringHash( "bswrakt" ) )
    local real x = GetUnitX( u )
    local real y = GetUnitY( u )
    local integer id1 = GetHandleId( u )
    local integer cyclA = 1
    local real xi 
    local real yi 

    if GetUnitState( u, UNIT_STATE_LIFE) <= 0.405 or not( udg_fightmod[0] ) then
        call DestroyTimer( GetExpiredTimer() )
        call FlushChildHashtable( udg_hash, id )
    elseif GetUnitLifePercent( u ) <= 30 then
        loop
            exitwhen cyclA > 4
            set xi = GetRectCenterX( udg_Boss_Rect ) + 2500 * Cos( ( 135 + ( 90 * cyclA ) ) * bj_DEGTORAD )
            set yi = GetRectCenterY( udg_Boss_Rect ) + 2500 * Sin( ( 135 + ( 90 * cyclA ) ) * bj_DEGTORAD )
            set bj_lastCreatedUnit = CreateUnit( GetOwningPlayer( u ), 'h005', xi, yi, 135 + ( 90 * cyclA ) )
            call PingMinimapLocForForceEx( bj_FORCE_ALL_PLAYERS, GetUnitLoc( bj_lastCreatedUnit ), 10, bj_MINIMAPPINGSTYLE_ATTACK, 100, 50, 50 )
            set cyclA = cyclA + 1
        endloop
        
        call DelBuff( u, false )
        call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\Orc\\FeralSpirit\\feralspirittarget.mdl", GetUnitX( u ), GetUnitY( u ) ) )
        call ShowUnit( u, false)
        set boss = CreateUnit( GetOwningPlayer( u ), 'o006', x, y, GetRandomReal( 0, 360 ) )
        call BlzSetUnitBaseDamage( boss, BlzGetUnitBaseDamage(u, 0), 0 )
        call BlzSetUnitArmor( boss, BlzGetUnitArmor(u) )
        call SetUnitState( boss, UNIT_STATE_LIFE, GetUnitState( boss, UNIT_STATE_MAX_LIFE ) * 0.3 )
        call GroupRemoveUnit( udg_Bosses, u )
        call TransmissionFromUnitWithNameBJ( bj_FORCE_ALL_PLAYERS, boss, GetUnitName(boss), null, "You wont get me!", bj_TIMETYPE_SET, 3, false )
        if bossbar == u then
            set bossbar = boss
        endif
        if bossbar1 == u then
            set bossbar1 = boss
        endif
        call RemoveUnit( u )
        set id1 = GetHandleId( boss )

        if LoadTimerHandle( udg_hash, id1, StringHash( "bswr2" ) ) == null  then
            call SaveTimerHandle( udg_hash, id1, StringHash( "bswr2" ), CreateTimer() )
        endif
        set id1 = GetHandleId( LoadTimerHandle( udg_hash, id1, StringHash( "bswr2" ) ) ) 
        call SaveUnitHandle( udg_hash, id1, StringHash( "bswr2" ), boss )
        call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( boss ), StringHash( "bswr2" ) ), bosscast(8), true, function Warl2Cast )
        
        set id1 = GetHandleId( boss )
        if LoadTimerHandle( udg_hash, id1, StringHash( "bswrp" ) ) == null  then
            call SaveTimerHandle( udg_hash, id1, StringHash( "bswrp" ), CreateTimer() )
        endif
        set id1 = GetHandleId( LoadTimerHandle( udg_hash, id1, StringHash( "bswrp" ) ) ) 
        call SaveUnitHandle( udg_hash, id1, StringHash( "bswrp" ), boss )
        call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( boss ), StringHash( "bswrp" ) ), 0.5, true, function WarlGhoul )

	set id1 = GetHandleId( boss )
    	if LoadTimerHandle( udg_hash, id1, StringHash( "bswrstr" ) ) == null  then
        	call SaveTimerHandle( udg_hash, id1, StringHash( "bswrstr" ), CreateTimer() )
    	endif
	set id1 = GetHandleId( LoadTimerHandle( udg_hash, id1, StringHash( "bswrstr" ) ) ) 
    	call SaveUnitHandle( udg_hash, id1, StringHash( "bswrstr" ), boss )
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( boss ), StringHash( "bswrstr" ) ), bosscast(15), true, function WarlockStorm )
        
        call DestroyTimer( GetExpiredTimer() )
        call FlushChildHashtable( udg_hash, id )
    endif
    
    set boss = null
    set u = null
endfunction

function Trig_Warlock1_Actions takes nothing returns nothing
    local integer id = GetHandleId( udg_DamageEventTarget )

    call DisableTrigger( GetTriggeringTrigger() )

    call TransmissionFromUnitWithNameBJ( bj_FORCE_ALL_PLAYERS, udg_DamageEventTarget, GetUnitName(udg_DamageEventTarget), null, "Pitiful mortals.", bj_TIMETYPE_SET, 3, false )
    if LoadTimerHandle( udg_hash, id, StringHash( "bswr" ) ) == null then
        call SaveTimerHandle( udg_hash, id, StringHash( "bswr" ), CreateTimer() )
    endif
	set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "bswr" ) ) ) 
    call SaveUnitHandle( udg_hash, id, StringHash( "bswr" ), udg_DamageEventTarget )
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( udg_DamageEventTarget ), StringHash( "bswr" ) ), bosscast(20), true, function WarlCast )
    
    set id = GetHandleId( udg_DamageEventTarget )
    if LoadTimerHandle( udg_hash, id, StringHash( "bswrakt" ) ) == null  then
        call SaveTimerHandle( udg_hash, id, StringHash( "bswrakt" ), CreateTimer() )
    endif
	set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "bswrakt" ) ) ) 
    call SaveUnitHandle( udg_hash, id, StringHash( "bswrakt" ), udg_DamageEventTarget )
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( udg_DamageEventTarget ), StringHash( "bswrakt" ) ), 0.5, true, function Warlock2Akt )

	set id = GetHandleId( udg_DamageEventTarget )
    	if LoadTimerHandle( udg_hash, id, StringHash( "bswrstr" ) ) == null  then
        	call SaveTimerHandle( udg_hash, id, StringHash( "bswrstr" ), CreateTimer() )
    	endif
	set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "bswrstr" ) ) ) 
    	call SaveUnitHandle( udg_hash, id, StringHash( "bswrstr" ), udg_DamageEventTarget )
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( udg_DamageEventTarget ), StringHash( "bswrstr" ) ), bosscast(15), true, function WarlockStorm )
endfunction

//===========================================================================
function InitTrig_Warlock1 takes nothing returns nothing
    set gg_trg_Warlock1 = CreateTrigger(  )
    call DisableTrigger( gg_trg_Warlock1 )
    call TriggerRegisterVariableEvent( gg_trg_Warlock1, "udg_AfterDamageEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_Warlock1, Condition( function Trig_Warlock1_Conditions ) )
    call TriggerAddAction( gg_trg_Warlock1, function Trig_Warlock1_Actions )
endfunction

