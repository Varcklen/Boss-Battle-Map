function Trig_Magic_Thread_Conditions takes nothing returns boolean 
	return GetItemTypeId(GetManipulatedItem()) == 'I0AE'
endfunction 

function Magic_ThreadCast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local unit caster = LoadUnitHandle( udg_hash, id, StringHash( "mgthrd" ) )
    local unit u
    local item it = LoadItemHandle( udg_hash, id, StringHash( "mgthrdt" ) )
    
    if not(UnitHasItem(caster,it )) then
        call FlushChildHashtable( udg_hash, id )
        call DestroyTimer( GetExpiredTimer() )
    elseif udg_combatlogic[GetPlayerId( GetOwningPlayer( caster ) ) + 1] and GetUnitState( caster, UNIT_STATE_LIFE) > 0.405 and ( ( ( caster == udg_unit[57] or caster == udg_unit[58] ) and udg_fightmod[3] ) or not( udg_fightmod[3] ) ) then
        set u = CreateUnitAtLoc( GetOwningPlayer( caster ), ID_SHEEP, Location(GetRandomReal(GetRectMinX(udg_Boss_Rect), GetRectMaxX(udg_Boss_Rect)), GetRandomReal(GetRectMinY(udg_Boss_Rect), GetRectMaxY(udg_Boss_Rect))), GetRandomReal( 0, 360 ) )
        call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\Human\\Polymorph\\PolyMorphDoneGround.mdl", GetUnitX( u ), GetUnitY( u ) ) )
        call UnitApplyTimedLife( u, 'BTLF', 60 )
    endif

    set u = null
    set caster = null
    set it = null
endfunction

function Trig_Magic_Thread_Actions takes nothing returns nothing
    local integer id = GetHandleId( GetManipulatedItem() )
    
    if LoadTimerHandle( udg_hash, id, StringHash( "mgthrd" ) ) == null  then
        call SaveTimerHandle( udg_hash, id, StringHash( "mgthrd" ), CreateTimer() )
    endif 
	set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "mgthrd" ) ) ) 
	call SaveUnitHandle( udg_hash, id, StringHash( "mgthrd" ), GetManipulatingUnit() ) 
    call SaveItemHandle( udg_hash, id, StringHash( "mgthrdt" ), GetManipulatedItem() ) 
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( GetManipulatedItem() ), StringHash( "mgthrd" ) ), 8, true, function Magic_ThreadCast )
endfunction

//===========================================================================
function InitTrig_Magic_Thread takes nothing returns nothing
    set gg_trg_Magic_Thread = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Magic_Thread, EVENT_PLAYER_UNIT_PICKUP_ITEM ) 
	call TriggerAddCondition( gg_trg_Magic_Thread, Condition( function Trig_Magic_Thread_Conditions ) ) 
    call TriggerAddAction( gg_trg_Magic_Thread, function Trig_Magic_Thread_Actions )
endfunction

