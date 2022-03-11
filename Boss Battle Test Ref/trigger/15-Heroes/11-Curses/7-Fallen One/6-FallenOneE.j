function Trig_FallenOneE_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A05H'
endfunction

function Trig_FallenOneE_Actions takes nothing returns nothing
    local unit caster
    local real x
    local real y
    local integer lvl
    
    if CastLogic() then
        set caster = udg_Caster
        set x = GetLocationX( GetSpellTargetLoc() )
        set y = GetLocationY( GetSpellTargetLoc() )
        set lvl = udg_Level
    elseif RandomLogic() then
        set caster = udg_Caster
        set lvl = udg_Level
        set x = GetUnitX( caster ) + GetRandomReal( -650, 650 )
        set y = GetUnitY( caster ) + GetRandomReal( -650, 650 )
        call textst( udg_string[0] + GetObjectName('A05H'), caster, 64, 90, 10, 1.5 )
    else
        set caster = GetSpellAbilityUnit()
        set x = GetLocationX( GetSpellTargetLoc() )
        set y = GetLocationY( GetSpellTargetLoc() )
        set lvl = GetUnitAbilityLevel(GetSpellAbilityUnit(), GetSpellAbilityId())
    endif
    if lvl > 4 then
        set lvl = 4
    endif
    
    set bj_lastCreatedUnit = CreateUnit( GetOwningPlayer(caster), 'o01K', x, y, 270 )
    call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\Orc\\FeralSpirit\\feralspirittarget.mdl", GetUnitX( bj_lastCreatedUnit ), GetUnitY( bj_lastCreatedUnit ) ) )
    call UnitApplyTimedLife( bj_lastCreatedUnit, 'BTLF', 10 )
    call SaveReal( udg_hash, GetHandleId( bj_lastCreatedUnit ), StringHash( "flned" ), 80 + (lvl*20) )
    call SaveInteger( udg_hash, GetHandleId( bj_lastCreatedUnit ), StringHash( "flnelvl" ), lvl )
    
    set caster = null
endfunction

//===========================================================================
function InitTrig_FallenOneE takes nothing returns nothing
    set gg_trg_FallenOneE = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_FallenOneE, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_FallenOneE, Condition( function Trig_FallenOneE_Conditions ) )
    call TriggerAddAction( gg_trg_FallenOneE, function Trig_FallenOneE_Actions )
endfunction

