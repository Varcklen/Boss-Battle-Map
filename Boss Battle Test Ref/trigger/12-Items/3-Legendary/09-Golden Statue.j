function Trig_Golden_Statue_Conditions takes nothing returns boolean 
	return GetItemTypeId(GetManipulatedItem()) == 'I0C4'
endfunction 

function Golden_StatueCast takes nothing returns nothing 
	local integer id = GetHandleId( GetExpiredTimer() )
    local unit u = LoadUnitHandle( udg_hash, id, StringHash( "glst" ) )
    local integer cyclA = 0
    local integer i = 0
    local item it = LoadItemHandle( udg_hash, id, StringHash( "glstt" ) )
    
    if not(UnitHasItem(u,it )) then
        call FlushChildHashtable( udg_hash, id )
        call DestroyTimer( GetExpiredTimer() )
    elseif GetUnitState( u, UNIT_STATE_LIFE) > 0.405 and combat( u, false, 0 ) and not( udg_fightmod[3]) then
        loop
            exitwhen cyclA > 5
            if GetItemType(UnitItemInSlot( u, cyclA )) == ITEM_TYPE_ARTIFACT then
                set i = i + 8
            endif
            set cyclA = cyclA + 1
        endloop
        if i > 0 then
            call moneyst( u, i )
        endif
    endif
    
    set it = null
    set u = null
endfunction 

function Trig_Golden_Statue_Actions takes nothing returns nothing 
	local integer id = GetHandleId( GetManipulatedItem() )
	
    if LoadTimerHandle( udg_hash, id, StringHash( "glst" ) ) == null  then
        call SaveTimerHandle( udg_hash, id, StringHash( "glst" ), CreateTimer() )
    endif 
	set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "glst" ) ) ) 
	call SaveUnitHandle( udg_hash, id, StringHash( "glst" ), GetManipulatingUnit() ) 
    call SaveItemHandle( udg_hash, id, StringHash( "glstt" ), GetManipulatedItem() ) 
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( GetManipulatedItem() ), StringHash( "glst" ) ), 5, true, function Golden_StatueCast )
endfunction 

//=========================================================================== 
function InitTrig_Golden_Statue takes nothing returns nothing 
	set gg_trg_Golden_Statue = CreateTrigger( ) 
	call TriggerRegisterAnyUnitEventBJ( gg_trg_Golden_Statue, EVENT_PLAYER_UNIT_PICKUP_ITEM ) 
	call TriggerAddCondition( gg_trg_Golden_Statue, Condition( function Trig_Golden_Statue_Conditions ) ) 
	call TriggerAddAction( gg_trg_Golden_Statue, function Trig_Golden_Statue_Actions ) 
endfunction