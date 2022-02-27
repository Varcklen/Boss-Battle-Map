globals
    constant real TWILIGHT_PHOENIX_TIME_REDUCTION = 0.5
    constant integer TWILIGHT_PHOENIX_TICK = 1
endglobals

function Trig_Twilight_Phoenix_Conditions takes nothing returns boolean 
	return GetItemTypeId(GetManipulatedItem()) == 'I07M'
endfunction 

function Twilight_PhoenixCast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local unit caster = LoadUnitHandle( udg_hash, id, StringHash( "twphu" ) )
    local item it = LoadItemHandle( udg_hash, id, StringHash( "twph" ) )
    
    if not(UnitHasItem(caster,it )) then
        call FlushChildHashtable( udg_hash, id )
        call DestroyTimer( GetExpiredTimer() )
    elseif IsUnitAlive(caster) and IsUnitInvisible( caster, Player(PLAYER_NEUTRAL_AGGRESSIVE)) then
        call UnitReduceCooldown(caster, TWILIGHT_PHOENIX_TIME_REDUCTION )
    endif
    
    set caster = null
    set it = null
endfunction

function Trig_Twilight_Phoenix_Actions takes nothing returns nothing
    local integer id 
    
    set id = InvokeTimerWithItem( GetManipulatedItem(), "twph", TWILIGHT_PHOENIX_TICK, true, function Twilight_PhoenixCast )
    call SaveUnitHandle( udg_hash, id, StringHash( "twphu" ), GetManipulatingUnit() ) 
endfunction

//===========================================================================
function InitTrig_Twilight_Phoenix takes nothing returns nothing
    set gg_trg_Twilight_Phoenix = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Twilight_Phoenix, EVENT_PLAYER_UNIT_PICKUP_ITEM ) 
	call TriggerAddCondition( gg_trg_Twilight_Phoenix, Condition( function Trig_Twilight_Phoenix_Conditions ) ) 
    call TriggerAddAction( gg_trg_Twilight_Phoenix, function Trig_Twilight_Phoenix_Actions )
endfunction

