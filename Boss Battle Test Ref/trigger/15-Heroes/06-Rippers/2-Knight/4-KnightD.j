function Trig_KnightD_Conditions takes nothing returns boolean
    return GetUnitAbilityLevel(GetDyingUnit(), 'A05M') > 0 and udg_combatlogic[GetPlayerId(GetOwningPlayer(GetDyingUnit())) + 1]
endfunction

function KnightDCast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local unit u = LoadUnitHandle( udg_hash, id, StringHash( "knge" ))
    local unit caster = LoadUnitHandle( udg_hash, id, StringHash( "kngec" ))
    
    if GetUnitState( caster, UNIT_STATE_LIFE) > 0.405 or GetUnitState( u, UNIT_STATE_LIFE) <= 0.405 then
        call RemoveSavedInteger( udg_hash, GetHandleId( u ), StringHash( "kngeq" ) )
        call RemoveSavedInteger( udg_hash, GetHandleId( u ), StringHash( "kngew" ) )
        call RemoveSavedInteger( udg_hash, GetHandleId( u ), StringHash( "kngee" ) )
        call RemoveSavedInteger( udg_hash, GetHandleId( u ), StringHash( "knger" ) )
        call spectime("Objects\\Spawnmodels\\Undead\\UndeadDissipate\\UndeadDissipate.mdx", GetUnitX( u ), GetUnitY( u ), 5 )
        call RemoveUnit( u )
        call DestroyTimer( GetExpiredTimer() )
        call FlushChildHashtable( udg_hash, id )
    endif

    set u = null
    set caster = null
endfunction

function Trig_KnightD_Actions takes nothing returns nothing
    local integer id
	local real c = 0.25+(GetUnitAbilityLevel(GetDyingUnit(), 'A05M') * 0.15)
    
    set bj_lastCreatedUnit = CreateUnit( GetOwningPlayer( GetDyingUnit() ), 'u001', GetUnitX( GetDyingUnit() ), GetUnitY( GetDyingUnit() ), GetUnitFacing( GetDyingUnit() ) )
    call spectime("Objects\\Spawnmodels\\Undead\\UndeadDissipate\\UndeadDissipate.mdx", GetUnitX( bj_lastCreatedUnit ), GetUnitY( bj_lastCreatedUnit ), 5 )
    call SetUnitVertexColor( bj_lastCreatedUnit, 255, 255, 255, 127 )
    call BlzSetUnitMaxHP( bj_lastCreatedUnit, R2I(BlzGetUnitMaxHP(GetDyingUnit()) * c) )
    call BlzSetUnitMaxMana( bj_lastCreatedUnit, R2I(BlzGetUnitMaxMana(GetDyingUnit()) * c) )
    call BlzSetUnitArmor( bj_lastCreatedUnit, R2I(BlzGetUnitArmor(GetDyingUnit())) )
    call BlzSetUnitBaseDamage( bj_lastCreatedUnit, R2I(BlzGetUnitBaseDamage(GetDyingUnit(), 0)), 0 )
    call SetUnitState( bj_lastCreatedUnit, UNIT_STATE_LIFE, GetUnitState( bj_lastCreatedUnit, UNIT_STATE_MAX_LIFE) )
    call SetUnitState( bj_lastCreatedUnit, UNIT_STATE_MANA, GetUnitState( bj_lastCreatedUnit, UNIT_STATE_MAX_MANA) )
    call UnitAddAbility( bj_lastCreatedUnit, udg_Ability_Uniq[GetPlayerId(GetOwningPlayer(GetDyingUnit())) + 1] )
    
    call UnitAddAbility( bj_lastCreatedUnit, 'A133' )
    call SaveInteger( udg_hash, GetHandleId( bj_lastCreatedUnit ), StringHash( "kngee" ), GetUnitAbilityLevel(GetDyingUnit(), 'A05M') )
    
    if GetUnitAbilityLevel( GetDyingUnit(), 'A05T' ) > 0  then
        call UnitAddAbility( bj_lastCreatedUnit, 'A05V' )
        call SaveInteger( udg_hash, GetHandleId( bj_lastCreatedUnit ), StringHash( "kngew" ), GetUnitAbilityLevel(GetDyingUnit(), 'A05T') )
    endif
    
    if GetUnitAbilityLevel( GetDyingUnit(), 'A05N' ) > 0  then
        call UnitAddAbility( bj_lastCreatedUnit, 'A0TZ' )
        call SaveInteger( udg_hash, GetHandleId( bj_lastCreatedUnit ), StringHash( "kngeq" ), GetUnitAbilityLevel(GetDyingUnit(), 'A05N') )
    endif
    
    if GetUnitAbilityLevel( GetDyingUnit(), 'A131' ) > 0 then
        call UnitAddAbility( bj_lastCreatedUnit, 'A134' )
        call SaveInteger( udg_hash, GetHandleId( bj_lastCreatedUnit ), StringHash( "knger" ), GetUnitAbilityLevel(GetDyingUnit(), 'A131') )
    endif
    
    call SelectUnitForPlayerSingle( bj_lastCreatedUnit, GetOwningPlayer(bj_lastCreatedUnit) )
    
    set id = GetHandleId(bj_lastCreatedUnit)
    
    if LoadTimerHandle( udg_hash, id, StringHash( "knge" ) ) == null then 
        call SaveTimerHandle( udg_hash, id, StringHash( "knge" ), CreateTimer() )
    endif
	set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "knge" ) ) ) 
	call SaveUnitHandle( udg_hash, id, StringHash( "knge" ), bj_lastCreatedUnit )
    call SaveUnitHandle( udg_hash, id, StringHash( "kngec" ), GetDyingUnit() )
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( bj_lastCreatedUnit ), StringHash( "knge" ) ), 1, true, function KnightDCast )
endfunction

//===========================================================================
function InitTrig_KnightD takes nothing returns nothing
    set gg_trg_KnightD = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_KnightD, EVENT_PLAYER_UNIT_DEATH )
    call TriggerAddCondition( gg_trg_KnightD, Condition( function Trig_KnightD_Conditions ) )
    call TriggerAddAction( gg_trg_KnightD, function Trig_KnightD_Actions )
endfunction

