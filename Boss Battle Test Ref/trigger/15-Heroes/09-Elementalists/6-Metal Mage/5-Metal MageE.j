function Trig_Metal_MageE_Conditions takes nothing returns boolean
    return GetUnitAbilityLevel(GetOrderedUnit(), 'A0NG') > 0
endfunction

function Metal_MageECast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer( ) )
    local unit caster = LoadUnitHandle( udg_hash, id, StringHash( "mtme" ) )
    local real per = LoadReal( udg_hash, id, StringHash( "mtme" ) )
    local group g = CreateGroup()
    local unit u
    
        call GroupEnumUnitsInRange( g, GetUnitX( caster ), GetUnitY( caster ), 900, null )
        loop
            set u = FirstOfGroup(g)
            exitwhen u == null
            if unitst( u, caster, "ally" ) and u != caster then
                call healst( caster, u, RMaxBJ( 1,GetUnitState( u, UNIT_STATE_MAX_LIFE) * per) )
		call manast( caster, u, RMaxBJ( 1,GetUnitState( u, UNIT_STATE_MAX_MANA) * per) )
            endif
            call GroupRemoveUnit(g,u)
            set u = FirstOfGroup(g)
        endloop
    
    call GroupClear( g )
    call DestroyGroup( g )
    set u = null
    set caster = null
endfunction

function Trig_Metal_MageE_Actions takes nothing returns nothing
    local integer id = GetHandleId( GetOrderedUnit() )
    local integer lvl
    
    set lvl = GetUnitAbilityLevel( GetOrderedUnit(), 'A0NG' )

    if GetIssuedOrderId() == OrderId("immolation") then
        call UnitAddAbility( GetOrderedUnit(), 'A0LT')
        
        if LoadTimerHandle( udg_hash, id, StringHash( "mtme" ) ) == null then
            call SaveTimerHandle( udg_hash, id, StringHash( "mtme" ), CreateTimer() )
        endif
        set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "mtme" ) ) ) 
        call SaveUnitHandle( udg_hash, id, StringHash( "mtme" ), GetOrderedUnit() )   
        call SaveReal( udg_hash, id, StringHash( "mtme" ), lvl * 0.004 )
        call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( GetOrderedUnit() ), StringHash( "mtme" ) ), 1, true, function Metal_MageECast )
    elseif GetIssuedOrderId() == OrderId("unimmolation") then
        call UnitRemoveAbility( GetOrderedUnit(), 'A0LT')
        call UnitRemoveAbility( GetOrderedUnit(), 'B06J')
        call FlushChildHashtable( udg_hash, GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "mtme" ) ) ) )
        call DestroyTimer( LoadTimerHandle( udg_hash, id, StringHash( "mtme" ) ) )
    endif
endfunction

//===========================================================================
function InitTrig_Metal_MageE takes nothing returns nothing
    set gg_trg_Metal_MageE = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Metal_MageE, EVENT_PLAYER_UNIT_ISSUED_ORDER )
    call TriggerAddCondition( gg_trg_Metal_MageE, Condition( function Trig_Metal_MageE_Conditions ) )
    call TriggerAddAction( gg_trg_Metal_MageE, function Trig_Metal_MageE_Actions )
endfunction

