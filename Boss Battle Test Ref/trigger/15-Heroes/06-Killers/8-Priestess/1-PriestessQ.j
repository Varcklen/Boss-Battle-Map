function Trig_PriestessQ_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A03Q'
endfunction

function Trig_PriestessQ_Actions takes nothing returns nothing
    local integer lvl
    local unit caster
    local real sp
    local integer cyclA
    local integer cyclAEnd
    local real x
    local real y
    
    if CastLogic() then
        set caster = udg_Caster
        set lvl = udg_Level
    elseif RandomLogic() then
        set caster = udg_Caster
        set lvl = udg_Level
        call textst( udg_string[0] + GetObjectName('A03Q'), caster, 64, 90, 10, 1.5 )
    else
        set caster = GetSpellAbilityUnit()
        set lvl = GetUnitAbilityLevel(GetSpellAbilityUnit(), GetSpellAbilityId() )
    endif

    set sp = GetUnitSpellPower(caster)
    set x = GetUnitX( caster ) + 200 * Cos( 0.017 * GetUnitFacing( caster ) )
    set y = GetUnitY( caster ) + 200 * Sin( 0.017 * GetUnitFacing( caster ) )
    
    set cyclA = 1
    set cyclAEnd = lvl + 1
    loop
        exitwhen cyclA > cyclAEnd
        set bj_lastCreatedUnit = CreateUnit( GetOwningPlayer( caster ), 'n020', x, y, GetUnitFacing( caster ) )
        call UnitApplyTimedLife(bj_lastCreatedUnit, 'BTLF', 45 )
        call BlzSetUnitMaxHP( bj_lastCreatedUnit, R2I(BlzGetUnitMaxHP(bj_lastCreatedUnit)*sp) )
        call BlzSetUnitBaseDamage( bj_lastCreatedUnit, R2I(GetUnitDamage(bj_lastCreatedUnit)*sp-GetUnitAvgDiceDamage(bj_lastCreatedUnit)), 0 )
        call SetUnitState( bj_lastCreatedUnit, UNIT_STATE_LIFE, GetUnitState( bj_lastCreatedUnit, UNIT_STATE_MAX_LIFE) )
        call BlzSetUnitArmor( bj_lastCreatedUnit, BlzGetUnitArmor(bj_lastCreatedUnit)*sp )
        call SetUnitMoveSpeed( bj_lastCreatedUnit, GetUnitDefaultMoveSpeed(bj_lastCreatedUnit)*sp )
        call DestroyEffect( AddSpecialEffectTarget( "Abilities\\Spells\\Orc\\FeralSpirit\\feralspirittarget.mdl", bj_lastCreatedUnit, "origin" ) )
        set cyclA = cyclA + 1
    endloop

    set caster = null
endfunction

//===========================================================================
function InitTrig_PriestessQ takes nothing returns nothing
    set gg_trg_PriestessQ = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_PriestessQ, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_PriestessQ, Condition( function Trig_PriestessQ_Conditions ) )
    call TriggerAddAction( gg_trg_PriestessQ, function Trig_PriestessQ_Actions )
endfunction

