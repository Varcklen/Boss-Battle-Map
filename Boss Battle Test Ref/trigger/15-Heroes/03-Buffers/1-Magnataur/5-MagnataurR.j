function Trig_MagnataurR_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A0WJ'
endfunction

function Trig_MagnataurR_Actions takes nothing returns nothing
    local group g = CreateGroup()
    local unit u
    local integer lvl
    local unit caster
    local real dur
    
    if CastLogic() then
        set caster = udg_Caster
        set lvl = udg_Level
    elseif RandomLogic() then
        set caster = udg_Caster
        set lvl = udg_Level
        call textst( udg_string[0] + GetObjectName('A0WJ'), caster, 64, 90, 10, 1.5 )
    else
        set caster = GetSpellAbilityUnit()
        set lvl = GetUnitAbilityLevel(GetSpellAbilityUnit(), GetSpellAbilityId())
    endif
    
    set dur = 1.5 + (0.5*lvl)
    call DestroyEffect( AddSpecialEffectTarget( "Abilities\\Spells\\Human\\Thunderclap\\ThunderClapCaster.mdl", caster, "origin" ) )
    call GroupEnumUnitsInRange( g, GetUnitX(caster), GetUnitY(caster), 400, null )
    loop
        set u = FirstOfGroup(g)
        exitwhen u == null
        if unitst( u, caster, "enemy" ) then
            call UnitStun(caster, u, dur )
        endif
        call GroupRemoveUnit(g,u)
        set u = FirstOfGroup(g)
    endloop

    call GroupClear( g )
    call DestroyGroup( g )
    set u = null
    set caster = null
endfunction

//===========================================================================
function InitTrig_MagnataurR takes nothing returns nothing
    set gg_trg_MagnataurR = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_MagnataurR, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_MagnataurR, Condition( function Trig_MagnataurR_Conditions ) )
    call TriggerAddAction( gg_trg_MagnataurR, function Trig_MagnataurR_Actions )
endfunction

