function Trig_MorlocW_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A0TI'
endfunction

function Trig_MorlocW_Actions takes nothing returns nothing
    local integer lvl
    local unit caster
    local unit target
    local real heal
    local real mana
    
    if CastLogic() then
        set caster = udg_Caster
        set target = udg_Target
        set lvl = udg_Level
    elseif RandomLogic() then
        set caster = udg_Caster
        set target = randomtarget( caster, 900, "ally", "", "", "", "" )
        set lvl = udg_Level
        call textst( udg_string[0] + GetObjectName('A0TI'), caster, 64, 90, 10, 1.5 )
        if target == null then
            set caster = null
            return
        endif
    else
        set caster = GetSpellAbilityUnit()
        set target = GetSpellTargetUnit()
        set lvl = GetUnitAbilityLevel(GetSpellAbilityUnit(), GetSpellAbilityId())
    endif

	set heal = 100 + ( 100. * lvl )
	set mana = 25 + (25 * lvl )

    if target == caster then
        call healst( caster, null, heal )
    else
        call manast( caster, target, mana )
    endif
	
    call DestroyEffect( AddSpecialEffectTarget( "Objects\\Spawnmodels\\Naga\\NagaDeath\\NagaDeath.mdl", target, "origin" ) )
    
    set caster = null
    set target = null
endfunction

//===========================================================================
function InitTrig_MorlocW takes nothing returns nothing
    set gg_trg_MorlocW = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_MorlocW, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_MorlocW, Condition( function Trig_MorlocW_Conditions ) )
    call TriggerAddAction( gg_trg_MorlocW, function Trig_MorlocW_Actions )
endfunction

