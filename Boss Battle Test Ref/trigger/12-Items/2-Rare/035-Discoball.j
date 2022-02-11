function Trig_Discoball_Conditions takes nothing returns boolean 
	return GetItemTypeId(GetManipulatedItem()) == 'I0BQ'
endfunction 

function DiscoballCast takes nothing returns nothing 
	local integer id = GetHandleId( GetExpiredTimer() )
    local unit u = LoadUnitHandle( udg_hash, id, StringHash( "disco" ) )
    local item it = LoadItemHandle( udg_hash, id, StringHash( "discot" ) )
    local integer k = 1
    local integer i = GetPlayerId(GetOwningPlayer(u)) + 1
	
    if not(UnitHasItem(u,it)) then
        call UnitRemoveAbility( u, 'A0MP' )
        call FlushChildHashtable( udg_hash, id )
        call DestroyTimer( GetExpiredTimer() )
    else
        if SetCount_GetPieces(u, SET_MECH) > 0 then
            set k = k + 1
        endif
        if udg_Set_Blood_Number[i] > 0 then
            set k = k + 1
        endif
        if udg_Set_Rune_Number[i] > 0 then
            set k = k + 1
        endif
        if udg_Set_Moon_Number[i] > 0 then
            set k = k + 1
        endif
        if udg_Set_Nature_Number[i] > 0 then
            set k = k + 1
        endif
        if udg_Set_Alchemy_Number[i] > 0 then
            set k = k + 1
        endif
        if udg_Set_Ring_Number[i] > 0 then
            set k = k + 1
        endif
        if udg_Set_Cristall_Number[i] > 0 then
            set k = k + 1
        endif
        if udg_Set_Weapon_Number[i] > 0 then
            set k = k + 1
        endif
        call SetUnitAbilityLevel( u, 'A0MP', k )
    endif
    
    set u = null
    set it = null
endfunction 

function Trig_Discoball_Actions takes nothing returns nothing 
	local integer id = GetHandleId( GetManipulatedItem() )
	
    call UnitAddAbility( GetManipulatingUnit(), 'A0MP' )
    
    if LoadTimerHandle( udg_hash, id, StringHash( "disco" ) ) == null  then
        call SaveTimerHandle( udg_hash, id, StringHash( "disco" ), CreateTimer() )
    endif 
	set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "disco" ) ) ) 
	call SaveUnitHandle( udg_hash, id, StringHash( "disco" ), GetManipulatingUnit() ) 
    call SaveItemHandle( udg_hash, id, StringHash( "discot" ), GetManipulatedItem() ) 
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( GetManipulatedItem() ), StringHash( "disco" ) ), 1, true, function DiscoballCast ) 
endfunction 

//=========================================================================== 
function InitTrig_Discoball takes nothing returns nothing 
	set gg_trg_Discoball = CreateTrigger( ) 
	call TriggerRegisterAnyUnitEventBJ( gg_trg_Discoball, EVENT_PLAYER_UNIT_PICKUP_ITEM ) 
	call TriggerAddCondition( gg_trg_Discoball, Condition( function Trig_Discoball_Conditions ) ) 
	call TriggerAddAction( gg_trg_Discoball, function Trig_Discoball_Actions ) 
endfunction