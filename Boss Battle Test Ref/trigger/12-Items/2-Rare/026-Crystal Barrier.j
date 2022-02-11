function Trig_Crystal_Barrier_Conditions takes nothing returns boolean 
	return GetItemTypeId(GetManipulatedItem()) == 'I08U' or ( GetItemTypeId(GetManipulatedItem()) == 'I030' and udg_Set_Weapon_Logic[GetPlayerId(GetOwningPlayer( GetTriggerUnit( ) )) + 1 + 104] ) 
endfunction 

function Crystal_BarrierCast takes nothing returns nothing 
    local integer id = GetHandleId( GetExpiredTimer( ) )
    local integer cyclA
    local unit caster = LoadUnitHandle( udg_hash, id, StringHash( "wsh" ) )
    local item it = LoadItemHandle( udg_hash, id, StringHash( "wsht" ) )
    local real t = 10
    
	if not(UnitHasItem(caster,it )) then
        call FlushChildHashtable( udg_hash, id )
        call DestroyTimer( GetExpiredTimer() )
    elseif GetUnitState( caster, UNIT_STATE_LIFE) > 0.405 then
        set t = timebonus(caster, t)
        if udg_Set_Cristall_Number[GetPlayerId(GetOwningPlayer(caster)) + 1] >= 3 then
            set cyclA = 1
            loop
                exitwhen cyclA > 4
                if unitst( udg_hero[cyclA], caster, "ally" ) then
                    call bufst( caster, udg_hero[cyclA], 'A18K', 'B08Q', "wsh1", t )
                    call effst( caster, udg_hero[cyclA], null, 1, t )
                endif
                set cyclA = cyclA + 1
            endloop
        else
            call bufst( caster, caster, 'A18K', 'B08Q', "wsh1", t )
            call effst( caster, caster, null, 1, t )
        endif
    endif
    
    set caster = null
    set it = null
endfunction 

function Trig_Crystal_Barrier_Actions takes nothing returns nothing 
	local integer id
    local item it
    local unit caster
    
    if udg_CastLogic then
        set udg_CastLogic = false
        set caster = udg_Caster
        set it = udg_CastItem
    else    
        set caster = GetManipulatingUnit()
        set it = GetManipulatedItem()
    endif
    
    set id = GetHandleId( it )
    if LoadTimerHandle( udg_hash, id, StringHash( "wsh" ) ) == null  then
        call SaveTimerHandle( udg_hash, id, StringHash( "wsh" ), CreateTimer() )
    endif 
	set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "wsh" ) ) ) 
	call SaveUnitHandle( udg_hash, id, StringHash( "wsh" ), caster ) 
    call SaveItemHandle( udg_hash, id, StringHash( "wsht" ), it ) 
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( it ), StringHash( "wsh" ) ), 30, true, function Crystal_BarrierCast ) 
    
    set caster = null
    set it = null
endfunction 

//=========================================================================== 
function InitTrig_Crystal_Barrier takes nothing returns nothing 
	set gg_trg_Crystal_Barrier = CreateTrigger( ) 
	call TriggerRegisterAnyUnitEventBJ( gg_trg_Crystal_Barrier, EVENT_PLAYER_UNIT_PICKUP_ITEM ) 
	call TriggerAddCondition( gg_trg_Crystal_Barrier, Condition( function Trig_Crystal_Barrier_Conditions ) ) 
	call TriggerAddAction( gg_trg_Crystal_Barrier, function Trig_Crystal_Barrier_Actions ) 
endfunction