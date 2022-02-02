function Trig_Unique_Recipe_Book_Conditions takes nothing returns boolean
    return GetItemTypeId(GetManipulatedItem()) == 'I02K'
endfunction

function Unique_Recipe_BookCast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local unit caster = LoadUnitHandle( udg_hash, id, StringHash( "ubok" ) )
    local integer pl = LoadInteger( udg_hash, id, StringHash( "ubokpl" ) )
    local integer i = pl + 1
    local item it = LoadItemHandle( udg_hash, id, StringHash( "uboki" ) )
    local real count = udg_SpellDamageSpec[i]-1
    local real arm = LoadReal( udg_hash, id, StringHash( "ubok" ) )
    local real spd = (count - arm) * 50
    local real spdnow = LoadReal( udg_hash, GetHandleId( caster ), StringHash( "ubokn" ) )

    if not(UnitHasItem(caster, it)) then
        call SpellPotion(i, -spdnow)
        call SaveReal( udg_hash, GetHandleId( caster ), StringHash( "ubokn" ), 0 )
        call FlushChildHashtable( udg_hash, id )
        call DestroyTimer( GetExpiredTimer() )
    elseif arm != count then
        call SpellPotion(i, spd)
        call SaveReal( udg_hash, GetHandleId( caster ), StringHash( "ubokn" ), spdnow+spd )
        call SaveReal( udg_hash, id, StringHash( "ubok" ), count ) 
    endif

    set caster = null
    set it = null
endfunction

function Trig_Unique_Recipe_Book_Actions takes nothing returns nothing
    local integer id = GetHandleId( GetManipulatedItem() )

    if LoadTimerHandle( udg_hash, id, StringHash( "ubok" ) ) == null then
        call SaveTimerHandle( udg_hash, id, StringHash( "ubok" ), CreateTimer() )
    endif
    set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "ubok" ) ) )
    call SaveUnitHandle( udg_hash, id, StringHash( "ubok" ), GetManipulatingUnit() ) 
    call SaveItemHandle( udg_hash, id, StringHash( "uboki" ), GetManipulatedItem() )
    call SaveInteger( udg_hash, id, StringHash( "ubokpl" ), CorrectPlayer(GetManipulatingUnit())-1 )
    call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( GetManipulatedItem() ), StringHash( "ubok" ) ), 3, true, function Unique_Recipe_BookCast )
endfunction

//===========================================================================
function InitTrig_Unique_Recipe_Book takes nothing returns nothing
    set gg_trg_Unique_Recipe_Book = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Unique_Recipe_Book, EVENT_PLAYER_UNIT_PICKUP_ITEM ) 
    call TriggerAddCondition( gg_trg_Unique_Recipe_Book, Condition( function Trig_Unique_Recipe_Book_Conditions ) )
    call TriggerAddAction( gg_trg_Unique_Recipe_Book, function Trig_Unique_Recipe_Book_Actions )
endfunction

