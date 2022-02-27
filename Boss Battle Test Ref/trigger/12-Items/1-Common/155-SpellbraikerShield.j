function Trig_SpellbraikerShield_Conditions takes nothing returns boolean 
	return GetItemTypeId(GetManipulatedItem()) == 'I00X' or ( GetItemTypeId(GetManipulatedItem()) == 'I030' and udg_Set_Weapon_Logic[GetPlayerId(GetOwningPlayer( GetTriggerUnit( ) )) + 1 + 52] ) 
endfunction 

function WitcherShieldEnd takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    call UnitRemoveAbility( LoadUnitHandle( udg_hash, id, StringHash( "wshend" ) ), 'A07C' ) 
    call UnitRemoveAbility( LoadUnitHandle( udg_hash, id, StringHash( "wshend" ) ), 'B02S' ) 
    call FlushChildHashtable( udg_hash, id )
endfunction

function WitcherShieldCast takes nothing returns nothing 
    local integer id = GetHandleId( GetExpiredTimer( ) )
    local unit caster = LoadUnitHandle( udg_hash, id, StringHash( "wsh" ) )
    local integer id1
    local real t = timebonus(caster, 3)
    local item it = LoadItemHandle( udg_hash, id, StringHash( "wsht" ) )
    
    if not(UnitHasItem(caster,it )) then
        call UnitRemoveAbility( caster, 'A07C' ) 
        call UnitRemoveAbility( caster, 'B02S' )
        call FlushChildHashtable( udg_hash, id )
        call DestroyTimer( GetExpiredTimer() )
    elseif GetUnitState( caster, UNIT_STATE_LIFE) > 0.405 then
        set id1 = GetHandleId( caster )
		call UnitAddAbility( caster, 'A07C' ) 
        if LoadTimerHandle( udg_hash, id1, StringHash( "wshend" ) ) == null then
            call SaveTimerHandle( udg_hash, id1, StringHash( "wshend" ), CreateTimer() )
        endif
        set id1 = GetHandleId( LoadTimerHandle( udg_hash, id1, StringHash( "wshend" ) ) ) 
        call SaveUnitHandle( udg_hash, id1, StringHash( "wshend" ), caster )
        call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( caster ), StringHash( "wshend" ) ), t, false, function WitcherShieldEnd )
        
        call effst( caster, caster, null, 1, t )
	endif
    
    set it = null
    set caster = null
endfunction 

function Trig_SpellbraikerShield_Actions takes nothing returns nothing 
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

    set id = GetHandleId( it )
    if LoadTimerHandle( udg_hash, id, StringHash( "wsh" ) ) == null then
        call SaveTimerHandle( udg_hash, id, StringHash( "wsh" ), CreateTimer() )
    endif 
	set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "wsh" ) ) ) 
	call SaveUnitHandle( udg_hash, id, StringHash( "wsh" ), caster ) 
    call SaveItemHandle( udg_hash, id, StringHash( "wsht" ), it ) 
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( it ), StringHash( "wsh" ) ), 12, true, function WitcherShieldCast )
    
    set caster = null
    set it = null
endfunction 

//=========================================================================== 
function InitTrig_SpellbraikerShield takes nothing returns nothing 
	set gg_trg_SpellbraikerShield = CreateTrigger( ) 
	call TriggerRegisterAnyUnitEventBJ( gg_trg_SpellbraikerShield, EVENT_PLAYER_UNIT_PICKUP_ITEM ) 
	call TriggerAddCondition( gg_trg_SpellbraikerShield, Condition( function Trig_SpellbraikerShield_Conditions ) ) 
	call TriggerAddAction( gg_trg_SpellbraikerShield, function Trig_SpellbraikerShield_Actions ) 
endfunction