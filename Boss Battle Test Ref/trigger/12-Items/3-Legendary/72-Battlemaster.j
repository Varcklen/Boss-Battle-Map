globals
    constant integer BATTLEMASTER_REQUIRES = 20000
endglobals

function Trig_Battlemaster_Conditions takes nothing returns boolean
    return IsHeroHasItem(udg_DamageEventTarget, 'I0GN')
endfunction

function Trig_Battlemaster_Actions takes nothing returns nothing
    local unit hero = udg_DamageEventTarget
    local integer index = GetUnitUserData(hero)
    local real currentState = udg_DamagedAllTime[index]
    
    if currentState >= BATTLEMASTER_REQUIRES then
        call RemoveItem( GetItemOfTypeFromUnitBJ(hero, 'I0GN') )
        call UnitAddItem(hero, CreateItem( 'I0GO', GetUnitX(hero), GetUnitY(hero)))
        call textst( "|c00ffffff Battlemaster done!", hero, 64, GetRandomReal( 45, 135 ), 12, 1.5 )
        call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\Human\\ReviveHuman\\ReviveHuman.mdl", GetUnitX(hero), GetUnitY(hero) ) )
        set udg_QuestDone[index] = true
    endif
    
    set hero = null
endfunction

//===========================================================================
function InitTrig_Battlemaster takes nothing returns nothing
    set gg_trg_Battlemaster = CreateTrigger(  )
    call TriggerRegisterVariableEvent( gg_trg_Battlemaster, "udg_AfterDamageEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_Battlemaster, Condition( function Trig_Battlemaster_Conditions ) )
    call TriggerAddAction( gg_trg_Battlemaster, function Trig_Battlemaster_Actions )
endfunction

