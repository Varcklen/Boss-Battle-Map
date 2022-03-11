function Trig_Sheep_tear_Conditions takes nothing returns boolean
    return GetItemTypeId(GetManipulatedItem()) == 'I0DE'
endfunction

function Sheep_tearCast takes nothing returns nothing 
	local integer id = GetHandleId( GetExpiredTimer( ) )
    local group g = CreateGroup()
    local unit u
    local unit caster = LoadUnitHandle( udg_hash, id, StringHash( "shtp" ) )
    local item it = LoadItemHandle( udg_hash, id, StringHash( "shtpt" ) )
    local real x = GetUnitX( caster )
    local real y = GetUnitY( caster )
	
    if not(UnitHasItem(caster,it )) then
        call FlushChildHashtable( udg_hash, id )
        call DestroyTimer( GetExpiredTimer() )
    elseif GetUnitState( caster, UNIT_STATE_LIFE ) > 0.405 and IsUnitInvisible( caster, Player(PLAYER_NEUTRAL_AGGRESSIVE)) then
    	call DestroyEffect( AddSpecialEffect( "war3mapImported\\ArcaneExplosion.mdx", GetUnitX(caster), GetUnitY(caster) ) )
        call dummyspawn( caster, 1, 0, 0, 0 )
        call GroupEnumUnitsInRange( g, x, y, 300, null )
        loop
            set u = FirstOfGroup(g)
            exitwhen u == null
            if unitst( u, caster, "enemy" ) then
                call UnitDamageTarget( bj_lastCreatedUnit, u, 100, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS )
            endif
            call GroupRemoveUnit(g,u)
            set u = FirstOfGroup(g)
        endloop
    endif
    
    call GroupClear( g )
    call DestroyGroup( g )
    set g = null
    set u = null
    set caster = null
    set it = null    
endfunction 

function Trig_Sheep_tear_Actions takes nothing returns nothing
    local integer id = GetHandleId( GetManipulatedItem() )
	
    if LoadTimerHandle( udg_hash, id, StringHash( "shtp" ) ) == null  then
        call SaveTimerHandle( udg_hash, id, StringHash( "shtp" ), CreateTimer() )
    endif 
	set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "shtp" ) ) ) 
	call SaveUnitHandle( udg_hash, id, StringHash( "shtp" ), GetManipulatingUnit() ) 
    call SaveItemHandle( udg_hash, id, StringHash( "shtpt" ), GetManipulatedItem() ) 
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( GetManipulatedItem() ), StringHash( "shtp" ) ), 1, true, function Sheep_tearCast )
endfunction

//===========================================================================
function InitTrig_Sheep_tear takes nothing returns nothing
    set gg_trg_Sheep_tear = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Sheep_tear, EVENT_PLAYER_UNIT_PICKUP_ITEM )
    call TriggerAddCondition( gg_trg_Sheep_tear, Condition( function Trig_Sheep_tear_Conditions ) )
    call TriggerAddAction( gg_trg_Sheep_tear, function Trig_Sheep_tear_Actions )
endfunction

