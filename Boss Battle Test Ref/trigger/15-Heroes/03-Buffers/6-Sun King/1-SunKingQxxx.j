function Trig_SunKingQxxx_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A01H'
endfunction

function SunKingQCast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local integer counter = LoadInteger( udg_hash, id, StringHash( "snkq" ) )
    local unit dummy = LoadUnitHandle( udg_hash, id, StringHash( "snkqd" ) )
    local unit caster = LoadUnitHandle( udg_hash, id, StringHash( "snkq" ) )
    local group g = CreateGroup()
    local unit u
    local real dmg = LoadReal( udg_hash, id, StringHash( "snkq" ) )
    local real x = LoadReal( udg_hash, id, StringHash( "snkqx" ) )
    local real y = LoadReal( udg_hash, id, StringHash( "snkqy" ) )
    local real heal = 0
    local unit target = null
    local integer cyclA
    
    call GroupEnumUnitsInRange( g, x, y, 250, null )
    loop
        set u = FirstOfGroup(g)
        exitwhen u == null
        if unitst( u, dummy, "enemy" ) then
            call DestroyEffect( AddSpecialEffectTarget( "Abilities\\Spells\\NightElf\\Immolation\\ImmolationDamage.mdl", u, "overhead" ) )
            call UnitDamageTarget( dummy, u, dmg, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS )
            set heal = heal + dmg
        endif
        call GroupRemoveUnit(g,u)
        set u = FirstOfGroup(g)
    endloop
    
    if heal > 0 then
        set cyclA = 1
        loop
            exitwhen cyclA > 4
            if inv(udg_hero[cyclA], 'I09N') == 0 and IsUnitAlly(udg_hero[cyclA], GetOwningPlayer(caster)) and GetUnitState(udg_hero[cyclA], UNIT_STATE_LIFE) > 0.405 and ( RMinBJ(GetUnitLifePercent(udg_hero[cyclA]), GetUnitLifePercent(udg_hero[cyclA - 3])) == GetUnitLifePercent(udg_hero[cyclA]) or GetUnitState(udg_hero[cyclA - 3], UNIT_STATE_LIFE) <= 0.405 ) and ( RMinBJ(GetUnitLifePercent(udg_hero[cyclA]), GetUnitLifePercent(udg_hero[cyclA - 1])) == GetUnitLifePercent(udg_hero[cyclA]) or GetUnitState(udg_hero[cyclA - 1], UNIT_STATE_LIFE) <= 0.405 ) and ( RMinBJ(GetUnitLifePercent(udg_hero[cyclA]), GetUnitLifePercent(udg_hero[cyclA - 2])) == GetUnitLifePercent(udg_hero[cyclA]) or GetUnitState(udg_hero[cyclA - 2], UNIT_STATE_LIFE) <= 0.405 ) then
                set target = udg_hero[cyclA]
            endif
            set cyclA = cyclA + 1
        endloop
        if target != null then
            call healst( caster, target, heal )
        endif
    endif
    
    if counter > 0 and GetUnitState( dummy, UNIT_STATE_LIFE) > 0.405 then
        call SaveInteger( udg_hash, id, StringHash( "snkq" ), counter - 1 )
    else
        call RemoveUnit( dummy )
        call FlushChildHashtable( udg_hash, id )
        call DestroyTimer( GetExpiredTimer() )
    endif
    
    call GroupClear( g )
    call DestroyGroup( g )
    set g = null
    set u = null
    set target = null
    set dummy = null
    set caster = null
endfunction

function Trig_SunKingQxxx_Actions takes nothing returns nothing
    local unit dummy
    local integer id 
    local unit caster
    local integer lvl
    local real x
    local real y
    local real dmg
    
    if CastLogic() then
        set caster = udg_Caster
        set lvl = udg_Level
        set x = GetSpellTargetX()
        set y = GetSpellTargetY()
    elseif RandomLogic() then
        set caster = udg_Caster
        set lvl = udg_Level
        set x = GetUnitX( caster ) + GetRandomReal( -650, 650 )
        set y = GetUnitY( caster ) + GetRandomReal( -650, 650 )
        call textst( udg_string[0] + GetObjectName('A01H'), caster, 64, 90, 10, 1.5 )
    else
        set caster = GetSpellAbilityUnit()
        set lvl = GetUnitAbilityLevel(GetSpellAbilityUnit(), GetSpellAbilityId())
        set x = GetSpellTargetX()
        set y = GetSpellTargetY()
    endif

    set dmg = (BlzGetUnitBaseDamage(caster, 0)*(0.2+(0.1*lvl))) * udg_SpellDamage[GetPlayerId(GetOwningPlayer(caster)) + 1]
    
    set bj_lastCreatedUnit = CreateUnit( GetOwningPlayer( caster ), 'u000', x, y, bj_UNIT_FACING )
    call DestroyEffect( AddSpecialEffect( "Objects\\Spawnmodels\\NightElf\\NECancelDeath\\NECancelDeath.mdl", GetUnitX( bj_lastCreatedUnit ), GetUnitY( bj_lastCreatedUnit ) ) )
    call UnitAddAbility( bj_lastCreatedUnit, 'A01J' )
     
    set id = GetHandleId( bj_lastCreatedUnit ) 
    call SaveTimerHandle( udg_hash, id, StringHash( "snkq" ), CreateTimer() )
	set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "snkq" ) ) ) 
	call SaveUnitHandle( udg_hash, id, StringHash( "snkq" ), caster )
    call SaveUnitHandle( udg_hash, id, StringHash( "snkqd" ), bj_lastCreatedUnit )
    call SaveInteger( udg_hash, id, StringHash( "snkq" ), 15 )
    call SaveReal( udg_hash, id, StringHash( "snkq" ), dmg )
    call SaveReal( udg_hash, id, StringHash( "snkqx" ), x )
    call SaveReal( udg_hash, id, StringHash( "snkqy" ), y )
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( bj_lastCreatedUnit ), StringHash( "snkq" ) ), 1, true, function SunKingQCast )
    
    set caster = null
endfunction

//===========================================================================
function InitTrig_SunKingQxxx takes nothing returns nothing
    set gg_trg_SunKingQxxx = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_SunKingQxxx, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_SunKingQxxx, Condition( function Trig_SunKingQxxx_Conditions ) )
    call TriggerAddAction( gg_trg_SunKingQxxx, function Trig_SunKingQxxx_Actions )
endfunction

