function Trig_MinionsPool_Conditions takes nothing returns boolean
    return GetUnitName(GetDyingUnit()) != "dummy" and not( IsUnitType(GetDyingUnit(), UNIT_TYPE_ANCIENT ) ) and not( IsUnitType(GetDyingUnit(), UNIT_TYPE_HERO ) )
endfunction

globals
    integer array deadminion[5][31]//игрок/лимит
    integer array deadminionhp[5][31]//игрок/лимит
    integer array deadminionat[5][31]//игрок/лимит
    integer array deadminionnum[5]
    integer array deadminionlim[5]
endglobals

function Trig_MinionsPool_Actions takes nothing returns nothing
    local integer i = GetPlayerId(GetOwningPlayer(GetDyingUnit())) + 1
    
    if i < 5 and udg_combatlogic[i] then
        set deadminionnum[i] = deadminionnum[i] + 1
        if deadminionnum[i] > 30 then
            set deadminionnum[i] = 1
        endif
        if deadminionlim[i] < 30 then
            set deadminionlim[i] = deadminionlim[i] + 1
        endif

        set deadminion[i][deadminionnum[i]] = GetUnitTypeId(GetDyingUnit())
        set deadminionhp[i][deadminionnum[i]] = BlzGetUnitMaxHP(GetDyingUnit())
        set deadminionat[i][deadminionnum[i]] = BlzGetUnitBaseDamage(GetDyingUnit(), 0)
    endif
endfunction

//===========================================================================
function InitTrig_MinionsPool takes nothing returns nothing
    set gg_trg_MinionsPool = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_MinionsPool, EVENT_PLAYER_UNIT_DEATH )
    call TriggerAddCondition( gg_trg_MinionsPool, Condition( function Trig_MinionsPool_Conditions ) )
    call TriggerAddAction( gg_trg_MinionsPool, function Trig_MinionsPool_Actions )
endfunction

