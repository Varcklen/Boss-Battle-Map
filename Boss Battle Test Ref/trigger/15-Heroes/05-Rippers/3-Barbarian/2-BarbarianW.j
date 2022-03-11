function Trig_BarbarianW_Conditions takes nothing returns boolean
    return GetUnitAbilityLevel(GetOrderedUnit(), 'A0R0') > 0
endfunction

function BarbarianWCast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer( ) )
    local unit caster = LoadUnitHandle( udg_hash, id, StringHash( "barw" ) )
    local real r = LoadReal( udg_hash, id, StringHash( "barw" ) )
    
    if IsUnitDead( caster )then
        call UnitRemoveAbility( caster, 'A0RG')
        call FlushChildHashtable( udg_hash, id )
        call DestroyTimer( GetExpiredTimer() )
    elseif GetUnitState( caster, UNIT_STATE_MANA) >= r then
        call SetUnitState( caster, UNIT_STATE_MANA, RMaxBJ(0,GetUnitState( caster, UNIT_STATE_MANA) - r ) )
    else
        call SetUnitState( caster, UNIT_STATE_LIFE, RMaxBJ(0,GetUnitState( caster, UNIT_STATE_LIFE) - r ) )
    endif

    set caster = null
endfunction

function Trig_BarbarianW_Actions takes nothing returns nothing
    local unit u = GetOrderedUnit()
    local integer id = GetHandleId( u )
    local integer lvl = GetUnitAbilityLevel( u, 'A0R0' )
    local real hp

    if GetIssuedOrderId() == OrderId("immolation") then
        set hp = 8 + lvl
    
        call UnitAddAbility( u, 'A0RG')
        call SetUnitAbilityLevel( u, 'A0RG', lvl )
        call DestroyEffect( AddSpecialEffectTarget( "Abilities\\Spells\\NightElf\\BattleRoar\\RoarCaster.mdl", u, "origin") )
        
        if LoadTimerHandle( udg_hash, id, StringHash( "barw" ) ) == null then
            call SaveTimerHandle( udg_hash, id, StringHash( "barw" ), CreateTimer() )
        endif
        set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "barw" ) ) ) 
        call SaveUnitHandle( udg_hash, id, StringHash( "barw" ), u )   
        call SaveReal( udg_hash, id, StringHash( "barw" ), hp )
        call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( u ), StringHash( "barw" ) ), 1, true, function BarbarianWCast )
    elseif GetIssuedOrderId() == OrderId("unimmolation") then
        call UnitRemoveAbility( u, 'A0RG')
        call FlushChildHashtable( udg_hash, GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "barw" ) ) ) )
        call DestroyTimer( LoadTimerHandle( udg_hash, id, StringHash( "barw" ) ) )
    endif
    
    set u = null
endfunction

//===========================================================================
function InitTrig_BarbarianW takes nothing returns nothing
    set gg_trg_BarbarianW = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_BarbarianW, EVENT_PLAYER_UNIT_ISSUED_ORDER )
    call TriggerAddCondition( gg_trg_BarbarianW, Condition( function Trig_BarbarianW_Conditions ) )
    call TriggerAddAction( gg_trg_BarbarianW, function Trig_BarbarianW_Actions )
endfunction