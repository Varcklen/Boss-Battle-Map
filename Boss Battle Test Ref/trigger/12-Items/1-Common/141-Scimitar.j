function Trig_Scimitar_Conditions takes nothing returns boolean 
	return (GetItemTypeId(GetManipulatedItem()) == 'I07N') or ( ( GetItemTypeId(GetManipulatedItem()) == 'I030' ) and (udg_Set_Weapon_Logic[GetPlayerId(GetOwningPlayer( GetManipulatingUnit() )) + 1 + 60]) ) 
endfunction 

function ScimitarCast takes nothing returns nothing 
	local integer id = GetHandleId( GetExpiredTimer( ) )
    local unit u = LoadUnitHandle( udg_hash, id, StringHash( "scmt" ) )
    local real hp = (GetUnitState( u, UNIT_STATE_LIFE) / RMaxBJ(0,GetUnitState( u, UNIT_STATE_MAX_LIFE))) * 100
    local item it = LoadItemHandle( udg_hash, id, StringHash( "scmtt" ) )
    
    if not(UnitHasItem(u,it )) then
        call UnitRemoveAbility( u, 'A0O2' )
        call FlushChildHashtable( udg_hash, id )
        call DestroyTimer( GetExpiredTimer() )
    elseif  GetUnitState( u, UNIT_STATE_LIFE) > 0.405 then
        if hp <= 50 and GetUnitAbilityLevel( u, 'A0O2') == 2 then
            call SetUnitAbilityLevel( u, 'A0O2', 1 )
        elseif hp > 50 and GetUnitAbilityLevel( u, 'A0O2') == 1 then
            call SetUnitAbilityLevel( u, 'A0O2', 2 )
        endif
    endif
    
    set u = null
    set it = null
endfunction

function Trig_Scimitar_Actions takes nothing returns nothing
    local integer id
    local unit caster
    local item it

    if udg_CastLogic then
        set udg_CastLogic = false
        set caster = udg_Caster
        set it = udg_CastItem
    else    
        set caster = GetManipulatingUnit()
        set it = GetManipulatedItem()
    endif

    call UnitAddAbility( caster, 'A0O2' )
    set id = GetHandleId( it )
    if LoadTimerHandle( udg_hash, id, StringHash( "scmt" ) ) == null  then
        call SaveTimerHandle( udg_hash, id, StringHash( "scmt" ), CreateTimer() )
    endif 
	set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "scmt" ) ) ) 
	call SaveUnitHandle( udg_hash, id, StringHash( "scmt" ), caster ) 
    call SaveItemHandle( udg_hash, id, StringHash( "scmtt" ), it ) 
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( it ), StringHash( "scmt" ) ), 1, true, function ScimitarCast )
    
    set caster = null
    set it = null
    
endfunction

//===========================================================================
function InitTrig_Scimitar takes nothing returns nothing
    set gg_trg_Scimitar = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Scimitar, EVENT_PLAYER_UNIT_PICKUP_ITEM ) 
	call TriggerAddCondition( gg_trg_Scimitar, Condition( function Trig_Scimitar_Conditions ) ) 
    call TriggerAddAction( gg_trg_Scimitar, function Trig_Scimitar_Actions )
endfunction

