function Trig_Metal_MageW_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A0KS'
endfunction

function Metal_MageWCast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer( ) )
    local real dmg = LoadReal( udg_hash, id, StringHash( "mtmw" ) )
    local unit target = LoadUnitHandle( udg_hash, id, StringHash( "mtmw" ) )
    local unit dummy = LoadUnitHandle( udg_hash, id, StringHash( "mtmw1" ) )
    
    if GetUnitState(target, UNIT_STATE_LIFE) <= 0.405 or GetUnitAbilityLevel( target, 'Beng') == 0 then
        call RemoveUnit( dummy )
        call DestroyTimer( GetExpiredTimer() )
        call FlushChildHashtable( udg_hash, id )
    elseif GetUnitState( target, UNIT_STATE_LIFE) > 0.405 then
        call UnitDamageTarget( dummy, target, dmg, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS )
    endif
    
    set target = null
    set dummy = null
endfunction

function Trig_Metal_MageW_Actions takes nothing returns nothing
    local unit dummy
    local integer id
    local real dmg
    local unit caster
    local unit target
    local integer lvl
    local real t
    
    if CastLogic() then
        set caster = udg_Caster
        set target = udg_Target
        set lvl = udg_Level
        set t = udg_Time
    elseif RandomLogic() then
        set caster = udg_Caster
        set target = randomtarget( caster, 300, "enemy", "", "", "", "" )
        set lvl = udg_Level
        call textst( udg_string[0] + GetObjectName('A0KS'), caster, 64, 90, 10, 1.5 )
        set t = lvl + 2
        if target == null then
            set caster = null
            return
        endif
    else
        set caster = GetSpellAbilityUnit()
        set target = GetSpellTargetUnit()
        set lvl = GetUnitAbilityLevel(GetSpellAbilityUnit(), GetSpellAbilityId())
        set t = lvl + 2
    endif
    set t = timebonus(caster, t)
    
    set dmg = 50 * GetUnitSpellPower(caster)

    set id = GetHandleId( target )
    set dummy = CreateUnit( GetOwningPlayer( caster ), 'u000', GetUnitX( caster ), GetUnitY( caster ), bj_UNIT_FACING )
    call DestroyEffect( AddSpecialEffect( "Dark Execution.mdx", GetUnitX(target), GetUnitY(target) ) )

    call UnitAddAbility( dummy, 'A0KZ' )
    call SetUnitAbilityLevel(dummy, 'A0KZ', lvl )
    call IssueTargetOrder( dummy, "ensnare", target )
    
     if LoadTimerHandle( udg_hash, id, StringHash( "mtmw" ) ) == null then
        call SaveTimerHandle( udg_hash, id, StringHash( "mtmw" ), CreateTimer() )
    endif
	set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "mtmw" ) ) ) 
	call SaveUnitHandle( udg_hash, id, StringHash( "mtmw" ), target )
    call SaveUnitHandle( udg_hash, id, StringHash( "mtmw1" ), dummy )
    call SaveReal( udg_hash, id, StringHash( "mtmw2" ), t )
    call SaveReal( udg_hash, id, StringHash( "mtmw" ), dmg)
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( target ), StringHash( "mtmw" ) ), 1, true, function Metal_MageWCast )
    
    if BuffLogic() then
        call debuffst( caster, target, "Trig_Metal_MageW_Actions", lvl, t )
    endif
    
    set dummy = null
    set caster = null
    set target = null
endfunction

//===========================================================================
function InitTrig_Metal_MageW takes nothing returns nothing
    set gg_trg_Metal_MageW = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Metal_MageW, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_Metal_MageW, Condition( function Trig_Metal_MageW_Conditions ) )
    call TriggerAddAction( gg_trg_Metal_MageW, function Trig_Metal_MageW_Actions )
endfunction

