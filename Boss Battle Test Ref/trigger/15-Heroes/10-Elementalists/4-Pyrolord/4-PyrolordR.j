globals 
    constant real PYROLORD_R_DAMAGE = 35
    constant integer PYROLORD_R_KILL_CONDITION = 6
endglobals

function Trig_PyrolordR_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A0NM'
endfunction

function PyrolordRCast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer( ) )
    local unit dummy = LoadUnitHandle( udg_hash, id, StringHash( "prlr" ) )
    local unit target = LoadUnitHandle( udg_hash, id, StringHash( "prlrt" ) )
    local real dmg = LoadReal( udg_hash, id, StringHash( "prlr" ) )
    
    if GetUnitState( target, UNIT_STATE_LIFE) > 0.405 then
        if DistanceBetweenUnits(target, dummy) < 50 then
            call DestroyEffect( AddSpecialEffect("Abilities\\Spells\\Other\\Incinerate\\FireLordDeathExplode.mdl", GetUnitX(target), GetUnitY(target)) )
            call UnitDamageTarget(dummy, target, dmg, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS)
            call RemoveUnit( dummy )
            call FlushChildHashtable( udg_hash, id )
            call DestroyTimer( GetExpiredTimer() )
        else
            call IssuePointOrder( dummy, "move", GetUnitX( target ), GetUnitY( target ) )
        endif
    elseif GetUnitState( dummy, UNIT_STATE_LIFE) > 0.405 and GetUnitState( target, UNIT_STATE_LIFE) <= 0.405 then
        set target = randomtarget( dummy, 900, "enemy", "", "", "", "" )
        if target != null then
            call IssuePointOrderLoc( dummy, "move", GetUnitLoc( target ) )
            call SaveUnitHandle( udg_hash, id, StringHash( "prlrt" ), target )
        else
            call DestroyEffect( AddSpecialEffect("Abilities\\Spells\\Other\\Incinerate\\FireLordDeathExplode.mdl", GetUnitX(dummy), GetUnitY(dummy)) )
            call RemoveUnit( dummy )
            call FlushChildHashtable( udg_hash, id )
            call DestroyTimer( GetExpiredTimer() )
        endif
    elseif GetUnitState( dummy, UNIT_STATE_LIFE) <= 0.405 then
        call RemoveUnit( dummy )
        call FlushChildHashtable( udg_hash, id )
        call DestroyTimer( GetExpiredTimer() )
    endif
    
    set target = null
    set dummy = null
endfunction

function Trig_PyrolordR_Actions takes nothing returns nothing
    local unit caster
    local integer lvl
    local real dmg
    local integer arrows
    local integer cyclA
    local integer id
    local unit t
    local real rand
    local integer bonus
    
    if CastLogic() then
        set caster = udg_Caster
        set lvl = udg_Level
    elseif RandomLogic() then
        set caster = udg_Caster
        set lvl = udg_Level
        call textst( udg_string[0] + GetObjectName('A0NM'), caster, 64, 90, 10, 1.5 )
    else
        set caster = GetSpellAbilityUnit()
        set lvl = GetUnitAbilityLevel(GetSpellAbilityUnit(), GetSpellAbilityId())
    endif
    
    set bonus = R2I(LoadInteger( udg_hash, GetHandleId( caster ), StringHash( "killb" ))/PYROLORD_R_KILL_CONDITION)
    
    set dmg = (PyrolordExtraDamage + PYROLORD_R_DAMAGE) * udg_SpellDamage[GetPlayerId(GetOwningPlayer( caster ) ) + 1]
    set arrows = bonus + lvl + 2
    
    set cyclA = 1
    loop
        exitwhen cyclA > arrows
        set t = randomtarget( caster, 900, "enemy", "", "", "", "" )
        if t != null then
            call dummyspawn( caster, 0, 'A017', 'A0N5', 0 )
            call SetUnitMoveSpeed( bj_lastCreatedUnit, GetRandomReal( 300, 500 ) )
            set rand = GetRandomReal( 0.5, 2 )
            call SetUnitScale( bj_lastCreatedUnit, rand, rand, rand )
            
            call IssuePointOrder( bj_lastCreatedUnit, "move", GetUnitX( t ), GetUnitY( t ) )
            
            set id = GetHandleId( bj_lastCreatedUnit )
            if LoadTimerHandle( udg_hash, id, StringHash( "prlr" ) ) == null then
                call SaveTimerHandle( udg_hash, id, StringHash( "prlr" ), CreateTimer() )
            endif
            set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "prlr" ) ) ) 
            call SaveUnitHandle( udg_hash, id, StringHash( "prlr" ), bj_lastCreatedUnit )
            call SaveUnitHandle( udg_hash, id, StringHash( "prlrt" ), t )
            call SaveReal( udg_hash, id, StringHash( "prlr" ), dmg )
            call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( bj_lastCreatedUnit ), StringHash( "prlr" ) ), 0.2, true, function PyrolordRCast )
        endif
        set cyclA = cyclA + 1
    endloop
    
    set caster = null
    set t = null
endfunction

//===========================================================================
function InitTrig_PyrolordR takes nothing returns nothing
    set gg_trg_PyrolordR = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_PyrolordR, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_PyrolordR, Condition( function Trig_PyrolordR_Conditions ) )
    call TriggerAddAction( gg_trg_PyrolordR, function Trig_PyrolordR_Actions )
endfunction

