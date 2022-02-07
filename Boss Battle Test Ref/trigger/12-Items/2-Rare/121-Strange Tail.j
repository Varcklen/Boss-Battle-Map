function Trig_Strange_Tail_Conditions takes nothing returns boolean
    return GetItemTypeId(GetManipulatedItem()) == 'I04U'
endfunction

function Strange_TailCast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local unit caster = LoadUnitHandle( udg_hash, id, StringHash( "sttl" ) )
    local integer pl = LoadInteger( udg_hash, id, StringHash( "sttlpl" ) )
    local item it = LoadItemHandle( udg_hash, id, StringHash( "sttli" ) )
    local real arm = LoadReal( udg_hash, id, StringHash( "sttl" ) )
    local real amount = 100-GetUnitStatePercent(caster, UNIT_STATE_LIFE, UNIT_STATE_MAX_LIFE)
    local real spd = amount - arm
    local real spdnow = LoadReal( udg_hash, GetHandleId( caster ), StringHash( "sttln" ) )
    
    if not(UnitHasItem(caster, it)) then
        call spdstpl( pl, -1*spdnow )
        call SaveReal( udg_hash, GetHandleId( caster ), StringHash( "sttln" ), 0 )
        call FlushChildHashtable( udg_hash, id )
        call DestroyTimer( GetExpiredTimer() )
    elseif arm != amount then
        call spdstpl( pl, spd )
        call SaveReal( udg_hash, GetHandleId( caster ), StringHash( "sttln" ), spdnow+spd )
        call SaveReal( udg_hash, id, StringHash( "sttl" ), amount ) 
    endif

    set caster = null
    set it = null
endfunction

function Trig_Strange_Tail_Actions takes nothing returns nothing
    local integer id = GetHandleId( GetManipulatedItem() )

    if LoadTimerHandle( udg_hash, id, StringHash( "sttl" ) ) == null  then
        call SaveTimerHandle( udg_hash, id, StringHash( "sttl" ), CreateTimer() )
    endif
    set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "sttl" ) ) )
    call SaveUnitHandle( udg_hash, id, StringHash( "sttl" ), GetManipulatingUnit() ) 
    call SaveItemHandle( udg_hash, id, StringHash( "sttli" ), GetManipulatedItem() )
    call SaveInteger( udg_hash, id, StringHash( "sttlpl" ), GetPlayerId( GetOwningPlayer( GetManipulatingUnit() ) ) )
    call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( GetManipulatedItem() ), StringHash( "sttl" ) ), 2, true, function Strange_TailCast )
endfunction

//===========================================================================
function InitTrig_Strange_Tail takes nothing returns nothing
    set gg_trg_Strange_Tail = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Strange_Tail, EVENT_PLAYER_UNIT_PICKUP_ITEM ) 
    call TriggerAddCondition( gg_trg_Strange_Tail, Condition( function Trig_Strange_Tail_Conditions ) )
    call TriggerAddAction( gg_trg_Strange_Tail, function Trig_Strange_Tail_Actions )
endfunction

