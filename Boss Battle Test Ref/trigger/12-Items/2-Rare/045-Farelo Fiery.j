function Trig_Farelo_Fiery_Conditions takes nothing returns boolean
    return inv( GetSpellAbilityUnit(), 'I0BI') > 0
endfunction

function Trig_Farelo_Fiery_Actions takes nothing returns nothing
    local integer i = GetPlayerId(GetOwningPlayer(GetSpellAbilityUnit())) + 1
    local integer ab = Database_Hero_Abilities[1][udg_HeroNum[i]]
    local integer ac = Database_Hero_Abilities[2][udg_HeroNum[i]]
    local integer ad = Database_Hero_Abilities[3][udg_HeroNum[i]]
    local integer ae = Database_Hero_Abilities[4][udg_HeroNum[i]]

    if BlzGetUnitAbilityCooldownRemaining(GetSpellAbilityUnit(),ab) > 1 then
        call BlzStartUnitAbilityCooldown( GetSpellAbilityUnit(), ab, RMaxBJ( 1.1,BlzGetUnitAbilityCooldownRemaining(GetSpellAbilityUnit(), ab) - 0.75) )
    endif
    if BlzGetUnitAbilityCooldownRemaining(GetSpellAbilityUnit(),ac) > 1 then
        call BlzStartUnitAbilityCooldown( GetSpellAbilityUnit(), ac, RMaxBJ( 1.1,BlzGetUnitAbilityCooldownRemaining(GetSpellAbilityUnit(), ac) - 0.75) )
    endif
    if BlzGetUnitAbilityCooldownRemaining(GetSpellAbilityUnit(),ad) > 1 then
        call BlzStartUnitAbilityCooldown( GetSpellAbilityUnit(), ad, RMaxBJ( 1.1,BlzGetUnitAbilityCooldownRemaining(GetSpellAbilityUnit(), ad) - 0.75) )
    endif
    if BlzGetUnitAbilityCooldownRemaining(GetSpellAbilityUnit(),ae) > 1 then
        call BlzStartUnitAbilityCooldown( GetSpellAbilityUnit(), ae, RMaxBJ( 1.1,BlzGetUnitAbilityCooldownRemaining(GetSpellAbilityUnit(), ae) - 0.75) )
    endif
endfunction

//===========================================================================
function InitTrig_Farelo_Fiery takes nothing returns nothing
    set gg_trg_Farelo_Fiery = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Farelo_Fiery, EVENT_PLAYER_UNIT_SPELL_FINISH )
    call TriggerAddCondition( gg_trg_Farelo_Fiery, Condition( function Trig_Farelo_Fiery_Conditions ) )
    call TriggerAddAction( gg_trg_Farelo_Fiery, function Trig_Farelo_Fiery_Actions )
endfunction

