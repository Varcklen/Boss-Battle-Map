function Trig_KillEye_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A00N' or GetSpellAbilityId() == 'A01U'
endfunction

function KillEyeCast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    call DestroyLightning( LoadLightningHandle( udg_hash, id, StringHash( "keye" ) ) )
    call FlushChildHashtable( udg_hash, id )
endfunction

function Trig_KillEye_Actions takes nothing returns nothing
    local integer cyclA = 1
    local integer cyclAEnd
    local unit caster
    local unit target
    local real dmg
    local lightning l 
    local integer id 
    
    if CastLogic() then
        set caster = udg_Caster
        set target = udg_Target
    elseif RandomLogic() then
        set caster = udg_Caster
        set target = randomtarget( caster, 900, "all", "", "", "", "" )
        call textst( udg_string[0] + GetObjectName('A00N'), caster, 64, 90, 10, 1.5 )
    else
        set caster = GetSpellAbilityUnit()
        set target = GetSpellTargetUnit()
    endif
    
    set cyclAEnd = 1
    if IsUniqueUpgraded(caster) then
        set cyclAEnd = 3*cyclAEnd
    endif

    set dmg = 100 * udg_SpellDamageSpec[GetPlayerId(GetOwningPlayer( caster )) + 1]
    
    call DestroyEffect( AddSpecialEffect( "war3mapImported\\ForkedLightningOrange.mdx", GetUnitX( target ), GetUnitY( target ) ) )
    set l = AddLightningEx("AFOD", true, GetUnitX(caster), GetUnitY(caster), GetUnitFlyHeight(caster) + 50, GetUnitX(target), GetUnitY(target), GetUnitFlyHeight(target) + 50 )
    set id = GetHandleId( l )
    call SaveTimerHandle( udg_hash, id, StringHash( "keye" ), CreateTimer() )
	set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "keye" ) ) ) 
	call SaveLightningHandle( udg_hash, id, StringHash( "keye" ), l )
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( l ), StringHash( "keye" ) ), 0.5, false, function KillEyeCast )
    
    call dummyspawn( caster, 1, 0, 0, 0 )
    call UnitDamageTarget( bj_lastCreatedUnit, target, dmg, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS)
    if GetUnitStatePercent( target, UNIT_STATE_LIFE, UNIT_STATE_MAX_LIFE) <= 50 then
        loop
            exitwhen cyclA > cyclAEnd
            set bj_lastCreatedUnit = CreateUnit( GetOwningPlayer( caster ), udg_Database_RandomUnit[GetRandomInt(1, udg_Database_NumberItems[5])], GetUnitX( target ) + GetRandomReal(-200, 200), GetUnitY( target ) + GetRandomReal(-200, 200), GetRandomReal( 0, 360 ) )
            call UnitApplyTimedLife(bj_lastCreatedUnit, 'BTLF', 15)
            call DestroyEffect( AddSpecialEffectTarget( "Abilities\\Spells\\Orc\\FeralSpirit\\feralspirittarget.mdl", bj_lastCreatedUnit, "origin" ) )
            set cyclA = cyclA + 1
        endloop
    endif
    
    set caster = null
    set target = null
    set l = null
endfunction

//===========================================================================
function InitTrig_KillEye takes nothing returns nothing
    set gg_trg_KillEye = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_KillEye, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_KillEye, Condition( function Trig_KillEye_Conditions ) )
    call TriggerAddAction( gg_trg_KillEye, function Trig_KillEye_Actions )
endfunction

