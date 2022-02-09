function Trig_MephistarW_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A14P'
endfunction

function Trig_MephistarW_Actions takes nothing returns nothing
    local integer lvl
    local unit caster
    local real sp
    local unit oldpet
    
    if CastLogic() then
        set caster = udg_Caster
        set lvl = udg_Level
    elseif RandomLogic() then
        set caster = udg_Caster
        set lvl = udg_Level
        call textst( udg_string[0] + GetObjectName('A14P'), caster, 64, 90, 10, 1.5 )
    else
        set caster = GetSpellAbilityUnit()
        set lvl = GetUnitAbilityLevel(GetSpellAbilityUnit(), GetSpellAbilityId() )
    endif

    set oldpet = LoadUnitHandle( udg_hash, GetHandleId( caster ), StringHash( "mephw" ) )
    if GetUnitState( oldpet, UNIT_STATE_LIFE) > 0.405 then
        call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\Orc\\FeralSpirit\\feralspirittarget.mdl", GetUnitX( oldpet ), GetUnitY( oldpet ) ) )
        call RemoveUnit( oldpet )
    endif

    set sp = udg_SpellDamage[GetPlayerId(GetOwningPlayer(caster)) + 1]
    set bj_lastCreatedUnit = CreateUnit( GetOwningPlayer( caster ), 'n053', GetUnitX( caster ) + GetRandomReal( -250, 250 ), GetUnitY( caster ) + GetRandomReal( -250, 250 ), GetRandomReal( 0, 360 ) )

    call SaveUnitHandle( udg_hash, GetHandleId( caster ), StringHash( "mephw" ), bj_lastCreatedUnit )
    call SaveInteger( udg_hash, GetHandleId( bj_lastCreatedUnit ), StringHash( "mephw" ), lvl )
    call BlzSetUnitMaxHP( bj_lastCreatedUnit, R2I(BlzGetUnitMaxHP(bj_lastCreatedUnit)+((lvl-1)*100)) )
    call BlzSetUnitBaseDamage( bj_lastCreatedUnit, R2I(BlzGetUnitBaseDamage(bj_lastCreatedUnit, 0)+((lvl-1)*5)), 0 )

    call BlzSetUnitMaxHP( bj_lastCreatedUnit, R2I(BlzGetUnitMaxHP(bj_lastCreatedUnit)*sp) )
    call BlzSetUnitBaseDamage( bj_lastCreatedUnit, R2I(GetUnitDamage(bj_lastCreatedUnit)*sp-GetUnitAvgDiceDamage(bj_lastCreatedUnit)), 0 )
    call SetUnitState( bj_lastCreatedUnit, UNIT_STATE_LIFE, GetUnitState( bj_lastCreatedUnit, UNIT_STATE_MAX_LIFE) )
    call BlzSetUnitArmor( bj_lastCreatedUnit, BlzGetUnitArmor(bj_lastCreatedUnit)*sp )
    call SetUnitMoveSpeed( bj_lastCreatedUnit, GetUnitDefaultMoveSpeed(bj_lastCreatedUnit)*sp )
    call DestroyEffect( AddSpecialEffectTarget( "Abilities\\Spells\\Orc\\FeralSpirit\\feralspirittarget.mdl", bj_lastCreatedUnit, "origin" ) )

    set caster = null
    set oldpet = null
endfunction

//===========================================================================
function InitTrig_MephistarW takes nothing returns nothing
    set gg_trg_MephistarW = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_MephistarW, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_MephistarW, Condition( function Trig_MephistarW_Conditions ) )
    call TriggerAddAction( gg_trg_MephistarW, function Trig_MephistarW_Actions )
endfunction