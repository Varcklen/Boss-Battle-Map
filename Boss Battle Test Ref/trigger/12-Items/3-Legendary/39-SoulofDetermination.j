function Trig_SoulofDetermination_Conditions takes nothing returns boolean 
	return GetItemTypeId(GetManipulatedItem()) == 'I0E4'
endfunction 

function SoulofDetermination takes nothing returns nothing 
	local integer id = GetHandleId( GetExpiredTimer( ) )
    local unit c = LoadUnitHandle( udg_hash, id, StringHash( "slod" ) )
    local item it = LoadItemHandle( udg_hash, id, StringHash( "slodt" ) )
    local integer id1
    local integer cyclA
    local unit u
    local boolean l = true
    
    if not(UnitHasItem(c,it )) then
        call FlushChildHashtable( udg_hash, id )
        call DestroyTimer( GetExpiredTimer() )
    elseif udg_Heroes_Amount - udg_Heroes_Deaths == 1 and inv( c, 'I0E4') > 0 and GetUnitState( c, UNIT_STATE_LIFE) > 0.405 and udg_fightmod[0] and not(udg_fightmod[3]) then
        set cyclA = 1
        loop
            exitwhen cyclA > 4
            set u = udg_hero[cyclA]
            if IsUnitInGroup(u, udg_DeadHero) and GetPlayerSlotState( Player( cyclA - 1 ) ) == PLAYER_SLOT_STATE_PLAYING and GetUnitAbilityLevel( u, 'A19D') == 0 then
                call ResInBattle( c, u, 100 )
            elseif GetUnitAbilityLevel( u, 'A19D') > 0 then
                set l = false
            endif
            set cyclA = cyclA + 1
        endloop
        if l then
            call stazisst( c, it )
            call statst( c, 5, 5, 5, 0, true )
        endif
    endif
    
    set it = null
    set c = null
endfunction 

function Trig_SoulofDetermination_Actions takes nothing returns nothing 
	local integer id = GetHandleId( GetManipulatedItem() )
	
    if LoadTimerHandle( udg_hash, id, StringHash( "slod" ) ) == null  then
        call SaveTimerHandle( udg_hash, id, StringHash( "slod" ), CreateTimer() )
    endif 
	set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "slod" ) ) ) 
	call SaveUnitHandle( udg_hash, id, StringHash( "slod" ), GetManipulatingUnit() ) 
    call SaveItemHandle( udg_hash, id, StringHash( "slodt" ), GetManipulatedItem() ) 
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( GetManipulatedItem() ), StringHash( "slod" ) ), 1, true, function SoulofDetermination ) 
endfunction 

//=========================================================================== 
function InitTrig_SoulofDetermination takes nothing returns nothing 
	set gg_trg_SoulofDetermination = CreateTrigger( ) 
	call TriggerRegisterAnyUnitEventBJ( gg_trg_SoulofDetermination, EVENT_PLAYER_UNIT_PICKUP_ITEM ) 
	call TriggerAddCondition( gg_trg_SoulofDetermination, Condition( function Trig_SoulofDetermination_Conditions ) ) 
	call TriggerAddAction( gg_trg_SoulofDetermination, function Trig_SoulofDetermination_Actions ) 
endfunction