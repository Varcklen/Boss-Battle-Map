function Trig_Horror1_Conditions takes nothing returns boolean
    return GetItemTypeId(GetManipulatedItem()) == 'I05R'
endfunction

function Horror1End takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer( ) )
    local unit u = LoadUnitHandle( udg_hash, id, StringHash( "drksf" ) )
    
    call UnitRemoveAbility( u, 'A07L' )
    call UnitRemoveAbility( u, 'B04H' )
    call FlushChildHashtable( udg_hash, id )
    
    set u = null
endfunction

function Trig_Horror1_Actions takes nothing returns nothing
	local integer id = GetHandleId( GetManipulatingUnit() )

	call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Undead\\DeathCoil\\DeathCoilSpecialArt.mdl", GetManipulatingUnit(), "origin"))
    call dummyspawn( GetManipulatingUnit(), 1, 0, 0, 0 )
    call UnitDamageTarget( bj_lastCreatedUnit, GetManipulatingUnit(), 100, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS)

    call UnitAddAbility( GetManipulatingUnit(), 'A07L' )

    if LoadTimerHandle( udg_hash, id, StringHash( "drksf" ) ) == null  then 
        call SaveTimerHandle( udg_hash, id, StringHash( "drksf" ), CreateTimer() )
    endif
	set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "drksf" ) ) ) 
	call SaveUnitHandle( udg_hash, id, StringHash( "drksf" ), GetManipulatingUnit() )
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( GetManipulatingUnit() ), StringHash( "drksf" ) ), 8, false, function Horror1End )
endfunction

//===========================================================================
function InitTrig_Horror1 takes nothing returns nothing
    set gg_trg_Horror1 = CreateTrigger(  )
    call DisableTrigger( gg_trg_Horror1 )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Horror1, EVENT_PLAYER_UNIT_PICKUP_ITEM )
    call TriggerAddCondition( gg_trg_Horror1, Condition( function Trig_Horror1_Conditions ) )
    call TriggerAddAction( gg_trg_Horror1, function Trig_Horror1_Actions )
endfunction

