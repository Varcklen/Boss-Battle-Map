function Trig_MorlocE_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A1AI'
endfunction

function Trig_MorlocE_Actions takes nothing returns nothing
    local integer lvl
    local unit caster
    local unit target = null
    local real heal
    local boolean l
    local integer k
    
    if CastLogic() then
        set caster = udg_Caster
        set lvl = udg_Level
    elseif RandomLogic() then
        set caster = udg_Caster
        set lvl = udg_Level
        call textst( udg_string[0] + GetObjectName('A1AI'), caster, 64, 90, 10, 1.5 )
    else
        set caster = GetSpellAbilityUnit()
        set lvl = GetUnitAbilityLevel(GetSpellAbilityUnit(), GetSpellAbilityId())
    endif

	set heal = 120 + ( 50 * lvl )
    
    set l = false
    set k = 0
    loop
        exitwhen l
        set target = HeroLessHP(caster)
        if target != null then
            call healst( caster, target, heal )
            call DestroyEffect( AddSpecialEffectTarget( "Objects\\Spawnmodels\\Naga\\NagaDeath\\NagaDeath.mdl", target, "origin" ) )
            if k > 20 or GetUnitState( target, UNIT_STATE_LIFE) > GetUnitState( target, UNIT_STATE_MAX_LIFE) * 0.4 then
                set l = true
            endif
        else
            set l = true
        endif
        set k = k + 1
    endloop
    
    
    set caster = null
    set target = null
endfunction

//===========================================================================
function InitTrig_MorlocE takes nothing returns nothing
    set gg_trg_MorlocE = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_MorlocE, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_MorlocE, Condition( function Trig_MorlocE_Conditions ) )
    call TriggerAddAction( gg_trg_MorlocE, function Trig_MorlocE_Actions )
endfunction

