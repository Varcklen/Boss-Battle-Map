function Trig_EnergyballW_Cast_Conditions takes nothing returns boolean
    return GetUnitAbilityLevel( GetSpellAbilityUnit(), 'B057') > 0 and GetSpellAbilityId() != 'A0V1' and GetSpellAbilityId() != 'A0VB'
endfunction

function Trig_EnergyballW_Cast_Actions takes nothing returns nothing
    local unit u = randomtarget( GetSpellAbilityUnit(), 900, "enemy", "", "", "", "" )
    local real dmg = LoadReal( udg_hash, GetHandleId( LoadTimerHandle( udg_hash, GetHandleId( GetSpellAbilityUnit() ), StringHash( "enbw" ) ) ) , StringHash( "enbw" ) ) 
    local lightning l
    local integer id 

    if u != null then
        set l = AddLightningEx("CLPB", true, GetUnitX(GetSpellAbilityUnit()), GetUnitY(GetSpellAbilityUnit()), GetUnitFlyHeight(GetSpellAbilityUnit()) + 50, GetUnitX(u), GetUnitY(u), GetUnitFlyHeight(u) + 50 )
        set id = GetHandleId( l )
        call SaveTimerHandle( udg_hash, id, StringHash( "enba" ), CreateTimer() )
        set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "enba" ) ) ) 
        call SaveLightningHandle( udg_hash, id, StringHash( "enba" ), l )
        call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( l ), StringHash( "enba" ) ), 0.5, false, function EnergyballACast )

        call dummyspawn( GetSpellAbilityUnit(), 1, 0, 0 , 0 )
        call DestroyEffect( AddSpecialEffect( "Abilities\\Weapons\\FarseerMissile\\FarseerMissile.mdl", GetUnitX( u ), GetUnitY( u ) ) )
        call UnitDamageTarget( bj_lastCreatedUnit, u, dmg, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS)
    endif
    set l = null
    set u = null
endfunction

//===========================================================================
function InitTrig_EnergyballW_Cast takes nothing returns nothing
    set gg_trg_EnergyballW_Cast = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_EnergyballW_Cast, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_EnergyballW_Cast, Condition( function Trig_EnergyballW_Cast_Conditions ) )
    call TriggerAddAction( gg_trg_EnergyballW_Cast, function Trig_EnergyballW_Cast_Actions )
endfunction

