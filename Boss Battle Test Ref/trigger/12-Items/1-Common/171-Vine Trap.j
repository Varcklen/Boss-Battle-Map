function Trig_Vine_Trap_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A18D'
endfunction

function Vine_TrapEnd takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local unit dummy = LoadUnitHandle( udg_hash, id, StringHash( "vntp" ) )
    local boolean l = false
    local group g = CreateGroup()
    local unit u
    
    if GetUnitState( dummy, UNIT_STATE_LIFE) <= 0.405 or not( udg_fightmod[0] ) then
        call FlushChildHashtable( udg_hash, id )
        call DestroyTimer( GetExpiredTimer() )
    else
        call GroupEnumUnitsInRange( g, GetUnitX( dummy ), GetUnitY( dummy ), 128, null )
        loop
            set u = FirstOfGroup(g)
            exitwhen u == null
            if unitst( u, dummy, "enemy" ) then
                call dummyspawn( dummy, 1, 'A18F', 0, 0 )
                call IssueTargetOrder( bj_lastCreatedUnit, "entanglingroots", u )
                set l = true
            endif
            call GroupRemoveUnit(g,u)
        endloop
        if l then
            call RemoveUnit( dummy )
            call FlushChildHashtable( udg_hash, id )
            call DestroyTimer( GetExpiredTimer() )
        endif
    endif
    
    call GroupClear( g )
    call DestroyGroup( g )
    set u = null
    set g = null
    set dummy = null
endfunction

function Trig_Vine_Trap_Actions takes nothing returns nothing
    local integer cyclA = 1
    local integer cyclAEnd
    local unit caster
    local real x
    local real y
    local integer id
    
    if CastLogic() then
        set caster = udg_Caster
        set x = GetLocationX( GetSpellTargetLoc() )
        set y = GetLocationY( GetSpellTargetLoc() )
    elseif RandomLogic() then
        set caster = udg_Caster
        set x = GetUnitX( caster ) + GetRandomReal( -650, 650 )
        set y = GetUnitY( caster ) + GetRandomReal( -650, 650 )
        call textst( udg_string[0] + GetObjectName('A18D'), caster, 64, 90, 10, 1.5 )
    else
        set caster = GetSpellAbilityUnit()
        set x = GetLocationX( GetSpellTargetLoc() )
        set y = GetLocationY( GetSpellTargetLoc() )
    endif

    set cyclAEnd = eyest( caster )
    loop
        exitwhen cyclA > cyclAEnd
        set bj_lastCreatedUnit = CreateUnit( GetOwningPlayer( caster ), 'u000', x, y, 270 )
        call UnitAddAbility( bj_lastCreatedUnit, 'A18E')

        set id = GetHandleId( bj_lastCreatedUnit )
        if LoadTimerHandle( udg_hash, id, StringHash( "vntp" ) ) == null  then
            call SaveTimerHandle( udg_hash, id, StringHash( "vntp" ), CreateTimer() )
        endif
        set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "vntp" ) ) ) 
        call SaveUnitHandle( udg_hash, id, StringHash( "vntp" ), bj_lastCreatedUnit )
        call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( bj_lastCreatedUnit ), StringHash( "vntp" ) ), 0.5, true, function Vine_TrapEnd )
        set cyclA = cyclA + 1
    endloop

    set caster = null
endfunction

//===========================================================================
function InitTrig_Vine_Trap takes nothing returns nothing
    set gg_trg_Vine_Trap = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Vine_Trap, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_Vine_Trap, Condition( function Trig_Vine_Trap_Conditions ) )
    call TriggerAddAction( gg_trg_Vine_Trap, function Trig_Vine_Trap_Actions )
endfunction

