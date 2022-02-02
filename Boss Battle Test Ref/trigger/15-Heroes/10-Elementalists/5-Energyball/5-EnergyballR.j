function Trig_EnergyballR_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A0V5'
endfunction

function EnergyballRCast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer( ) )
    local real counter = LoadReal( udg_hash, id, StringHash( "enbrt" ) )
    local integer sp = LoadInteger( udg_hash, id, StringHash( "enbrb" ) )
    local real dmg = LoadReal( udg_hash, id, StringHash( "enbr" ) )
    local unit caster = LoadUnitHandle( udg_hash, id, StringHash( "enbr" ) )
    local unit u = randomtarget( caster, 900, "enemy", "", "", "", "" )
    local lightning l 
    local integer id1 
    local unit dummy = CreateUnit( GetOwningPlayer( caster ), 'u000', GetUnitX( caster ), GetUnitY( caster ), 270 )

    if u != null and GetUnitState( caster, UNIT_STATE_LIFE) > 0.405 then
        set l = AddLightningEx("CLPB", true, GetUnitX(caster), GetUnitY(caster), GetUnitFlyHeight(caster) + 50, GetUnitX(u), GetUnitY(u), GetUnitFlyHeight(u) + 50 )
        set id1 = GetHandleId( l )
        call SaveTimerHandle( udg_hash, id1, StringHash( "enba" ), CreateTimer() )
        set id1 = GetHandleId( LoadTimerHandle( udg_hash, id1, StringHash( "enba" ) ) ) 
        call SaveLightningHandle( udg_hash, id1, StringHash( "enba" ), l )
        call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( l ), StringHash( "enba" ) ), 0.5, false, function EnergyballACast )
        
        call UnitApplyTimedLife( dummy, 'BTLF', 1)
        call UnitAddAbility( dummy, 'A0N5')
        call DestroyEffect( AddSpecialEffect( "Abilities\\Weapons\\FarseerMissile\\FarseerMissile.mdl", GetUnitX( u ), GetUnitY( u ) ) )
        call UnitDamageTarget( dummy, u, dmg, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS)
    endif
    if counter > 0 and GetUnitState( caster, UNIT_STATE_LIFE) > 0.405 and GetUnitAbilityLevel( caster, 'A0V7' ) > 0 and not( IsUnitLoaded( caster ) ) then
        call SaveReal( udg_hash, id, StringHash( "enbrt" ), counter - 1 )
    else
        call UnitRemoveAbility( caster, 'A0V7' )
        call UnitRemoveAbility( caster, 'B058' )
        call FlushChildHashtable( udg_hash, id )
        call DestroyTimer( GetExpiredTimer() )
    endif
    
    set l = null
    set u = null
    set dummy = null
    set caster = null
endfunction

function Trig_EnergyballR_Actions takes nothing returns nothing
    local integer id 
    local real dmg 
    local integer lvl
    local unit caster
    local integer sp
    local real t
    
    if CastLogic() then
        set caster = udg_Caster
        set lvl = udg_Level
        set t = udg_Time
    elseif RandomLogic() then
        set caster = udg_Caster
        set lvl = udg_Level
        call textst( udg_string[0] + GetObjectName('A0V5'), caster, 64, 90, 10, 1.5 )
        set t = 25
    else
        set caster = GetSpellAbilityUnit()
        set lvl = GetUnitAbilityLevel(GetSpellAbilityUnit(), GetSpellAbilityId() )
        set t = 25
    endif
    set t = timebonus(caster, t)
    
    set id = GetHandleId( caster )
    set dmg = 4 * lvl * udg_SpellDamage[GetPlayerId(GetOwningPlayer( caster ) ) + 1]
    
        set sp = GetSpellAbilityId()
    
    call UnitAddAbility( caster, 'A0V7' )
    if LoadTimerHandle( udg_hash, id, StringHash( "enbr" ) ) == null then
        call SaveTimerHandle( udg_hash, id, StringHash( "enbr" ), CreateTimer() )
    endif
	set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "enbr" ) ) ) 
	call SaveUnitHandle( udg_hash, id, StringHash( "enbr" ), caster )
    call SaveReal( udg_hash, id, StringHash( "enbr" ), dmg )
    call SaveReal( udg_hash, id, StringHash( "enbrt" ), t*2 )
    call SaveInteger( udg_hash, id, StringHash( "enbrb" ), sp )
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( caster ), StringHash( "enbr" ) ), 0.5, true, function EnergyballRCast )
    
    if BuffLogic() then
        call effst( caster, caster, "Trig_EnergyballR_Actions", lvl, t )
    endif
    
    set caster = null
endfunction

//===========================================================================
function InitTrig_EnergyballR takes nothing returns nothing
    set gg_trg_EnergyballR = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_EnergyballR, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_EnergyballR, Condition( function Trig_EnergyballR_Conditions ) )
    call TriggerAddAction( gg_trg_EnergyballR, function Trig_EnergyballR_Actions )
endfunction

