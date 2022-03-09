globals 
    constant integer PYROLORD_E_AOE_RANGE = 300
    
    real PyrolordExtraDamage = 0
endglobals

function Trig_PyrolordE_Conditions takes nothing returns boolean
    return GetUnitAbilityLevel( udg_hero[GetPlayerId(GetOwningPlayer(GetKillingUnit())) + 1], 'A0FQ') > 0 and IsUnitEnemy(GetDyingUnit(), GetOwningPlayer(udg_hero[GetPlayerId(GetOwningPlayer(GetKillingUnit())) + 1])) and ( ( GetUnitTypeId(GetKillingUnit()) == 'u000' ) or ( GetKillingUnit() == udg_hero[GetPlayerId(GetOwningPlayer(GetKillingUnit())) + 1] ) )
endfunction

function Trig_PyrolordE_Actions takes nothing returns nothing
    local real dmg
    local unit caster = GetKillingUnit()
    local unit target = GetDyingUnit()  
    local integer lvl = GetUnitAbilityLevel( udg_hero[GetPlayerId(GetOwningPlayer(caster)) + 1], 'A0FQ')
    local integer bonus = Math_Split(lvl)

    set dmg = PyrolordExtraDamage + 60 + ( 40 * lvl )

    call GroupAoE(caster, null, GetUnitX( target ), GetUnitY( target ), dmg, PYROLORD_E_AOE_RANGE, "enemy", "Abilities\\Spells\\Other\\Incinerate\\FireLordDeathExplode.mdl", "Abilities\\Spells\\Other\\Incinerate\\FireLordDeathExplode.mdl" )
    
    if not( udg_fightmod[3] ) and combat( caster, false, 0 ) then
        set PyrolordExtraDamage = PyrolordExtraDamage + bonus
        call textst( "|cFFFF0303 +" + I2S(bonus) + " damage", caster, 64, GetRandomInt(45, 135), 8, 1.5 )
    endif
    
    set caster = null
    set target = null
endfunction

//===========================================================================
function InitTrig_PyrolordE takes nothing returns nothing
    set gg_trg_PyrolordE = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_PyrolordE, EVENT_PLAYER_UNIT_DEATH )
    call TriggerAddCondition( gg_trg_PyrolordE, Condition( function Trig_PyrolordE_Conditions ) )
    call TriggerAddAction( gg_trg_PyrolordE, function Trig_PyrolordE_Actions )
endfunction

