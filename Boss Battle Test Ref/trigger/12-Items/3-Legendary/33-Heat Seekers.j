function Trig_Heat_Seekers_Conditions takes nothing returns boolean 
	return GetItemTypeId(GetManipulatedItem()) == 'I070'
endfunction 

function Heat_SeekersEnd takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer( ) )
    local unit dummy = LoadUnitHandle( udg_hash, id, StringHash( "htskr1" ) )
    local unit target = LoadUnitHandle( udg_hash, id, StringHash( "htskr1t" ) )
    local real dmg = LoadReal( udg_hash, id, StringHash( "htskr1" ) )
    
    if GetUnitState( target, UNIT_STATE_LIFE) > 0.405 then
        if DistanceBetweenUnits(target, dummy) < 50 then
            call DestroyEffect( AddSpecialEffect("Abilities\\Spells\\Other\\Incinerate\\FireLordDeathExplode.mdl", GetUnitX(target), GetUnitY(target)) )
            call UnitDamageTarget(dummy, target, dmg, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS)
            call RemoveUnit( dummy )
            call FlushChildHashtable( udg_hash, id )
            call DestroyTimer( GetExpiredTimer() )
        else
            call IssuePointOrder( dummy, "move", GetUnitX( target ), GetUnitY( target ) )
        endif
    elseif GetUnitState( dummy, UNIT_STATE_LIFE) > 0.405 and GetUnitState( target, UNIT_STATE_LIFE) <= 0.405 then
        set target = randomtarget( dummy, 900, "enemy", "", "", "", "" )
        if target != null then
            call IssuePointOrderLoc( dummy, "move", GetUnitLoc( target ) )
            call SaveUnitHandle( udg_hash, id, StringHash( "htskr1t" ), target )
        else
            call DestroyEffect( AddSpecialEffect("Abilities\\Spells\\Other\\Incinerate\\FireLordDeathExplode.mdl", GetUnitX(dummy), GetUnitY(dummy)) )
            call RemoveUnit( dummy )
            call FlushChildHashtable( udg_hash, id )
            call DestroyTimer( GetExpiredTimer() )
        endif
    elseif GetUnitState( dummy, UNIT_STATE_LIFE) <= 0.405 then
        call RemoveUnit( dummy )
        call FlushChildHashtable( udg_hash, id )
        call DestroyTimer( GetExpiredTimer() )
    endif
    
    set target = null
    set dummy = null
endfunction

function Heat_SeekersCast takes nothing returns nothing 
	local integer id = GetHandleId( GetExpiredTimer( ) )
    local unit u = LoadUnitHandle( udg_hash, id, StringHash( "htskr" ) )
    local unit t
    local item it = LoadItemHandle( udg_hash, id, StringHash( "htskrt" ) )
    local integer i = GetUnitUserData(u)
    local integer mech = SetCount_GetPieces(u, SET_MECH)
    local real dmg
    local integer cyclA
    local integer id1
    
    if not(UnitHasItem(u,it)) then
        call FlushChildHashtable( udg_hash, id )
        call DestroyTimer( GetExpiredTimer() )
    elseif GetUnitState( u, UNIT_STATE_LIFE) > 0.405 and not( IsUnitLoaded( u ) )  then
        set dmg = 125 * GetUnitSpellPower(u)
        call BlzStartUnitAbilityCooldown( u, 'A163', 10 )
        set cyclA = 1
        loop
            exitwhen cyclA > mech
            set t = randomtarget( u, 900, "enemy", "", "", "", "" )
            if t != null then
                call dummyspawn( u, 0, 'A0Z7', 'A0N5', 0 )
                call SetUnitMoveSpeed( bj_lastCreatedUnit, 400 )
                
                call IssuePointOrder( bj_lastCreatedUnit, "move", GetUnitX( t ), GetUnitY( t ) )
                
                set id1 = GetHandleId( bj_lastCreatedUnit )
                if LoadTimerHandle( udg_hash, id1, StringHash( "htskr1" ) ) == null then
                    call SaveTimerHandle( udg_hash, id1, StringHash( "htskr1" ), CreateTimer() )
                endif
                set id1 = GetHandleId( LoadTimerHandle( udg_hash, id1, StringHash( "htskr1" ) ) ) 
                call SaveUnitHandle( udg_hash, id1, StringHash( "htskr1" ), bj_lastCreatedUnit )
                call SaveUnitHandle( udg_hash, id1, StringHash( "htskr1t" ), t )
                call SaveReal( udg_hash, id1, StringHash( "htskr1" ), dmg )
                call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( bj_lastCreatedUnit ), StringHash( "htskr1" ) ), 0.2, true, function Heat_SeekersEnd )
            else
                set cyclA = mech
            endif
            set cyclA = cyclA + 1
        endloop
    endif
    
    set t = null
    set it = null
    set u = null
endfunction 

function Trig_Heat_Seekers_Actions takes nothing returns nothing 
	local integer id = GetHandleId( GetManipulatedItem() )
	
    if LoadTimerHandle( udg_hash, id, StringHash( "htskr" ) ) == null  then
        call SaveTimerHandle( udg_hash, id, StringHash( "htskr" ), CreateTimer() )
    endif 
	set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "htskr" ) ) ) 
	call SaveUnitHandle( udg_hash, id, StringHash( "htskr" ), GetManipulatingUnit() ) 
    call SaveItemHandle( udg_hash, id, StringHash( "htskrt" ), GetManipulatedItem() ) 
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( GetManipulatedItem() ), StringHash( "htskr" ) ), 10, true, function Heat_SeekersCast ) 
endfunction 

//=========================================================================== 
function InitTrig_Heat_Seekers takes nothing returns nothing 
	set gg_trg_Heat_Seekers = CreateTrigger( ) 
	call TriggerRegisterAnyUnitEventBJ( gg_trg_Heat_Seekers, EVENT_PLAYER_UNIT_PICKUP_ITEM ) 
	call TriggerAddCondition( gg_trg_Heat_Seekers, Condition( function Trig_Heat_Seekers_Conditions ) ) 
	call TriggerAddAction( gg_trg_Heat_Seekers, function Trig_Heat_Seekers_Actions ) 
endfunction