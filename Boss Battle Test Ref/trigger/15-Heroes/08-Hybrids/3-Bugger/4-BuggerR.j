function Trig_BuggerR_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A0MU'
endfunction

function Trig_BuggerR_Actions takes nothing returns nothing
    local integer cyclA = 1
    local integer lvl
    local unit caster
    local unit oldpet
    local real size
  
    if CastLogic() then
        set caster = udg_Caster
        set lvl = udg_Level
    elseif RandomLogic() then
        set caster = udg_Caster
        set lvl = udg_Level
        call textst( udg_string[0] + GetObjectName('A0MU'), caster, 64, 90, 10, 1.5 )
    else
        set caster = GetSpellAbilityUnit()
        set lvl = GetUnitAbilityLevel(GetSpellAbilityUnit(), GetSpellAbilityId())
    endif

    set size = 0.8+(0.1*lvl)

    set oldpet = LoadUnitHandle( udg_hash, GetHandleId( caster ), StringHash( "bggr" ) )
    if GetUnitState( oldpet, UNIT_STATE_LIFE) > 0.405 then
        call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\Orc\\FeralSpirit\\feralspirittarget.mdl", GetUnitX( oldpet ), GetUnitY( oldpet ) ) )
        call RemoveUnit( oldpet )
    endif
    
	set bj_lastCreatedUnit = CreateUnit( GetOwningPlayer( caster ), 'n02F', GetUnitX( caster ) + GetRandomReal( -200, 200 ), GetUnitY( caster ) + GetRandomReal( -200, 200 ), GetRandomReal( 0, 360 ) )
    call SaveUnitHandle( udg_hash, GetHandleId( caster ), StringHash( "bggr" ), bj_lastCreatedUnit )
    call SaveUnitHandle( udg_hash, GetHandleId( bj_lastCreatedUnit ), StringHash( "bggrac" ), caster )
    call DestroyEffect( AddSpecialEffectTarget( "Abilities\\Spells\\Orc\\FeralSpirit\\feralspirittarget.mdl", bj_lastCreatedUnit, "origin" ) )
    
    call BlzSetUnitMaxHP( bj_lastCreatedUnit, R2I(BlzGetUnitMaxHP(bj_lastCreatedUnit)+((lvl-1)*150)) )
    call BlzSetUnitBaseDamage( bj_lastCreatedUnit, R2I(BlzGetUnitBaseDamage(bj_lastCreatedUnit, 0)+((lvl-1)*8)), 0 )
    
    call SetUnitState( bj_lastCreatedUnit, UNIT_STATE_LIFE, GetUnitState( bj_lastCreatedUnit, UNIT_STATE_MAX_LIFE) )
    call BlzSetUnitArmor( bj_lastCreatedUnit, lvl )
    call SetUnitScale( bj_lastCreatedUnit, size, size, size )
    
    call SetUnitAnimation( bj_lastCreatedUnit, "spell slam" )
    call QueueUnitAnimation( bj_lastCreatedUnit, "stand" )
    
    set caster = null
    set oldpet = null
endfunction

//===========================================================================
function InitTrig_BuggerR takes nothing returns nothing
    set gg_trg_BuggerR = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_BuggerR, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_BuggerR, Condition( function Trig_BuggerR_Conditions ) )
    call TriggerAddAction( gg_trg_BuggerR, function Trig_BuggerR_Actions )
endfunction

