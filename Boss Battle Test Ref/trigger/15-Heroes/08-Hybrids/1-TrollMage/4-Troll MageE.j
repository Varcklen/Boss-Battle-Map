function Trig_Troll_MageE_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A150'
endfunction

function Trig_Troll_MageE_Actions takes nothing returns nothing
    local integer cyclA = 1
    local integer id
    local integer lvl
    local unit caster
    local unit u
    local integer i
    
    if CastLogic() then
        set caster = udg_Caster
        set lvl = udg_Level
    elseif RandomLogic() then
        set caster = udg_Caster
        set lvl = udg_Level
        call textst( udg_string[0] + GetObjectName('A150'), caster, 64, 90, 10, 1.5 )
    else
        set caster = GetSpellAbilityUnit()
        set lvl = GetUnitAbilityLevel(GetSpellAbilityUnit(), GetSpellAbilityId())
    endif
    
    call UnitAddAbility( caster, 'A152' )
    call DestroyEffect( AddSpecialEffectTarget("DarkSwirl.mdx", caster, "overhead" ) )
    call SaveInteger( udg_hash, GetHandleId(caster), StringHash( "trme" ), 5 )
    call SaveReal( udg_hash, GetHandleId(caster), StringHash( "trme" ), 0.3*lvl )

    set bj_lastCreatedUnit = CreateUnit( GetOwningPlayer( caster ), 'u000', GetUnitX(caster),  GetUnitY(caster), 270 )
    call UnitAddAbility( bj_lastCreatedUnit, 'A04J' )
    
    set caster = null
    set u = null
endfunction

//===========================================================================
function InitTrig_Troll_MageE takes nothing returns nothing
    set gg_trg_Troll_MageE = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Troll_MageE, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_Troll_MageE, Condition( function Trig_Troll_MageE_Conditions ) )
    call TriggerAddAction( gg_trg_Troll_MageE, function Trig_Troll_MageE_Actions )
endfunction

