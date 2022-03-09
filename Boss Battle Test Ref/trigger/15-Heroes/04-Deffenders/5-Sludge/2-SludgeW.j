function Trig_SludgeW_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A0R7' or GetSpellAbilityId() == 'A0SO'
endfunction

function Trig_SludgeW_Actions takes nothing returns nothing
    local unit caster
    local unit target
    local integer lvl
    local real dmg
    local integer d
    
    if CastLogic() then
        set caster = udg_Caster
        set target = udg_Target
        set lvl = udg_Level
    elseif RandomLogic() then
        set caster = udg_Caster
        set target = randomtarget( caster, 300, "all", "notcaster", "", "", "" )
        set lvl = udg_Level
        call textst( udg_string[0] + GetObjectName('A0R7'), caster, 64, 90, 10, 1.5 )
        if target == null then
            set caster = null
            return
        endif
    else
        set caster = GetSpellAbilityUnit()
        set target = GetSpellTargetUnit()
        if GetSpellAbilityId() == 'A0SO' then
            set lvl = LoadInteger( udg_hash, GetHandleId(caster), StringHash( "sldgw" ) )
        else
            set lvl = GetUnitAbilityLevel(GetSpellAbilityUnit(), GetSpellAbilityId())
        endif
    endif
    set dmg = 120 + ( 40 * lvl )

    call DestroyEffect( AddSpecialEffect( "Objects\\Spawnmodels\\Demon\\DemonLargeDeathExplode\\DemonLargeDeathExplode.mdl", GetUnitX(target), GetUnitY(target) ) )

    call dummyspawn( caster, 1, 0, 0, 0 )
    call UnitDamageTarget( bj_lastCreatedUnit, target, dmg, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS)
    if GetUnitState( target, UNIT_STATE_LIFE) <= 0.405 and not(udg_fightmod[3]) and udg_combatlogic[GetPlayerId(GetOwningPlayer( caster ) ) + 1 ] then
        call BlzSetUnitMaxHP( caster, R2I(BlzGetUnitMaxHP(caster)+25) )
		call BlzSetUnitBaseDamage( caster, R2I(BlzGetUnitBaseDamage(caster, 0)+1), 0 )
		set udg_Data[GetPlayerId( GetOwningPlayer( caster ) ) + 1 + 212] = udg_Data[GetPlayerId( GetOwningPlayer( caster ) ) + 1 + 212] + 25
		set udg_Data[GetPlayerId( GetOwningPlayer( caster ) ) + 1 + 216] = udg_Data[GetPlayerId( GetOwningPlayer( caster ) ) + 1 + 216] + 1
    		
		set d = udg_Data[GetPlayerId( GetOwningPlayer( caster ) ) + 1 + 216]
		if d < 20 and ( GetUnitTypeId( caster ) == 'u00X' or GetUnitTypeId( caster ) == 'H01U' ) then
			call SetUnitScale( caster, 1 + (d * 0.03), 1 + (d * 0.03), 1 + (d * 0.03) )
		endif
    endif
    
    set caster = null
    set target = null
endfunction

//===========================================================================
function InitTrig_SludgeW takes nothing returns nothing
    set gg_trg_SludgeW = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_SludgeW, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_SludgeW, Condition( function Trig_SludgeW_Conditions ) )
    call TriggerAddAction( gg_trg_SludgeW, function Trig_SludgeW_Actions )
endfunction

