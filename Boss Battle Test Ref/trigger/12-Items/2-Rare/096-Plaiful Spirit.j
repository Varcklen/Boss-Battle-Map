function Trig_Plaiful_Spirit_Conditions takes nothing returns boolean
    return GetItemTypeId(GetManipulatedItem()) == 'I07L'
endfunction

function Naughty_SpiritCast takes nothing returns nothing 
	local integer id = GetHandleId( GetExpiredTimer( ) )
    local unit u = LoadUnitHandle( udg_hash, id, StringHash( "nght" ) )
	local real r = 12 * udg_SpellDamage[GetPlayerId( GetOwningPlayer( u ) ) + 1]
    local item it = LoadItemHandle( udg_hash, id, StringHash( "nghtt" ) )
    
    if not(UnitHasItem(u,it )) then
        call FlushChildHashtable( udg_hash, id )
        call DestroyTimer( GetExpiredTimer() )
    elseif GetUnitState( u, UNIT_STATE_MANA) >= r and GetUnitState( u, UNIT_STATE_LIFE) > 0.405 and not( udg_fightmod[3] ) and combat( u, false, 0 ) then
        call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\Human\\Invisibility\\InvisibilityTarget.mdl", GetUnitX( u ), GetUnitY( u ) ) )
        call spdst( u, 0.5 )
        call SetUnitState( u, UNIT_STATE_MANA, RMaxBJ(0,GetUnitState( u, UNIT_STATE_MANA) - r ) )
    endif
    
    set it = null
    set u = null
endfunction 

function Trig_Plaiful_Spirit_Actions takes nothing returns nothing
    local integer id = GetHandleId( GetManipulatedItem() )

    if LoadTimerHandle( udg_hash, id, StringHash( "nght" ) ) == null  then
        call SaveTimerHandle( udg_hash, id, StringHash( "nght" ), CreateTimer() )
    endif 
	set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "nght" ) ) ) 
	call SaveUnitHandle( udg_hash, id, StringHash( "nght" ), GetManipulatingUnit() ) 
    call SaveItemHandle( udg_hash, id, StringHash( "nghtt" ), GetManipulatedItem() ) 
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( GetManipulatedItem() ), StringHash( "nght" ) ), 10, true, function Naughty_SpiritCast )
endfunction

//===========================================================================
function InitTrig_Plaiful_Spirit takes nothing returns nothing
    set gg_trg_Plaiful_Spirit = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Plaiful_Spirit, EVENT_PLAYER_UNIT_PICKUP_ITEM )
    call TriggerAddCondition( gg_trg_Plaiful_Spirit, Condition( function Trig_Plaiful_Spirit_Conditions ) )
    call TriggerAddAction( gg_trg_Plaiful_Spirit, function Trig_Plaiful_Spirit_Actions )
endfunction

