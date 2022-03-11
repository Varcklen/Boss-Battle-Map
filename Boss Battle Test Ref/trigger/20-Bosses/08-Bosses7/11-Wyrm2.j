function Trig_Wyrm2_Conditions takes nothing returns boolean
    return GetUnitTypeId(GetEnteringUnit()) == 'e00E' and GetOwningPlayer(GetEnteringUnit()) == Player(10) and udg_fightmod[0]
endfunction

function Wyrm2Cast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local unit u = LoadUnitHandle( udg_hash, id, StringHash( "bswrb" ) )
    local unit nu
    local real hp = GetUnitState( u, UNIT_STATE_LIFE)
    local real f = GetUnitFacing( u )
    local real x = GetUnitX( u )
    local real y = GetUnitY( u )
    local real hpp = ( hp / RMaxBJ(0,GetUnitState( u, UNIT_STATE_MAX_LIFE) ) ) * 100
    local unit target
    
    if not( udg_fightmod[0] ) then
        call FlushChildHashtable( udg_hash, id )
        call DestroyTimer( GetExpiredTimer() )
    elseif hpp <= 25 then
        call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\Other\\Charm\\CharmTarget.mdl", x, y ) )
        call RemoveUnit( u )
        set nu = CreateUnit( Player(4), 'e00G', x, y, f )
        if hpp > 10 then
            call SetUnitState( nu, UNIT_STATE_LIFE, hp)
        else
            call SetUnitState( nu, UNIT_STATE_LIFE, GetUnitState( nu, UNIT_STATE_MAX_LIFE) * 0.1 )
        endif
        set target = GroupPickRandomUnit(GetUnitsOfPlayerAndTypeId(Player(10), 'o00M'))
        if target != null then
            call IssueTargetOrder( nu, "attack", target )
        endif
        call UnitAddAbility( nu, 'Amim')
        call FlushChildHashtable( udg_hash, id )
        call DestroyTimer( GetExpiredTimer() )
    endif

    set u = null
    set nu = null
    set target = null
endfunction

function Trig_Wyrm2_Actions takes nothing returns nothing
    local integer id = GetHandleId( GetEnteringUnit() )
    
    call SaveTimerHandle( udg_hash, id, StringHash( "bswrb" ), CreateTimer() )
	set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "bswrb" ) ) ) 
    call SaveUnitHandle( udg_hash, id, StringHash( "bswrb" ), GetEnteringUnit() )
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( GetEnteringUnit() ), StringHash( "bswrb" ) ), 0.5, true, function Wyrm2Cast )
endfunction

//===========================================================================
function InitTrig_Wyrm2 takes nothing returns nothing
    set gg_trg_Wyrm2 = CreateTrigger()
    call DisableTrigger( gg_trg_Wyrm2 )
    call TriggerRegisterEnterRectSimple( gg_trg_Wyrm2, GetWorldBounds() )
    call TriggerAddCondition( gg_trg_Wyrm2, Condition( function Trig_Wyrm2_Conditions ) )
    call TriggerAddAction( gg_trg_Wyrm2, function Trig_Wyrm2_Actions )
endfunction

