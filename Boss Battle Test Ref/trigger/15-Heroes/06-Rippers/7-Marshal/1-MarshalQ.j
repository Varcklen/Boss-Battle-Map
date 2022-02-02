function Trig_MarshalQ_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A0EJ'
endfunction

function MarshalQCool takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local unit u = LoadUnitHandle( udg_hash, id, StringHash( "mrsq" ) )

    call BlzStartUnitAbilityCooldown( u, 'A0EJ', RMaxBJ( 0.1,BlzGetUnitAbilityCooldownRemaining(u, 'A0EJ') * 0.5) )
    call FlushChildHashtable( udg_hash, id )

    set u = null
endfunction  

function Trig_MarshalQ_Actions takes nothing returns nothing
    local unit caster
    local unit target
    local integer lvl
    local real dmg
    local real stunDuration
    local unit controller
    
    if CastLogic() then
        set caster = udg_Caster
        set target = udg_Target
        set lvl = udg_Level
    elseif RandomLogic() then
        set caster = udg_Caster
        set target = randomtarget( caster, 300, "all", "", "", "", "" )
        set lvl = udg_Level
        call textst( udg_string[0] + GetObjectName('A0EJ'), caster, 64, 90, 10, 1.5 )
        if target == null then
            set caster = null
            return
        endif
    else
        set caster = GetSpellAbilityUnit()
        set target = GetSpellTargetUnit()
        set lvl = GetUnitAbilityLevel(GetSpellAbilityUnit(), GetSpellAbilityId())
    endif
    set dmg = 50 + ( 50 * lvl )
    set stunDuration = 0.5 + (0.5*lvl)
    
    call DestroyEffect( AddSpecialEffect("Abilities\\Spells\\Orc\\WarStomp\\WarStompCaster.mdl", GetUnitX(target), GetUnitY(target) ) )
    call dummyspawn( caster, 1, 0, 0, 0 )
    call UnitDamageTarget(bj_lastCreatedUnit, target, dmg, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS)
    
    if GetUnitState( target, UNIT_STATE_LIFE) > 0.405 then
        if IsUnitType(target, UNIT_TYPE_ANCIENT ) then
            call UnitStun(caster, target, stunDuration )
        elseif not(IsUnitType(target, UNIT_TYPE_HERO )) then
            set controller = GroupPickRandomUnit(udg_heroinfo)
            call SetUnitOwner( target, GetOwningPlayer( controller ), true )
            call UnitApplyTimedLife( target, 'BTLF', 30)
            if GetUnitAbilityLevel(caster, 'A0EJ') > 0 then
                call InvokeTimerWithUnit( caster, "mrsq", 0.01, false, function MarshalQCool )
            endif
        endif
    endif
    
    set controller = null
    set caster = null
    set target = null
endfunction

//===========================================================================
function InitTrig_MarshalQ takes nothing returns nothing
    set gg_trg_MarshalQ = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_MarshalQ, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_MarshalQ, Condition( function Trig_MarshalQ_Conditions ) )
    call TriggerAddAction( gg_trg_MarshalQ, function Trig_MarshalQ_Actions )
endfunction

