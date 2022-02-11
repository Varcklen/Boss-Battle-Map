function Trig_OrbCairne_Conditions takes nothing returns boolean 
	return GetItemTypeId(GetManipulatedItem()) == 'I0EQ'
endfunction 

function OrbCairneCast takes nothing returns nothing 
	local integer id = GetHandleId( GetExpiredTimer( ) )
    local unit n = LoadUnitHandle( udg_hash, id, StringHash( "orbcn" ) )
    local item it = LoadItemHandle( udg_hash, id, StringHash( "orbcnt" ) )
    local group g = CreateGroup()
    local unit u
    local boolean isWork = false
    
    if not(UnitHasItem(n,it )) then
        call FlushChildHashtable( udg_hash, id )
        call DestroyTimer( GetExpiredTimer() )
    elseif GetUnitState( n, UNIT_STATE_LIFE) > 0.405 then
        call GroupEnumUnitsInRange( g, GetUnitX( n ), GetUnitY( n ), 400, null )
        loop
            set u = FirstOfGroup(g)
            exitwhen u == null
            if unitst( u, n, "enemy" ) then
                call UnitStun(n, u, 1.5 )
                set isWork = true
            endif
            call GroupRemoveUnit(g,u)
        endloop
        if isWork then
            call DestroyEffect( AddSpecialEffect("Abilities\\Spells\\Human\\Thunderclap\\ThunderClapCaster.mdl", GetUnitX( n ), GetUnitY( n ) ) )
        endif
    endif
    
    call GroupClear( g )
    call DestroyGroup( g )
    set g = null
    set u = null
    set it = null
    set n = null
endfunction 

function Trig_OrbCairne_Actions takes nothing returns nothing 
	local integer id = GetHandleId( GetManipulatedItem() )
	
    if LoadTimerHandle( udg_hash, id, StringHash( "orbcn" ) ) == null  then
        call SaveTimerHandle( udg_hash, id, StringHash( "orbcn" ), CreateTimer() )
    endif 
	set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "orbcn" ) ) ) 
	call SaveUnitHandle( udg_hash, id, StringHash( "orbcn" ), GetManipulatingUnit() ) 
    call SaveItemHandle( udg_hash, id, StringHash( "orbcnt" ), GetManipulatedItem() ) 
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( GetManipulatedItem() ), StringHash( "orbcn" ) ), 12, true, function OrbCairneCast ) 
endfunction 

//=========================================================================== 
function InitTrig_OrbCairne takes nothing returns nothing 
	set gg_trg_OrbCairne = CreateTrigger( ) 
	call TriggerRegisterAnyUnitEventBJ( gg_trg_OrbCairne, EVENT_PLAYER_UNIT_PICKUP_ITEM ) 
	call TriggerAddCondition( gg_trg_OrbCairne, Condition( function Trig_OrbCairne_Conditions ) ) 
	call TriggerAddAction( gg_trg_OrbCairne, function Trig_OrbCairne_Actions ) 
endfunction