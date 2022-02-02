function Trig_Stabilization_Cast_Conditions takes nothing returns boolean
    return GetUnitAbilityLevel(GetSpellAbilityUnit(), 'A0GS') > 0 and GetSpellAbilityId() != 'A0GR' 
endfunction

function StabilizationEnd takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer( ) )
    local unit caster = LoadUnitHandle( udg_hash, id, StringHash( "stblst" ) )
	local integer cost = LoadInteger( udg_hash, id, StringHash( "stblst" ) )
	local integer spell = LoadInteger( udg_hash, id, StringHash( "stblstsp" ) )
	local integer lvl = LoadInteger( udg_hash, id, StringHash( "stblstlvl" ) )
    
    if spell != 0 and GetUnitAbilityLevel(caster, spell) > 0 then
        call BlzSetUnitAbilityManaCost( caster, spell, lvl, cost )
    endif

    call FlushChildHashtable( udg_hash, id )
    
    set caster = null
endfunction

function Trig_Stabilization_Cast_Actions takes nothing returns nothing
    local unit caster = GetSpellAbilityUnit()
	local integer id = GetHandleId( caster )
	local integer spell = GetSpellAbilityId()
	local integer lvl = GetUnitAbilityLevel(caster, spell ) - 1
    local integer cost = BlzGetAbilityManaCost( spell, lvl )

    call UnitRemoveAbility(caster, 'A0GS')

	call BlzSetUnitAbilityManaCost( caster, spell, lvl, 0 )
    call DestroyEffect( AddSpecialEffectTarget( "Abilities\\Spells\\Items\\AIma\\AImaTarget.mdl", caster, "origin" ) )

    set id = InvokeTimerWithUnit( caster, "stblst", 0.01, false, function StabilizationEnd )
    call SaveInteger( udg_hash, id, StringHash( "stblst" ), cost )
    call SaveInteger( udg_hash, id, StringHash( "stblstlvl" ), lvl )
    call SaveInteger( udg_hash, id, StringHash( "stblstsp" ), spell )

    set caster = null
endfunction

//===========================================================================
function InitTrig_Stabilization_Cast takes nothing returns nothing
    set gg_trg_Stabilization_Cast = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Stabilization_Cast, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_Stabilization_Cast, Condition( function Trig_Stabilization_Cast_Conditions ) )
    call TriggerAddAction( gg_trg_Stabilization_Cast, function Trig_Stabilization_Cast_Actions )
endfunction
