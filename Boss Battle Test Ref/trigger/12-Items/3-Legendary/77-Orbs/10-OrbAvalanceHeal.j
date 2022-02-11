function Trig_OrbAvalanceHeal_Conditions takes nothing returns boolean 
	return GetItemTypeId(GetManipulatedItem()) == 'I0ES'
endfunction 

function OrbAvalanceHealEnd takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer( ) )
    local unit u = LoadUnitHandle( udg_hash, id, StringHash( "orbavc" ) )
    
	call SaveBoolean( udg_hash, GetHandleId( u ), StringHash( "orbavh" ), false )
    call FlushChildHashtable( udg_hash, id )

    set u = null
endfunction

function OrbAvalanceHealStun takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local unit caster = LoadUnitHandle( udg_hash, id, StringHash( "orbavs" ) )
    local integer i = LoadInteger( udg_hash, id, StringHash( "orbavs" ) ) + 1
    
    if GetUnitState( caster, UNIT_STATE_LIFE) > 0.405 then
        call healst(caster, null, 0.25*GetUnitState( caster, UNIT_STATE_MAX_LIFE))
    endif
    if GetUnitState( caster, UNIT_STATE_LIFE) <= 0.405 or GetUnitAbilityLevel( caster, 'A0WQ') == 0 or i >= 3 then
        call UnitRemoveAbility(caster, 'A0WQ')
        call pausest(caster, -1)
        call DestroyTimer( GetExpiredTimer() )
        call FlushChildHashtable( udg_hash, id )
    else
        call SaveInteger( udg_hash, id, StringHash( "orbavs" ), i )
    endif
    
    set caster = null
endfunction

function OrbAvalanceHealCast takes nothing returns nothing 
	local integer id = GetHandleId( GetExpiredTimer( ) )
    local unit caster = LoadUnitHandle( udg_hash, id, StringHash( "orbavh" ) )
    local item it = LoadItemHandle( udg_hash, id, StringHash( "orbavht" ) )
    local integer id1
    local real x
    local real y
    local integer cyclA
    
    if not(UnitHasItem(caster,it )) then
        call FlushChildHashtable( udg_hash, id )
        call DestroyTimer( GetExpiredTimer() )
    elseif GetUnitState( caster, UNIT_STATE_LIFE) > 0.405 and not(LoadBoolean( udg_hash, GetHandleId( caster ), StringHash( "orbavh" ))) and GetUnitState( caster, UNIT_STATE_LIFE) < 0.2*GetUnitState( caster, UNIT_STATE_MAX_LIFE) then
        call SaveBoolean( udg_hash, GetHandleId( caster ), StringHash( "orbavh" ), true )
        call BlzStartUnitAbilityCooldown( caster, 'A0WE', 90 )
        
        set id1 = GetHandleId( caster )
        if LoadTimerHandle( udg_hash, id1, StringHash( "orbavc" ) ) == null then
            call SaveTimerHandle( udg_hash, id1, StringHash( "orbavc" ), CreateTimer() )
        endif
        call SaveTimerHandle( udg_hash, id1, StringHash( "orbavc" ), CreateTimer( ) ) 
        set id1 = GetHandleId( LoadTimerHandle( udg_hash, id1, StringHash( "orbavc" ) ) ) 
        call SaveUnitHandle( udg_hash, id1, StringHash( "orbavc" ), caster ) 
        call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( caster ), StringHash( "orbavc" ) ), 90, false, function OrbAvalanceHealEnd ) 
        
        if GetUnitAbilityLevel( caster, 'A0WQ') == 0 then
            call pausest(caster, 1)
        endif
        call UnitAddAbility(caster, 'A0WQ')
        set id1 = GetHandleId( caster )
        if LoadTimerHandle( udg_hash, id1, StringHash( "orbavs" ) ) == null then
            call SaveTimerHandle( udg_hash, id1, StringHash( "orbavs" ), CreateTimer() )
        endif
        call SaveTimerHandle( udg_hash, id1, StringHash( "orbavs" ), CreateTimer( ) ) 
        set id1 = GetHandleId( LoadTimerHandle( udg_hash, id1, StringHash( "orbavs" ) ) ) 
        call SaveUnitHandle( udg_hash, id1, StringHash( "orbavs" ), caster ) 
        call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( caster ), StringHash( "orbavs" ) ), 1, true, function OrbAvalanceHealStun ) 
        
        call spectimeunit( caster, "Abilities\\Spells\\Undead\\FrostNova\\FrostNovaTarget.mdl", "origin", 1 )
        set cyclA = 1
        loop
            exitwhen cyclA > 8
            set x = GetUnitX(caster) + 100 * Cos(45. * cyclA * bj_DEGTORAD)
            set y = GetUnitY(caster) + 100 * Sin(45. * cyclA * bj_DEGTORAD)
            call spectime( "war3mapImported\\Ice Shard.mdx", x, y, 3 )
            set cyclA = cyclA + 1
        endloop
    endif
    
    set it = null
    set caster = null
endfunction

function Trig_OrbAvalanceHeal_Actions takes nothing returns nothing 
	local integer id = GetHandleId( GetManipulatedItem() )
	
    if LoadTimerHandle( udg_hash, id, StringHash( "orbavh" ) ) == null  then
        call SaveTimerHandle( udg_hash, id, StringHash( "orbavh" ), CreateTimer() )
    endif 
	set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "orbavh" ) ) ) 
	call SaveUnitHandle( udg_hash, id, StringHash( "orbavh" ), GetManipulatingUnit() ) 
    call SaveItemHandle( udg_hash, id, StringHash( "orbavht" ), GetManipulatedItem() )  
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( GetManipulatedItem() ), StringHash( "orbavh" ) ), 1, true, function OrbAvalanceHealCast ) 
endfunction 

//=========================================================================== 
function InitTrig_OrbAvalanceHeal takes nothing returns nothing 
	set gg_trg_OrbAvalanceHeal = CreateTrigger( ) 
	call TriggerRegisterAnyUnitEventBJ( gg_trg_OrbAvalanceHeal, EVENT_PLAYER_UNIT_PICKUP_ITEM ) 
	call TriggerAddCondition( gg_trg_OrbAvalanceHeal, Condition( function Trig_OrbAvalanceHeal_Conditions ) ) 
	call TriggerAddAction( gg_trg_OrbAvalanceHeal, function Trig_OrbAvalanceHeal_Actions ) 
endfunction