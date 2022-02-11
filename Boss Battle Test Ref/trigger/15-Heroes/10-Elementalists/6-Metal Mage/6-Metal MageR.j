function Trig_Metal_MageR_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A0LY'
endfunction

function Trig_Metal_MageR_Actions takes nothing returns nothing
    local integer lvl
    local unit caster
    local unit oldpet
    local real sp
    local real size
    
    if CastLogic() then
        set caster = udg_Caster
        set lvl = udg_Level
    elseif RandomLogic() then
        set caster = udg_Caster
        set lvl = udg_Level
        call textst( udg_string[0] + GetObjectName('A0LY'), caster, 64, 90, 10, 1.5 )
    else
        set caster = GetSpellAbilityUnit()
        set lvl = GetUnitAbilityLevel(GetSpellAbilityUnit(), GetSpellAbilityId() )
    endif

    set oldpet = LoadUnitHandle( udg_hash, GetHandleId( caster ), StringHash( "mtmr" ) )
    if GetUnitState( oldpet, UNIT_STATE_LIFE) > 0.405 then
        call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\Orc\\FeralSpirit\\feralspirittarget.mdl", GetUnitX( oldpet ), GetUnitY( oldpet ) ) )
        call RemoveUnit( oldpet )
    endif

    set sp = udg_SpellDamage[GetPlayerId(GetOwningPlayer(caster)) + 1]
    if sp >= 2 then
        set size = 1.4
    else
        set size = sp*0.7
    endif
    set bj_lastCreatedUnit = CreateUnit( GetOwningPlayer( caster ), 'n047', GetUnitX( caster ) + GetRandomReal( -250, 250 ), GetUnitY( caster ) + GetRandomReal( -250, 250 ), GetRandomReal( 0, 360 ) )

    call SaveUnitHandle( udg_hash, GetHandleId( caster ), StringHash( "mtmr" ), bj_lastCreatedUnit )
    call BlzSetUnitMaxHP( bj_lastCreatedUnit, R2I(BlzGetUnitMaxHP(bj_lastCreatedUnit)+((lvl-1)*150)) )
    call BlzSetUnitBaseDamage( bj_lastCreatedUnit, R2I(BlzGetUnitBaseDamage(bj_lastCreatedUnit, 0)+((lvl-1)*5)), 0 )

    call BlzSetUnitMaxHP( bj_lastCreatedUnit, R2I(BlzGetUnitMaxHP(bj_lastCreatedUnit)*sp) )
    call BlzSetUnitBaseDamage( bj_lastCreatedUnit, R2I(GetUnitDamage(bj_lastCreatedUnit)*sp-GetUnitAvgDiceDamage(bj_lastCreatedUnit)), 0 )
    call SetUnitState( bj_lastCreatedUnit, UNIT_STATE_LIFE, GetUnitState( bj_lastCreatedUnit, UNIT_STATE_MAX_LIFE) )
    call BlzSetUnitArmor( bj_lastCreatedUnit, BlzGetUnitArmor(bj_lastCreatedUnit)*sp )
    call SetUnitMoveSpeed( bj_lastCreatedUnit, GetUnitDefaultMoveSpeed(bj_lastCreatedUnit)*sp )
    call SetUnitScale( bj_lastCreatedUnit, size, size, size )
    call DestroyEffect( AddSpecialEffectTarget( "Abilities\\Spells\\Orc\\FeralSpirit\\feralspirittarget.mdl", bj_lastCreatedUnit, "origin" ) )

    set caster = null
    set oldpet = null
endfunction

//===========================================================================
function InitTrig_Metal_MageR takes nothing returns nothing
    set gg_trg_Metal_MageR = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Metal_MageR, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_Metal_MageR, Condition( function Trig_Metal_MageR_Conditions ) )
    call TriggerAddAction( gg_trg_Metal_MageR, function Trig_Metal_MageR_Actions )
endfunction

