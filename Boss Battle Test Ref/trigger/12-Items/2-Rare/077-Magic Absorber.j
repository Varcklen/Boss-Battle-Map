function Trig_Magic_Absorber_Conditions takes nothing returns boolean
    return GetItemTypeId(GetManipulatedItem()) == 'I0FA'
endfunction

function Magic_AbsorberCast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local unit caster = LoadUnitHandle( udg_hash, id, StringHash( "pwsi" ) )
    local item it = LoadItemHandle( udg_hash, id, StringHash( "pwsii" ) )
    local real arm = LoadReal( udg_hash, id, StringHash( "pwsi" ) )
    local real spd = (GetHeroInt( caster, true) - arm) * 0.3
    local real spdnow = LoadReal( udg_hash, GetHandleId( caster ), StringHash( "pwsin" ) )

    if not(UnitHasItem(caster, it)) then
        call spdst( caster, -1*spdnow )
        call SaveReal( udg_hash, GetHandleId( caster ), StringHash( "pwsin" ), 0 )
        call FlushChildHashtable( udg_hash, id )
        call DestroyTimer( GetExpiredTimer() )
    elseif arm != GetHeroInt( caster, true) then
        call spdst( caster, spd )
        call SaveReal( udg_hash, GetHandleId( caster ), StringHash( "pwsin" ), spdnow+spd )
        call SaveReal( udg_hash, id, StringHash( "pwsi" ), GetHeroInt( caster, true) ) 
    endif

    set caster = null
    set it = null
endfunction

function Trig_Magic_Absorber_Actions takes nothing returns nothing
    local integer id = GetHandleId( GetManipulatedItem() )

    if LoadTimerHandle( udg_hash, id, StringHash( "pwsi" ) ) == null  then
        call SaveTimerHandle( udg_hash, id, StringHash( "pwsi" ), CreateTimer() )
    endif
    set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "pwsi" ) ) )
    call SaveUnitHandle( udg_hash, id, StringHash( "pwsi" ), GetManipulatingUnit() ) 
    call SaveItemHandle( udg_hash, id, StringHash( "pwsii" ), GetManipulatedItem() )
    call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( GetManipulatedItem() ), StringHash( "pwsi" ) ), 1, true, function Magic_AbsorberCast )
endfunction

//===========================================================================
function InitTrig_Magic_Absorber takes nothing returns nothing
    set gg_trg_Magic_Absorber = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Magic_Absorber, EVENT_PLAYER_UNIT_PICKUP_ITEM ) 
    call TriggerAddCondition( gg_trg_Magic_Absorber, Condition( function Trig_Magic_Absorber_Conditions ) )
    call TriggerAddAction( gg_trg_Magic_Absorber, function Trig_Magic_Absorber_Actions )
endfunction

