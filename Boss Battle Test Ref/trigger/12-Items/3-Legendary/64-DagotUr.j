function Trig_DagotUr_Conditions takes nothing returns boolean 
	return GetItemTypeId(GetManipulatedItem()) == 'I092'
endfunction 

function DagotUrCast takes nothing returns nothing 
	local integer id = GetHandleId( GetExpiredTimer( ) )
    local unit u = LoadUnitHandle( udg_hash, id, StringHash( "dgtur" ) )
    local item it = LoadItemHandle( udg_hash, id, StringHash( "dgturt" ) )
    local integer cyclA
    
    if not(UnitHasItem(u,it )) then
        call FlushChildHashtable( udg_hash, id )
        call DestroyTimer( GetExpiredTimer() )
    elseif GetUnitState( u, UNIT_STATE_LIFE) > 0.405 then
        set cyclA = 1
        loop
            exitwhen cyclA > 4
            if unitst( udg_hero[cyclA], u, "ally" ) then
                call UnitAddAbility( udg_hero[cyclA], 'A01I')
            endif
            set cyclA = cyclA + 1
        endloop
    endif
    
    set it = null
    set u = null
endfunction 

function Trig_DagotUr_Actions takes nothing returns nothing 
	local integer id = GetHandleId( GetManipulatedItem() )
	
    if LoadTimerHandle( udg_hash, id, StringHash( "dgtur" ) ) == null  then
        call SaveTimerHandle( udg_hash, id, StringHash( "dgtur" ), CreateTimer() )
    endif 
	set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "dgtur" ) ) ) 
	call SaveUnitHandle( udg_hash, id, StringHash( "dgtur" ), GetManipulatingUnit() ) 
    call SaveItemHandle( udg_hash, id, StringHash( "dgturt" ), GetManipulatedItem() ) 
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( GetManipulatedItem() ), StringHash( "dgtur" ) ), 5, true, function DagotUrCast ) 
endfunction 

//=========================================================================== 
function InitTrig_DagotUr takes nothing returns nothing 
	set gg_trg_DagotUr = CreateTrigger( ) 
	call TriggerRegisterAnyUnitEventBJ( gg_trg_DagotUr, EVENT_PLAYER_UNIT_PICKUP_ITEM ) 
	call TriggerAddCondition( gg_trg_DagotUr, Condition( function Trig_DagotUr_Conditions ) ) 
	call TriggerAddAction( gg_trg_DagotUr, function Trig_DagotUr_Actions ) 
endfunction