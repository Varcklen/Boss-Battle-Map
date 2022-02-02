function Trig_StormPot_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A0RN'
endfunction

function StormPotCast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local integer counter = LoadInteger( udg_hash, id, StringHash( "stpt" ) )
    local real dmg = LoadReal( udg_hash, id, StringHash( "stpt" ) )
    local unit dummy = LoadUnitHandle( udg_hash, id, StringHash( "stptd" ) )
    local unit caster = LoadUnitHandle( udg_hash, id, StringHash( "stpt" ) )
    local unit u
    local group g = CreateGroup()
    local real x = LoadReal( udg_hash, id, StringHash( "stptx" ) )
    local real y = LoadReal( udg_hash, id, StringHash( "stpty" ) )

    if GetUnitState( dummy, UNIT_STATE_LIFE) > 0.405 then
        call GroupEnumUnitsInRange( g, x, y, 600, null )
        loop
            set u = FirstOfGroup(g)
            exitwhen u == null
            if unitst( u, caster, "enemy" ) then
                call UnitDamageTarget( dummy, u, dmg, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS )
            endif
            call GroupRemoveUnit(g,u)
            set u = FirstOfGroup(g)
        endloop
    endif
    
    if counter > 1 and GetUnitState( dummy, UNIT_STATE_LIFE) > 0.405 then
        call SaveInteger( udg_hash, id, StringHash( "stpt" ), counter - 1 )
    else    
        call RemoveUnit( dummy )
        call FlushChildHashtable( udg_hash, id )
        call DestroyTimer( GetExpiredTimer() )
    endif
    
    call GroupClear( g )
    call DestroyGroup( g )
    set u = null
    set dummy = null
    set caster = null
endfunction

function Trig_StormPot_Actions takes nothing returns nothing
    local integer id
    local unit caster
    local real x
    local real y
    local real dmg
    
    if CastLogic() then
        set caster = udg_Caster
        set x = GetLocationX( GetSpellTargetLoc() )
        set y = GetLocationY( GetSpellTargetLoc() )
    elseif RandomLogic() then
        set caster = udg_Caster
        set x = GetUnitX( caster ) + GetRandomReal( -650, 650 )
        set y = GetUnitY( caster ) + GetRandomReal( -650, 650 )
        call textst( "|cf0FF3030 Firestorm", caster, 64, 90, 10, 1.5 )
    else
        set caster = GetSpellAbilityUnit()
        set x = GetLocationX( GetSpellTargetLoc() )
        set y = GetLocationY( GetSpellTargetLoc() )
    endif
 
    set dmg = 75 * udg_SpellDamagePotion[GetPlayerId( GetOwningPlayer( caster ) ) + 1]
 
    call dummyspawn( caster, 0, 'A0PC', 0, 0 )
    call IssuePointOrder( bj_lastCreatedUnit, "flamestrike", x, y )
    set id = GetHandleId( bj_lastCreatedUnit )
    
    if LoadTimerHandle( udg_hash, id, StringHash( "stpt" ) ) == null then
        call SaveTimerHandle( udg_hash, id, StringHash( "stpt" ), CreateTimer() )
    endif
	set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "stpt" ) ) ) 
	call SaveUnitHandle( udg_hash, id, StringHash( "stpt" ), caster )
    call SaveUnitHandle( udg_hash, id, StringHash( "stptd" ), bj_lastCreatedUnit )
    call SaveInteger( udg_hash, id, StringHash( "stpt" ), 12 )
    call SaveReal( udg_hash, id, StringHash( "stpt" ), dmg )
    call SaveReal( udg_hash, id, StringHash( "stptx" ), x )
    call SaveReal( udg_hash, id, StringHash( "stpty" ), y )
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( bj_lastCreatedUnit ), StringHash( "stpt" ) ), 1, true, function StormPotCast )
    
    call potionst( caster )
    
    set caster = null
endfunction

//===========================================================================
function InitTrig_StormPot takes nothing returns nothing
    set gg_trg_StormPot = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_StormPot, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_StormPot, Condition( function Trig_StormPot_Conditions ) )
    call TriggerAddAction( gg_trg_StormPot, function Trig_StormPot_Actions )
endfunction

