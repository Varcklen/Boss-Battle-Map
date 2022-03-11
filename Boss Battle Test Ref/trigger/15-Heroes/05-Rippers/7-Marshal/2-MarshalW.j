globals
    constant real MARSHAL_W_DURATION = 15
    constant real MARSHAL_W_LIFETIME = 15
endglobals

function Trig_MarshalW_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A0EL'
endfunction

function Trig_MarshalW_Actions takes nothing returns nothing
    local integer lvl
    local unit caster
  
    if CastLogic() then
        set caster = udg_Caster
        set lvl = udg_Level
    elseif RandomLogic() then
        set caster = udg_Caster
        set lvl = udg_Level
        call textst( udg_string[0] + GetObjectName('A0EL'), caster, 64, 90, 10, 1.5 )
    else
        set caster = GetSpellAbilityUnit()
        set lvl = GetUnitAbilityLevel(GetSpellAbilityUnit(), GetSpellAbilityId())
    endif
    
    set bj_lastCreatedUnit = CreateUnit( GetOwningPlayer( caster ), 'n015', GetUnitX( caster ) + GetRandomReal( -128, 128 ), GetUnitY( caster ) + GetRandomReal( -128, 128 ), GetRandomReal( 0, 360 ) )
    call DestroyEffect( AddSpecialEffectTarget( "Abilities\\Spells\\Orc\\FeralSpirit\\feralspirittarget.mdl", bj_lastCreatedUnit, "origin" ) )
    call UnitApplyTimedLife( bj_lastCreatedUnit, 'BTLF', MARSHAL_W_LIFETIME)
    call SaveInteger( udg_hash, GetHandleId( bj_lastCreatedUnit ), StringHash( "mrswe" ), lvl )

    set caster = null
endfunction

//===========================================================================
function InitTrig_MarshalW takes nothing returns nothing
    set gg_trg_MarshalW = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_MarshalW, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_MarshalW, Condition( function Trig_MarshalW_Conditions ) )
    call TriggerAddAction( gg_trg_MarshalW, function Trig_MarshalW_Actions )
endfunction