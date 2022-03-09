function Trig_Wendigo1_Conditions takes nothing returns boolean
    return GetUnitTypeId(udg_DamageEventTarget) == 'n03I'
endfunction

function WendMana takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local unit dummy = LoadUnitHandle( udg_hash, id, StringHash( "bswdmp" ) )
    local group g = CreateGroup()
    local unit u

    if GetUnitState( dummy, UNIT_STATE_LIFE) <= 0.405 or not( udg_fightmod[0] ) then
        call FlushChildHashtable( udg_hash, id )
        call DestroyTimer( GetExpiredTimer() )
    else
        call GroupEnumUnitsInRange( g, GetUnitX( dummy ), GetUnitY( dummy ), 100, null )
        loop
            set u = FirstOfGroup(g)
            exitwhen u == null
            if IsUnitType( u, UNIT_TYPE_HERO) then
                call manast( u, null, GetUnitState( u, UNIT_STATE_MAX_MANA) * 0.05 )
                call DestroyEffect( AddSpecialEffectTarget( "Abilities\\Spells\\Items\\AIma\\AImaTarget.mdl", u, "origin") )
            endif
            call GroupRemoveUnit(g,u)
            set u = FirstOfGroup(g)
        endloop
    endif

    call GroupClear( g )
    set u = null
    set g = null
    set dummy = null
endfunction

function WendLife takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local unit dummy = LoadUnitHandle( udg_hash, id, StringHash( "bswdhp" ) )
    local group g = CreateGroup()
    local unit u

    if GetUnitState( dummy, UNIT_STATE_LIFE) <= 0.405 or not( udg_fightmod[0] ) then
        call FlushChildHashtable( udg_hash, id )
        call DestroyTimer( GetExpiredTimer() )
    else
        call GroupEnumUnitsInRange( g, GetUnitX( dummy ), GetUnitY( dummy ), 100, null )
        loop
            set u = FirstOfGroup(g)
            exitwhen u == null
            if IsUnitType( u, UNIT_TYPE_HERO) then
                call healst( u, null, GetUnitState( u, UNIT_STATE_MAX_LIFE) * 0.03 )
                call DestroyEffect( AddSpecialEffectTarget( "Abilities\\Spells\\Human\\Heal\\HealTarget.mdl", u, "origin") )
            endif
            call GroupRemoveUnit(g,u)
            set u = FirstOfGroup(g)
        endloop
    endif

    call GroupClear( g )
    set u = null
    set g = null
    set dummy = null
endfunction

function WendTime takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local unit dummy = LoadUnitHandle( udg_hash, id, StringHash( "bswdtm" ) )
    local group g = CreateGroup()
    local unit u

    if GetUnitState( dummy, UNIT_STATE_LIFE) <= 0.405 or not( udg_fightmod[0] ) then
        call FlushChildHashtable( udg_hash, id )
        call DestroyTimer( GetExpiredTimer() )
    else
        call GroupEnumUnitsInRange( g, GetUnitX( dummy ), GetUnitY( dummy ), 100, null )
        loop
            set u = FirstOfGroup(g)
            exitwhen u == null
            if IsUnitType( u, UNIT_TYPE_HERO) then
                call UnitResetCooldown( u )
                call DestroyEffect( AddSpecialEffectTarget( "war3mapImported\\Sci Teleport.mdx", u, "origin") )
            endif
            call GroupRemoveUnit(g,u)
            set u = FirstOfGroup(g)
        endloop
    endif

    call GroupClear( g )
    set u = null
    set g = null
    set dummy = null
endfunction

function WendRageEnd takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    call UnitRemoveAbility( LoadUnitHandle( udg_hash, id, StringHash( "bswdrg1" ) ), 'A0VO' )
    call UnitRemoveAbility( LoadUnitHandle( udg_hash, id, StringHash( "bswdrg1" ) ), 'B02F' )
    call FlushChildHashtable( udg_hash, id )
endfunction

function WendRage takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local integer id1
    local unit dummy = LoadUnitHandle( udg_hash, id, StringHash( "bswdrg" ) )
    local group g = CreateGroup()
    local unit u

    if GetUnitState( dummy, UNIT_STATE_LIFE) <= 0.405 or not( udg_fightmod[0] ) then
        call FlushChildHashtable( udg_hash, id )
        call DestroyTimer( GetExpiredTimer() )
    else
        call GroupEnumUnitsInRange( g, GetUnitX( dummy ), GetUnitY( dummy ), 100, null )
        loop
            set u = FirstOfGroup(g)
            exitwhen u == null
            if IsUnitType( u, UNIT_TYPE_HERO) then
                call DestroyEffect( AddSpecialEffectTarget( "Abilities\\Spells\\NightElf\\BattleRoar\\RoarCaster.mdl", u, "origin") )
                call UnitAddAbility( u, 'A0VO' )
                
                set id1 = GetHandleId( u )
                if LoadTimerHandle( udg_hash, id, StringHash( "bswdrg1" ) ) == null  then
                    call SaveTimerHandle( udg_hash, id1, StringHash( "bswdrg1" ), CreateTimer() )
                endif
                set id1 = GetHandleId( LoadTimerHandle( udg_hash, id1, StringHash( "bswdrg1" ) ) ) 
                call SaveUnitHandle( udg_hash, id1, StringHash( "bswdrg1" ), u )
                call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( u ), StringHash( "bswdrg1" ) ), 20, true, function WendRageEnd ) 
            endif
            call GroupRemoveUnit(g,u)
            set u = FirstOfGroup(g)
        endloop
    endif

    call GroupClear( g )
    set u = null
    set g = null
    set dummy = null
endfunction

function WendRunEnd takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    call UnitRemoveAbility( LoadUnitHandle( udg_hash, id, StringHash( "bswdrn1" ) ), 'A0VQ' )
    call UnitRemoveAbility( LoadUnitHandle( udg_hash, id, StringHash( "bswdrn1" ) ), 'B02G' )
    call FlushChildHashtable( udg_hash, id )
endfunction

function WendRun takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local integer id1
    local unit dummy = LoadUnitHandle( udg_hash, id, StringHash( "bswdrn" ) )
    local group g = CreateGroup()
    local unit u

    if GetUnitState( dummy, UNIT_STATE_LIFE) <= 0.405 or not( udg_fightmod[0] ) then
        call FlushChildHashtable( udg_hash, id )
        call DestroyTimer( GetExpiredTimer() )
    else
        call GroupEnumUnitsInRange( g, GetUnitX( dummy ), GetUnitY( dummy ), 100, null )
        loop
            set u = FirstOfGroup(g)
            exitwhen u == null
            if IsUnitType( u, UNIT_TYPE_HERO) then
                call DestroyEffect( AddSpecialEffectTarget( "Abilities\\Spells\\Human\\DispelMagic\\DispelMagicTarget.mdl", u, "origin") )
                call UnitAddAbility( u, 'A0VQ' )
                
                set id1 = GetHandleId( u )
                if LoadTimerHandle( udg_hash, id, StringHash( "bswdrn1" ) ) == null  then
                    call SaveTimerHandle( udg_hash, id1, StringHash( "bswdrn1" ), CreateTimer() )
                endif
                set id1 = GetHandleId( LoadTimerHandle( udg_hash, id1, StringHash( "bswdrn1" ) ) ) 
                call SaveUnitHandle( udg_hash, id1, StringHash( "bswdrn1" ), u )
                call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( u ), StringHash( "bswdrn1" ) ), 20, true, function WendRunEnd ) 
            endif
            call GroupRemoveUnit(g,u)
            set u = FirstOfGroup(g)
        endloop
    endif

    call GroupClear( g )
    set u = null
    set g = null
    set dummy = null
endfunction

function WendCast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local integer id1
    local unit boss = LoadUnitHandle( udg_hash, id, StringHash( "bswd" ) )
    local integer rand = GetRandomInt( 1, 5 )
    local real x = GetRandomReal(GetRectMinX(udg_Boss_Rect), GetRectMaxX(udg_Boss_Rect))
    local real y = GetRandomReal(GetRectMinY(udg_Boss_Rect), GetRectMaxY(udg_Boss_Rect))
    
    if GetUnitState( boss, UNIT_STATE_LIFE) <= 0.405 or not( udg_fightmod[0] ) then
        call FlushChildHashtable( udg_hash, id )
        call DestroyTimer( GetExpiredTimer() )
    elseif rand == 1 then
        set bj_lastCreatedUnit = CreateUnit( GetOwningPlayer( boss ), 'u000', x, y, 270 )
        call UnitAddAbility( bj_lastCreatedUnit, 'A0VI')
        call UnitApplyTimedLife( bj_lastCreatedUnit, 'BTLF', 20)
        call DestroyEffect( AddSpecialEffectTarget( "Abilities\\Spells\\Items\\AIma\\AImaTarget.mdl", bj_lastCreatedUnit, "origin") )
        
        set id1 = GetHandleId( bj_lastCreatedUnit )
        
        call SaveTimerHandle( udg_hash, id1, StringHash( "bswdmp" ), CreateTimer() )
        set id1 = GetHandleId( LoadTimerHandle( udg_hash, id1, StringHash( "bswdmp" ) ) ) 
        call SaveUnitHandle( udg_hash, id1, StringHash( "bswdmp" ), bj_lastCreatedUnit )
        call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( bj_lastCreatedUnit ), StringHash( "bswdmp" ) ), 1, true, function WendMana )
    elseif rand == 2 then
        set bj_lastCreatedUnit = CreateUnit( GetOwningPlayer( boss ), 'u000', x, y, 270 )
        call UnitAddAbility( bj_lastCreatedUnit, 'A0VJ')
        call UnitApplyTimedLife( bj_lastCreatedUnit, 'BTLF', 20)
        call DestroyEffect( AddSpecialEffectTarget( "Abilities\\Spells\\Human\\Heal\\HealTarget.mdl", bj_lastCreatedUnit, "origin") )
        
        set id1 = GetHandleId( bj_lastCreatedUnit )
        
        call SaveTimerHandle( udg_hash, id1, StringHash( "bswdhp" ), CreateTimer() )
        set id1 = GetHandleId( LoadTimerHandle( udg_hash, id1, StringHash( "bswdhp" ) ) ) 
        call SaveUnitHandle( udg_hash, id1, StringHash( "bswdhp" ), bj_lastCreatedUnit )
        call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( bj_lastCreatedUnit ), StringHash( "bswdhp" ) ), 1, true, function WendLife )
    elseif rand == 3 then
        set bj_lastCreatedUnit = CreateUnit( GetOwningPlayer( boss ), 'u000', x, y, 270 )
        call UnitAddAbility( bj_lastCreatedUnit, 'A0VK')
        call UnitApplyTimedLife( bj_lastCreatedUnit, 'BTLF', 20)
        call DestroyEffect( AddSpecialEffectTarget( "war3mapImported\\Sci Teleport.mdx", bj_lastCreatedUnit, "origin") )
        
        set id1 = GetHandleId( bj_lastCreatedUnit )
        
        call SaveTimerHandle( udg_hash, id1, StringHash( "bswdtm" ), CreateTimer() )
        set id1 = GetHandleId( LoadTimerHandle( udg_hash, id1, StringHash( "bswdtm" ) ) ) 
        call SaveUnitHandle( udg_hash, id1, StringHash( "bswdtm" ), bj_lastCreatedUnit )
        call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( bj_lastCreatedUnit ), StringHash( "bswdtm" ) ), 1, true, function WendTime )   
    elseif rand == 4 then
        set bj_lastCreatedUnit = CreateUnit( GetOwningPlayer( boss ), 'u000', x, y, 270 )
        call UnitAddAbility( bj_lastCreatedUnit, 'A0VL')
        call UnitApplyTimedLife( bj_lastCreatedUnit, 'BTLF', 20)
        call DestroyEffect( AddSpecialEffectTarget( "Abilities\\Spells\\NightElf\\BattleRoar\\RoarCaster.mdl", bj_lastCreatedUnit, "origin") )
        
        set id1 = GetHandleId( bj_lastCreatedUnit )
        
        call SaveTimerHandle( udg_hash, id1, StringHash( "bswdrg" ), CreateTimer() )
        set id1 = GetHandleId( LoadTimerHandle( udg_hash, id1, StringHash( "bswdrg" ) ) ) 
        call SaveUnitHandle( udg_hash, id1, StringHash( "bswdrg" ), bj_lastCreatedUnit )
        call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( bj_lastCreatedUnit ), StringHash( "bswdrg" ) ), 1, true, function WendRage )
    elseif rand == 5 then
        set bj_lastCreatedUnit = CreateUnit( GetOwningPlayer( boss ), 'u000', x, y, 270 )
        call UnitAddAbility( bj_lastCreatedUnit, 'A0VM')
        call UnitApplyTimedLife( bj_lastCreatedUnit, 'BTLF', 20)
        call DestroyEffect( AddSpecialEffectTarget( "Abilities\\Spells\\Human\\DispelMagic\\DispelMagicTarget.mdl", bj_lastCreatedUnit, "origin") )
        
        set id1 = GetHandleId( bj_lastCreatedUnit )
        
        call SaveTimerHandle( udg_hash, id1, StringHash( "bswdrn" ), CreateTimer() )
        set id1 = GetHandleId( LoadTimerHandle( udg_hash, id1, StringHash( "bswdrn" ) ) ) 
        call SaveUnitHandle( udg_hash, id1, StringHash( "bswdrn" ), bj_lastCreatedUnit )
        call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( bj_lastCreatedUnit ), StringHash( "bswdrn" ) ), 1, true, function WendRun ) 
    endif
    
    set boss = null
endfunction

function Trig_Wendigo1_Actions takes nothing returns nothing
    local integer id = GetHandleId( udg_DamageEventTarget )

    call DisableTrigger( GetTriggeringTrigger() )
    
    if LoadTimerHandle( udg_hash, id, StringHash( "bswd" ) ) == null  then
        call SaveTimerHandle( udg_hash, id, StringHash( "bswd" ), CreateTimer() )
    endif
	set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "bswd" ) ) ) 
    call SaveUnitHandle( udg_hash, id, StringHash( "bswd" ), udg_DamageEventTarget )
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( udg_DamageEventTarget ), StringHash( "bswd" ) ), bosscast(5), true, function WendCast )
endfunction

//===========================================================================
function InitTrig_Wendigo1 takes nothing returns nothing
    set gg_trg_Wendigo1 = CreateTrigger(  )
    call DisableTrigger( gg_trg_Wendigo1 )
    call TriggerRegisterVariableEvent( gg_trg_Wendigo1, "udg_AfterDamageEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_Wendigo1, Condition( function Trig_Wendigo1_Conditions ) )
    call TriggerAddAction( gg_trg_Wendigo1, function Trig_Wendigo1_Actions )
endfunction

