function Trig_Magic_Dispenser_Conditions takes nothing returns boolean
    return GetItemTypeId(GetManipulatedItem()) == 'I0F9'
endfunction

function Magic_DispenserCast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local unit caster = LoadUnitHandle( udg_hash, id, StringHash( "pwsa" ) )
    local integer pl = LoadInteger( udg_hash, id, StringHash( "pwsapl" ) )
    local item it = LoadItemHandle( udg_hash, id, StringHash( "pwsai" ) )
    local real arm = LoadReal( udg_hash, id, StringHash( "pwsa" ) )
    local real spd = (GetHeroAgi( caster, true) - arm) * 0.5
    local real spdnow = LoadReal( udg_hash, GetHandleId( caster ), StringHash( "pwsan" ) )

    if not(UnitHasItem(caster, it)) then
        call spdstpl( pl, -1*spdnow )
        call SaveReal( udg_hash, GetHandleId( caster ), StringHash( "pwsan" ), 0 )
        call FlushChildHashtable( udg_hash, id )
        call DestroyTimer( GetExpiredTimer() )
    elseif arm != GetHeroAgi( caster, true) then
        call spdstpl( pl, spd )
        call SaveReal( udg_hash, GetHandleId( caster ), StringHash( "pwsan" ), spdnow+spd )
        call SaveReal( udg_hash, id, StringHash( "pwsa" ), GetHeroAgi( caster, true) ) 
    endif

    set caster = null
    set it = null
endfunction

function Trig_Magic_Dispenser_Actions takes nothing returns nothing
    local integer id = GetHandleId( GetManipulatedItem() )

    if LoadTimerHandle( udg_hash, id, StringHash( "pwsa" ) ) == null  then
        call SaveTimerHandle( udg_hash, id, StringHash( "pwsa" ), CreateTimer() )
    endif
    set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "pwsa" ) ) )
    call SaveUnitHandle( udg_hash, id, StringHash( "pwsa" ), GetManipulatingUnit() ) 
    call SaveItemHandle( udg_hash, id, StringHash( "pwsai" ), GetManipulatedItem() )
    call SaveInteger( udg_hash, id, StringHash( "pwsapl" ), GetPlayerId( GetOwningPlayer( GetManipulatingUnit() ) ) )
    call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( GetManipulatedItem() ), StringHash( "pwsa" ) ), 1, true, function Magic_DispenserCast )
endfunction

//===========================================================================
function InitTrig_Magic_Dispenser takes nothing returns nothing
    set gg_trg_Magic_Dispenser = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Magic_Dispenser, EVENT_PLAYER_UNIT_PICKUP_ITEM ) 
    call TriggerAddCondition( gg_trg_Magic_Dispenser, Condition( function Trig_Magic_Dispenser_Conditions ) )
    call TriggerAddAction( gg_trg_Magic_Dispenser, function Trig_Magic_Dispenser_Actions )
endfunction

