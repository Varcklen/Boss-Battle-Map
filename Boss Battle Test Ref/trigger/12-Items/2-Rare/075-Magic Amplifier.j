function Trig_Magic_Amplifier_Conditions takes nothing returns boolean
    return GetItemTypeId(GetManipulatedItem()) == 'I0BS'
endfunction

function Magic_AmplifierCast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local unit caster = LoadUnitHandle( udg_hash, id, StringHash( "pwst" ) )
    local item it = LoadItemHandle( udg_hash, id, StringHash( "pwsti" ) )
    local real arm = LoadReal( udg_hash, id, StringHash( "pwst" ) )
    local real spd = (GetHeroStr( caster, true) - arm) * 0.5
    local real spdnow = LoadReal( udg_hash, GetHandleId( caster ), StringHash( "pwstn" ) )

    if not(UnitHasItem(caster, it)) then
        call spdst( caster, -spdnow )
        call SaveReal( udg_hash, GetHandleId( caster ), StringHash( "pwstn" ), 0 )
        call FlushChildHashtable( udg_hash, id )
        call DestroyTimer( GetExpiredTimer() )
    elseif arm != GetHeroStr( caster, true) then
        call spdst( caster, spd )
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
    call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( GetManipulatedItem() ), StringHash( "pwst" ) ), 1, true, function Magic_AmplifierCast )
endfunction

//===========================================================================
function InitTrig_Magic_Amplifier takes nothing returns nothing
    set gg_trg_Magic_Amplifier = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Magic_Amplifier, EVENT_PLAYER_UNIT_PICKUP_ITEM ) 
    call TriggerAddCondition( gg_trg_Magic_Amplifier, Condition( function Trig_Magic_Amplifier_Conditions ) )
    call TriggerAddAction( gg_trg_Magic_Amplifier, function Trig_Magic_Amplifier_Actions )
endfunction

