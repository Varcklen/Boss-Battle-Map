function Trig_SuperLuch_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A02K'
endfunction

function SuperLuchCast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    call DestroyLightning( LoadLightningHandle( udg_hash, id, StringHash( "sprl" ) ) )
    call FlushChildHashtable( udg_hash, id )
endfunction

function Trig_SuperLuch_Actions takes nothing returns nothing
    local unit caster
    local unit target
    local lightning l 
    local integer id 
    
    set l = null
    
    if CastLogic() then
        set caster = udg_Caster
        set target = udg_Target
    elseif RandomLogic() then
        set caster = udg_Caster
        set target = randomtarget( caster, 900, "enemy", "", "", "", "" )
        call textst( udg_string[0] + GetObjectName('A02K'), caster, 64, 90, 10, 1.5 )
        if target == null then
            set caster = null
            return
        endif
    else
        set caster = GetSpellAbilityUnit()
        set target = GetSpellTargetUnit()
    endif
    
    call DestroyEffect( AddSpecialEffect( "war3mapImported\\ForkedLightningOrange.mdx", GetUnitX( target ), GetUnitY( target ) ) )
    set l = AddLightningEx("AFOD", true, GetUnitX(caster), GetUnitY(caster), GetUnitFlyHeight(caster) + 50, GetUnitX(target), GetUnitY(target), GetUnitFlyHeight(target) + 50 )
    set id = GetHandleId( l )
    call SaveTimerHandle( udg_hash, id, StringHash( "sprl" ), CreateTimer() )
	set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "sprl" ) ) ) 
	call SaveLightningHandle( udg_hash, id, StringHash( "sprl" ), l )
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( l ), StringHash( "sprl" ) ), 0.5, false, function SuperLuchCast )
    
    call dummyspawn( caster, 1, 0, 0, 0 )
    call UnitDamageTarget( bj_lastCreatedUnit, target, 200, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS)
    
    set caster = null
    set target = null
    set l = null
endfunction

//===========================================================================
function InitTrig_SuperLuch takes nothing returns nothing
    set gg_trg_SuperLuch = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_SuperLuch, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_SuperLuch, Condition( function Trig_SuperLuch_Conditions ) )
    call TriggerAddAction( gg_trg_SuperLuch, function Trig_SuperLuch_Actions )
endfunction

