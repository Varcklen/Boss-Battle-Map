function PvPCondition takes unit u returns boolean
    local boolean l = false
    if not( udg_combatlogic[GetPlayerId(GetOwningPlayer(u)) + 1] ) or (udg_fightmod[3] and udg_unit[57] != u and udg_unit[58] != u) then
        set l = true
    endif
    set u = null
    return l
endfunction

function Trig_ResTower_Conditions takes nothing returns boolean
    return IsUnitInGroup(GetDyingUnit(), udg_heroinfo) and PvPCondition(GetDyingUnit()) and GetOwningPlayer(GetDyingUnit()) != Player(PLAYER_NEUTRAL_AGGRESSIVE) and GetOwningPlayer(GetDyingUnit()) != Player(10)
endfunction
 
function Trig_ResTower_Actions takes nothing returns nothing
    call ReviveHero( GetDyingUnit(), GetRectCenterX(gg_rct_HeroTp), GetRectCenterY(gg_rct_HeroTp), true )
       
    call PauseUnit(GetDyingUnit(), false)
endfunction

//===========================================================================
function InitTrig_ResTower takes nothing returns nothing
    set gg_trg_ResTower = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_ResTower, EVENT_PLAYER_UNIT_DEATH )
    call TriggerAddCondition( gg_trg_ResTower, Condition( function Trig_ResTower_Conditions ) )
    call TriggerAddAction( gg_trg_ResTower, function Trig_ResTower_Actions )
endfunction

