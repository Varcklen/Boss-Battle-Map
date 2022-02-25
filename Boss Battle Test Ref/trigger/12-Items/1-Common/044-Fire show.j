function Trig_Fire_show_Conditions takes nothing returns boolean 
	return GetItemTypeId(GetManipulatedItem()) == 'I0CU'
endfunction 

function Crowd_instigatorCast takes nothing returns nothing 
	local integer id = GetHandleId( GetExpiredTimer( ) )
    local unit u = LoadUnitHandle( udg_hash, id, StringHash( "cwig" ) )
    local boolean l = false
    local item it = LoadItemHandle( udg_hash, id, StringHash( "cwigt" ) )
    
    if not(UnitHasItem(u,it )) then
        call UnitRemoveAbility( u, 'A162')
        call UnitRemoveAbility( u, 'B075')
        call FlushChildHashtable( udg_hash, id )
        call DestroyTimer( GetExpiredTimer() )
    elseif GetUnitState( u, UNIT_STATE_LIFE) > 0.405 and udg_combatlogic[GetPlayerId( GetOwningPlayer( u ) ) + 1] then
        if not(RectContainsLoc(udg_Boss_Rect, Location(GetUnitX(u)-500, GetUnitY(u)))) then
            set l = true
        elseif not(RectContainsLoc(udg_Boss_Rect, Location(GetUnitX(u)+500, GetUnitY(u)))) then
            set l = true
        elseif not(RectContainsLoc(udg_Boss_Rect, Location(GetUnitX(u), GetUnitY(u)-500))) then
            set l = true
        elseif not(RectContainsLoc(udg_Boss_Rect, Location(GetUnitX(u), GetUnitY(u)+500))) then
            set l = true
        endif
        if l and GetUnitAbilityLevel( u, 'B075') == 0 then
            call UnitAddAbility( u, 'A162')
        elseif not(l) and GetUnitAbilityLevel( u, 'B075') > 0 then
            call UnitRemoveAbility( u, 'A162')
            call UnitRemoveAbility( u, 'B075')
        endif
    endif
    
    set it = null
    set u = null
endfunction 

function Trig_Fire_show_Actions takes nothing returns nothing 
	local integer id = GetHandleId( GetManipulatedItem() )

    if LoadTimerHandle( udg_hash, id, StringHash( "cwig" ) ) == null  then
        call SaveTimerHandle( udg_hash, id, StringHash( "cwig" ), CreateTimer() )
    endif 
	set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "cwig" ) ) ) 
	call SaveUnitHandle( udg_hash, id, StringHash( "cwig" ), GetManipulatingUnit() ) 
    call SaveItemHandle( udg_hash, id, StringHash( "cwigt" ), GetManipulatedItem() ) 
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( GetManipulatedItem() ), StringHash( "cwig" ) ), 1, true, function Crowd_instigatorCast )
endfunction 

//=========================================================================== 
function InitTrig_Fire_show takes nothing returns nothing 
	set gg_trg_Fire_show = CreateTrigger( ) 
	call TriggerRegisterAnyUnitEventBJ( gg_trg_Fire_show, EVENT_PLAYER_UNIT_PICKUP_ITEM ) 
	call TriggerAddCondition( gg_trg_Fire_show, Condition( function Trig_Fire_show_Conditions ) ) 
	call TriggerAddAction( gg_trg_Fire_show, function Trig_Fire_show_Actions ) 
endfunction