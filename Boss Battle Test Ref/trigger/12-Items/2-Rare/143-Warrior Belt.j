function Trig_Warrior_Belt_Conditions takes nothing returns boolean 
	return GetItemTypeId(GetManipulatedItem()) == 'I0CK'
endfunction 

function Hero_BeltCast takes nothing returns nothing 
	local integer id = GetHandleId( GetExpiredTimer( ) )
    local unit u = LoadUnitHandle( udg_hash, id, StringHash( "hrbt" ) )
    local item it = LoadItemHandle( udg_hash, id, StringHash( "hrbtt" ) )
    
    if not(UnitHasItem(u,it )) then
        call UnitRemoveAbility( u, 'A15G')
        call FlushChildHashtable( udg_hash, id )
        call DestroyTimer( GetExpiredTimer() )
    elseif GetUnitState( u, UNIT_STATE_LIFE) > 0.405 then
        if GetHeroStr( u, false) > 30 and GetUnitAbilityLevel( u, 'A15G') > 0 then
            call UnitRemoveAbility( u, 'A15G')
        elseif GetHeroStr( u, false) <= 30 and GetUnitAbilityLevel( u, 'A15G') == 0 then
            call UnitAddAbility( u, 'A15G')
        endif
    endif
    
    set it = null
    set u = null
endfunction 

function Trig_Warrior_Belt_Actions takes nothing returns nothing 
	local integer id = GetHandleId( GetManipulatedItem() )
    
    if LoadTimerHandle( udg_hash, id, StringHash( "hrbt" ) ) == null  then
        call SaveTimerHandle( udg_hash, id, StringHash( "hrbt" ), CreateTimer() )
    endif 
	set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "hrbt" ) ) ) 
	call SaveUnitHandle( udg_hash, id, StringHash( "hrbt" ), GetManipulatingUnit() ) 
    call SaveItemHandle( udg_hash, id, StringHash( "hrbtt" ), GetManipulatedItem() ) 
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( GetManipulatedItem() ), StringHash( "hrbt" ) ), 1, true, function Hero_BeltCast ) 
endfunction 

//=========================================================================== 
function InitTrig_Warrior_Belt takes nothing returns nothing 
	set gg_trg_Warrior_Belt = CreateTrigger( ) 
	call TriggerRegisterAnyUnitEventBJ( gg_trg_Warrior_Belt, EVENT_PLAYER_UNIT_PICKUP_ITEM ) 
	call TriggerAddCondition( gg_trg_Warrior_Belt, Condition( function Trig_Warrior_Belt_Conditions ) ) 
	call TriggerAddAction( gg_trg_Warrior_Belt, function Trig_Warrior_Belt_Actions ) 
endfunction