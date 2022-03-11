function Trig_KnightP_Conditions takes nothing returns boolean
    return GetUnitAbilityLevel( udg_hero[GetPlayerId(GetOwningPlayer(GetKillingUnit())) + 1], 'A05M') > 0 and IsUnitEnemy(GetDyingUnit(), GetOwningPlayer(udg_hero[GetPlayerId(GetOwningPlayer(GetKillingUnit())) + 1])) and ( ( GetUnitTypeId(GetKillingUnit()) == 'u000' ) or ( GetKillingUnit() == udg_hero[GetPlayerId(GetOwningPlayer(GetKillingUnit())) + 1] ) )
endfunction

function Trig_KnightP_Actions takes nothing returns nothing
    local integer i = GetPlayerId(GetOwningPlayer(GetKillingUnit())) + 1
    local real heal = GetUnitState(GetKillingUnit(), UNIT_STATE_MAX_LIFE) * 0.02 * GetUnitAbilityLevel(udg_hero[i], 'A05M')
    local real mana = GetUnitState(GetKillingUnit(), UNIT_STATE_MAX_MANA) * 0.02 * GetUnitAbilityLevel(udg_hero[i], 'A05M')
      
    call healst( udg_hero[i], null, heal )
    call manast( udg_hero[i], null, mana )
    call DestroyEffect( AddSpecialEffectTarget( "Abilities\\Spells\\Undead\\VampiricAura\\VampiricAuraTarget.mdl", udg_hero[i], "origin") )
endfunction

//===========================================================================
function InitTrig_KnightP takes nothing returns nothing
    set gg_trg_KnightP = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_KnightP, EVENT_PLAYER_UNIT_DEATH )
    call TriggerAddCondition( gg_trg_KnightP, Condition( function Trig_KnightP_Conditions ) )
    call TriggerAddAction( gg_trg_KnightP, function Trig_KnightP_Actions )
endfunction

