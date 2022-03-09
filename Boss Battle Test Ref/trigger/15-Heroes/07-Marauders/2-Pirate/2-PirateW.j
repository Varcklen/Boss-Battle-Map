function Trig_PirateW_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A03E'
endfunction

function PirateWCast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    call UnitRemoveAbility( LoadUnitHandle( udg_hash, id, StringHash( "prtw" ) ), 'A0QG' )
    call FlushChildHashtable( udg_hash, id )
endfunction

function Trig_PirateW_Actions takes nothing returns nothing
    local unit caster
    local unit target
    local integer lvl
    local integer id
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
	set t = udg_Time
        call textst( udg_string[0] + GetObjectName('A03E'), caster, 64, 90, 10, 1.5 )
        if target == null then
            set caster = null
            return
        endif
    else
        set caster = GetSpellAbilityUnit()
        set target = GetSpellTargetUnit()
        set lvl = GetUnitAbilityLevel(GetSpellAbilityUnit(), GetSpellAbilityId())
	set t = 4
    endif
    set t = timebonus(caster, t)
    set dmg = 100 + ( 50 * lvl )
    set id = GetHandleId( caster )

    call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\Orc\\MirrorImage\\MirrorImageDeathCaster.mdl", GetUnitX( caster ), GetUnitY( caster ) ) )
    call dummyspawn( caster, 1, 0, 0, 0 )
    call UnitDamageTarget( bj_lastCreatedUnit, target, dmg, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS)
    
    call shadowst( caster )
    call UnitAddAbility( caster, 'A0QG' )
    if LoadTimerHandle( udg_hash, id, StringHash( "prtw" ) ) == null then 
        call SaveTimerHandle( udg_hash, id, StringHash( "prtw" ), CreateTimer() )
    endif
	set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "prtw" ) ) ) 
	call SaveUnitHandle( udg_hash, id, StringHash( "prtw" ), caster )
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( caster ), StringHash( "prtw" ) ), t, false, function PirateWCast )
    
    set caster = null
    set target = null
endfunction

//===========================================================================
function InitTrig_PirateW takes nothing returns nothing
    set gg_trg_PirateW = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_PirateW, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_PirateW, Condition( function Trig_PirateW_Conditions ) )
    call TriggerAddAction( gg_trg_PirateW, function Trig_PirateW_Actions )
endfunction

