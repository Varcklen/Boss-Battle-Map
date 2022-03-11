function Trig_GamblerW_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A0YW' and ( combat( GetSpellAbilityUnit(), true, GetSpellAbilityId() ) ) and not( udg_fightmod[3] )
endfunction

function GamblerWCast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local unit caster = LoadUnitHandle( udg_hash, id, StringHash( "gmbwc" ) )
    local unit u = LoadUnitHandle( udg_hash, id, StringHash( "gmbw" ) )
    
	if GetUnitState( u, UNIT_STATE_LIFE) <= 0.405 then
		call RemoveUnit( u )
		call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\Orc\\FeralSpirit\\feralspirittarget.mdl", GetUnitX( u ), GetUnitY( u ) ) )
		if CountLivingPlayerUnitsOfTypeId('u01G', GetOwningPlayer(caster)) == 0 then
			call UnitRemoveAbility( caster, 'A103' )
			call UnitRemoveAbility( caster, 'B06Q' )
		endif
		call FlushChildHashtable( udg_hash, id )
		call DestroyTimer( GetExpiredTimer() )
	endif
	
    set caster = null
    set u = null
endfunction 

function Trig_GamblerW_Actions takes nothing returns nothing
    local integer lvl
    local unit caster
	local integer id
    
    if CastLogic() then
        set caster = udg_Caster
        set lvl = udg_Level
    elseif RandomLogic() then
        set caster = udg_Caster
        set lvl = udg_Level
        call textst( udg_string[0] + GetObjectName('A0YW'), caster, 64, 90, 10, 1.5 )
    else
        set caster = GetSpellAbilityUnit()
        set lvl = GetUnitAbilityLevel(GetSpellAbilityUnit(), GetSpellAbilityId() )
    endif

	call RemoveUnit( LoadUnitHandle( udg_hash, GetHandleId( caster ), StringHash( "gmbwi" ) ) )
	
	set bj_lastCreatedUnit = CreateUnit( GetOwningPlayer( caster ), 'u01G', GetUnitX( caster ) + GetRandomReal( -200, 200 ), GetUnitY( caster ) + GetRandomReal( -200, 200 ), GetUnitFacing( caster ) )
    call SaveUnitHandle( udg_hash, GetHandleId( caster ), StringHash( "gmbwi" ), bj_lastCreatedUnit )
	call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\Orc\\FeralSpirit\\feralspirittarget.mdl", GetUnitX( bj_lastCreatedUnit ), GetUnitY( bj_lastCreatedUnit ) ) )
    call SetUnitVertexColor( bj_lastCreatedUnit, 255, 255, 255, 200 )
    call BlzSetUnitMaxHP( bj_lastCreatedUnit, R2I(BlzGetUnitMaxHP(caster) ) )
    call BlzSetUnitMaxMana( bj_lastCreatedUnit, R2I(BlzGetUnitMaxMana(caster)) )
    call BlzSetUnitArmor( bj_lastCreatedUnit, R2I(BlzGetUnitArmor(caster)) )
    call BlzSetUnitBaseDamage( bj_lastCreatedUnit, R2I(BlzGetUnitBaseDamage(caster, 0) ), 0 )
	call SetUnitState( bj_lastCreatedUnit, UNIT_STATE_LIFE, GetUnitState( caster, UNIT_STATE_LIFE) )
	call SetUnitState( bj_lastCreatedUnit, UNIT_STATE_MANA, GetUnitState( caster, UNIT_STATE_MANA) )
    call UnitAddAbility( bj_lastCreatedUnit, udg_Ability_Uniq[GetPlayerId(GetOwningPlayer(caster)) + 1] )
    
    if GetUnitAbilityLevel( caster, 'A11U' ) > 0  then
        call UnitAddAbility( bj_lastCreatedUnit, 'A0YG' )
    endif

    if GetUnitAbilityLevel( caster, 'A10M' ) > 0  then
        call UnitAddAbility( bj_lastCreatedUnit, 'A11T' )
        call SaveInteger( udg_hash, GetHandleId( bj_lastCreatedUnit ), StringHash( "gmbwe" ), GetUnitAbilityLevel(caster, 'A10M') )
    endif
    
	call UnitAddAbility( caster, 'A103' )
    call SetUnitAbilityLevel( caster, 'A0ZD', lvl )
    call SetUnitAbilityLevel( caster, 'A0ZG', lvl )
	call UnitApplyTimedLife( bj_lastCreatedUnit , 'BTLF', 25 )
       
    set id = GetHandleId(bj_lastCreatedUnit)
    
    if LoadTimerHandle( udg_hash, id, StringHash( "gmbw" ) ) == null then 
        call SaveTimerHandle( udg_hash, id, StringHash( "gmbw" ), CreateTimer() )
    endif
	set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "gmbw" ) ) ) 
	call SaveUnitHandle( udg_hash, id, StringHash( "gmbw" ), bj_lastCreatedUnit )
    call SaveUnitHandle( udg_hash, id, StringHash( "gmbwc" ), caster )
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( bj_lastCreatedUnit ), StringHash( "gmbw" ) ), 1, true, function GamblerWCast )

	set caster = null
endfunction

//===========================================================================
function InitTrig_GamblerW takes nothing returns nothing
    set gg_trg_GamblerW = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_GamblerW, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_GamblerW, Condition( function Trig_GamblerW_Conditions ) )
    call TriggerAddAction( gg_trg_GamblerW, function Trig_GamblerW_Actions )
endfunction

