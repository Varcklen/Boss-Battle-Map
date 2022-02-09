function Trig_Steam_generator_Conditions takes nothing returns boolean
    return GetItemTypeId(GetManipulatedItem()) == 'I07V'
endfunction

function Steam_generatorCast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local unit caster = LoadUnitHandle( udg_hash, id, StringHash( "stmg" ) )
    local integer pl = LoadInteger( udg_hash, id, StringHash( "stmgpl" ) )
    local item it = LoadItemHandle( udg_hash, id, StringHash( "stmgi" ) )
    local integer arm = LoadInteger( udg_hash, id, StringHash( "stmg" ) )
    local integer mech = SetCount_GetPieces(caster, SET_MECH)
    local real spd = (mech - arm) * 7
    local real spdnow = LoadReal( udg_hash, id, StringHash( "stmgn" ) )

    if not(UnitHasItem(caster, it)) then
        call spdstpl( pl, -1*spdnow )
        call SaveReal( udg_hash, id, StringHash( "stmgn" ), 0 )
        call FlushChildHashtable( udg_hash, id )
        call DestroyTimer( GetExpiredTimer() )
    elseif arm != mech then
        call spdstpl( pl, spd )
        call SaveReal( udg_hash, id, StringHash( "stmgn" ), spdnow+spd )
        call SaveInteger( udg_hash, id, StringHash( "stmg" ), mech ) 
    endif

    set caster = null
    set it = null
endfunction

function Trig_Steam_generator_Actions takes nothing returns nothing
    local integer id = GetHandleId( GetManipulatedItem() )

    if LoadTimerHandle( udg_hash, id, StringHash( "stmg" ) ) == null  then
        call SaveTimerHandle( udg_hash, id, StringHash( "stmg" ), CreateTimer() )
    endif
    set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "stmg" ) ) )
    call SaveUnitHandle( udg_hash, id, StringHash( "stmg" ), GetManipulatingUnit() ) 
    call SaveItemHandle( udg_hash, id, StringHash( "stmgi" ), GetManipulatedItem() )
    call SaveInteger( udg_hash, id, StringHash( "stmgpl" ), GetPlayerId( GetOwningPlayer( GetManipulatingUnit() ) ) )
    call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( GetManipulatedItem() ), StringHash( "stmg" ) ), 1, true, function Steam_generatorCast )
endfunction

//===========================================================================
function InitTrig_Steam_generator takes nothing returns nothing
    set gg_trg_Steam_generator = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Steam_generator, EVENT_PLAYER_UNIT_PICKUP_ITEM ) 
    call TriggerAddCondition( gg_trg_Steam_generator, Condition( function Trig_Steam_generator_Conditions ) )
    call TriggerAddAction( gg_trg_Steam_generator, function Trig_Steam_generator_Actions )
endfunction

