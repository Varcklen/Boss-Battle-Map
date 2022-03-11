function Trig_KnightPM_Conditions takes nothing returns boolean
    return GetUnitAbilityLevel( GetKillingUnit(), 'A133' ) > 0 and IsUnitEnemy(GetDyingUnit(), GetOwningPlayer(GetKillingUnit()))
endfunction

function Trig_KnightPM_Actions takes nothing returns nothing
    local real heal = GetUnitState(GetKillingUnit(), UNIT_STATE_MAX_LIFE) * 0.02 * LoadInteger( udg_hash, GetHandleId( GetKillingUnit() ), StringHash( "kngee" ) )
    local real mana = GetUnitState(GetKillingUnit(), UNIT_STATE_MAX_MANA) * 0.02 * LoadInteger( udg_hash, GetHandleId( GetKillingUnit() ), StringHash( "kngee" ) )

    call healst( GetKillingUnit(), null, heal )
    call manast( GetKillingUnit(), null, mana )
    call DestroyEffect( AddSpecialEffectTarget( "Abilities\\Spells\\Undead\\VampiricAura\\VampiricAuraTarget.mdl", GetKillingUnit(), "origin") )
endfunction

//===========================================================================
function InitTrig_KnightPM takes nothing returns nothing
    set gg_trg_KnightPM = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_KnightPM, EVENT_PLAYER_UNIT_DEATH )
    call TriggerAddCondition( gg_trg_KnightPM, Condition( function Trig_KnightPM_Conditions ) )
    call TriggerAddAction( gg_trg_KnightPM, function Trig_KnightPM_Actions )
endfunction

