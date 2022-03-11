function Trig_DogQ_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A154'
endfunction

function DogQCast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local unit u = LoadUnitHandle( udg_hash, id, StringHash( "dogq" ) )
    local integer sk = LoadInteger( udg_hash, id, StringHash( "dogq" ) )

	call BlzStartUnitAbilityCooldown( u, sk, 0.01 )
    call FlushChildHashtable( udg_hash, id )

    set u = null
endfunction

function Trig_DogQ_Actions takes nothing returns nothing
    local integer lvl
    local unit caster
    local unit target
    local real dmg
    local integer id
    local real r
    
    if CastLogic() then
        set caster = udg_Caster
        set target = udg_Target
        set lvl = udg_Level
    elseif RandomLogic() then
        set caster = udg_Caster
        set lvl = udg_Level
        set target = randomtarget( caster, 300, "all", "notcaster", "", "", "" )
        call textst( udg_string[0] + GetObjectName('A154'), caster, 64, 90, 10, 1.5 )
        if target == null then
            set caster = null
            return
        endif
    elseif GetSpellAbilityId() == 'A0TZ' then
        set caster = GetSpellAbilityUnit()
        set target = GetSpellTargetUnit()
        set lvl = LoadInteger( udg_hash, GetHandleId( GetSpellAbilityUnit() ), StringHash( "kngeq" ) )
    else
        set caster = GetSpellAbilityUnit()
        set target = GetSpellTargetUnit()
        set lvl = GetUnitAbilityLevel(GetSpellAbilityUnit(), GetSpellAbilityId())
    endif
    
    set r = (1-(GetUnitState( target, UNIT_STATE_LIFE)/RMaxBJ(0,GetUnitState( target, UNIT_STATE_MAX_LIFE))))*3
    set dmg = 50 + ( 50 * lvl )
    if r > 0 then
        set dmg = dmg + (dmg*r)
    endif
    
    call healst( caster, null, dmg )
    call dummyspawn( caster, 1, 0, 0, 0 )
    call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\Other\\Stampede\\StampedeMissileDeath.mdl", GetUnitX( target ), GetUnitY( target ) ) )
    call UnitDamageTarget( bj_lastCreatedUnit, target, dmg, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS)
     
    if not(IsUnitType( target, UNIT_TYPE_HERO) ) and not(IsUnitType( target, UNIT_TYPE_ANCIENT) ) and GetUnitState( target, UNIT_STATE_LIFE) <= GetUnitState( target, UNIT_STATE_MAX_LIFE)*0.5 then
        call DestroyEffect( AddSpecialEffect( "war3mapImported\\SoulRitual.mdx", GetUnitX( caster ), GetUnitY( caster ) ) )

        set id = GetHandleId( caster )
        if LoadTimerHandle( udg_hash, id, StringHash( "dogq" ) ) == null then
            call SaveTimerHandle( udg_hash, id, StringHash( "dogq" ), CreateTimer() )
        endif
        set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "dogq" ) ) ) 
        call SaveUnitHandle( udg_hash, id, StringHash( "dogq" ), caster )
        call SaveInteger( udg_hash, id, StringHash( "dogq" ), GetSpellAbilityId() )
        call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( caster ), StringHash( "dogq" ) ), 0.05, false, function DogQCast )
    endif
     
    set caster = null
    set target = null
endfunction

//===========================================================================
function InitTrig_DogQ takes nothing returns nothing
    set gg_trg_DogQ = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_DogQ, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_DogQ, Condition( function Trig_DogQ_Conditions ) )
    call TriggerAddAction( gg_trg_DogQ, function Trig_DogQ_Actions )
endfunction

