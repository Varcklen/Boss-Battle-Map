function Trig_VampBlood_Conditions takes nothing returns boolean 
	return GetItemTypeId(GetManipulatedItem()) == 'I004'
endfunction 

function VampBloodCast takes nothing returns nothing 
	local integer id = GetHandleId( GetExpiredTimer( ) )
    local unit u = LoadUnitHandle( udg_hash, id, StringHash( "vpbl" ) )
    local item it = LoadItemHandle( udg_hash, id, StringHash( "vpblt" ) )
    local integer cyclA
    local integer i
    
    if not(UnitHasItem(u,it )) then
        call UnitRemoveAbility(u, 'A18H')
        call UnitRemoveAbility(u, 'B08P')
        call FlushChildHashtable( udg_hash, id )
        call DestroyTimer( GetExpiredTimer() )
    elseif GetUnitState( u, UNIT_STATE_LIFE) > 0.405 then
        set cyclA = 0
        set i = 0
        loop
            exitwhen cyclA > 5
            if GetItemType(UnitItemInSlot( u, cyclA )) == ITEM_TYPE_ARTIFACT then
                set i = i + 1
            endif
            set cyclA = cyclA + 1
        endloop
        if i == 0 and GetUnitAbilityLevel(u, 'B08P') == 0 then
            call UnitAddAbility(u, 'A18H')
        elseif i > 0 and GetUnitAbilityLevel(u, 'B08P') > 0 then
            call UnitRemoveAbility(u, 'A18H')
            call UnitRemoveAbility(u, 'B08P')
        endif
    endif
    
    set it = null
    set u = null
endfunction 

function Trig_VampBlood_Actions takes nothing returns nothing 
	local integer id = GetHandleId( GetManipulatedItem() )
	
    if LoadTimerHandle( udg_hash, id, StringHash( "vpbl" ) ) == null  then
        call SaveTimerHandle( udg_hash, id, StringHash( "vpbl" ), CreateTimer() )
    endif 
	set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "vpbl" ) ) ) 
	call SaveUnitHandle( udg_hash, id, StringHash( "vpbl" ), GetManipulatingUnit() ) 
    call SaveItemHandle( udg_hash, id, StringHash( "vpblt" ), GetManipulatedItem() ) 
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( GetManipulatedItem() ), StringHash( "vpbl" ) ), 1, true, function VampBloodCast ) 
endfunction 

//=========================================================================== 
function InitTrig_VampBlood takes nothing returns nothing 
	set gg_trg_VampBlood = CreateTrigger( ) 
	call TriggerRegisterAnyUnitEventBJ( gg_trg_VampBlood, EVENT_PLAYER_UNIT_PICKUP_ITEM ) 
	call TriggerAddCondition( gg_trg_VampBlood, Condition( function Trig_VampBlood_Conditions ) ) 
	call TriggerAddAction( gg_trg_VampBlood, function Trig_VampBlood_Actions ) 
endfunction