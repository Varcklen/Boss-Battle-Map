function Trig_Sheep3_Conditions takes nothing returns boolean
    return GetUnitTypeId(udg_DamageEventTarget) == 'n007' and GetUnitLifePercent(udg_DamageEventTarget) <= 50. and GetOwningPlayer(udg_DamageEventTarget) == Player(10)
endfunction

function Sheep3Repeat takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local unit boss = LoadUnitHandle( udg_hash, id, StringHash( "bstt3u" ) )
    local unit dummy = LoadUnitHandle( udg_hash, id, StringHash( "bstt3d" ) )
    local group g = CreateGroup()
    local unit u
    local integer id1
    local boolean l = false
    
    call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\Human\\Polymorph\\PolyMorphTarget.mdl", GetUnitX( dummy ), GetUnitY( dummy ) + 100 ) )
    call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\Human\\Polymorph\\PolyMorphTarget.mdl", GetUnitX( dummy ) + 140, GetUnitY( dummy ) - 140 ) )
    call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\Human\\Polymorph\\PolyMorphTarget.mdl", GetUnitX( dummy ) - 140, GetUnitY( dummy ) - 140 ) )
    
    call GroupEnumUnitsInRange( g, GetUnitX( dummy ), GetUnitY( dummy ), 200, null )
    loop
        set u = FirstOfGroup(g)
        exitwhen u == null
        if unitst( u, boss, "enemy" ) then
            call UnitPoly( boss, u, 'n02L', 5 )
            if IsUnitType( u, UNIT_TYPE_HERO) then
                set l = true
            endif
        endif
        call GroupRemoveUnit(g,u)
    endloop
    
    if l then
        set id1 = GetHandleId( dummy )
        if LoadTimerHandle( udg_hash, id1, StringHash( "bstt3d" ) ) == null  then
            call SaveTimerHandle( udg_hash, id1, StringHash( "bstt3d" ), CreateTimer() )
        endif
        set id1 = GetHandleId( LoadTimerHandle( udg_hash, id1, StringHash( "bstt3d" ) ) ) 
        call SaveUnitHandle( udg_hash, id1, StringHash( "bstt3d" ), dummy )
        call SaveUnitHandle( udg_hash, id1, StringHash( "bstt3u" ), boss )
        call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( dummy ), StringHash( "bstt3d" ) ), bosscast(1), false, function Sheep3Repeat )
    else
        call RemoveUnit( dummy )
        call FlushChildHashtable( udg_hash, id )
    endif
    
    call GroupClear( g )
    call DestroyGroup( g )
    set u = null
    set g = null
    set boss = null
    set dummy = null
endfunction 

function Trig_Sheep3_Actions takes nothing returns nothing
    local integer cyclA = 1
    local integer id
    
    call DisableTrigger( GetTriggeringTrigger() )
    loop
        exitwhen cyclA > 4
        if GetUnitState( udg_hero[cyclA], UNIT_STATE_LIFE) > 0.405 then
            set bj_lastCreatedUnit = CreateUnit( GetOwningPlayer( udg_DamageEventTarget ), 'u000', GetUnitX( udg_hero[cyclA] ), GetUnitY( udg_hero[cyclA] ), 270 )
            call SetUnitScale(bj_lastCreatedUnit, 2, 2, 2 )
            call UnitAddAbility( bj_lastCreatedUnit, 'A136')
        
            set id = GetHandleId( bj_lastCreatedUnit )
            if LoadTimerHandle( udg_hash, id, StringHash( "bstt3d" ) ) == null then
                call SaveTimerHandle( udg_hash, id, StringHash( "bstt3d" ), CreateTimer() )
            endif
            set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "bstt3d" ) ) ) 
            call SaveUnitHandle( udg_hash, id, StringHash( "bstt3d" ), bj_lastCreatedUnit )
            call SaveUnitHandle( udg_hash, id, StringHash( "bstt3u" ), udg_DamageEventTarget )
            call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( bj_lastCreatedUnit ), StringHash( "bstt3d" ) ), bosscast(1), false, function Sheep3Repeat )
        endif
        set cyclA = cyclA + 1
    endloop
endfunction

//===========================================================================
function InitTrig_Sheep3 takes nothing returns nothing
    set gg_trg_Sheep3 = CreateTrigger()
    call DisableTrigger( gg_trg_Sheep3 )
    call TriggerRegisterVariableEvent( gg_trg_Sheep3, "udg_AfterDamageEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_Sheep3, Condition( function Trig_Sheep3_Conditions ) )
    call TriggerAddAction( gg_trg_Sheep3, function Trig_Sheep3_Actions )
endfunction