function Trig_Ring_of_Light_Conditions takes nothing returns boolean
    return GetItemTypeId(GetManipulatedItem()) == 'I029'
endfunction

function BitSunCast takes nothing returns nothing 
	local integer id = GetHandleId( GetExpiredTimer( ) )
    local group g = CreateGroup()
    local unit u
    local unit caster = LoadUnitHandle( udg_hash, id, StringHash( "bots" ) )
    local item it = LoadItemHandle( udg_hash, id, StringHash( "botst" ) )
	
    if not(UnitHasItem(caster,it )) then
        call FlushChildHashtable( udg_hash, id )
        call DestroyTimer( GetExpiredTimer() )
    elseif GetUnitState( caster, UNIT_STATE_LIFE ) > 0.405 then
        call dummyspawn( caster, 1, 0, 0, 0 )
        call GroupEnumUnitsInRange( g, GetUnitX( caster ), GetUnitY( caster ), 300, null )
        loop
            set u = FirstOfGroup(g)
            exitwhen u == null
            if unitst( u, caster, "enemy" ) then
                call UnitDamageTarget( bj_lastCreatedUnit, u, 10, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS )
                call DestroyEffect( AddSpecialEffectTarget("Abilities\\Spells\\NightElf\\Immolation\\ImmolationDamage.mdl", u, "origin" ) )
            endif
            call GroupRemoveUnit(g,u)
        endloop
    endif
    
    call GroupClear( g )
    call DestroyGroup( g )
    set g = null
    set u = null
    set caster = null
    set it = null
endfunction 

function Trig_Ring_of_Light_Actions takes nothing returns nothing
    local integer id = GetHandleId( GetManipulatedItem() )
    
    if LoadTimerHandle( udg_hash, id, StringHash( "bots" ) ) == null  then
        call SaveTimerHandle( udg_hash, id, StringHash( "bots" ), CreateTimer() )
    endif 
	set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "bots" ) ) ) 
	call SaveUnitHandle( udg_hash, id, StringHash( "bots" ), GetManipulatingUnit() ) 
    call SaveItemHandle( udg_hash, id, StringHash( "botst" ), GetManipulatedItem() ) 
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( GetManipulatedItem() ), StringHash( "bots" ) ), 1, true, function BitSunCast )
endfunction

//===========================================================================
function InitTrig_Ring_of_Light takes nothing returns nothing
    set gg_trg_Ring_of_Light = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Ring_of_Light, EVENT_PLAYER_UNIT_PICKUP_ITEM )
    call TriggerAddCondition( gg_trg_Ring_of_Light, Condition( function Trig_Ring_of_Light_Conditions ) )
    call TriggerAddAction( gg_trg_Ring_of_Light, function Trig_Ring_of_Light_Actions )
endfunction

