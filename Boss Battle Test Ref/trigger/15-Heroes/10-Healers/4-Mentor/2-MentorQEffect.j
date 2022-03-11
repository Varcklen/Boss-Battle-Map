function Trig_MentorQEffect_Conditions takes nothing returns boolean
    return GetUnitAbilityLevel(udg_DamageEventTarget, 'B036') > 0
endfunction

function Trig_MentorQEffect_Actions takes nothing returns nothing
    local unit caster = LoadUnitHandle( udg_hash, GetHandleId( LoadTimerHandle( udg_hash, GetHandleId( udg_DamageEventTarget ), StringHash( "menq" ) ) ), StringHash( "menqc" ) )
    local real r = LoadReal( udg_hash, GetHandleId( LoadTimerHandle( udg_hash, GetHandleId( udg_DamageEventTarget ), StringHash( "menq" ) ) ), StringHash( "menq1" ) )
    local real d = LoadReal( udg_hash, GetHandleId(LoadTimerHandle( udg_hash, GetHandleId( udg_DamageEventTarget ), StringHash( "menq" ) ) ), StringHash( "menq2" ) )
    local real f
    
    set udg_DamageEventAmount = udg_DamageEventAmount - ( udg_DamageEventAmount * r )
    call DestroyEffect( AddSpecialEffectTarget( "Abilities\\Spells\\Items\\OrbVenom\\OrbVenomSpecialArt.mdl", udg_DamageEventTarget, "chest" ) )
    if udg_DamageEventTarget != caster and GetUnitState( caster, UNIT_STATE_LIFE) > 0.405 then
        set f = udg_DamageEventAmount * d
        set udg_DamageEventAmount = udg_DamageEventAmount - f
        call SetUnitState( caster, UNIT_STATE_LIFE, RMaxBJ(0,GetUnitState( caster, UNIT_STATE_LIFE) - f ) )
        call DestroyEffect( AddSpecialEffectTarget( "Abilities\\Spells\\Items\\OrbVenom\\OrbVenomSpecialArt.mdl", caster, "chest" ) )
    endif
    
    set caster = null
endfunction

//===========================================================================
function InitTrig_MentorQEffect takes nothing returns nothing
    set gg_trg_MentorQEffect = CreateTrigger(  )
    call TriggerRegisterVariableEvent( gg_trg_MentorQEffect, "udg_DamageModifierEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_MentorQEffect, Condition( function Trig_MentorQEffect_Conditions ) )
    call TriggerAddAction( gg_trg_MentorQEffect, function Trig_MentorQEffect_Actions )
endfunction

