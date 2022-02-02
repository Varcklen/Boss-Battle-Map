function Trig_AggressiveShield_Conditions takes nothing returns boolean 
	return GetItemTypeId(GetManipulatedItem()) == 'I0AV' or ( GetItemTypeId(GetManipulatedItem()) == 'I030' and udg_Set_Weapon_Logic[GetPlayerId(GetOwningPlayer( GetManipulatingUnit() )) + 1 + 44] ) 
endfunction 

function ArmorShildCast takes nothing returns nothing 
    local integer id = GetHandleId( GetExpiredTimer( ) )
    local integer idn
    local unit caster = LoadUnitHandle( udg_hash, id, StringHash( "armsh" ) )
    local unit target
    local real t = timebonus(caster, 4)
    local item it = LoadItemHandle( udg_hash, id, StringHash( "armsht" ) )
    
    if not(UnitHasItem(caster,it )) then
        call FlushChildHashtable( udg_hash, id )
        call DestroyTimer( GetExpiredTimer() )
	elseif GetUnitState( caster, UNIT_STATE_LIFE) > 0.405 and combat( caster, false, 0 ) then
        set target = randomtarget( caster, 900, "enemy", "org", "", "", "" )
        if target != null then
            call DestroyEffect( AddSpecialEffectTarget("Abilities\\Spells\\NightElf\\Taunt\\TauntCaster.mdl" , caster, "origin" ) )
            call taunt( caster, target, t )
        endif
	endif
    
    set caster = null
    set target = null
    set it = null
endfunction 

function Trig_AggressiveShield_Actions takes nothing returns nothing 
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
    if LoadTimerHandle( udg_hash, id, StringHash( "armsh" ) ) == null  then
        call SaveTimerHandle( udg_hash, id, StringHash( "armsh" ), CreateTimer() )
    endif 
	set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "armsh" ) ) ) 
	call SaveUnitHandle( udg_hash, id, StringHash( "armsh" ), caster ) 
    call SaveItemHandle( udg_hash, id, StringHash( "armsht" ), it ) 
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( it ), StringHash( "armsh" ) ), 12, true, function ArmorShildCast )
    
    set caster = null
    set it = null
endfunction 

//=========================================================================== 
function InitTrig_AggressiveShield takes nothing returns nothing 
	set gg_trg_AggressiveShield = CreateTrigger( ) 
	call TriggerRegisterAnyUnitEventBJ( gg_trg_AggressiveShield, EVENT_PLAYER_UNIT_PICKUP_ITEM ) 
	call TriggerAddCondition( gg_trg_AggressiveShield, Condition( function Trig_AggressiveShield_Conditions ) ) 
	call TriggerAddAction( gg_trg_AggressiveShield, function Trig_AggressiveShield_Actions ) 
endfunction