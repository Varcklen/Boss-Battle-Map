function Trig_NinjaQ_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A0KC' and combat( GetSpellAbilityUnit(), true, GetSpellAbilityId() )
endfunction

function NinjaQCast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer( ) )
    local unit caster = LoadUnitHandle( udg_hash, id, StringHash( "ninq" ) )
    local unit target = LoadUnitHandle( udg_hash, id, StringHash( "ninqt" ) )
    local integer sp = LoadInteger( udg_hash, id, StringHash( "ninq" ) )
    local real dmg = LoadReal( udg_hash, id, StringHash( "ninq" ) )
    local real x = LoadReal( udg_hash, id, StringHash( "ninqx" ) )
    local real y = LoadReal( udg_hash, id, StringHash( "ninqy" ) )
    local real mana = LoadReal( udg_hash, id, StringHash( "ninqmana" ) )
    
    if RectContainsCoords(udg_Boss_Rect, x, y) then
        call SetUnitPosition( caster, x, y )
    endif
    call SetUnitFacing( caster, bj_RADTODEG * Atan2(GetUnitY(target) - GetUnitY(caster), GetUnitX(target) - GetUnitX(caster) ) )
    call DestroyEffect( AddSpecialEffect("Objects\\Spawnmodels\\Human\\HumanLargeDeathExplode\\HumanLargeDeathExplode.mdl", GetUnitX(target), GetUnitY(target) ) )
    call DestroyEffect( AddSpecialEffect("Abilities\\Spells\\Human\\FlakCannons\\FlakTarget.mdl", GetUnitX(caster), GetUnitY(caster) ) )

    call dummyspawn( caster, 1, 'A0N5', 0, 0 )
    call UnitDamageTarget( bj_lastCreatedUnit, target, dmg, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS )

    if sp == 'A0KC' and ( GetUnitState( target, UNIT_STATE_LIFE) <= 0.405 or udg_DamageEventType == udg_DamageTypeCriticalStrike ) then
        call BlzEndUnitAbilityCooldown( caster, sp )
        call SetUnitState( caster, UNIT_STATE_MANA, GetUnitState( caster, UNIT_STATE_MANA ) + mana )
    endif

    call FlushChildHashtable( udg_hash, id )
    
    set caster = null
    set target = null
endfunction

function Trig_NinjaQ_Actions takes nothing returns nothing
    local integer id
    local real dmg
    local unit caster
    local unit target
    local integer lvl
    local real x
    local real y
    local real mana = 0

    if CastLogic() then
        set caster = udg_Caster
        set target = udg_Target
	set lvl = udg_Level
    elseif RandomLogic() then
        set caster = udg_Caster
        set target = randomtarget( caster, 900, "enemy", "", "", "", "" )
        call textst( udg_string[0] + GetObjectName('A0KC'), caster, 64, 90, 10, 1.5 )
	set lvl = udg_Level
        if target == null then
            set caster = null
            return
        endif
    else
        set caster = GetSpellAbilityUnit()
        set target = GetSpellTargetUnit()
        set lvl = GetUnitAbilityLevel(GetSpellAbilityUnit(), GetSpellAbilityId())
    endif
    
    set x = GetUnitX( target ) - 200 * Cos( 0.017 * GetUnitFacing( target ) )
    set y = GetUnitY( target ) - 200 * Sin( 0.017 * GetUnitFacing( target ) )
    if GetSpellAbilityId() == 'A0KC' then
        set mana = BlzGetAbilityManaCost( GetSpellAbilityId(), lvl-1 )
    endif

    call DestroyEffect( AddSpecialEffect("Abilities\\Spells\\Human\\FlakCannons\\FlakTarget.mdl", GetUnitX(caster), GetUnitY(caster) ) )

    set id = GetHandleId( caster )
    set dmg = (60 + ( 40 * lvl ) )* udg_SpellDamage[GetPlayerId(GetOwningPlayer( caster ) ) + 1]

    call SaveTimerHandle( udg_hash, id, StringHash( "ninq" ), CreateTimer() )
	set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "ninq" ) ) ) 
	call SaveUnitHandle( udg_hash, id, StringHash( "ninq" ), caster )
	call SaveUnitHandle( udg_hash, id, StringHash( "ninqt" ), target )
	call SaveInteger( udg_hash, id, StringHash( "ninq" ), GetSpellAbilityId() )
	call SaveReal( udg_hash, id, StringHash( "ninq" ), dmg )
	call SaveReal( udg_hash, id, StringHash( "ninqx" ), x )
    call SaveReal( udg_hash, id, StringHash( "ninqy" ), y )
    call SaveReal( udg_hash, id, StringHash( "ninqmana" ), mana )
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( caster ), StringHash( "ninq" ) ), 0.01, false, function NinjaQCast )

    set caster = null
    set target = null
endfunction

//===========================================================================
function InitTrig_NinjaQ takes nothing returns nothing
    set gg_trg_NinjaQ = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_NinjaQ, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_NinjaQ, Condition( function Trig_NinjaQ_Conditions ) )
    call TriggerAddAction( gg_trg_NinjaQ, function Trig_NinjaQ_Actions )
endfunction

