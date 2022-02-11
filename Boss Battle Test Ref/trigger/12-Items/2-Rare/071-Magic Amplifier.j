function Trig_Magic_Amplifier_Conditions takes nothing returns boolean
    return GetItemTypeId(GetManipulatedItem()) == 'I0BS'
endfunction

function Magic_AmplifierCast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local unit caster = LoadUnitHandle( udg_hash, id, StringHash( "pwst" ) )
    local integer pl = LoadInteger( udg_hash, id, StringHash( "pwstpl" ) )
    local item it = LoadItemHandle( udg_hash, id, StringHash( "pwsti" ) )
    local real arm = LoadReal( udg_hash, id, StringHash( "pwst" ) )
    local real spd = (GetHeroStr( caster, true) - arm) * 0.5
    local real spdnow = LoadReal( udg_hash, GetHandleId( caster ), StringHash( "pwstn" ) )

    if not(UnitHasItem(caster, it)) then
        call spdstpl( pl, -1*spdnow )
        call SaveReal( udg_hash, GetHandleId( caster ), StringHash( "pwstn" ), 0 )
        call FlushChildHashtable( udg_hash, id )
        call DestroyTimer( GetExpiredTimer() )
    elseif arm != GetHeroStr( caster, true) then
        call spdstpl( pl, spd )
        call SaveReal( udg_hash, GetHandleId( caster ), StringHash( "pwstn" ), spdnow+spd )
        call SaveReal( udg_hash, id, StringHash( "pwst" ), GetHeroStr( caster, true) ) 
    endif

    set caster = null
    set it = null
endfunction

function Trig_Magic_Amplifier_Actions takes nothing returns nothing
    local integer id = GetHandleId( GetManipulatedItem() )

    if LoadTimerHandle( udg_hash, id, StringHash( "pwst" ) ) == null  then
        call SaveTimerHandle( udg_hash, id, StringHash( "pwst" ), CreateTimer() )
    endif
    set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "pwst" ) ) )
    call SaveUnitHandle( udg_hash, id, StringHash( "pwst" ), GetManipulatingUnit() ) 
    call SaveItemHandle( udg_hash, id, StringHash( "pwsti" ), GetManipulatedItem() )
    call SaveInteger( udg_hash, id, StringHash( "pwstpl" ), GetPlayerId( GetOwningPlayer( GetManipulatingUnit() ) ) )
    call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( GetManipulatedItem() ), StringHash( "pwst" ) ), 1, true, function Magic_AmplifierCast )
endfunction

//===========================================================================
function InitTrig_Magic_Amplifier takes nothing returns nothing
    set gg_trg_Magic_Amplifier = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Magic_Amplifier, EVENT_PLAYER_UNIT_PICKUP_ITEM ) 
    call TriggerAddCondition( gg_trg_Magic_Amplifier, Condition( function Trig_Magic_Amplifier_Conditions ) )
    call TriggerAddAction( gg_trg_Magic_Amplifier, function Trig_Magic_Amplifier_Actions )
endfunction

