function Trig_ESPN_Conditions takes nothing returns boolean 
	return GetItemTypeId(GetManipulatedItem()) == 'I09D'
endfunction 

function ESPNCast takes nothing returns nothing 
	local integer id = GetHandleId( GetExpiredTimer( ) )
    local unit u = LoadUnitHandle( udg_hash, id, StringHash( "espn" ) )
    local item it = LoadItemHandle( udg_hash, id, StringHash( "espnt" ) )
    local integer p

    if not(UnitHasItem(u,it )) then
        call FlushChildHashtable( udg_hash, id )
        call DestroyTimer( GetExpiredTimer() )
    elseif GetUnitState( u, UNIT_STATE_LIFE) > 0.405 and combat( u, false, 0 ) and not( udg_fightmod[3] ) and IsUnitInvisible( u, Player(PLAYER_NEUTRAL_AGGRESSIVE)) then
        set p = LoadInteger( udg_hash, GetHandleId( u ), StringHash( udg_QuestItemCode[2] ) ) + 1
        call SaveInteger( udg_hash, GetHandleId( u ), StringHash( udg_QuestItemCode[2] ), p )
        if p >= udg_QuestNum[2] then
            call RemoveItem(GetItemOfTypeFromUnitBJ(u, 'I09D'))
            call UnitAddItem(u, CreateItem( 'I094', GetUnitX(u), GetUnitY(u)))
            call textst( "|c00ffffff Espionage training done!", u, 64, GetRandomReal( 45, 135 ), 12, 1.5 )
            call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\Human\\ReviveHuman\\ReviveHuman.mdl", GetUnitX(u), GetUnitY(u) ) )
            set udg_QuestDone[GetPlayerId( GetOwningPlayer( u ) ) + 1] = true
        else
            call QuestDiscription( u, 'I09D', p, udg_QuestNum[2] )
        endif
    endif
    
    set it = null
    set u = null
endfunction 

function Trig_ESPN_Actions takes nothing returns nothing 
	local integer id = GetHandleId( GetManipulatedItem() )
	
    if LoadTimerHandle( udg_hash, id, StringHash( "espn" ) ) == null  then
        call SaveTimerHandle( udg_hash, id, StringHash( "espn" ), CreateTimer() )
    endif 
	set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "espn" ) ) ) 
	call SaveUnitHandle( udg_hash, id, StringHash( "espn" ), GetManipulatingUnit() ) 
    call SaveItemHandle( udg_hash, id, StringHash( "espnt" ), GetManipulatedItem() ) 
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( GetManipulatedItem() ), StringHash( "espn" ) ), 1, true, function ESPNCast ) 
endfunction 

//=========================================================================== 
function InitTrig_ESPN takes nothing returns nothing 
	set gg_trg_ESPN = CreateTrigger( ) 
	call TriggerRegisterAnyUnitEventBJ( gg_trg_ESPN, EVENT_PLAYER_UNIT_PICKUP_ITEM ) 
	call TriggerAddCondition( gg_trg_ESPN, Condition( function Trig_ESPN_Conditions ) ) 
	call TriggerAddAction( gg_trg_ESPN, function Trig_ESPN_Actions ) 
endfunction