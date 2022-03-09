function Trig_GiveLvL_Conditions takes nothing returns boolean
    return inv( udg_hero[GetPlayerId(GetOwningPlayer(GetLevelingUnit())) + 1], 'I0BW' ) > 0
endfunction

function Trig_GiveLvL_Actions takes nothing returns nothing
    if GetHeroLevel(GetLevelingUnit()) >= udg_QuestNum[13] then
        call SetWidgetLife( GetItemOfTypeFromUnitBJ(GetLevelingUnit(), 'I0BW'), 0 )
        set bj_lastCreatedItem = CreateItem( 'I0C0', GetUnitX(GetLevelingUnit()), GetUnitY(GetLevelingUnit()))
        call UnitAddItem(GetLevelingUnit(), bj_lastCreatedItem)
        call textst( "|c00ffffff Hunger for knowledge complete!", GetLevelingUnit(), 64, GetRandomReal( 45, 135 ), 12, 1.5 )
        call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\Human\\ReviveHuman\\ReviveHuman.mdl", GetUnitX(GetLevelingUnit()), GetUnitY(GetLevelingUnit()) ) )
        set udg_QuestDone[GetPlayerId( GetOwningPlayer(GetLevelingUnit()) ) + 1] = true
    else
        call QuestDiscription( GetLevelingUnit(), 'I0BW', GetHeroLevel(GetLevelingUnit()), udg_QuestNum[13] )
    endif
endfunction

//===========================================================================
function InitTrig_GiveLvL takes nothing returns nothing
    set gg_trg_GiveLvL = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_GiveLvL, EVENT_PLAYER_HERO_LEVEL )
    call TriggerAddCondition( gg_trg_GiveLvL, Condition( function Trig_GiveLvL_Conditions ) )
    call TriggerAddAction( gg_trg_GiveLvL, function Trig_GiveLvL_Actions )
endfunction

