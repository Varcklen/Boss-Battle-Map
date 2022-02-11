function Trig_OrbElderWarlock_Conditions takes nothing returns boolean
    return GetItemTypeId(GetManipulatedItem()) == 'I0FX'
endfunction

function OrbElderWarlockCast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local unit caster = LoadUnitHandle( udg_hash, id, StringHash( "orbew" ) )
    local integer pl = LoadInteger( udg_hash, id, StringHash( "orbewpl" ) )
    local item it = LoadItemHandle( udg_hash, id, StringHash( "orbewi" ) )
    local real arm = LoadReal( udg_hash, id, StringHash( "orbew" ) )
    local real spd
    local real spdnow = LoadReal( udg_hash, GetHandleId( caster ), StringHash( "orbewn" ) )
    local group g = CreateGroup()
    local unit u
    local integer k = 0

    call GroupEnumUnitsOfPlayer(g, Player(pl), null )
    loop
        set u = FirstOfGroup(g)
        exitwhen u == null
        if not( IsUnitType(u, UNIT_TYPE_ANCIENT ) ) and not( IsUnitType(u, UNIT_TYPE_HERO ) ) and GetUnitState( u, UNIT_STATE_LIFE) > 0.405 and GetUnitTypeId( u ) != 'h01B' and GetUnitName(u) != "dummy" then
            set k = k + 1
        endif
        call GroupRemoveUnit(g,u)
    endloop
    set spd = (k - arm) * 5

    if not(UnitHasItem(caster, it)) then
        call spdstpl( pl, -1*spdnow )
        call SaveReal( udg_hash, GetHandleId( caster ), StringHash( "orbewn" ), 0 )
        call FlushChildHashtable( udg_hash, id )
        call DestroyTimer( GetExpiredTimer() )
    elseif arm != GetHeroStr( caster, true) then
        call spdstpl( pl, spd )
        call SaveReal( udg_hash, GetHandleId( caster ), StringHash( "orbewn" ), spdnow+spd )
        call SaveReal( udg_hash, id, StringHash( "orbew" ), k ) 
    endif

    call GroupClear( g )
    call DestroyGroup( g )
    set u = null
    set g = null
    set caster = null
    set it = null
endfunction

function Trig_OrbElderWarlock_Actions takes nothing returns nothing
    local integer id = GetHandleId( GetManipulatedItem() )

    if LoadTimerHandle( udg_hash, id, StringHash( "orbew" ) ) == null  then
        call SaveTimerHandle( udg_hash, id, StringHash( "orbew" ), CreateTimer() )
    endif
    set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "orbew" ) ) )
    call SaveUnitHandle( udg_hash, id, StringHash( "orbew" ), GetManipulatingUnit() ) 
    call SaveItemHandle( udg_hash, id, StringHash( "orbewi" ), GetManipulatedItem() )
    call SaveInteger( udg_hash, id, StringHash( "orbewpl" ), GetPlayerId( GetOwningPlayer( GetManipulatingUnit() ) ) )
    call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( GetManipulatedItem() ), StringHash( "orbew" ) ), 1, true, function OrbElderWarlockCast )
endfunction

//===========================================================================
function InitTrig_OrbElderWarlock takes nothing returns nothing
    set gg_trg_OrbElderWarlock = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_OrbElderWarlock, EVENT_PLAYER_UNIT_PICKUP_ITEM ) 
    call TriggerAddCondition( gg_trg_OrbElderWarlock, Condition( function Trig_OrbElderWarlock_Conditions ) )
    call TriggerAddAction( gg_trg_OrbElderWarlock, function Trig_OrbElderWarlock_Actions )
endfunction

