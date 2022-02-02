function Trig_NerubQ_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A07I'
endfunction

function NerubQCast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer( ) )
    call UnitRemoveAbility( LoadUnitHandle( udg_hash, id, StringHash( "konq" ) ), 'A0D5' )
    call UnitRemoveAbility( LoadUnitHandle( udg_hash, id, StringHash( "konq" ) ), 'B023' )
    call FlushChildHashtable( udg_hash, id )
endfunction

function Trig_NerubQ_Actions takes nothing returns nothing
    local integer id 
    local unit caster
    local unit target
    local integer lvl
    local real dmg
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
        set t = 8
        call textst( udg_string[0] + GetObjectName('A07I'), caster, 64, 90, 10, 1.5 )
        if target == null then
            set caster = null
            return
        endif
    else
        set caster = GetSpellAbilityUnit()
        set target = GetSpellTargetUnit()
        set lvl = GetUnitAbilityLevel(GetSpellAbilityUnit(), GetSpellAbilityId())
        set t = 8
    endif
    set t = timebonus(caster, t)
    set id = GetHandleId( caster )
    set dmg = GetUnitState( caster, UNIT_STATE_MAX_LIFE) * ( 0.03 + ( 0.03 * lvl ) )
    
    if not( udg_BuffLogic ) then
        if udg_Database_Hero[12] == 'N02Z' then
            call DestroyEffect( AddSpecialEffectTarget("Magmaeruption.mdx", target, "origin") )
        else
            call DestroyEffect( AddSpecialEffectTarget("Abilities\\Spells\\Orc\\MirrorImage\\MirrorImageDeathCaster.mdl", target, "chest") )
        endif
        call dummyspawn( caster, 1, 0, 0, 0 )
        call UnitDamageTarget( bj_lastCreatedUnit, target, dmg, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS)
    endif
    
    call UnitAddAbility( caster, 'A0D5' )
    if LoadTimerHandle( udg_hash, id, StringHash( "konq" ) ) == null then
        call SaveTimerHandle( udg_hash, id, StringHash( "konq" ), CreateTimer() )
    endif
	set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "konq" ) ) ) 
	call SaveUnitHandle( udg_hash, id, StringHash( "konq" ), caster )
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( caster ), StringHash( "konq" ) ), t, false, function NerubQCast )
    
    if BuffLogic() then
        call effst( caster, caster, "Trig_NerubQ_Actions", lvl, t )
    endif
    
    set caster = null
    set target = null
endfunction

//===========================================================================
function InitTrig_NerubQ takes nothing returns nothing
    set gg_trg_NerubQ = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_NerubQ, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_NerubQ, Condition( function Trig_NerubQ_Conditions ) )
    call TriggerAddAction( gg_trg_NerubQ, function Trig_NerubQ_Actions )
endfunction

