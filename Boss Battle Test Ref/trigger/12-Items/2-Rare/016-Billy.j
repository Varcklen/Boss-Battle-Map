globals
    constant integer BILLY_ID = 'I0GE'
    constant integer BILLY_DAMAGE = 500
    constant integer BILLY_SPEED = 60
    constant integer BILLY_SCATTER = 200
    
    constant string BILLY_ANIMATION = "Abilities\\Spells\\Human\\Thunderclap\\ThunderClapCaster.mdl"
endglobals

function Trig_Billy_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A102' and combat(GetSpellAbilityUnit(), true, GetSpellAbilityId()) and udg_fightmod[3] == false
endfunction

function BillyEnd takes unit dummy, unit target, integer id returns nothing
    local real dmg = LoadReal( udg_hash, id, StringHash( "billy" ) )
    local item billy = LoadItemHandle( udg_hash, id, StringHash( "billyit" ) )
    
    call DestroyEffect( AddSpecialEffect( BILLY_ANIMATION, GetUnitX( target ), GetUnitY( target ) ) )
    call UnitDamageTarget( dummy, target, dmg, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS)
    
    call SetItemPosition(billy, Math_GetUnitRandomX(target, BILLY_SCATTER), Math_GetUnitRandomY(target, BILLY_SCATTER))
    call SetItemVisible(billy, true)
    
    set target = null
    set dummy = null
    set billy = null
endfunction  

function BillyMotion takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local unit target = LoadUnitHandle( udg_hash, id, StringHash( "billyt" ) )
    local unit dummy = LoadUnitHandle( udg_hash, id, StringHash( "billy" ) )
    local point movePoint 

    if DistanceBetweenUnits(dummy, target) > 100 and IsUnitAlive(target) and IsUnitAlive(dummy) then
        set movePoint = GetMovedPointBetweenUnits( dummy, target, BILLY_SPEED )
        call SetUnitPosition( dummy, movePoint.x, movePoint.y )
    else
        call BillyEnd(dummy, target, id )
        call RemoveUnit( dummy )
        call DestroyTimer( GetExpiredTimer() )
        call FlushChildHashtable( udg_hash, id )
    endif

    call movePoint.destroy()
    set dummy = null
    set target = null
endfunction   

function Trig_Billy_Actions takes nothing returns nothing
    local integer id 
    local real dmg 
    local unit caster
    local unit target
    local item billy

    if CastLogic() then
        set caster = udg_Caster
        set target = udg_Target
    elseif RandomLogic() then
        set caster = udg_Caster
        set target = randomtarget( caster, 900, "enemy", "", "", "", "" )
        call textst( udg_string[0] + GetObjectName('A102'), caster, 64, 90, 10, 1.5 )
        if target == null then
            set caster = null
            return
        endif
    else
        set caster = GetSpellAbilityUnit()
        set target = GetSpellTargetUnit()
    endif
    
    set billy = GetItemOfTypeFromUnitBJ( caster, BILLY_ID)
    set dmg = BILLY_DAMAGE * udg_SpellDamage[GetUnitUserData(caster)] * eyest( caster )
    
    if billy != null then
        call UnitRemoveItem(caster, billy)
        call SetItemVisible(billy, false)
    
        call dummyspawn( caster, 0, 'A10F', 'A0N5', 0 )
        call SetUnitFacing( bj_lastCreatedUnit, AngleBetweenUnits( caster, target ) )
        
        set id = InvokeTimerWithUnit( bj_lastCreatedUnit, "billy", 0.04, true, function BillyMotion )
        call SaveUnitHandle( udg_hash, id, StringHash( "billyt" ), target )
        call SaveReal( udg_hash, id, StringHash( "billy" ), dmg )
        call SaveItemHandle( udg_hash, id, StringHash( "billyit" ), billy )
    endif
    
    set caster = null
    set target = null
endfunction

//===========================================================================
function InitTrig_Billy takes nothing returns nothing
    set gg_trg_Billy = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Billy, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_Billy, Condition( function Trig_Billy_Conditions ) )
    call TriggerAddAction( gg_trg_Billy, function Trig_Billy_Actions )
endfunction




