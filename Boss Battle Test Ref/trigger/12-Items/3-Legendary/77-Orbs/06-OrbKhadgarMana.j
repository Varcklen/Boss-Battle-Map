function Trig_OrbKhadgarMana_Conditions takes nothing returns boolean 
	return GetItemTypeId(GetManipulatedItem()) == 'I0DK'
endfunction 

function OrbKhadgarManaEnd takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer( ) )
    local unit u = LoadUnitHandle( udg_hash, id, StringHash( "orbkc" ) )
    
	call SaveBoolean( udg_hash, GetHandleId( u ), StringHash( "orbkm" ), false )
    call FlushChildHashtable( udg_hash, id )

    set u = null
endfunction

function OrbKhadgarManaCast takes nothing returns nothing 
	local integer id = GetHandleId( GetExpiredTimer( ) )
    local unit caster = LoadUnitHandle( udg_hash, id, StringHash( "orbkm" ) )
    local item it = LoadItemHandle( udg_hash, id, StringHash( "orbkmt" ) )
    local integer id1
    
    if not(UnitHasItem(caster,it )) then
        call FlushChildHashtable( udg_hash, id )
        call DestroyTimer( GetExpiredTimer() )
    elseif GetUnitState( caster, UNIT_STATE_LIFE) > 0.405 and not(LoadBoolean( udg_hash, GetHandleId( caster ), StringHash( "orbkm" ))) and GetUnitState( caster, UNIT_STATE_MANA) < 0.1*GetUnitState( caster, UNIT_STATE_MAX_MANA) then
        call SaveBoolean( udg_hash, GetHandleId( caster ), StringHash( "orbkm" ), true )
        call manast(caster, null, GetUnitState( caster, UNIT_STATE_MAX_MANA))
        call BlzStartUnitAbilityCooldown( caster, 'A0I8', 90 )
        call DestroyEffect( AddSpecialEffectTarget("Abilities\\Spells\\Human\\MassTeleport\\MassTeleportCaster.mdl", caster, "origin" ) )
        
        set id1 = GetHandleId( caster )
        if LoadTimerHandle( udg_hash, id1, StringHash( "orbkc" ) ) == null then
            call SaveTimerHandle( udg_hash, id1, StringHash( "orbkc" ), CreateTimer() )
        endif
        call SaveTimerHandle( udg_hash, id1, StringHash( "orbkc" ), CreateTimer( ) ) 
        set id1 = GetHandleId( LoadTimerHandle( udg_hash, id1, StringHash( "orbkc" ) ) ) 
        call SaveUnitHandle( udg_hash, id1, StringHash( "orbkc" ), caster ) 
        call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( caster ), StringHash( "orbkc" ) ), 90, false, function OrbKhadgarManaEnd ) 
    endif
    
    set it = null
    set caster = null
endfunction

function Trig_OrbKhadgarMana_Actions takes nothing returns nothing 
	local integer id = GetHandleId( GetManipulatedItem() )
	
    if LoadTimerHandle( udg_hash, id, StringHash( "orbkm" ) ) == null  then
        call SaveTimerHandle( udg_hash, id, StringHash( "orbkm" ), CreateTimer() )
    endif 
	set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "orbkm" ) ) ) 
	call SaveUnitHandle( udg_hash, id, StringHash( "orbkm" ), GetManipulatingUnit() ) 
    call SaveItemHandle( udg_hash, id, StringHash( "orbkmt" ), GetManipulatedItem() )  
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( GetManipulatedItem() ), StringHash( "orbkm" ) ), 1, true, function OrbKhadgarManaCast ) 
endfunction 

//=========================================================================== 
function InitTrig_OrbKhadgarMana takes nothing returns nothing 
	set gg_trg_OrbKhadgarMana = CreateTrigger( ) 
	call TriggerRegisterAnyUnitEventBJ( gg_trg_OrbKhadgarMana, EVENT_PLAYER_UNIT_PICKUP_ITEM ) 
	call TriggerAddCondition( gg_trg_OrbKhadgarMana, Condition( function Trig_OrbKhadgarMana_Conditions ) ) 
	call TriggerAddAction( gg_trg_OrbKhadgarMana, function Trig_OrbKhadgarMana_Actions ) 
endfunction