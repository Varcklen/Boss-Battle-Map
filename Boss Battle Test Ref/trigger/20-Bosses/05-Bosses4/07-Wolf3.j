function Trig_Wolf3_Conditions takes nothing returns boolean
    return GetUnitTypeId( udg_DamageEventTarget ) == 'o009' and GetUnitLifePercent(udg_DamageEventTarget) <= 25
endfunction

function Wolf3Cast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local unit boss = LoadUnitHandle( udg_hash, id, StringHash( "bswf" ) )
    local group g = CreateGroup()
    local unit u
    local integer i = 0
    
    set bj_livingPlayerUnitsTypeId = 'o00A'
    call GroupEnumUnitsOfPlayer(g, GetOwningPlayer( boss ), filterLivingPlayerUnitsOfTypeId)
    loop
        set u = FirstOfGroup(g)
        exitwhen u == null
        set i = i + 1
        call GroupRemoveUnit(g,u)
    endloop
    
    if i == 0 then
        if udg_fightmod[0] then
            call SetUnitPositionLoc( boss, Location(GetRectCenterX(udg_Boss_Rect), GetRectCenterY(udg_Boss_Rect)) ) 
            call ShowUnit( boss, true )
            call DestroyEffect( AddSpecialEffectTarget( "Abilities\\Spells\\Orc\\FeralSpirit\\feralspirittarget.mdl", boss, "origin") )
            call DestroyEffect( AddSpecialEffectTarget( "Abilities\\Spells\\NightElf\\BattleRoar\\RoarCaster.mdl", boss, "origin") )
            call UnitAddAbility( boss, 'A0JZ' )
            call IssueImmediateOrder( boss, "stop" )
            call aggro( boss )
        else
            call RemoveUnit( boss )
        endif
        call moonst( -1 )
        call FlushChildHashtable( udg_hash, id )
        call DestroyTimer( GetExpiredTimer() )
    endif
    
    call GroupClear( g )
    call DestroyGroup( g )
    set u = null
    set g = null
    set boss = null
endfunction

function Trig_Wolf3_Actions takes nothing returns nothing
    local integer id = GetHandleId( udg_DamageEventTarget )
    local integer cyclA = 1
    local integer cyclB
    
    call DisableTrigger( GetTriggeringTrigger() )
    call ShowUnit( udg_DamageEventTarget, false )
    call SetUnitPosition( udg_DamageEventTarget, GetRectCenterX( gg_rct_HeroesTp ), GetRectCenterY( gg_rct_HeroesTp ) ) 
    call IssueImmediateOrder( udg_DamageEventTarget, "stop" )
    call moonst( 1 )
    loop
        exitwhen cyclA > 4
        if GetUnitState( udg_hero[cyclA], UNIT_STATE_LIFE) > 0.405 then
            call IssueImmediateOrder( udg_hero[cyclA], "stop" )
            set cyclB = 1
            loop
                exitwhen cyclB > 2
                call CreateUnit( GetOwningPlayer( udg_DamageEventTarget ), 'o00A', GetUnitX( udg_hero[cyclA] ) + GetRandomReal( -120, 120 ), GetUnitY( udg_hero[cyclA] ) + GetRandomReal( -120, 120 ), GetRandomReal(0, 360) )
                set cyclB = cyclB + 1
            endloop
        endif
        set cyclA = cyclA + 1
    endloop
    
    if LoadTimerHandle( udg_hash, id, StringHash( "bswf" ) ) == null then
        call SaveTimerHandle( udg_hash, id, StringHash( "bswf" ), CreateTimer() )
    endif
    set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "bswf" ) ) ) 
    call SaveUnitHandle( udg_hash, id, StringHash( "bswf" ), udg_DamageEventTarget )
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( udg_DamageEventTarget ), StringHash( "bswf" ) ), 1, true, function Wolf3Cast )
endfunction

//===========================================================================
function InitTrig_Wolf3 takes nothing returns nothing
    set gg_trg_Wolf3 = CreateTrigger(  )
    call DisableTrigger( gg_trg_Wolf3 )
    call TriggerRegisterVariableEvent( gg_trg_Wolf3, "udg_AfterDamageEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_Wolf3, Condition( function Trig_Wolf3_Conditions ) )
    call TriggerAddAction( gg_trg_Wolf3, function Trig_Wolf3_Actions )
endfunction